"""
Load CSV files into a fresh SQLite database.

For each ``*.csv`` file inside ``csv_dir`` we:

1. Read the file with Polars (schema is inferred from the data).
2. Create a SQLite table named after the CSV file stem.
3. Translate Polars dtypes into SQLAlchemy column types.
4. Bulk-insert all rows.

The destination database file is always deleted first so the result is
fully reproducible from the CSV inputs.
"""

from __future__ import annotations

import re
from pathlib import Path

import polars as pl
import sqlalchemy as sa


# Files in ``data/`` are prefixed like ``01_users.csv`` so that
# ``sorted()`` walks them in FK-dependency order. The prefix is for
# ordering only; the table name is the stem with the prefix removed.
_PREFIX_RE = re.compile(r"^\d+_")


def csv_path_to_table_name(csv_path: Path) -> str:
    return _PREFIX_RE.sub("", csv_path.stem)


def polars_dtype_to_sqlalchemy(dtype: pl.DataType) -> sa.types.TypeEngine:
    if dtype.is_integer():
        return sa.Integer()
    if dtype.is_float():
        return sa.Float()
    if dtype == pl.Boolean:
        return sa.Boolean()
    if dtype == pl.Date:
        return sa.Date()
    if isinstance(dtype, pl.Datetime):
        return sa.DateTime()
    return sa.Text()


def _build_table(
    name: str,
    df: pl.DataFrame,
    metadata: sa.MetaData,
) -> sa.Table:
    columns = [
        sa.Column(col, polars_dtype_to_sqlalchemy(df.schema[col]))
        for col in df.columns
    ]
    return sa.Table(name, metadata, *columns)


def load_csv_dir_to_sqlite(
    csv_dir: Path,
    db_path: Path,
) -> dict[str, int]:
    """Recreate ``db_path`` and load every CSV in ``csv_dir`` into it.

    The CSV file stem (with any leading ``NN_`` prefix stripped) becomes
    the table name: ``01_users.csv`` -> table ``users``. The numeric
    prefix is used only to control load order so that parent tables are
    populated before children that reference them.

    Returns a mapping of table name -> rows inserted.
    """
    csv_dir = Path(csv_dir)
    db_path = Path(db_path)

    if db_path.exists():
        db_path.unlink()

    engine = sa.create_engine(f"sqlite:///{db_path}")
    metadata = sa.MetaData()
    summary: dict[str, int] = {}

    for csv_path in sorted(csv_dir.glob("*.csv")):
        table_name = csv_path_to_table_name(csv_path)
        df = pl.read_csv(csv_path)
        table = _build_table(table_name, df, metadata)
        table.create(engine)

        rows = df.to_dicts()
        if rows:
            with engine.begin() as conn:
                conn.execute(table.insert(), rows)
        summary[table_name] = df.height

    engine.dispose()
    return summary
