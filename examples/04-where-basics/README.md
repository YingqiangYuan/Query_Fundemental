# Lesson 04 — WHERE basics

> Once you know `SELECT`, you can pull back the whole table. But in real work, nobody wants the whole table — people want **the rows that match a condition**. This lesson is about "pick out only the rows I care about".

## What we'll learn

This lesson is all about one keyword: **`WHERE`**.

Its job is simple: **filter out the rows that don't match the condition** and keep only the ones you care about.

We'll practice the most basic comparison operators:

| Form | One-liner |
|------|-----------|
| `WHERE col = 'value'` | Equal to (text needs single quotes) |
| `WHERE col != 'value'` or `<>` | Not equal to |
| `WHERE col > N` / `< N` | Strictly greater / less than (boundary NOT included) |
| `WHERE col >= N` / `<= N` | Greater-or-equal / less-or-equal (boundary IS included) |
| `WHERE col = NULL` | **Returns an empty result** — the most important "gotcha" of this lesson |

That last one (`= NULL`) is NOT us teaching you the right way to write it — it's us forcing you to **see it fail with your own eyes**. Almost every beginner trips over this once. We've planted it on purpose so you trip over it here. The proper fix, `IS NULL`, shows up later in Lesson 06.

## The data story

The practice data is a gym's **weekly class schedule**.

| Table | Contents | Rows |
|-------|----------|------|
| `gym_classes` | One row per class session (instructor, type, day of week, start time, duration, level, max capacity, current sign-ups) | 40 |

Class types cover yoga, spin, HIIT, pilates, and zumba; level is beginner / intermediate / advanced, with some classes that **haven't had a level set yet** — those NULL rows are the key ingredient for the gotcha at the end.

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

Before you start on the examples, **poke around yourself first**:

- In DBeaver, expand `gym_classes` in the left navigator and double-click to preview the rows.
- Read each column name and its type.
- Scroll through the 40 rows so you have a mental picture of the weekly schedule — which day has the most yoga? Which classes are nearly full? Which rows have an empty `level`?

The examples below will land much better with those observations in your head. You'll be able to predict what each query should return and then check yourself against the real output — much faster than guessing at unfamiliar data.

## Work through the examples

Open the five SQL files below in order and run them **one at a time** in your SQL editor:

- The header comment in each file tells you:
  - What **business question** the query is trying to answer (written in plain English).
  - Which SQL constructs are being used and **why**.
- **Read the comment first**, predict the result.
- **Run** the query and look at the real output.
- Re-read the comment with the result in front of you — does it line up with what you expected?

| File | Teaches |
|------|---------|
| [example_01.sql](./example_01.sql) | `WHERE col = 'value'` — text equality filter |
| [example_02.sql](./example_02.sql) | `WHERE col != 'value'` / `<>` — not equal |
| [example_03.sql](./example_03.sql) | `WHERE col > N` / `< N` — strict greater / less than |
| [example_04.sql](./example_04.sql) | `WHERE col >= N` / `<= N` — inclusive comparisons |
| [example_05.sql](./example_05.sql) | `WHERE col = NULL` — **the empty-result gotcha** (see it with your own eyes) |

`example_05.sql` is **supposed to return zero rows** — that empty result IS the lesson. The comment in the file explains exactly why.

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
