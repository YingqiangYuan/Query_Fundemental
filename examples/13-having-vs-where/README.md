## What we'll learn

This lesson has one core goal: **finally nail the difference between `WHERE` and `HAVING`**.

Lots of SQL beginners get stuck on these two keywords — they both look like they "filter," but they filter different things:

| Keyword | What it filters | When it runs |
|---------|-----------------|--------------|
| `WHERE` | **individual raw rows** | **before GROUP BY** |
| `HAVING` | **the groups themselves, after grouping** | **after GROUP BY** |

We'll practice these moves:

- `GROUP BY user_name HAVING AVG(steps) >= 8000` — the most common use of HAVING
- Putting a WHERE version and a HAVING version **side by side** so you can see they answer different questions
- The full SELECT pipeline: `WHERE → GROUP BY → HAVING → ORDER BY → LIMIT`
- Multiple conditions inside `HAVING` (`AND` / `OR`)

By the end you should be able to look at a filter and just feel: "this belongs in WHERE" or "this belongs in HAVING."

## The data story

The practice data is a **fitness-tracker daily log**.

| Table | Contents | Rows |
|-------|----------|------|
| `daily_logs` | One row per user per day (steps, calories burned, active minutes, distance in km) | 150 |

The data covers **10 users**, each with **15 days** logged (2025-05-01 through 2025-05-15).
The activity levels between users are intentionally very different — some people walk a lot, some are mostly sedentary —
so that a condition like `HAVING avg(steps) >= 8000` actually filters something useful.
Results won't be "everyone passes" or "no one passes."

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

Before you start on the examples, **strongly recommended: poke around yourself first**:

- In DBeaver, expand `daily_logs` in the left navigator and double-click to preview the rows.
- Read each column name and its type.
- Scroll through the data — note roughly which users appear and the rough range of daily steps.
- In your head, guess: "if I group by user and average their steps, who do I expect to clear 8,000?"

Comparing your guess to what each query returns is the fastest way to build intuition for what HAVING is actually doing.

## Work through the examples

Open the SQL files below in order and run them **one at a time** in your SQL editor:

- The header comment in each file tells you:
  - What **business question** the query is trying to answer (in plain English).
  - Which SQL constructs are being used and **why**.
- **Read the comment first**, predict the result.
- **Run** the query and look at the real output.
- Re-read the comment with the result in front of you — does it line up with what you expected?

| File | Teaches |
|------|---------|
| [example_01.sql](./example_01.sql) | `GROUP BY` + `HAVING` — group by user and keep only those whose average steps >= 8000 |
| [example_02.sql](./example_02.sql) | `WHERE` vs `HAVING` — same data, two filters, two different questions answered |
| [example_03.sql](./example_03.sql) | The full pipeline — `WHERE → GROUP BY → HAVING → ORDER BY → LIMIT` in one query |
| [example_04.sql](./example_04.sql) | Multiple conditions in `HAVING` (`AND`) — high average steps **and** high total active minutes |

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
