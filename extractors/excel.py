import pandas as pd
import re


_TYPE_MAP = {
    "int64":           "integer",
    "float64":         "number",
    "bool":            "boolean",
    "datetime64[ns]":  "datetime",
    "object":          "string",
}


def _safe_col_name(name: str) -> str:
    name = str(name).strip().lower()
    name = re.sub(r"[^a-z0-9]+", "_", name)
    name = re.sub(r"_+", "_", name).strip("_")
    return name or "column"


def _pandas_type(dtype) -> str:
    for key, val in _TYPE_MAP.items():
        if str(dtype).startswith(key):
            return val
    return "string"


def _build_columns(df: pd.DataFrame) -> list[dict]:
    columns = []
    for original_name, dtype in zip(df.columns, df.dtypes):
        col_name = _safe_col_name(str(original_name))
        detected_type = _pandas_type(dtype)

        # Promote object → datetime when parseable
        if detected_type == "string":
            try:
                pd.to_datetime(df[original_name].dropna().head(20), infer_datetime_format=True)
                detected_type = "datetime"
            except Exception:
                pass

        sample_values = df[original_name].dropna().head(5).astype(str).tolist()

        columns.append({
            "name":          col_name,
            "original_name": str(original_name),
            "type":          detected_type,
            "description":   "",
            "expose":        True,
            "sample_values": sample_values,
            "nullable":      bool(df[original_name].isnull().any()),
        })
    return columns


def _data_preview(df: pd.DataFrame, n: int = 5) -> list[dict]:
    """Return first n rows as a list of {col: value} dicts for the agent."""
    preview_df = df.head(n).fillna("").astype(str)
    return preview_df.to_dict(orient="records")


def extract(file_path: str, sheet_name: int | str = 0) -> dict:
    df = pd.read_excel(file_path, sheet_name=sheet_name)
    df = df.dropna(how="all")

    return {
        "columns":      _build_columns(df),
        "row_count":    len(df),
        "sheet_count":  1,
        "data_preview": _data_preview(df),
    }


def extract_csv(file_path: str) -> dict:
    df = pd.read_csv(file_path)
    df = df.dropna(how="all")

    return {
        "columns":      _build_columns(df),
        "row_count":    len(df),
        "sheet_count":  1,
        "data_preview": _data_preview(df),
    }
