# Lesson 08 — LIMIT / OFFSET / Top-N

> Once a result is sorted, how do you grab "just the top N", "page 2", "page 3"? That's this lesson.

## What we'll learn

This lesson is all about **slicing the result set** — given a bunch of already-sorted rows, how do you keep just the slice you actually want?

| Construct | One-liner |
|-----------|-----------|
| `ORDER BY ... DESC LIMIT N` | The classic "Top-N" idiom — leaderboard front-runners |
| `LIMIT N OFFSET M` | Skip the first M rows, then take N — classic "page 2 onwards" |
| `LIMIT M, N` (SQLite shorthand) | Equivalent form, argument order is easy to mix up |
| Generic pagination formula | `LIMIT page_size OFFSET page_size * (page - 1)` |
| ⚠️ `LIMIT` without `ORDER BY` | The engine gives you "whatever N rows" — an anti-pattern |

**The single most important rule:** **`LIMIT` should always show up with an `ORDER BY`.**
A bare `LIMIT 5` does NOT mean "top 5", it means "stop scanning at row 5" —
and which rows get scanned first is entirely up to the engine.

## The data story

The practice data is a **weekly podcast chart** — the same shape of leaderboard you'd see on Apple Podcasts or Spotify.

| Table | Contents | Rows |
|-------|----------|------|
| `chart_entries` | One row per chart entry per week (podcast, episode title, host, chart week, listens, weekly rank) | 80 |

The data spans 8 weeks (2025-03-03 through 2025-04-21), with 10 entries per week.
80 rows is the sweet spot: enough to demonstrate real pagination, small enough to scroll through.

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

Before you start on the examples, **strongly recommended: poke around yourself first**:

- In DBeaver, expand `chart_entries` in the left navigator and double-click to preview.
- Check how many distinct values appear in `chart_week` (hint: use `DISTINCT` from Lesson 02).
- Scroll through the `listens` column to get a feel for the magnitude (millions).
- Notice `rank` is the rank **within that week** (1–10), not a global rank across the whole table — that distinction matters when reading the examples.

## Work through the examples

Open the five SQL files below in order and run them **one at a time** in your SQL editor:

- The header comment in each file tells you:
  - What **business question** the query is trying to answer (in plain English).
  - Which SQL constructs are being used and **why**.
- **Read the comment first**, predict the result.
- **Run** the query and look at the real output.
- Re-read the comment with the result in front of you — does it line up with what you expected?

| File | Teaches |
|------|---------|
| [example_01.sql](./example_01.sql) | `ORDER BY ... DESC LIMIT 5` — the classic Top-N idiom |
| [example_02.sql](./example_02.sql) | `LIMIT 5 OFFSET 5` — page 2 (ranks 6–10) |
| [example_03.sql](./example_03.sql) | `LIMIT 5, 5` — SQLite's shorthand form |
| [example_04.sql](./example_04.sql) | The generic pagination formula: 10 per page, page 3 |
| [example_05.sql](./example_05.sql) | ⚠️ `LIMIT 3` with no `ORDER BY` — undefined result, anti-pattern |

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
