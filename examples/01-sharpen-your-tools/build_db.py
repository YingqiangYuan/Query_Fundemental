"""
Build the forum.sqlite database from the SQL files in ./sql/.

Usage::

    python build_db.py

This re-creates ``forum.sqlite`` next to this script every time it runs,
so feel free to commit the generated file -- it is fully reproducible.
"""

from pathlib import Path
import sqlite3
import sys


HERE = Path(__file__).resolve().parent
SQL_DIR = HERE / "sql"
DB_PATH = HERE / "forum.sqlite"

SQL_FILES = [
    SQL_DIR / "01_schema.sql",
    SQL_DIR / "02_seed.sql",
]


def build() -> None:
    if DB_PATH.exists():
        DB_PATH.unlink()

    conn = sqlite3.connect(DB_PATH)
    try:
        conn.execute("PRAGMA foreign_keys = ON;")
        for sql_file in SQL_FILES:
            print(f"Running {sql_file.relative_to(HERE)} ...")
            conn.executescript(sql_file.read_text(encoding="utf-8"))
        conn.commit()

        users = conn.execute("SELECT COUNT(*) FROM users").fetchone()[0]
        posts = conn.execute("SELECT COUNT(*) FROM posts").fetchone()[0]
        replies = conn.execute("SELECT COUNT(*) FROM replies").fetchone()[0]
    finally:
        conn.close()

    print()
    print(f"Database created: {DB_PATH}")
    print(f"  users:   {users}")
    print(f"  posts:   {posts}")
    print(f"  replies: {replies}")


if __name__ == "__main__":
    try:
        build()
    except sqlite3.Error as exc:
        print(f"SQLite error: {exc}", file=sys.stderr)
        sys.exit(1)
