# Lesson 17 — Self-Join

> How does a table join to *itself*? When your data hides a tree inside it (employees → managers, replies → parent posts), a self-join is the most natural way to walk it.

## What we'll learn

This lesson teaches one move: **make the same table appear twice (or three times) in the FROM clause**.

Why would you want that? Because some relationships point back at "your own kind" — an employee's manager is also an employee, a reply's parent is also a post, a part is made of other parts. This pattern, called a *self-referencing foreign key*, shows up all over real databases, and the self-join is the standard tool for querying it.

| Construct | One-liner |
|-----------|-----------|
| `FROM t AS e JOIN t AS m ON e.fk = m.pk` | Make one physical table play two roles via aliases |
| `LEFT JOIN` + `IS NULL` | Find the "top of the chain" (people with no boss) |
| Self-join + `GROUP BY` + `COUNT` | Count direct reports per manager |
| Self-join twice | Walk two levels up (employee → manager → grand-manager) |
| The real power of aliases | The same table can simultaneously be "employees" and "managers" |

## The data story

The practice data is a **retail-chain staff org chart**.

| Table | Contents | Rows |
|-------|----------|------|
| `staff` | One row per employee: id, name, role, store location, direct-manager id (points back into this same table; NULL at the top) | 20 |

The hierarchy is **3 levels deep**:

- **Level 1**: 2 **regional managers** whose `manager_id` is NULL — nobody manages them.
- **Level 2**: 5 **store managers** across 5 stores, each reporting to a regional manager.
- **Level 3**: 13 **frontline staff** — assistant managers / floor leads / cashiers — each reporting to a store manager.

The `manager_id` column is a *self-referencing foreign key*: it points back at `staff.employee_id`. So "employee and manager" looks like a two-table relationship but is actually a same-table relationship — which is exactly where the self-join shines.

## Open the database

`db.sqlite` is **already generated and committed** in this folder, so you do **not** need to build it yourself.
Just open `db.sqlite` in **DBeaver** (GUI) or in the `sqlite3` CLI.
If you've forgotten how, jump back to [examples/01-sharpen-your-tools](../01-sharpen-your-tools/) for a refresher.

> **If `db.sqlite` ever gets corrupted**: delete it and re-run [gen_db.py](./gen_db.py) to regenerate.
>
> ```bash
> python gen_db.py
> ```

## Explore the database first

Before you start on the examples, **strongly recommended: poke around yourself first**:

- In DBeaver, expand `staff` in the left navigator and double-click to preview the rows.
- Pay attention to the `manager_id` column: it's a number, but those numbers are actually other rows' `employee_id` — pointing back into the **same table**.
- Trace the chain by eye: pick a cashier, follow `manager_id` to find their store manager, then follow that store manager's `manager_id` to the regional manager.
- Notice the two rows with NULL `manager_id` — they are the roots of the org tree.

Once you've drawn the tree in your head, the SQL below is just "what you did by eye, written down as SQL".

## Work through the examples

Open the SQL files below in order and run them **one at a time** in your SQL editor:

- The header comment in each file tells you:
  - What **business question** the query is trying to answer.
  - Which SQL constructs are being used and **why**.
- **Read the comment first**, predict the result.
- **Run** the query and look at the real output.
- Re-read the comment with the result in front of you — does it line up with what you expected?

| File | Teaches |
|------|---------|
| [example_01.sql](./example_01.sql) | Self-join `staff` to itself — list every employee with their direct manager |
| [example_02.sql](./example_02.sql) | `LEFT JOIN` + `IS NULL` — find the top of the org tree (people no one manages) |
| [example_03.sql](./example_03.sql) | Self-join + `GROUP BY` + `COUNT` — direct-report count per manager |
| [example_04.sql](./example_04.sql) | Join the table to itself twice — employee → manager → grand-manager (two hops) |
| [example_05.sql](./example_05.sql) | Closing sidebar: aliases let the same table play multiple roles (with `LEFT JOIN` to keep everyone) |

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
