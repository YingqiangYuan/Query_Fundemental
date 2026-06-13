# Lesson 11 — Aggregate functions (no GROUP BY yet)

> Without `GROUP BY`, aggregate functions alone can already collapse a whole table into a single-row summary.

## What we'll learn

In this lesson we'll meet SQL's most commonly used **aggregate functions**.
What they all have in common: **they turn many rows into a single value**.

| Function | One-liner |
|----------|-----------|
| `COUNT(*)` | How many rows are there |
| `COUNT(col)` | How many rows where `col` IS NOT NULL |
| `COUNT(DISTINCT col)` | How many distinct values in `col` |
| `SUM(col)` | The total of `col` |
| `AVG(col)` | The mean of `col` |
| `MIN(col)` / `MAX(col)` | The smallest / largest value of `col` (works on numbers, dates, strings) |

This lesson **deliberately skips `GROUP BY`** -- that's the next lesson.
For now, keep one picture in mind: **whole table in, one row out**.

The single most important hidden rule: **every aggregate silently ignores NULL**.
This is the classic beginner trap, and the first example exists specifically to nail it down.

## The data story

The practice data is a slice of **personal bank account transactions**, from January through March 2025.

| Table | Contents | Rows |
|-------|----------|------|
| `transactions` | One row per transaction: account, date, category, merchant, amount, debit/credit type | 100 |

A few details worth flagging:

- `category` **deliberately has some NULLs** -- modelling "haven't gotten around to tagging it" transactions, used to demonstrate the gap between `COUNT(*)` and `COUNT(col)`.
- `type` has just two values: `debit` (money out) and `credit` (money in).
- Merchant names and categories are realistic (Whole Foods, Starbucks, Netflix, rent, payroll, ...) so you can picture the rows easily.

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

- In DBeaver, expand `transactions` in the left navigator and double-click to preview the rows.
- Glance at the `category` column -- you'll see a few empty (NULL) cells. Remember they're there.
- Skim the `merchant` column: which merchants repeat? Which appear only once?
- Notice the `type` column -- most rows are `debit`, but the monthly paycheck rows are `credit`.

These eyeball observations will shape how you interpret the query results below.
For instance, once you know NULLs exist, the gap between `COUNT(*)` and `COUNT(category)` won't surprise you.

## Work through the examples

Open the six SQL files below in order and run them **one at a time** in your SQL editor:

- The header comment in each file tells you:
  - What **business question** the query is trying to answer (written in plain English).
  - Which SQL constructs are being used and **why**.
- **Read the comment first**, predict the result.
- **Run** the query and look at the real output.
- Re-read the comment with the result in front of you -- does it line up with what you expected?

| File | Teaches |
|------|---------|
| [example_01.sql](./example_01.sql) | `COUNT(*)` vs `COUNT(col)` -- NULLs are silently skipped |
| [example_02.sql](./example_02.sql) | `SUM(amount)` -- total spend |
| [example_03.sql](./example_03.sql) | `AVG(amount)` -- average charge size |
| [example_04.sql](./example_04.sql) | `MIN` / `MAX` on a date column -- the time span of the data |
| [example_05.sql](./example_05.sql) | `COUNT(DISTINCT col)` -- number of unique merchants |
| [example_06.sql](./example_06.sql) | Multiple aggregates in one SELECT -- a one-row "monthly summary" |

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
