"""
Self-check every example SQL across all lesson folders.

Walks every ``examples/NN-*/`` folder, opens its ``db.sqlite`` with SQLAlchemy,
and executes each ``example_*.sql`` file via ``sa.text(path.read_text())``.
Reports OK / ERROR per file with row counts, plus a final summary.
Exits non-zero if any SQL errored.

Usage::

    python examples/check_examples.py

Supports SQL files containing multiple statements separated by ``;``;
each statement runs independently and the row count of the last
row-returning statement is reported.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

import sqlalchemy as sa


HERE = Path(__file__).resolve().parent
LESSON_RE = re.compile(r"^\d{2}[-_].+")


def find_lessons(examples_dir: Path) -> list[Path]:
    return sorted(
        p for p in examples_dir.iterdir()
        if p.is_dir() and LESSON_RE.match(p.name)
    )


_LINE_COMMENT_RE = re.compile(r"--[^\n]*")
_BLOCK_COMMENT_RE = re.compile(r"/\*.*?\*/", re.DOTALL)


def split_statements(sql: str) -> list[str]:
    # Strip comments before splitting so semicolons inside comments
    # don't get treated as statement separators.
    stripped = _LINE_COMMENT_RE.sub("", sql)
    stripped = _BLOCK_COMMENT_RE.sub("", stripped)
    return [stmt for stmt in (s.strip() for s in stripped.split(";")) if stmt]


def _exec_one(conn: sa.Connection, sql: str) -> int | None:
    result = conn.execute(sa.text(sql))
    if result.returns_rows:
        return len(result.fetchall())
    return None


def run_sql_file(engine: sa.Engine, sql_path: Path) -> tuple[bool, str]:
    sql = sql_path.read_text(encoding="utf-8")
    # Fast path: most files are a single statement. Try the whole file
    # first so comments-with-semicolons don't fool us.
    try:
        with engine.connect() as conn:
            rows = _exec_one(conn, sql)
        return True, f"{rows} rows" if rows is not None else "ok (no result set)"
    except Exception as exc_whole:
        pass  # fall through to multi-statement attempt

    statements = split_statements(sql)
    if len(statements) <= 1:
        return False, str(exc_whole).splitlines()[0]

    last: int | None = None
    try:
        with engine.connect() as conn:
            for stmt in statements:
                rows = _exec_one(conn, stmt)
                if rows is not None:
                    last = rows
        suffix = f" ({len(statements)} stmts)"
        return True, (f"{last} rows" + suffix) if last is not None else ("ok" + suffix)
    except Exception as exc_multi:
        return False, str(exc_multi).splitlines()[0]


def main() -> int:
    lessons = find_lessons(HERE)
    total_ok = 0
    total_err = 0
    errors: list[tuple[Path, str]] = []

    for lesson in lessons:
        db_path = lesson / "db.sqlite"
        sql_files = sorted(lesson.glob("example_*.sql"))
        if not sql_files:
            continue

        print(f"\n[{lesson.name}]")

        if not db_path.exists():
            print(f"  ! db.sqlite missing -- skipping {len(sql_files)} file(s)")
            for sql_path in sql_files:
                errors.append((sql_path, "db.sqlite missing"))
                total_err += 1
            continue

        engine = sa.create_engine(f"sqlite:///{db_path}")
        try:
            for sql_path in sql_files:
                ok, msg = run_sql_file(engine, sql_path)
                mark = "OK " if ok else "ERR"
                print(f"  {mark}  {sql_path.name:<28} {msg}")
                if ok:
                    total_ok += 1
                else:
                    total_err += 1
                    errors.append((sql_path, msg))
        finally:
            engine.dispose()

    print()
    print("=" * 64)
    print(f"Summary: {total_ok} ok, {total_err} error(s)")
    if errors:
        print("\nErrors:")
        for sql_path, msg in errors:
            print(f"  {sql_path.relative_to(HERE)}: {msg}")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
