# Lesson 06 — LIKE / IN / BETWEEN / IS NULL

> Equality (`=`) only matches exact values. But in real life we constantly ask "titles starting with The...", "prices between 10 and 20", "rows where this field hasn't been filled in". This lesson teaches the sharper filtering tools.

## What we'll learn

This lesson adds four more flexible filtering tools on top of the basic `WHERE`:

| Construct | One-liner |
|-----------|-----------|
| `LIKE 'The %'` | Pattern match: titles starting with "The " |
| `LIKE '_he %'` | `_` wildcard matches a single character (catches both "The" and "She") |
| `IN (...)` | Equals any value in this list |
| `NOT IN (...)` | Not in this list |
| `BETWEEN a AND b` | Falls between two values (**inclusive on both ends**) |
| `IS NULL` / `IS NOT NULL` | The **correct** way to test for missing values (`= NULL` never works) |

These are the highest-frequency filtering tools in everyday SQL. Once you've got them, a single `WHERE` line can already express maybe 80% of real-world business filters.

## The data story

The practice data is a small movie-theater chain's **showtimes table** for about two weeks.

| Table | Contents | Rows |
|-------|----------|------|
| `showtimes` | One row per screening (title, theater, screen, start/end time, rating, audio language, subtitle language, ticket price) | 50 |

A single table on purpose — focus on the filtering syntax.
Note: the `subtitle_lang` column has **many NULL rows** — those screenings play in the original audio only with no subtitle track. We rely on that "blank" property in the last example to practice `IS NULL`.

## Open the database

`db.sqlite` is **already generated and committed** in this folder, so you do **not** need to build it yourself.
Just open `db.sqlite` in **DBeaver** (GUI) or in the `sqlite3` CLI.
If you've forgotten how, jump back to [examples/01-sharpen-your-tools](../01-sharpen-your-tools/) for a refresher.

> **If `db.sqlite` ever gets corrupted**: delete it and re-run [gen_db.py](./gen_db.py) to regenerate.
>
> ```bash
> python gen_db.py
> ```

## Explore the database first

Before you start on the examples, **strongly recommended: poke around yourself first**:

- In DBeaver, expand `showtimes` in the left navigator and double-click to preview the rows.
- Read each column and what its values look like: what `screen_number` values exist? What ratings? Is `language` only English?
- **Pay extra attention to `subtitle_lang`** — you'll see a lot of blanks (NULLs) and a smaller set of "English", "Spanish", "French" values.

Building this mental picture up front makes the queries below much more concrete: you can predict what each one should return and then verify, which is way faster than guessing at unfamiliar data.

## Work through the examples

Open the six SQL files below in order and run them **one at a time** in your SQL editor:

- The header comment in each file tells you:
  - What **business question** the query is trying to answer (in plain English).
  - Which SQL constructs are being used and **why**.
- **Read the comment first**, predict the result.
- **Run** the query and look at the real output.
- Re-read the comment with the result in front of you — does it line up with what you expected?

| File | Teaches |
|------|---------|
| [example_01.sql](./example_01.sql) | `LIKE 'The %'` — the `%` wildcard matches any length |
| [example_02.sql](./example_02.sql) | `LIKE '_he %'` — the `_` wildcard matches a single character |
| [example_03.sql](./example_03.sql) | `IN (...)` — equals any value in a list |
| [example_04.sql](./example_04.sql) | `NOT IN (...)` — not in the list |
| [example_05.sql](./example_05.sql) | `BETWEEN a AND b` — falls between two values (inclusive) |
| [example_06.sql](./example_06.sql) | `IS NULL` / `IS NOT NULL` — the correct way to test for missing values |

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

The database **completely ignores** comments, so you can write whatever you want without affecting the query. We use comments in each example to record the business question and the "why" behind the SQL right next to the code, so when you re-read a file weeks later you can immediately remember what it does — comments living with the code beats hunting back through a tutorial.
