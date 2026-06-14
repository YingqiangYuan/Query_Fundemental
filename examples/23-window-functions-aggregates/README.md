# Lesson 23 — Window aggregates, LAG, and LEAD

> You want both the per-row detail AND the group-level summary — window aggregates give you both in a single query.

## What we'll learn

In the previous lesson we used window functions for **ranking**
(`ROW_NUMBER`, `RANK`, `DENSE_RANK`). This lesson switches to a different
family of window functions: **aggregates** (`SUM`, `AVG` with `OVER`),
plus two enormously useful "step one row" functions — `LAG` and `LEAD`.

| Construct | One-liner |
|-----------|-----------|
| `AVG(...) OVER (PARTITION BY ...)` | Attach "group average" to every row |
| `SUM(...) OVER (... ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)` | Running total |
| `AVG(...) OVER (... ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)` | 7-day rolling average |
| `LAG(col) OVER (ORDER BY ...)` | Value from the previous row (yesterday) |
| `LEAD(col) OVER (ORDER BY ...)` | Value from the next row (tomorrow) |
| `col - LAG(col) OVER (...)` | Day-over-day change pattern |

The big difference from `GROUP BY`:
**window functions do not collapse rows**. Every original day is still
there in the output, with a summary column tacked on the side. That's
exactly what window aggregates are for.

## The data story

The practice data is **roughly six months** of daily weather observations
for a single city, modeled after a place like Boston — four real
seasons, snowy winters, rainy spring.

| Table | Contents | Rows |
|-------|----------|------|
| `weather_days` | One row per day (date, high/low temperature, precipitation, humidity, weather condition) | 181 |

Column notes:

- `reading_date` — ISO `YYYY-MM-DD`, from 2024-11-01 through 2025-04-30, sorted chronologically.
- `temp_high_c` / `temp_low_c` — daily high/low temperature in Celsius.
- `precipitation_mm` — daily precipitation in millimetres (snow counted as melted equivalent).
- `humidity_pct` — daily average relative humidity, as a percentage.
- `condition` — one of `sunny` / `cloudy` / `rain` / `snow`.

A single table — on purpose. The point of window functions is
"keep the rows AND produce a summary on the same table"; multi-table
relationships would just be a distraction here.

## Open the database

`db.sqlite` is **already generated and committed** in this folder, so you do **not** need to build it yourself.
Just open `db.sqlite` in **DBeaver** (GUI) or in the `sqlite3` CLI.
If you've forgotten how, jump back to [examples/01-sharpen-your-tools](../01-sharpen-your-tools) for a refresher.

> **If `db.sqlite` ever gets corrupted**: delete it and re-run [gen_db.py](./gen_db.py) to regenerate.
>
> ```bash
> python gen_db.py
> ```

## Explore the database first

Before you start on the examples, **strongly recommended: poke around
yourself first**:

- In DBeaver, expand `weather_days` in the left navigator and
  double-click to preview the rows.
- Read each column name and its type.
- Scroll through the 181 rows and notice things like:
  - Does the winter high temperature ever drop below zero?
  - Which months in the `condition` column have the most `snow` days?
  - Is `precipitation_mm` always 0 on `sunny` days?

Once you have a **gut feel** for the data, the window-function queries
below will feel much more concrete — you'll be able to predict what
shape each result should have, then verify, which is a much faster way
to learn than guessing at unfamiliar data.

## Work through the examples

Open the six SQL files below in order and run them **one at a time** in
your SQL editor:

- The header comment in each file tells you:
  - What **business question** the query is trying to answer (written
    in plain English).
  - Which SQL constructs are being used and **why**.
- **Read the comment first**, predict the result.
- **Run** the query and look at the real output.
- Re-read the comment with the result in front of you — does it line up
  with what you expected?

| File | Teaches |
|------|---------|
| [example_01.sql](./example_01.sql) | `AVG(...) OVER (PARTITION BY ...)` — monthly average high attached to each day |
| [example_02.sql](./example_02.sql) | `SUM(...) OVER (... UNBOUNDED PRECEDING ...)` — cumulative precipitation since day one |
| [example_03.sql](./example_03.sql) | `AVG(...) OVER (... 6 PRECEDING ...)` — 7-day rolling average that smooths daily temperature noise |
| [example_04.sql](./example_04.sql) | `LAG(...)` — show yesterday's high next to today's |
| [example_05.sql](./example_05.sql) | `LEAD(...)` — show tomorrow's high next to today's |
| [example_06.sql](./example_06.sql) | `col - LAG(col) OVER (...)` — day-over-day change, surfacing the biggest swings |

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
