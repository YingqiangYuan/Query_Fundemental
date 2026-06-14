# Lesson 03 — Pick columns, rename them

> Last lesson we used `SELECT *` to pull back the whole table. This time we'll do something more everyday: **only pick the columns we actually want**, and **give them nicer names**.

## What we'll learn

In real work, `SELECT *` is rare. Far more common is "just these few columns" and "rename the columns so the report reads well." We'll practice these minimal building blocks:

| Construct | One-liner |
|-----------|-----------|
| `SELECT col1, col2` | Pull back only the columns you want (called "projection") |
| Reorder the columns | The SELECT list order *is* the result order |
| `AS new_name` | Give a column an alias so the result header reads nicely |
| Drop the `AS` | The keyword is optional, but we recommend writing it |
| Same column listed twice | A column can appear more than once with different aliases |

Once you have these, you can turn a messy raw table into a business-friendly, human-named result — that's the most frequent step in day-to-day data work.

## The data story

The practice data is a coffee shop's **drinks menu**.

| Table | Contents | Rows |
|-------|----------|------|
| `drinks` | One row per drink (name, category, size, milk type, syrup, calories, price, seasonal flag) | 30 |

A single table again — like Lesson 02, we want you focused on "picking columns" and "renaming them," without multi-table relationships getting in the way.

## Open the database

[db.sqlite](./db.sqlite) is **already generated and committed** in this folder, so you do **not** need to build it yourself. Just open it in **DBeaver** (GUI) or in the `sqlite3` CLI. If you've forgotten how, jump back to [examples/01-sharpen-your-tools](../01-sharpen-your-tools) for a refresher.

> **If `db.sqlite` ever gets corrupted**: delete it and re-run [gen_db.py](./gen_db.py) to regenerate.
>
> ```bash
> python gen_db.py
> ```

## Explore the database first

Before starting on the examples, **strongly recommended: poke around yourself first**:

- In DBeaver, expand `drinks` in the left navigator and double-click to preview the rows.
- Read each column name and its type — pay special attention to which values show up in `category`, `size`, `milk_type`, and `syrup`.
- Scroll through the 30 rows so you have a mental picture of the menu: which drinks are coffee? Which are tea? Which are seasonal?

Reading alone won't teach you SQL, but the queries below will feel a lot more grounded once you can picture the rows they're touching. You'll be able to predict what a query should return and then check yourself — that's a much faster way to learn than guessing at unfamiliar data.

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
| [example_01.sql](./example_01.sql) | `SELECT col1, col2` — pick only the columns you want |
| [example_02.sql](./example_02.sql) | Reorder the columns in the SELECT list |
| [example_03.sql](./example_03.sql) | `AS` — give a column an alias |
| [example_04.sql](./example_04.sql) | Aliases without `AS` (works, but explicit is preferred) |
| [example_05.sql](./example_05.sql) | The same column listed twice with different aliases |

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
