from extractors import excel, pdf, docx_extractor
from models.dataset import DocType


def extract(file_path: str, doc_type: DocType) -> dict:
    if doc_type == DocType.excel:
        return excel.extract(file_path)
    if doc_type == DocType.csv:
        return excel.extract_csv(file_path)
    if doc_type == DocType.pdf:
        return pdf.extract(file_path)
    if doc_type == DocType.docx:
        return docx_extractor.extract(file_path)
    # image — OCR requires tesseract; return stub
    return {
        "columns": [{"name": "text", "original_name": "text", "type": "string", "description": "OCR extracted text", "expose": True, "sample_values": [], "nullable": False}],
        "row_count": 0,
        "note": "Image OCR extraction — install tesseract to enable full support.",
    }
