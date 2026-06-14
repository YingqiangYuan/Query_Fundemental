# Lesson 22 — Window functions: ranking

> Don't let `GROUP BY` collapse your rows -- but still attach a rank to every row. That's exactly what window functions are for.

## What we'll learn

Until now, the only way to "rank" rows was `ORDER BY` plus counting in your head.
This lesson introduces **window functions**, which let the database attach a rank directly onto every row:

| Construct | One-liner |
|-----------|-----------|
| `ROW_NUMBER() OVER (ORDER BY ...)` | Stamp every row with a unique 1-based sequence number |
| `RANK()` | Ties share a rank; the NEXT rank skips ahead (1, 2, 2, 4, ...) |
| `DENSE_RANK()` | Ties share a rank; the NEXT rank does NOT skip (1, 2, 2, 3, ...) |
| `PARTITION BY` | Restart the ranking inside each group (each team gets its own 1, 2, 3, ...) |
| "Top-N per group" pattern | CTE computes `rn`, outer query filters `WHERE rn <= 3` |

The headline difference between window functions and `GROUP BY`:
**`GROUP BY` collapses many rows into one; window functions keep every row and just add a column.**

## The data story

The practice data is a **soccer-league match results** table. Each match is recorded as two rows (one per team), so we can rank questions like "which team performances scored the most goals?" and "what are each team's three highest-scoring matches?"

| Table | Contents | Rows |
|-------|----------|------|
| `match_results` | One row per team per match: goals_for, goals_against, result (W/D/L), competition (league/cup) | 80 |

The data **deliberately contains many matches with the same goals_for** (several 5-goal performances, nine 4-goal performances, etc.), so that the contrast between `RANK()` and `DENSE_RANK()` on ties is actually visible.

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

- In DBeaver, expand `match_results` and preview the first 20 rows.
- Read each column name and type -- notice that `match_date` is an ISO string (`YYYY-MM-DD`), which sorts correctly as plain text.
- Spot the team names you recognize, glance at the goals-scored distribution, and **make a private guess**: "Which team is probably the top scorer?"

Reading alone won't teach you window functions, but once you have a mental picture of the rows, the examples below land much faster.

## Work through the examples

Open the five SQL files below in order and run them **one at a time** in your SQL editor:

- The header comment in each file tells you:
  - What **business question** the query is trying to answer (in plain English).
  - Which SQL constructs are being used and **why**.
- **Read the comment first**, predict the result.
- **Run** the query and look at the real output.
- Re-read the comment with the result in front of you -- does it match what you expected?

| File | Teaches |
|------|---------|
| [example_01.sql](./example_01.sql) | `ROW_NUMBER() OVER (ORDER BY ...)` -- stamp every row with a unique sequence number |
| [example_02.sql](./example_02.sql) | `RANK()` vs `DENSE_RANK()` -- two ways to handle ties (gap vs no gap) |
| [example_03.sql](./example_03.sql) | `PARTITION BY team` -- rank inside each team independently |
| [example_04.sql](./example_04.sql) | Classic "Top-N per group": CTE + `WHERE rn <= 3` for each team's three highest-scoring matches |
| [example_05.sql](./example_05.sql) | `OVER (...)` vs `GROUP BY` -- window functions don't collapse rows |

> **Look closely at example_02**: find a group of rows where `goals_for` is the same and stare at the `rk` and `drk` columns. In the 4-goal cluster, `RANK` jumps from 2 to 5 (3 and 4 are skipped), while `DENSE_RANK` goes 2, 2, 2, 2, 2 then on to 3. That gap-vs-no-gap behavior is the single most important difference between the two functions.

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

The database **completely ignores** comments, so you can write whatever you want without affecting the query. We use comments in each example to record the business question and the "why" behind the SQL right next to the code, so when you re-read a file weeks later you can immediately remember what it does -- comments living with the code beats hunting back through a tutorial.
