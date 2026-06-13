# Lesson 10 — Built-in functions

> The strings, numbers, and dates stored in a database are rarely in the exact shape you want. This lesson teaches you to use SQLite's "built-in toolbox" — built-in functions — to reshape them in place.

## What we'll learn

This lesson is all about **SQLite's built-in functions**: you don't need to install anything extra, you can just call them inside `SELECT`.
We'll group the common ones by the kind of data they operate on, plus a final section on NULL handling:

| Category | Representative functions | One-liner |
|----------|--------------------------|-----------|
| Strings · case and length | `UPPER`, `LOWER`, `LENGTH`, `TRIM` | Normalize strings (unify case, strip whitespace, measure length) |
| Strings · slice and replace | `SUBSTR`, `REPLACE`, `INSTR` | Extract a piece, substitute a substring, find a position |
| Numbers | `ROUND`, `ABS`, `CAST` | Round, take absolute value, force a type conversion |
| Dates | `date()`, `strftime()`, `julianday()` | Normalize a date, bucket by month, compute day differences |
| NULL handling | `COALESCE`, `IFNULL` | Provide a fallback when a column is NULL |

By the end of this lesson you'll be able to clean and format data directly in SQL, without exporting to Excel or Python first.

## The data story

The scenario for this lesson is a **public library's checkout records**.

| Table | Contents | Rows |
|-------|----------|------|
| `checkouts` | One row per checkout (member name, email, book title, checkout date, due date, returned date, late fee) | 50 |

The data is **deliberately a bit messy** — which makes it good practice material:

- Some `member_name` values have stray leading/trailing whitespace (good for `TRIM` and `LENGTH`).
- `member_email` values use a variety of domains (gmail / yahoo / outlook / hotmail / icloud / several university `.edu` domains), giving us material for `SUBSTR` (slice out the domain) and `REPLACE` (swap the domain).
- Checkouts that haven't been returned yet have `returned_date = NULL`; checkouts that didn't incur a fine have `late_fee = NULL` — exactly the cases the `COALESCE` / `IFNULL` section is designed for.

## Open the database

`db.sqlite` is **already generated and committed** in this folder, so you do **not** need to build it yourself.
Just open it in **DBeaver** (GUI) or in the `sqlite3` CLI.

> **If `db.sqlite` ever gets corrupted**: delete it and re-run [gen_db.py](./gen_db.py) to regenerate.
>
> ```bash
> python gen_db.py
> ```

## Explore the database first

Before you start on the examples, **poke around yourself first**:

- In DBeaver, expand `checkouts` in the left navigator and double-click to preview the rows.
- Notice which rows have NULL `returned_date` / `late_fee` — those are exactly the rows the NULL-handling section will "patch up" later.
- Scan down the `member_email` column and count how many distinct domains you see.

A quick mental picture of the data up front will make the queries below much easier to read.

## Work through the examples

Open the five files below in order and run them **one at a time** in your SQL editor:

- The header comment in each file tells you what **business question** the query is answering and why it's written the way it is.
- **Read the comment first** and predict the result.
- **Run** the query and compare actual output against your prediction.

| File | Teaches |
|------|---------|
| [example_01.sql](./example_01.sql) | String functions — `UPPER` / `LOWER` / `LENGTH` / `TRIM` to normalize names |
| [example_02.sql](./example_02.sql) | String functions — `SUBSTR` + `INSTR` to extract an email domain, `REPLACE` to swap it |
| [example_03.sql](./example_03.sql) | Numeric functions — `ROUND` for decimal precision, `ABS` for magnitude, `CAST` to integer |
| [example_04.sql](./example_04.sql) | Date functions — `date()` to normalize, `strftime('%Y-%m', ...)` to bucket by month, `julianday()` for day differences |
| [example_05.sql](./example_05.sql) | NULL handling — `COALESCE` and `IFNULL` to fill in friendly fallbacks |

## A note on SQL comments

Every example file uses many `--` lines for explanation. SQL has two comment styles:

```sql
-- Single-line comment: from `--` to the end of the line is ignored by
-- the database.

/*
 * Block comment: spans multiple lines.
 * Handy when an explanation runs long.
 */
```

The database **completely ignores** comments, so you can write whatever you want without affecting the query. We keep the "business question" and the "why" right next to the SQL — so when you re-read a file later, you can immediately remember what it does.
