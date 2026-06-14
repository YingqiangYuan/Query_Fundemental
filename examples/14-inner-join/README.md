# Lesson 14 — INNER JOIN: stitch two tables together to ask real questions

> A single table can only answer half a question. When the pet's name lives in table A and the visit reason lives in table B, you need a JOIN to line them up.

## What we'll learn

The star of this lesson is **`INNER JOIN`** — the JOIN you'll reach for most often in real jobs.

We'll work through the following moves step by step:

| Construct | One-liner |
|-----------|-----------|
| `INNER JOIN ... ON ...` | Stitch two tables into one wide table on a shared key |
| Table aliases `p`, `v` | Give long table names a one- or two-letter nickname |
| Qualified columns `p.name` / `v.vet_name` | When both tables have a `name` column, you must tell the database which one you mean |
| `INNER JOIN` + `WHERE` | After joining, WHERE can filter on columns from either side |
| Bare `JOIN` | `JOIN` = `INNER JOIN`; the keyword `INNER` is optional |

Once INNER JOIN clicks, you've crossed the line from "I can only query one table" to "I can answer cross-table business questions." Everything that follows — LEFT JOIN, multi-table joins, self-joins — is just a small variation on top.

## The data story

The practice data is a small **veterinary clinic's** day-to-day log.

| Table | Contents | Rows |
|-------|----------|------|
| `pets` | One row per registered pet (name, breed, owner, date of birth, etc.) | 20 |
| `visits` | One row per clinic visit (which pet, when, why, which vet, how much) | 40 |

The two tables are linked by `pet_id`:
- `pets.pet_id` is the pet's unique ID.
- `visits.pet_id` points to which pet came in (the **foreign key**).

On average each pet has come in twice, but some have visited 3 times (like Charlie) and others only once. That's the classic "parent + child" shape you'll see in any real clinic.

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

Before you start on the examples, **strongly recommended: poke around yourself first**:

- In DBeaver, expand `pets` and `visits` in the left navigator and double-click each to preview the rows.
- Read each column name and its type.
- Pick a pet you like (say, Charlie), look up its profile in `pets`, then flip over to `visits` and find its visit history.
- Ask yourself: if you want "pet name + visit reason" on the same row, how would you line up these two tables?

Coming into the JOIN queries with that mental picture makes them click much faster.

## Work through the examples

Open the 5 SQL files below in order and run them **one at a time** in your SQL editor:

- The header comment in each file tells you:
  - What **business question** the query is trying to answer (written in plain English).
  - Which SQL constructs are being used and **why**.
- **Read the comment first**, predict the result.
- **Run** the query and look at the real output.
- Re-read the comment with the result in front of you — does it line up with what you expected?

| File | Teaches |
|------|---------|
| [example_01.sql](./example_01.sql) | `INNER JOIN ... ON ...` — stitch the two tables on `pet_id` |
| [example_02.sql](./example_02.sql) | Table aliases `pets AS p` / `visits AS v` — turn long names into short ones |
| [example_03.sql](./example_03.sql) | Qualify columns with `p.name` / `v.vet_name` to avoid "ambiguous column" errors |
| [example_04.sql](./example_04.sql) | INNER JOIN + `WHERE` filtering on columns from both sides ("dogs that had surgery") |
| [example_05.sql](./example_05.sql) | Bare `JOIN` — `INNER` is optional and the result is identical |

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
