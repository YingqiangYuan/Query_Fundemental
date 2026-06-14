---
name: sql-example
description: Scaffold a new SQL-query lesson under examples/NN-title following this project's convention — CSV seed data, a Python DB generator, numbered .sql examples, and bilingual READMEs. The whole course is SELECT-only. This skill defines the file layout and authoring conventions, NOT the lesson content.
when_to_use: "User asks to add/create/scaffold a new SQL example, lesson, or chapter under examples/. Examples: 'add a new lesson', 'make a new example', '搭建一个新的 example', '帮我写第 N 节课', 'scaffold examples/NN-...'."
argument-hint: [topic-slug e.g. "where-basics"]
---

# SQL example folder convention

This is a query-only SQL course. Each lesson lives in its own `examples/NN-title/` folder, generates a small SQLite database from CSV seed files, and walks the student through several `.sql` examples.

**This skill defines the convention only.** It does not prescribe what topic each lesson covers, what schema to design, or what business domain to use — those decisions stay with the author. The skill exists so every lesson folder has a predictable shape.

## Numbering

Folder names are `examples/NN-kebab-title/` where `NN` is a two-digit number.

- `examples/01/` is the **special intro lesson** (environment setup, DBeaver, running SQL). **Never modify or overwrite it.**
- Real lessons start at `02` and count up — `02`, `03`, `04`, ... There is no hard cap. Pick the lowest free `NN ≥ 02` (run `ls examples/`).

## Required folder layout

```
examples/NN-kebab-title/
├── data/
│   ├── 01_parent_table.csv
│   ├── 02_child_table.csv
│   └── 03_grandchild_table.csv
├── gen_db.py                  # AUTHOR tool — students do NOT run this
├── db.sqlite                  # generated AND committed — students open this
├── example_01.sql
├── example_02.sql
├── example_03.sql
├── README-cn.md               # WRITE THIS FIRST (Chinese)
└── README.md                  # English translation of README-cn.md
```

## Hard rules

### 1. CSV filenames

Files in `data/` MUST be prefixed `NN_` (`01_`, `02_`, ...) in **foreign-key dependency order** — parents before children. The library helper sorts by filename, so the prefix controls insertion order. The prefix is stripped to derive the table name: `01_users.csv` → table `users`. Even a single-table dataset uses the prefix (`01_books.csv`), for consistency.

### 2. SQL filenames

Files at the folder root are named `example_NN.sql` starting at `example_01.sql`, two-digit padded.

### 3. SQL comment convention (important)

Every `.sql` file is a teaching artifact, not just runnable code. Each file MUST start with a header comment that frames the query as the answer to a real-world question. The convention is "business question first, query second" — the same pattern tutorials use ("here's the problem, now here's how SQL solves it"), but kept inline with the SQL so it travels with the code.

Use this template:

```sql
-- Example NN: <one-line summary of the SQL pattern>
--
-- Business question:
--   "<The real-world question a stakeholder would ask, in plain English.
--    Use quotes; write it as if a non-technical person said it out loud.>"
--
-- Why this query:
--   <2-4 lines: which SQL constructs answer the question and why. Point
--   out anything subtle the reader should notice in the result.>
SELECT ...
FROM ...;
```

All comments inside `.sql` files MUST be in English (the READMEs carry the Chinese explanation).

**SQL comment syntax** — both styles are allowed; use whichever reads cleaner:

```sql
-- Single-line comment: from `--` to end of line is ignored.

/*
 * Block comment: spans multiple lines.
 * Use for longer narration when `--` lines get unwieldy.
 */
```

### 4. READMEs are bilingual and parallel

Always write `README-cn.md` first in Chinese, then translate to `README.md`. Keep the two files structurally parallel — same headings, same section order, same tables — so they diff cleanly and stay easy to maintain.

Tone is first-person and inviting ("我们一起来看…" / "let's…").

**Required sections (both languages):**

| Section | What goes here |
|---------|---------------|
| **我们要学什么 / What we'll learn** | The SQL skill(s) this lesson teaches and why they matter. |
| **数据库故事 / The data story** | The business scenario the schema models. Include a table listing each table with a one-line description and approximate row count. |
| **打开数据库 / Open the database** | `db.sqlite` is already committed in the lesson folder. Tell students to open it directly in DBeaver or `sqlite3`. They do NOT run `gen_db.py`. Include a short note (block-quote) that says: "if db.sqlite is corrupted, delete it and re-run `python gen_db.py`" — that is the only place students see `gen_db.py`. |
| **先自己探索一下 / Explore the database first** | Tell students to poke around the tables themselves before running the examples — preview rows, read column names, get a mental picture. |
| **跟着例子练 / Work through the examples** | Tell students to open each `example_NN.sql`, **copy-paste it into their SQL editor one at a time**, and read the embedded comment before and after running. Provide a short index table listing each file and what it teaches in one line. |
| **关于 SQL 注释 / A note on SQL comments** | Brief explanation of `--` and `/* */` syntax so students understand the comments in the example files. |

**Lesson-02-only section** — `examples/02-select-basics/` is the first practical lesson, so its README additionally includes a **一次性的项目准备 / One-time project setup** section (placed BEFORE "打开数据库") telling students to run `mise inst` once. Later lessons (03+) MUST NOT repeat this — the env is already set up and reminding students every lesson is noise.

**Do NOT** duplicate the per-example deep explanation in the README — that lives in the `.sql` file's header comment. The README's example-walkthrough section is just an index pointing students to the right files.

**Link every file reference.** Whenever a README mentions a sibling file students should open (`example_NN.sql`, `gen_db.py`) or another lesson folder (`examples/01/`), write it as a relative markdown link — e.g. `[example_01.sql](./example_01.sql)`, `[gen_db.py](./gen_db.py)`, `[examples/01-sharpen-your-tools](../01-sharpen-your-tools)` — so students can click through instead of hunting in the file tree. Inside the example-walkthrough index table, the filename cell MUST be a link.

### 5. `gen_db.py` is an author tool, not a student step

`gen_db.py` is a minimal driver around the library helper that the **author** runs ONCE while building the lesson, to produce `db.sqlite`. Then **`db.sqlite` is committed to git** and ships with the lesson. Students never have to run `gen_db.py` to do the exercises — they just open the committed `db.sqlite`.

Do not hand-write DDL or `INSERT` statements in `gen_db.py`. Use the library helper exactly as shown in the template below.

The READMEs mention `gen_db.py` exactly once, as a recovery instruction: "if `db.sqlite` gets corrupted, delete it and re-run `python gen_db.py`."

## Workflow

### Step 1 — Pick the folder

```bash
ls examples/
```

Find the lowest free `NN ≥ 02`. Choose a short kebab-case topic slug. Final folder: `examples/NN-topic-slug/`.

### Step 2 — Design the dataset and business story

Pick a small, realistic-feeling domain that fits the topic. Constraints:

- 1–3 tables, roughly 20–50 rows per table. Small enough to read at a glance.
- Simple column types only: `INTEGER`, `REAL`, `TEXT`. Use ISO-8601 strings for dates. Avoid booleans (Polars infers `"true"/"false"` as text, not bool — use 0/1 ints if you really need a flag).
- Realistic-looking values. Avoid `foo`/`bar` placeholder content — it makes the business question framing feel hollow.

### Step 3 — Write the CSV files

Create `data/NN_<table>.csv` in FK dependency order. Header row = column names. The library uses Polars dtype inference, so write numbers as numbers and dates as ISO strings.

If a child table has an FK into a parent table, **its ordering prefix must be higher** than the parent's. Example: `01_users.csv`, `02_posts.csv`, `03_replies.csv`.

### Step 4 — Write `gen_db.py`

Use this template exactly — it's just a driver around the library helper:

```python
"""
Generate db.sqlite from every CSV file in ./data/.

Usage::

    python gen_db.py
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
```

### Step 5 — Write the `example_NN.sql` files

Each file demonstrates one SQL pattern and uses the comment template from Rule 3. Build from simpler to more interesting variations within the lesson.

### Step 6 — Write `README-cn.md` (Chinese, FIRST)

Hit every required section in Rule 4. Keep the example-walkthrough section as a short **index table** (file → one-liner), not a re-explanation of each query.

### Step 7 — Translate to `README.md`

Translate `README-cn.md` into English. Same headings (in English), same section order, same tables. The English README is a translation, not a rewrite — keep them easy to diff.

### Step 8 — Verify end-to-end (author only)

From the lesson folder, run `gen_db.py` once to produce `db.sqlite` so it can be committed alongside the lesson:

```bash
python gen_db.py
```

Confirm row counts match the CSVs. Then run each example through sqlite3 to confirm they parse and return sensible output:

```bash
for f in example_*.sql; do
  echo "=== $f ==="
  sqlite3 -header -column db.sqlite < "$f"
done
```

If any query errors or returns empty when it shouldn't, fix before considering the lesson done.

## Reference

- **Library helper**: `learn_sql_query_basic.load_csv_dir_to_sqlite(csv_dir, db_path)` — wipes `db_path`, then for each CSV (sorted by filename) reads it with Polars, infers a SQLAlchemy schema, creates the table, and bulk-inserts rows. The `NN_` filename prefix is stripped to derive the table name.
- **Reference implementation**: `examples/02-select-basics/` — mirror its shape when in doubt.
