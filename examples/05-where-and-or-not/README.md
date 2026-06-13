# Lesson 05 — Compound WHERE: AND / OR / NOT

> Real-world filters are almost never a single condition. Let's learn how to glue multiple conditions together with AND / OR / NOT.

## What we'll learn

In [examples/04-where-basics](../04-where-basics/) we wrote single-condition `WHERE` clauses like `WHERE type = 'yoga'`.
But in real life a guest's request usually sounds more like:

> "I want a deluxe ocean-view room, with a balcony, that sleeps two, for under $300 a night."

One condition isn't enough. This lesson is about **combining** conditions.

| Construct | One-liner |
|-----------|-----------|
| `A AND B` | Both conditions must hold |
| `A OR B` | At least one condition must hold |
| `NOT A` | Flip the truth of a condition |
| `A AND (B OR C)` | Use **parentheses** to control AND / OR ordering |
| 3+ conditions | Real business filters are often a long chain of ANDs |

The single biggest "gotcha" in this lesson: when AND and OR appear in the same WHERE, the **precedence** is not the reading order you might expect. We have a dedicated example to nail this down.

## The data story

The practice data is a tiny **hotel room inventory**.

| Table | Contents | Rows |
|-------|----------|------|
| `hotel_rooms` | One row per room (room type, view, beds, max occupancy, balcony flag, nightly rate, floor) | 50 |

Column notes:

- `room_type`: `standard` / `deluxe` / `suite`
- `view`: `city` / `ocean` / `courtyard`
- `beds`: number of beds
- `max_occupancy`: max guests allowed
- `has_balcony`: `1` yes, `0` no
- `nightly_rate`: price per night, in USD
- `floor`: floor number

A single table — on purpose. This lesson is about practicing compound conditions; multi-table JOINs come later.

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

- In DBeaver, expand `hotel_rooms` in the left navigator and double-click to preview the rows.
- Read each column name and its type.
- Scroll through the 50 rows so you have a mental picture of the hotel — what's on each floor, are ocean-view rooms pricier, which room types come with balconies?

Once the data feels familiar, the queries below read a lot more easily. You'll be able to predict what each query should return and then verify — that's much faster than guessing at unfamiliar data.

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
| [example_01.sql](./example_01.sql) | `WHERE A AND B` — both conditions must hold |
| [example_02.sql](./example_02.sql) | `WHERE A OR B` — either condition is enough |
| [example_03.sql](./example_03.sql) | `WHERE NOT A` — flipping a condition |
| [example_04.sql](./example_04.sql) | `WHERE A AND (B OR C)` — parentheses change the meaning |
| [example_05.sql](./example_05.sql) | Chaining 3+ conditions in a real-world filter |

[example_04.sql](./example_04.sql) is the most important one in this lesson: **when AND and OR appear together, AND binds tighter than OR**, and without parentheses your query almost certainly doesn't mean what you think it means. Read that header comment carefully.

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
