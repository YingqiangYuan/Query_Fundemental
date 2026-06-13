# Lesson 07 — Sorting results with ORDER BY

> The same data tells a totally different story depending on how you sort it. This lesson is all about mastering `ORDER BY`.

## What we'll learn

The last few lessons focused on **filtering** — `WHERE` lets us pick the rows we care about.
But the **order** those rows come back in is decided by the database, and it is not necessarily the order you want.

This lesson is about **taking control of result order**:

| Construct | One-liner |
|-----------|-----------|
| `ORDER BY col` | Sort by a column ascending (the default) |
| `ORDER BY col DESC` | Sort descending (largest at the top) |
| `ORDER BY a, b` | Sort by `a`; break ties with `b` |
| Mixed `ASC` / `DESC` | Each column gets its own direction |
| `NULLS LAST` | Push NULL values to the bottom of the result |
| `ORDER BY 1` | Reference a column by its position (works, but fragile) |

Once you have these down, you can answer a whole class of questions: "what are the top 10?", "sort by year and then runtime", "group by type then rank by score" — and so on.

## The data story

The practice data is a small **streaming-service catalog** — movies and series in a single table.

| Table | Contents | Rows |
|-------|----------|------|
| `titles` | One row per title (name, type, release year, runtime, IMDb score, Rotten Tomatoes score, cumulative watch hours) | 40 |

A single table on purpose, so your attention stays on `ORDER BY` itself.
Note: a few older titles do not have a Rotten Tomatoes score (`rotten_score` is NULL) — this is deliberate, so we can practice "how do I handle NULL when sorting?" in [example_05.sql](./example_05.sql).

## Open the database

`db.sqlite` is **already generated and committed** in this folder, so you do **not** need to build it yourself.
Just open `db.sqlite` in **DBeaver** (GUI) or in the `sqlite3` CLI.
If you've forgotten how, jump back to [examples/01_sharpen_your_tools](../01_sharpen_your_tools/) for a refresher.

> **If `db.sqlite` ever gets corrupted**: delete it and re-run [gen_db.py](./gen_db.py) to regenerate.
>
> ```bash
> python gen_db.py
> ```

## Explore the database first

Before you run the examples, **strongly recommended: poke around yourself first**:

- In DBeaver, expand `titles` in the left navigator and double-click to preview the rows.
- Notice the `type` column only has two values: `movie` and `series`.
- Skim `imdb_score`, `rotten_score`, and `watch_hours_millions` to get a feel for the **range** of values in each.
- Spot the rows where `rotten_score` is empty (NULL) — those rows are the stars of [example_05.sql](./example_05.sql).

Sorting questions are the worst when "you don't know what the result is supposed to look like." Look at the raw data first so you can **predict** before each query: which title should land on top? Which should land at the bottom? Then run it and compare. That feedback loop is much faster than staring at SQL in the abstract.

## Work through the examples

Open the six SQL files below in order and run them **one at a time** in your SQL editor:

- The header comment in each file tells you:
  - What **business question** the query is trying to answer (in plain English).
  - Which SQL constructs are being used and **why**.
- **Read the comment first**, predict the result.
- **Run** the query and look at the real output.
- Re-read the comment with the result in front of you — does it match what you expected?

| File | Teaches |
|------|---------|
| [example_01.sql](./example_01.sql) | `ORDER BY col` — default ascending sort |
| [example_02.sql](./example_02.sql) | `ORDER BY col DESC` — descending sort (foundation of "Top N") |
| [example_03.sql](./example_03.sql) | Multi-column sort — sort by one column, break ties with the next |
| [example_04.sql](./example_04.sql) | Mixed `ASC` / `DESC` — each column gets its own direction |
| [example_05.sql](./example_05.sql) | `NULLS LAST` — keep NULL rows at the bottom |
| [example_06.sql](./example_06.sql) | `ORDER BY <column number>` — shorthand (works, but fragile) |

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
