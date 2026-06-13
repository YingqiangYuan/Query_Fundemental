# Lesson 19 — Scalar and derived-table subqueries

> A SELECT inside another SELECT — when the "comparison value" or the "intermediate table" you need is itself the result of a query, subqueries step in.

## What we'll learn

Last lesson ([Lesson 18](../18-subqueries-in-where/)) we put subqueries in `WHERE`.
This lesson, we put them in `SELECT` and `FROM`:

| Shape | One-liner | What it looks like |
|-------|-----------|--------------------|
| **Scalar subquery** (in SELECT) | Subquery returns one value; the outer query reuses it on every row | `SELECT ..., (SELECT AVG(x) FROM t) AS avg_x FROM t` |
| **Derived table** (in FROM) | Subquery returns a small table; the outer query JOINs it like a real table | `FROM (SELECT subscriber_id, SUM(...) ...) AS agg` |
| **Correlated subquery** (in SELECT) | Subquery references each outer row, re-runs per row | `(SELECT AVG(x) FROM child WHERE child.fk = outer.id)` |
| **"Pre-aggregate, then JOIN"** | A clean rewrite of the correlated form | `LEFT JOIN (SELECT ... GROUP BY ...) AS agg ON ...` |

Once these four shapes click, you already have all the intuition you need for the next lesson on CTEs (`WITH`) —
a CTE is essentially a derived table lifted out and given a name.

## The data story

We run a **monthly subscription box** business (think Birchbox / Loot Crate):
- Subscribers receive a themed box every month ("Indie Snacks", "Cozy Reads", "Beauty Picks", …).
- Each subscriber is on one plan: `basic` / `premium` / `luxury` — plan tier drives how many items and how much value each box carries.

| Table | Contents | Rows |
|-------|----------|------|
| `subscribers` | One row per subscriber (name, plan, signup date, city) | 25 |
| `shipments` | One row per shipment (FK `subscriber_id`, ship date, box theme, item count, declared value) | 89 |

`shipments.subscriber_id` references `subscribers.subscriber_id`.

## Open the database

`db.sqlite` is already generated and committed in this folder.
Open it directly in **DBeaver** or in the `sqlite3` CLI — you do **not** need to run the generator yourself.

> **If `db.sqlite` ever gets corrupted**: delete it and re-run [gen_db.py](./gen_db.py) to regenerate.
>
> ```bash
> python gen_db.py
> ```

## Explore the database first

Before diving into the examples, strongly recommended: poke around in DBeaver first:

- Preview `subscribers`: how many distinct `plan` values? which cities show up?
- Preview `shipments`: what's the rough range of `declared_value`? which `box_theme` values do you see?
- Rough guess: is a luxury box really several times more valuable than a basic one?
- Imagine: if you had to compute "average box value per subscriber", how would you start?

Eyeballing the data before writing SQL makes the subquery shapes below feel natural —
you already have a mental picture of what the answer should look like, so writing the SQL is the easy half.

## Work through the examples

Open the four SQL files below in order and run them **one at a time** in your SQL editor:

| File | Teaches |
|------|---------|
| [example_01.sql](./example_01.sql) | **Scalar subquery in SELECT** — show a global average next to each row for comparison |
| [example_02.sql](./example_02.sql) | **Derived table in FROM** — pre-aggregate shipments per subscriber, then JOIN back to names |
| [example_03.sql](./example_03.sql) | **Correlated subquery in SELECT** — compute each subscriber's own average (intuitive, slower) |
| [example_04.sql](./example_04.sql) | **Pre-aggregate, then JOIN** — clean rewrite of example_03; natural stepping stone to CTEs |

Each file starts with a comment block: first the **business question** in plain English, then **why this query is shaped that way**. **Read the comment first, predict the result, then run, then compare.**

Pay close attention to examples 03 and 04 — they return **the same answer** with different shapes.
That's the most important contrast in this lesson: a single question often has multiple valid SQL shapes,
and "which one is more readable and more scalable" is a tradeoff you'll be making for the rest of your SQL life.

## A note on SQL comments

Every example file is full of `--` lines. SQL has two comment styles:

```sql
-- Single-line comment: from `--` to the end of the line is ignored by
-- the database.

/*
 * Block comment: spans multiple lines.
 * Handy when an explanation runs long.
 */
```

The database completely ignores comments, so write as much as you want — they don't affect the query.
We embed the business question and the "why" right next to the SQL so when you re-read a file weeks later you can immediately remember what it does.
