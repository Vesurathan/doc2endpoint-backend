"""
Doc2Endpoint schema agent.

The agent is given:
  - The full extracted schema (column names, detected types, sample values)
  - A data preview (first 5 rows as a markdown table)
  - Any raw text excerpt from unstructured documents (PDFs / DOCX with no tables)

It then:
  1. Introduces itself and summarises what it understood about the document
  2. Asks smart clarifying questions about domain, currency, dates, identifiers, etc.
  3. Updates the schema in response to user replies
  4. Tells the user when they can confirm and get their live API
"""

import json
import anthropic
from core.config import settings

client = anthropic.Anthropic(api_key=settings.ANTHROPIC_API_KEY)


SYSTEM_PROMPT = """You are a friendly data schema assistant inside Doc2Endpoint — a platform that turns uploaded documents into live REST APIs.

Your job is to help the user review and finalise the schema detected from their uploaded file, then help them get a live REST API.

## What you must do in every response

1. **Understand the document** — look at the column names, types, and the data preview rows to figure out what the document is about (invoices, employee records, product catalogue, sales data, etc.). State your understanding at the start.

2. **Ask smart clarifying questions** when relevant — pick the right questions for the data:
   - **Amounts / currency columns** → "What currency is this in? Should I store it as a number?"
   - **Date columns** → "Are these dates in MM/DD/YYYY or DD/MM/YYYY format? Which timezone?"
   - **ID / code columns** → "Is this the unique identifier for each record? Should I use it as a string or integer?"
   - **Name / email / phone columns** → "This column looks like personal data — do you want to expose it in the public API, or hide it?"
   - **Status / category columns** → "I see values like X, Y, Z — should I document the possible values?"
   - **Unclear column names** → "What does the column 'col_4' represent? Can I give it a better name?"

3. **Present the detected columns clearly** in a numbered list. Include the detected type and ask if each needs to be changed.

4. **Accept instructions in plain English** — if the user says "rename X to Y", "hide the email column", "that amount is in GBP", "the date is UTC", "col_4 is the order status" — apply it and confirm.

5. **When the user is satisfied**, confirm the final schema and tell them: "Everything looks good! Click **Confirm & Create API** to generate your live REST endpoint."

## Rules
- Be concise and conversational. No technical jargon.
- Never output raw JSON to the user.
- Keep responses to 4–8 sentences unless you are listing many columns.
- If the document appears to have no useful tabular data (only raw text), say so clearly and suggest the user might want to upload a structured file instead, or ask how they want to model the text as an API.
- Always end your first response with one or two specific clarifying questions about the data you see.

## Internal schema update (never shown to user)

After your user-facing response, on a NEW LINE, output exactly:
SCHEMA_UPDATE: <valid JSON array>

The JSON must follow this structure exactly:
[{"name": "col_name", "original_name": "Original Name", "type": "string|number|integer|boolean|datetime", "description": "...", "expose": true}]

Always include ALL columns in SCHEMA_UPDATE, not just changed ones. If nothing changed, repeat the current schema."""


# ── Formatting helpers ─────────────────────────────────────────────────────────

def _format_schema_summary(extracted_schema: dict) -> str:
    cols = extracted_schema.get("columns", [])
    row_count = extracted_schema.get("row_count", 0)
    note = extracted_schema.get("note", "")

    lines = [f"File contains **{row_count} rows** with **{len(cols)} columns**:\n"]
    for i, col in enumerate(cols, 1):
        samples = ", ".join(f'"{v}"' for v in col.get("sample_values", [])[:3])
        line = f"{i}. `{col['original_name']}` → detected as **{col['type']}**"
        if samples:
            line += f" — sample values: {samples}"
        lines.append(line)

    if note:
        lines.append(f"\n⚠️ Note: {note}")

    return "\n".join(lines)


def _format_data_preview(extracted_schema: dict) -> str:
    """Render the first 5 rows as a plain-text table for the agent."""
    preview = extracted_schema.get("data_preview", [])
    if not preview:
        return ""

    headers = list(preview[0].keys())
    # Cap columns to avoid bloating the prompt
    headers = headers[:10]

    # Header row
    header_line = " | ".join(f"{h[:20]:<20}" for h in headers)
    sep_line    = " | ".join("-" * 20 for _ in headers)
    rows = []
    for row in preview[:5]:
        rows.append(" | ".join(f"{str(row.get(h, ''))[:20]:<20}" for h in headers))

    return "**Data preview (first rows):**\n```\n" + "\n".join([header_line, sep_line] + rows) + "\n```"


def _format_raw_text(extracted_schema: dict) -> str:
    raw = extracted_schema.get("raw_text", "")
    if not raw:
        return ""
    return f"**Document text excerpt:**\n```\n{raw[:1500]}\n```"


def _parse_schema_update(text: str) -> list | None:
    marker = "SCHEMA_UPDATE:"
    idx = text.find(marker)
    if idx == -1:
        return None
    json_str = text[idx + len(marker):].strip()
    try:
        return json.loads(json_str)
    except json.JSONDecodeError:
        return None


def _clean_response(text: str) -> str:
    marker = "SCHEMA_UPDATE:"
    idx = text.find(marker)
    return text[:idx].strip() if idx != -1 else text.strip()


# ── Public API ─────────────────────────────────────────────────────────────────

def get_opening_message(extracted_schema: dict) -> tuple[str, list]:
    """
    Called once right after upload.
    Passes the full schema + data preview to Claude and returns its opening message.
    """
    schema_summary  = _format_schema_summary(extracted_schema)
    data_preview    = _format_data_preview(extracted_schema)
    raw_text        = _format_raw_text(extracted_schema)

    user_turn_parts = [
        "I just uploaded a file. Here is what was detected:\n",
        schema_summary,
    ]
    if data_preview:
        user_turn_parts.append("\n" + data_preview)
    if raw_text:
        user_turn_parts.append("\n" + raw_text)

    user_turn = "\n".join(user_turn_parts)

    response = client.messages.create(
        model="claude-haiku-4-5",   # fast + cheap — handles schema review perfectly
        max_tokens=800,
        system=SYSTEM_PROMPT,
        messages=[{"role": "user", "content": user_turn}],
    )

    raw   = response.content[0].text
    clean = _clean_response(raw)
    cols  = _parse_schema_update(raw)
    return clean, cols or extracted_schema.get("columns", [])


def chat(
    history: list[dict],
    extracted_schema: dict,
    current_columns: list[dict],
    user_message: str,
) -> tuple[str, list]:
    """
    Called on every user message after the opening.
    Passes full conversation history + current schema state.
    """
    schema_summary    = _format_schema_summary(extracted_schema)
    data_preview      = _format_data_preview(extracted_schema)
    current_schema_json = json.dumps(current_columns, indent=2)

    system = (
        SYSTEM_PROMPT
        + f"\n\n---\n**Original extracted schema:**\n{schema_summary}"
        + (f"\n\n{data_preview}" if data_preview else "")
        + f"\n\n**Current working schema (updated by conversation so far):**\n```json\n{current_schema_json}\n```"
    )

    # Cap to last 6 messages (3 turns) — enough context, avoids token bloat
    recent = history[-6:] if len(history) > 6 else history
    messages = [{"role": m["role"], "content": m["content"]} for m in recent]
    messages.append({"role": "user", "content": user_message})

    response = client.messages.create(
        model="claude-haiku-4-5",   # fast + cheap
        max_tokens=800,
        system=system,
        messages=messages,
    )

    raw   = response.content[0].text
    clean = _clean_response(raw)
    cols  = _parse_schema_update(raw)
    return clean, cols or current_columns
