"""
Generate ``db.sqlite`` from every CSV file in ``./data/``.

Usage::

    python gen_db.py

The database is rebuilt from scratch every run.
"""

from pathlib import Path

from learn_sql_query_basic import load_csv_dir_to_sqlite

HERE = Path(__file__).resolve().parent
DATA_DIR = HERE / "data"
DB_PATH = HERE / "db.sqlite"


def main() -> None:
    summary = load_csv_dir_to_sqlite(DATA_DIR, DB_PATH)
    print(f"Database created: {DB_PATH}")
    for table, n_rows in summary.items():
        print(f"  {table}: {n_rows} rows")


if __name__ == "__main__":
    main()
