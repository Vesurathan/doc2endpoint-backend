import pdfplumber
import re


def _safe_col_name(name: str) -> str:
    name = str(name).strip().lower()
    name = re.sub(r"[^a-z0-9]+", "_", name)
    return re.sub(r"_+", "_", name).strip("_") or "column"


def _extract_full_text(pdf) -> str:
    """Pull all readable text from the PDF (capped at 3000 chars for agent context)."""
    parts = []
    for page in pdf.pages:
        text = page.extract_text()
        if text:
            parts.append(text.strip())
    return "\n\n".join(parts)[:3000]


def extract(file_path: str) -> dict:
    tables_found = []
    full_text = ""

    with pdfplumber.open(file_path) as pdf:
        full_text = _extract_full_text(pdf)

        for page in pdf.pages:
            for table in page.extract_tables():
                if not table or len(table) < 2:
                    continue
                headers = [str(h).strip() if h else f"col_{i}" for i, h in enumerate(table[0])]
                rows = table[1:]
                tables_found.append({"headers": headers, "rows": rows})

    if not tables_found:
        # No tables — hand the raw text to the agent so it can understand the doc
        preview_lines = [l.strip() for l in full_text.splitlines() if l.strip()][:10]
        return {
            "columns": [{
                "name":          "content",
                "original_name": "content",
                "type":          "string",
                "description":   "Extracted text content",
                "expose":        True,
                "sample_values": preview_lines[:5],
                "nullable":      False,
            }],
            "row_count":    len([l for l in full_text.splitlines() if l.strip()]),
            "data_preview": [{"content": l} for l in preview_lines[:5]],
            "raw_text":     full_text,
            "note":         "No structured tables found — extracted raw text.",
        }

    # Use the largest table
    best = max(tables_found, key=lambda t: len(t["rows"]))
    columns = []
    for i, header in enumerate(best["headers"]):
        sample = [
            str(row[i]) for row in best["rows"][:5]
            if i < len(row) and row[i]
        ]
        columns.append({
            "name":          _safe_col_name(header),
            "original_name": header,
            "type":          "string",
            "description":   "",
            "expose":        True,
            "sample_values": sample,
            "nullable":      True,
        })

    # Build data_preview from best table rows
    col_names = [c["original_name"] for c in columns]
    data_preview = []
    for row in best["rows"][:5]:
        data_preview.append({
            col_names[i]: (str(row[i]) if i < len(row) and row[i] else "")
            for i in range(len(col_names))
        })

    return {
        "columns":       columns,
        "row_count":     len(best["rows"]),
        "tables_found":  len(tables_found),
        "data_preview":  data_preview,
        "raw_text":      full_text[:1000],  # short excerpt for agent context
    }
