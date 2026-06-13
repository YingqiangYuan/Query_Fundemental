# Lesson 02 — SELECT basics

> No WHERE, no GROUP BY, no JOIN — what business questions can you answer with just the most basic SELECT?

## What we'll learn

The single goal of this lesson is: **get fully comfortable with SELECT**.

We'll practice the four smallest, most common SQL building blocks:

| Construct | One-liner |
|-----------|-----------|
| `SELECT *` | Pull back the whole table |
| `LIMIT n` | Take only the first n rows (peek at the data) |
| `COUNT(*)` | Count how many rows there are |
| `DISTINCT col` | See the unique values in a column |

These four moves are the opening gambit of every more complex query you'll
ever write. Get them down and you can already answer a whole category of
basic business questions. Skip them and no amount of fancy syntax will
save you later.

## The data story

The practice data is a tiny **bookstore inventory**.

| Table | Contents | Rows |
|-------|----------|------|
| `books` | One row per book (title, author, genre, year, pages, price, stock count) | 20 |

A single table — on purpose.
We want you focused on SELECT itself this lesson, without multi-table
relationships getting in the way. Later lessons will add more tables and
relationships.

## One-time project setup

This is your **first hands-on lesson** in the repo. Every later lesson reuses the same Python environment, so you only need to install it **once**:

```bash
mise inst
```

## Open the database

`db.sqlite` is **already generated and committed** in this folder, so you do **not** need to build it yourself.
Just open `db.sqlite` in **DBeaver** (GUI) or in the `sqlite3` CLI.
If you've forgotten how, jump back to [examples/01](../01/) for a refresher.

> **If `db.sqlite` ever gets corrupted**: delete it and re-run [gen_db.py](./gen_db.py) to regenerate.
>
> ```bash
> python gen_db.py
> ```

## Explore the database first

Before you start on the examples, **strongly recommended: poke around
yourself first**:

- In DBeaver, expand `books` in the left navigator and double-click to
  preview the rows.
- Read each column name and its type.
- Scroll through the 20 rows so you have a mental picture of the
  inventory in front of you.

Reading alone won't teach you SQL, but the queries below will feel a lot
more grounded once you can picture the rows they're touching. You'll be
able to predict what a query should return and then check yourself —
that's a much faster way to learn than guessing at unfamiliar data.

## Work through the examples

Open the four SQL files below in order and run them **one at a time** in
your SQL editor:

- The header comment in each file tells you:
  - What **business question** the query is trying to answer (written in
    plain English).
  - Which SQL constructs are being used and **why**.
- **Read the comment first**, predict the result.
- **Run** the query and look at the real output.
- Re-read the comment with the result in front of you — does it line up
  with what you expected?

| File | Teaches |
|------|---------|
| [example_01.sql](./example_01.sql) | `SELECT *` — pull back every row |
| [example_02.sql](./example_02.sql) | `LIMIT` — only the first few rows |
| [example_03.sql](./example_03.sql) | `COUNT(*)` — total row count |
| [example_04.sql](./example_04.sql) | `DISTINCT` — unique values in a column |

## A note on SQL comments

You'll notice every example file is full of `--` lines.
SQL has two comment styles:

```sql
-- Single-line comment: from `--` to the end of the line is ignored by
-- the database.

/*
 * Block comment: spans multiple lines.
 * Handy when an explanation runs long.
 */
```

The database **completely ignores** comments, so you can write whatever
you want without affecting the query. We use comments in each example to
record the business question and the "why" behind the SQL right next to
the code, so when you re-read a file weeks later you can immediately
remember what it does — comments living with the code beats hunting back
through a tutorial.
