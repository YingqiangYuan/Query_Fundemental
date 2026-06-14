# Lesson 21 — Set operations (UNION / INTERSECT / EXCEPT)

> Two tables record dine-in and takeout orders separately. How do we stack them, intersect them, and subtract one from the other? That's what this lesson is about.

## What we'll learn

Up to now, every SELECT we've written produced **one** result set.
This lesson teaches how to **combine two result sets into one** — the four most common ways:

| Construct | One-liner |
|-----------|-----------|
| `UNION ALL` | Stack the two results, **keep duplicates** |
| `UNION` | Stack the two results, **remove duplicate rows** |
| `INTERSECT` | Keep only rows that appear in **both** (intersection) |
| `EXCEPT` | Keep only rows in the **first** that are **not** in the second (set difference) |

The idea behind set operations is to treat each SELECT's **result set** like a mathematical set, then add or subtract them. Their biggest strength: when you only care about whether a column shows up in both queries, set operations are more direct, shorter, and closer to plain English than the JOIN- or subquery-based alternatives.

There is one **hard rule**, though: the two SELECTs being combined must return the **same number of columns, in the same order, with compatible types** — SQLite matches columns **by position, not by name**. The last example focuses on this rule.

## The data story

The scenario is a small coffee shop that records orders on two separate lines of business:

| Table | Contents | Rows |
|-------|----------|------|
| `dine_in_orders` | Dine-in orders (`order_id`, `customer_email`, `items_total`, `ordered_at`, `table_number`) | 30 |
| `takeout_orders` | Takeout orders (`receipt_id`, `customer_email`, `items_total`, `ordered_at`, `pickup_time`) | 30 |

The two tables have **no foreign key relationship** — they independently record two channels. But because the same customer might both dine in and order takeout, `customer_email` **overlaps** across the two tables, which is exactly where set operations shine.

> Note one **intentional gotcha**: the "primary key" column has a different name on each side (`order_id` vs `receipt_id`), and the other columns are similar but not identical (`table_number` vs `pickup_time`). This happens all the time in real life — two systems evolved separately, so the column names never line up cleanly. To use set operations across them, you'll have to **alias columns with AS** so the two sides match up.

## Open the database

`db.sqlite` is **already generated and committed** in this folder, so you do **not** need to build it yourself.
Just open `db.sqlite` in **DBeaver** (GUI) or the `sqlite3` CLI.
If you've forgotten how, jump back to [examples/01-sharpen-your-tools](../01-sharpen-your-tools/) for a refresher.

> **If `db.sqlite` ever gets corrupted**: delete it and re-run [gen_db.py](./gen_db.py) to regenerate.
>
> ```bash
> python gen_db.py
> ```

## Explore the database first

Before you start on the examples, **strongly recommended: poke around yourself first**:

- In DBeaver, expand `dine_in_orders` and `takeout_orders` in the left navigator and double-click each to preview the rows.
- Compare the columns side by side: which names match? Which don't? What are the types?
- Pick a frequent email (e.g. `emma.larsson@gmail.com`) and filter both tables by it — has she ordered on both channels?
- Make a rough mental estimate: roughly how many customers ordered **only dine-in**, **only takeout**, and **both**?

Those predictions will make the INTERSECT and EXCEPT results immediately recognizable — instead of getting lost in a wall of email addresses.

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
| [example_01.sql](./example_01.sql) | `UNION ALL` — stack dine-in and takeout orders into one combined feed |
| [example_02.sql](./example_02.sql) | `UNION` — same stack, but **deduped**, useful for a mailing list |
| [example_03.sql](./example_03.sql) | `INTERSECT` — customers who came **both** ways (multi-channel regulars) |
| [example_04.sql](./example_04.sql) | `EXCEPT` — customers who **only** dined in and never did takeout |
| [example_05.sql](./example_05.sql) | Column-count / type compatibility rules, plus a deliberate-error example |

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
