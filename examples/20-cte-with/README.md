# Lesson 20 — Common Table Expressions (`WITH`)

> When a query needs to "compute A first, then use A to compute B", CTEs let you write SQL top-to-bottom like prose.

## What we'll learn

This lesson's topic is the **`WITH ... AS (...)` Common Table Expression (CTE)**. It solves a very specific pain: when a query needs to reuse an intermediate result, nested subqueries become a headache — CTEs let the query read like an essay.

We'll practice the following moves:

| Construct | One-liner |
|-----------|-----------|
| Single CTE | Name an intermediate result, then use it in the main query |
| Multiple CTEs | Chain them with commas to express several steps in one query |
| Subquery → CTE refactor | Translate "nested-to-the-point-of-illegible" into "top-to-bottom" |
| CTE + join back to base tables | Compute an intermediate, then JOIN it back to base tables for the final report |

> Heads up: SQL also has `WITH RECURSIVE` for recursive queries (e.g. expanding an org chart). That's an advanced topic and is out of scope here.

## The data story

The practice data is a **real-estate brokerage system**: agents list properties, buyers close transactions, reports get pulled.

| Table | Contents | Rows |
|-------|----------|------|
| `agents` | Agent info (name, agency, hire date) | 10 |
| `listings` | Active listings (address, neighborhood, bedrooms, list price, status: active/pending/sold/withdrawn) | 40 |
| `transactions` | Closed sales (sale price, close date, buyer name) | 20 |

FK relationships: `listings.agent_id → agents.agent_id`, `transactions.listing_id → listings.listing_id`.

Note: **not every `status = 'sold'` listing has a matching row in `transactions`** (paperwork still pending), and `withdrawn` listings **never** have a transaction. This mismatch is exactly what makes the CTE examples interesting.

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

Before you dive in, **strongly recommended: poke around in DBeaver first**:

- Preview all three tables — get a feel for what columns `agents`, `listings`, and `transactions` have.
- Notice the distinct values of `listings.status` (active / pending / sold / withdrawn).
- Count: how many listings have `status = 'sold'`? How many rows in `transactions`? The numbers don't match — think about why.

That "look at the data before writing SQL" muscle memory matters — once you have a mental picture of each table, the CTE queries become a lot easier to read.

## Work through the examples

Open the four SQL files below in order and run them **one at a time** in your SQL editor:

- The header comment in each file tells you:
  - What **business question** the query is trying to answer (written in plain English).
  - Which SQL constructs are being used and **why**.
- **Read the comment first**, predict the result.
- **Run** the query and look at the real output.
- Re-read the comment with the result in front of you — does it line up with what you expected?

| File | Teaches |
|------|---------|
| [example_01.sql](./example_01.sql) | Single CTE — total closed sale value per agent |
| [example_02.sql](./example_02.sql) | Multiple CTEs chained — agent average vs company average |
| [example_03.sql](./example_03.sql) | Nested subquery → CTE refactor — same question, two ways |
| [example_04.sql](./example_04.sql) | CTE then JOIN back to base tables — a monthly closings report |

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
