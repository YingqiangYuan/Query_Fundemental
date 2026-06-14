# Lesson 15 — LEFT JOIN

> INNER JOIN only keeps rows that match on both sides. But many business questions are really asking about the rows that *didn't* match — and that's exactly where LEFT JOIN earns its keep.

## What we'll learn

The spine of this lesson is **LEFT JOIN** — and its single most classic use: "find the rows in A that have no counterpart in B".

| Construct | One-liner |
|-----------|-----------|
| `LEFT JOIN` | Keep every row from the left table even when the right has no match |
| `LEFT JOIN ... WHERE r.<key> IS NULL` | The anti-join idiom — "in A but not in B" |
| `COUNT(r.<col>)` vs `COUNT(*)` | The most common LEFT-JOIN counting bug |
| `INNER JOIN` vs `LEFT JOIN` | Same data, swap the join, see how many rows you lose |
| `RIGHT JOIN` | Exists, almost never used — just rewrite as a LEFT with tables swapped |

By the end you should be able to spot at a glance that a business question calls for LEFT JOIN, and you should sidestep the famous `COUNT(*)` turning-zero-into-one bug.

## The data story

Pretend we're running a small ride-share platform. Two kinds of things live in the database: **drivers** and **rides**.

| Table | Contents | Rows |
|-------|----------|------|
| `drivers` | One row per registered driver (name, signup date, city, car) | 15 |
| `rides` | One row per completed ride (driver, rider, pickup/dropoff time, distance, fare) | 50 |

**Key wrinkle**: 3 drivers have just signed up and **have not given a single ride yet** (Kenji, Rachel, Andre). This is a very common real-world state — newly onboarded drivers who haven't taken their first trip. Most of this lesson's examples are about how to make sure those zero-ride drivers don't quietly fall out of our results.

`rides.driver_id` is a foreign key into `drivers.driver_id`.

## Open the database

`db.sqlite` is **already generated and committed** in this folder, so you do **not** need to build it yourself.
Just open `db.sqlite` in **DBeaver** (GUI) or in the `sqlite3` CLI.
If you've forgotten how, jump back to [examples/01](../01-sharpen-your-tools/) for a refresher.

> **If `db.sqlite` ever gets corrupted**: delete it and re-run [gen_db.py](./gen_db.py) to regenerate.
>
> ```bash
> python gen_db.py
> ```

## Explore the database first

Before you start on the queries, **strongly recommended: poke around yourself first**:

- In DBeaver, expand `drivers` and `rides` in the left navigator and double-click to preview the rows.
- Look at which `driver_id` values actually appear in `rides`.
- **Pay attention**: `drivers` has 15 rows, but only 12 distinct `driver_id` values show up in `rides` — those missing 3 are the protagonists of this lesson.

Going into the queries with the concrete question "which drivers gave no rides?" in your head makes everything below stick a lot faster than reading SQL cold.

## Work through the examples

Open the 5 SQL files below in order and run them **one at a time** in your SQL editor:

- The header comment in each file tells you what **business question** it answers, what SQL pieces it uses, and **why**.
- **Read the comment first**, predict the result.
- **Run** the query and look at the real output.
- Re-read the comment with the result in front of you — does it line up with what you expected?

| File | Teaches |
|------|---------|
| [example_01.sql](./example_01.sql) | `LEFT JOIN` basics — every driver + their rides, including zero-ride drivers |
| [example_02.sql](./example_02.sql) | `LEFT JOIN ... WHERE r.ride_id IS NULL` — the anti-join idiom, "drivers who've never given a ride" |
| [example_03.sql](./example_03.sql) | `COUNT(r.ride_id)` vs `COUNT(*)` — the most common LEFT-JOIN bug |
| [example_04.sql](./example_04.sql) | Same query under `INNER JOIN` vs `LEFT JOIN` — the gap is exactly the zero-ride set |
| [example_05.sql](./example_05.sql) | A quick note on `RIGHT JOIN` — it works, but almost no one writes it |

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
