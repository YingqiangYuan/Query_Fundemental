# Lesson 18 — Subqueries in `WHERE`

> When you want to ask "is this value in the result of another query?", a subquery is your answer. Let's walk through `IN`, `EXISTS`, and the NULL traps that come with them.

## What we'll learn

This lesson is about **subqueries inside a `WHERE` clause** — using "the result of another SELECT" as a filter.

We'll practice the five most common shapes:

| Construct | One-liner |
|-----------|-----------|
| `WHERE col IN (SELECT ...)` | Is the current row's `col` in the subquery's result list? |
| `WHERE col NOT IN (SELECT ...)` | Is it absent — **but watch out, NULL trashes this** |
| `WHERE EXISTS (SELECT ...)` | Does the subquery return at least one row? ("does any exist") |
| `WHERE NOT EXISTS (SELECT ...)` | Does it return no rows at all? (NULL-safe replacement for `NOT IN`) |
| `WHERE col > (SELECT AVG(...) ...)` | Compare against a single value produced by a scalar subquery |

The single most important lesson here is: **`NOT IN` silently returns zero rows when the subquery contains a NULL**. Textbooks all mention it, but only once you've seen it bite you in person does the lesson actually stick. So we've deliberately set up the data so you can step on the rake yourself.

## The data story

The practice data is a **tiny dating app**.

| Table | Contents | Rows |
|-------|----------|------|
| `users` | One row per user (username, age, city, last active time). **A few inactive accounts have `last_active_at` set to NULL.** | 30 |
| `matches` | One row per match (`user_a_id` initiator, `user_b_id` other side, when it happened, message count). **A few rows have `user_b_id` set to NULL** — pending invites where the other side hasn't reciprocated yet. | 54 |

Why the deliberate NULLs? Because that's exactly what makes the `NOT IN` trap fire. No NULL, no bug; no bug, no lesson — and you'd write it wrong later.

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

- In DBeaver, expand `users` and `matches` in the left navigator and preview the rows.
- Count: how many rows in `users` have `last_active_at IS NULL`? How many rows in `matches` have `user_b_id IS NULL`?
- Pick a user and look at how often they appear as `user_a_id` vs `user_b_id` in `matches`.

Loading this picture into your head up front makes the subqueries below much clearer — you'll be able to predict roughly which rows each query should return, then check yourself.

## Work through the examples

Open the five SQL files below in order and run them **one at a time** in your SQL editor:

- The header comment in each file tells you what **business question** the query is answering and **why** it's written this way.
- **Read the comment first**, predict the result.
- **Run** the query and look at the real output.
- Re-read the comment with the result in front of you — does it line up with what you expected?

| File | Teaches |
|------|---------|
| [example_01.sql](./example_01.sql) | `IN (SELECT ...)` — using a subquery as a filter whitelist |
| [example_02.sql](./example_02.sql) | `NOT IN (SELECT ...)` — **trips the NULL gotcha and returns 0 rows** |
| [example_03.sql](./example_03.sql) | `EXISTS (SELECT ...)` — correlated subquery, "does any matching row exist?" |
| [example_04.sql](./example_04.sql) | `NOT EXISTS (SELECT ...)` — NULL-safe replacement for `NOT IN`, fixes example_02 |
| [example_05.sql](./example_05.sql) | `col > (SELECT AVG(...) ...)` — scalar subquery on the right side of a comparison |

**The key moment**: when `example_02.sql` returns zero rows, don't panic — that *is* the expected result. Immediately run `example_04.sql` and watch four real "wallflower" users finally show up. That side-by-side is the lesson: you've now **seen with your own eyes** how `NOT IN` and `NOT EXISTS` diverge when NULL enters the picture.

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

The database **completely ignores** comments, so you can write whatever you want without affecting the query. We use comments in each example to record the business question and the "why" behind the SQL right next to the code, so when you re-read a file weeks later you can immediately remember what it does — comments living with the code beats hunting back through a tutorial.
