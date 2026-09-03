"""
Rule-based column analyzer.

Runs instantly (no API call) after extraction.
Returns per-column flags/hints and decides whether the schema
is clear enough to show a direct editor UI (ai_mode="editor")
or needs AI chat to resolve ambiguities (ai_mode="chat").
"""

import re

# (regex on lower-cased original column name, expected_type, flag, ui_hint)
_PATTERNS = [
    # Sensitive credentials — always hide
    (r"password|secret|token|api_key|private_key|hash",
     "string", "sensitive",
     "Credential field — hidden from API by default for security."),

    # PII — recommend hiding
    (r"ssn|social_security|passport|national_id|sin\b|nric",
     "string", "pii",
     "Sensitive ID — recommended to hide from public API."),
    (r"\bemail\b|e_mail|emailaddress",
     "string", "pii",
     "Email address — personal data, consider whether to expose."),
    (r"\bphone\b|mobile|cellphone|telephone|\btel\b|fax",
     "string", "pii",
     "Phone number — personal data, consider whether to expose."),
    (r"\bdob\b|date_of_birth|birthdate|birth_date",
     "datetime", "pii",
     "Date of birth — sensitive personal data."),

    # Identifiers
    (r"_id$|^id$|^id_|\buid\b|\buuid\b|_key$|^key$|_code$|^code$",
     "string", "identifier",
     "Unique identifier — kept as string to preserve leading zeros/formats."),

    # Dates / timestamps
    (r"\bdate\b|_date$|_at$|_on$|\btimestamp\b|\btime\b|created|updated|modified|deleted_at|expires",
     "datetime", "date",
     "Date/time field — confirm format (MM/DD vs DD/MM) and timezone."),

    # Monetary amounts
    (r"\bamount\b|price|cost|total|revenue|fee|salary|wage|earnings|spend|charge|invoice_value|subtotal|tax|discount|balance|payment",
     "number", "currency",
     "Monetary value — what currency is this? (USD, EUR, INR, GBP…)"),

    # Counts / quantities
    (r"\bqty\b|quantity|\bcount\b|num_|number_of|\bunits\b|\bpieces\b|\bstock\b|inventory",
     "integer", "count",
     "Count or quantity field."),

    # Percentages / ratios
    (r"percent|pct|\bratio\b|\brate\b|\bscore\b|\bgrade\b|\brating\b",
     "number", "metric",
     "Percentage or ratio — stored as a number (e.g. 0.15 for 15%)."),

    # Booleans
    (r"^is_|^has_|^can_|\bactive\b|\benabled\b|\bverified\b|\bpublished\b|\bdeleted\b|\barchived\b|\bapproved\b|\bconfirmed\b",
     "boolean", "boolean",
     "Boolean flag — will be stored as true/false."),

    # Status / category (enum-like)
    (r"\bstatus\b|\bstate\b|\bstage\b|\bphase\b|category|type$|^type_|\bkind\b|\btier\b|\blevel\b|\bpriority\b|\brole\b",
     "string", "enum",
     "Category field — likely has a fixed set of values."),

    # Names / labels
    (r"\bname\b|\btitle\b|\blabel\b|\bheading\b|\bsubject\b|\bsummary\b|\bfullname\b|full_name|first_name|last_name|username",
     "string", "text",
     "Name or label field."),

    # Free text
    (r"description|^desc$|_desc$|\bnotes?\b|\bcomment\b|\bremarks?\b|\bdetails\b|\bbody\b|\bcontent\b|\bmessage\b",
     "string", "text",
     "Free-text description or notes."),

    # URLs / images
    (r"\burl\b|\blink\b|\bhref\b|website|domain|image|photo|avatar|thumbnail|picture|logo",
     "string", "url",
     "URL or image link field."),

    # Location
    (r"country|region|\bcity\b|\bstate\b|province|address|\bzip\b|postal|latitude|longitude|\blat\b|\blon\b|\bgeo\b",
     "string", "location",
     "Location field."),

    # Measurements
    (r"weight|height|width|length|\bsize\b|dimension|volume|\barea\b",
     "number", "metric",
     "Measurement field — confirm the unit (kg, cm, etc.)."),
]

# Columns that look like a placeholder name → low confidence
_GENERIC_NAME_RE = re.compile(
    r"^col_?\d+$|^field_?\d+$|^column_?\d+$|^f\d+$|^[a-z]$|^unnamed",
    re.IGNORECASE,
)


def _flag_color(flag: str) -> str:
    return {
        "sensitive":  "badge-error",
        "pii":        "badge-warning",
        "identifier": "badge-info",
        "date":       "badge-secondary",
        "currency":   "badge-success",
        "count":      "badge-ghost",
        "metric":     "badge-ghost",
        "boolean":    "badge-ghost",
        "enum":       "badge-ghost",
        "text":       "badge-ghost",
        "url":        "badge-ghost",
        "location":   "badge-ghost",
    }.get(flag, "badge-ghost")


def analyze_column(col: dict) -> dict:
    name_lower = col.get("original_name", col.get("name", "")).lower().strip()
    detected_type = col.get("type", "string")
    sample_values = col.get("sample_values", [])

    flag = ""
    hint = ""
    confidence = 0.5

    for pattern, expected_type, p_flag, p_hint in _PATTERNS:
        if re.search(pattern, name_lower):
            flag = p_flag
            hint = p_hint
            # Type agreement boosts confidence
            confidence = 0.9 if detected_type == expected_type else 0.7
            break
    else:
        # No pattern matched
        if _GENERIC_NAME_RE.match(name_lower):
            confidence = 0.15  # col_4, Unnamed: 3, etc.
            hint = "Generic column name — what does this column represent?"
        elif len(name_lower) >= 3:
            confidence = 0.55  # has a real name but unknown domain
        else:
            confidence = 0.3

    # Sample values boost confidence (data is consistent)
    if len(sample_values) >= 3:
        confidence = min(1.0, confidence + 0.08)

    # Sensitive columns: default to hidden
    expose = col.get("expose", True)
    if flag == "sensitive":
        expose = False
        hint += " Hidden by default."

    return {
        **col,
        "expose":      expose,
        "flag":        flag,
        "flag_color":  _flag_color(flag),
        "hint":        hint,
        "confidence":  round(confidence, 2),
    }


def analyze(extracted_schema: dict) -> dict:
    """
    Main entry point. Returns enriched schema + routing decision.

    Returns:
        {
          "columns":        [...enriched columns...],
          "confidence":     0.0–1.0,
          "ai_mode":        "editor" | "chat",
          "is_unstructured": bool,
        }
    """
    cols = extracted_schema.get("columns", [])
    analyzed = [analyze_column(c) for c in cols]

    # Overall confidence = weakest column (chain is only as strong as weakest link)
    overall = min((c["confidence"] for c in analyzed), default=0.0)

    has_generic = any(_GENERIC_NAME_RE.match(
        c.get("original_name", c.get("name", "")).lower()
    ) for c in cols)

    is_unstructured = bool(
        (len(cols) == 1 and cols[0].get("name") in ("text", "content"))
        or extracted_schema.get("raw_text")
    )

    # Use AI chat when:
    #   • any column has a generic/unknown name
    #   • the doc is unstructured text (PDF / DOCX with no tables)
    #   • overall confidence is below threshold
    ai_mode = (
        "chat"
        if (overall < 0.65 or has_generic or is_unstructured)
        else "editor"
    )

    return {
        "columns":         analyzed,
        "confidence":      round(overall, 2),
        "ai_mode":         ai_mode,
        "is_unstructured": is_unstructured,
    }
