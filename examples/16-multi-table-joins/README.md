# Lesson 16 — Multi-table joins (3 or even 4 tables)

> Real-world queries rarely touch just one table. This lesson chains `INNER JOIN` and `LEFT JOIN` together across three or four tables to answer fully-formed questions like "who saw whom, at which venue, and how much did they pay?"

## What we'll learn

You've already practised `INNER JOIN` ([examples/14](../14-inner-join/)) and `LEFT JOIN` ([examples/15](../15-left-join/)) separately. This lesson **stacks them**:

| Skill | One-liner |
|-------|-----------|
| 3-table INNER JOIN | One query walks through three tables, hopping along FK links |
| 4-table INNER JOIN | Add one more table — same pattern, just one more `JOIN` line |
| Mixing INNER and LEFT | In the same query, some tables must match while others may not — keep the "may not" rows anyway |
| Aggregating across multi-table joins | Join everything into one wide row stream, then collapse with `GROUP BY` (revenue per venue, revenue per artist) |
| Readability: write joins in dependency order | Let the reader follow the FK chain top-to-bottom — pays off as soon as you cross 5 tables |

There's only one mental model to internalize: **a JOIN glues another table's columns onto the current result.** As long as a foreign key links them, you can keep gluing more on.

## The data story

The practice data is a small **concert ticketing system**:

| Table | Contents | Rows |
|-------|----------|------|
| `customers` | Ticket buyers (name, email, city) | 20 |
| `venues` | Venue info (name, city, capacity) | 6 |
| `events` | Show lineup (artist, venue FK, event date) | 12 |
| `tickets` | One row per ticket sold (event FK, customer FK, section, price, purchase date) | 80 |

Foreign-key links:
- `events.venue_id` → `venues.venue_id`
- `tickets.event_id` → `events.event_id`
- `tickets.customer_id` → `customers.customer_id`

We deliberately seeded the data with some "real-world bumps":
- A few customers (in Denver, Miami) bought **zero** tickets — handy for verifying that a LEFT JOIN really preserves them.
- Several customers bought **multiple** tickets (two seats to the same show, or attended several shows) — handy for verifying that `COUNT` and `SUM` across a join still produce the right numbers.

## Open the database

[db.sqlite](./db.sqlite) is **already generated and committed** in this folder, so you do **not** need to build it yourself. Open it directly in **DBeaver** or the `sqlite3` CLI.

> **If [db.sqlite](./db.sqlite) ever gets corrupted**: delete it and re-run [gen_db.py](./gen_db.py) to regenerate.
>
> ```bash
> python gen_db.py
> ```

## Explore the database first

Before diving into the examples, strongly recommended: poke around in DBeaver:

- Expand `customers`, `venues`, `events`, `tickets` in the left navigator and preview the first few rows of each.
- Notice **which columns are foreign keys** (anything with a `_id` suffix usually is).
- Trace in your head how the three or four tables connect. Start at `tickets`: one side links to `customers`, the other to `events`; from `events` you can hop on to `venues`.

Once you've walked the FK graph mentally, the JOIN statements below stop looking like magic and start looking like exactly what you'd write yourself.

## Work through the examples

Open the five SQL files in order and run them **one at a time** in your SQL editor:

- The header of each file states the **business question** and explains the **why** of the SQL. Read it first, predict the result, run, then re-read.

| File | Teaches |
|------|---------|
| [example_01.sql](./example_01.sql) | 3-table INNER JOIN — `tickets` × `customers` × `events` |
| [example_02.sql](./example_02.sql) | 4-table INNER JOIN — add `venues` for the full "story card" per ticket |
| [example_03.sql](./example_03.sql) | Mixing LEFT JOIN + INNER JOIN — keep customers who bought nothing |
| [example_04.sql](./example_04.sql) | `GROUP BY` on top of a multi-table join — revenue + ticket count per venue |
| [example_05.sql](./example_05.sql) | Same join skeleton, regrouped — revenue per artist, plus a note on join order for readability |

## A note on SQL comments

You'll notice every example file is full of `--` lines. SQL has two comment styles:

```sql
-- Single-line comment: from `--` to the end of the line is ignored by
-- the database.

/*
 * Block comment: spans multiple lines.
 * Handy when an explanation runs long.
 */
```

The database **completely ignores** comments, so you can write whatever you want without affecting the query. We use comments in each example to record the business question and the "why" behind the SQL right next to the code, so when you re-read a file weeks later you can immediately remember what it does.
