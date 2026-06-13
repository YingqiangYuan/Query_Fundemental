# Lesson 09 — Computed columns and CASE expressions

> What if the database doesn't store the "total" column you need? What if you want to sort statuses in workflow order, not alphabetical order? This lesson teaches you how to **compute columns on the fly inside SELECT**.

## What we'll learn

So far, every column we've queried has been a column that **already lives in the table**. But in real business work, the single most valuable column is often **not in the table at all**:

- The "order total" is usually not stored — only the unit price, quantity, delivery fee, and tip are.
- "Whether an order is done" is usually not stored — only a status string is.
- "Order size bucket" (S/M/L/XL) only lives in the product manager's head.

This lesson is about **computing those columns right inside the query**. Two big ideas:

| Construct | One-liner |
|-----------|-----------|
| **Arithmetic / string concat** | Combine existing columns with `+ - * /` and `\|\|` to form new columns |
| **`CASE WHEN ... THEN ... ELSE ... END`** | SQL's inline if/else — map one value to another based on rules |

`CASE` is the centerpiece of the lesson. It does much more than "translate a status into Chinese" —
it gives `ORDER BY` a custom sort order, labels rows into categories, and produces 0/1 flags that play nicely with later aggregates.
Master `CASE` and you can express most "it depends" business logic directly in SQL.

## The data story

The practice data is a stream of **food-delivery orders**.

| Table | Contents | Rows |
|-------|----------|------|
| `delivery_orders` | One row per order line (restaurant, item, qty, unit price, delivery fee, tip, status, placed at) | 60 |

The data includes real restaurants — Shake Shack, Chipotle, Domino's, Sweetgreen, Starbucks, and more —
with statuses spanning the full lifecycle: `placed`, `preparing`, `out-for-delivery`, `delivered`, `cancelled`.
So you're looking at the same shape of data a real ops dashboard would face.

Note: the table only stores **raw fields** — no total column, no status-bucket column —
every derived piece of information has to be computed on the fly with the techniques in this lesson.

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

Before the examples, try this in DBeaver:

- Double-click `delivery_orders` and preview the first few rows.
- Note the columns and their types; in particular, look at how many distinct values the `status` column takes.
- Mentally compute the total for one or two orders (`qty * unit_price + delivery_fee + tip`) so you have a number to check the query against later.

A bit of feel for the shape of the data goes a long way toward understanding the queries.

## Work through the examples

Open each SQL file below in order and run it **one query at a time** in your SQL editor:

- The header comment in each file tells you:
  - What **business question** the query is trying to answer (in plain English).
  - Which SQL constructs are being used and **why**.
- **Read the comment first**, predict the result.
- **Run** the query and look at the real output.
- Re-read the comment with the result in front of you — does it line up with what you expected?

| File | Teaches |
|------|---------|
| [example_01.sql](./example_01.sql) | Arithmetic computed column — `qty * unit_price + delivery_fee + tip AS total` |
| [example_02.sql](./example_02.sql) | String concatenation — `\|\|` to glue restaurant and item into one label |
| [example_03.sql](./example_03.sql) | Two-branch `CASE` — map `status` to a 0/1 done-flag |
| [example_04.sql](./example_04.sql) | Multi-branch `CASE` — bucket order totals into S/M/L/XL |
| [example_05.sql](./example_05.sql) | `CASE` inside `ORDER BY` — give statuses a custom workflow order |

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
