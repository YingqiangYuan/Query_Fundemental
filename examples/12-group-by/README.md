# Lesson 12 — GROUP BY

> Lesson 11 taught you how to aggregate over the whole table. This lesson teaches you how to **split the table into groups** and aggregate inside each one — the actual shape of almost every business report you'll ever build.

## What we'll learn

Any time the business says "show me X **by** Y" — **revenue by category**, **sales by cashier**, **trend by month** — there's a `GROUP BY` hiding behind it.

The building blocks we'll practice:

| Construct | One-liner |
|-----------|-----------|
| `GROUP BY col` | Collapse every row sharing the same `col` value into one group |
| `GROUP BY` + `COUNT/SUM/AVG` | Return one aggregated row per group |
| `GROUP BY col1, col2` | Group by a combination of columns (e.g. month + category) |
| `ORDER BY <aggregate>` | Sort by the aggregate (the standard "leaderboard" idiom) |
| "Must appear in GROUP BY or be aggregated" | The classic GROUP BY gotcha |

By the end you can crank out the kind of small reports a convenience-store manager looks at every day.

## The data story

The practice data is one month of sales at a **convenience store**.

| Table | Contents | Rows |
|-------|----------|------|
| `sales` | One row per receipt (item, category, date, quantity, amount, cashier) | 120 |

Field notes:

- `category`: product category — `drinks` / `snacks` / `tobacco` / `household` / `lottery`
- `sale_date`: ISO date string covering all of May 2025
- `cashier`: who was at the register (4 people on rotation)
- `total_amount`: dollar amount for the transaction (tax included)

## Open the database

`db.sqlite` is already generated and committed in this folder, so you do **not** need to build it yourself. Just open `db.sqlite` in **DBeaver** (GUI) or with the `sqlite3` CLI. If you've forgotten how, jump back to [examples/01-sharpen-your-tools](../01-sharpen-your-tools) for a refresher.

> **If `db.sqlite` ever gets corrupted**: delete it and re-run [gen_db.py](./gen_db.py) to regenerate.
>
> ```bash
> python gen_db.py
> ```

## Explore the database first

Before running the examples, **poke around yourself first**:

- In DBeaver, expand `sales` and double-click to preview the rows.
- See which `category` and `cashier` values actually exist.
- Scroll through the 120 rows to get a feel for a typical receipt (quantities are mostly 1–5, totals are single-digit dollars).

Once the data feels concrete, every `GROUP BY` below maps cleanly to "I'm stacking these receipts into piles by X".

## Work through the examples

Open the six SQL files in order and run them **one at a time** in your editor:

- The header in each file tells you the **business question** and **why** the query is written that way.
- Read the comment, predict the result, then run and compare.

| File | Teaches |
|------|---------|
| [example_01.sql](./example_01.sql) | `GROUP BY` one column + `COUNT(*)` — transactions per category |
| [example_02.sql](./example_02.sql) | `GROUP BY` + `SUM` — total sales per cashier |
| [example_03.sql](./example_03.sql) | Several aggregates at once — count + sum + avg in one row |
| [example_04.sql](./example_04.sql) | `GROUP BY` two columns — month × category breakdown |
| [example_05.sql](./example_05.sql) | `GROUP BY` + `ORDER BY <aggregate>` — top-sellers leaderboard |
| [example_06.sql](./example_06.sql) | "Must appear in GROUP BY or be aggregated" — the classic trap |

One note on [example_06.sql](./example_06.sql): the comment shows the **broken** version that would error in stricter engines, and the query that actually runs is the fixed-up rewrite. The point is to recognize what that error looks like, so the next time you see it in the wild you immediately think "ah, GROUP BY gotcha again".

## A note on SQL comments

Every example file is full of `--` lines at the top. SQL has two comment styles:

```sql
-- Single-line comment: from `--` to the end of the line is ignored.

/*
 * Block comment: spans multiple lines.
 * Handy when an explanation runs long.
 */
```

The database **completely ignores** comments, so you can write whatever you want without changing the result. We record the business question and the "why" right next to the SQL so that when you re-read a file weeks later, you can immediately remember what it does.
