# learn_sql_query_basic — Course Index

> 22 hands-on SQL lessons. Every lesson uses a different everyday industry and ships its own self-contained SQLite database. The course covers `SELECT` only — no writes, no DDL.

## How to use this tutorial

If you don't yet know how to open a `.sqlite` file in DBeaver or the command line, start with [01 — Sharpen Your Tools](./01-sharpen-your-tools/) to get the environment running. Every later lesson assumes you've done this.

From lesson 02 onward, work through the folders in numeric order. Each lesson is a self-contained folder, and its `db.sqlite` is pre-generated and committed to git — **just open it in DBeaver or `sqlite3` directly** (if the file ever gets corrupted, `cd` into that folder and run `python gen_db.py` to rebuild it).

In each lesson folder:
1. Read `README.md` (or `README-cn.md`) for the business context and table schema.
2. Browse the tables in DBeaver to get a mental picture of the data.
3. Open `example_01.sql` … `example_0N.sql` and run them **one at a time** in your SQL editor. Read the header comment in each file carefully — it tells you what **business question** the query answers and **why** it's written this way. The detailed teaching lives there; this index is just an overview.

To batch-verify every SQL still runs: `python examples/check_examples.py` from the repo root.

---

## Lesson list

### [02 — SELECT Basics](./02-select-basics/)
- **Goal:** the most basic SELECT, with no filtering at all
- **Dataset:** bookstore inventory (`books`, 20 rows)
- **You'll learn:** `SELECT *`, `LIMIT`, `COUNT(*)`, `DISTINCT`

### [03 — Pick columns and rename with `AS`](./03-select-columns-and-aliases/)
- **Goal:** stop using `SELECT *`; project only the columns you want and give them friendly names
- **Dataset:** café menu (`drinks`, 30 rows)
- **You'll learn:** `SELECT col1, col2, ...`, `AS` aliases, column ordering and renaming

### [04 — WHERE basics](./04-where-basics/)
- **Goal:** filter rows by a single condition
- **Dataset:** gym class schedule (`gym_classes`, 40 rows)
- **You'll learn:** `=`, `!=` / `<>`, `>`, `<`, `>=`, `<=`, plus a deliberate `= NULL` gotcha (fixed in Lesson 06 with `IS NULL`)

### [05 — WHERE with AND / OR / NOT](./05-where-and-or-not/)
- **Goal:** combine multiple conditions; use parentheses to control precedence
- **Dataset:** hotel rooms (`hotel_rooms`, 50 rows)
- **You'll learn:** `AND`, `OR`, `NOT`, how parentheses change operator precedence

### [06 — LIKE / IN / BETWEEN / IS NULL](./06-where-like-in-between-null/)
- **Goal:** replace bulky AND/OR chains with WHERE's convenience operators
- **Dataset:** movie theater showtimes (`showtimes`, 50 rows)
- **You'll learn:** `LIKE` wildcards (`%` and `_`), `IN` / `NOT IN`, `BETWEEN`, `IS NULL` / `IS NOT NULL`

### [07 — ORDER BY](./07-order-by/)
- **Goal:** control the order rows come back in
- **Dataset:** streaming-service catalog (`titles`, 40 rows)
- **You'll learn:** `ASC` / `DESC`, multi-column sort, mixed direction, `NULLS LAST`, sort by column number

### [08 — LIMIT / OFFSET and Top-N](./08-limit-offset-top-n/)
- **Goal:** take just the first N rows; paginate big result sets
- **Dataset:** podcast weekly charts (`chart_entries`, 80 rows)
- **You'll learn:** `LIMIT`, `OFFSET`, the `ORDER BY + LIMIT` top-N idiom, and why `LIMIT` without `ORDER BY` is a trap

### [09 — Computed columns and CASE](./09-computed-columns-and-case/)
- **Goal:** derive new columns inside SELECT; branch with CASE
- **Dataset:** food-delivery orders (`delivery_orders`, 60 rows)
- **You'll learn:** arithmetic, `||` string concat, `CASE WHEN ... THEN ... ELSE ... END`, `CASE` inside `ORDER BY` for custom sort

### [10 — Built-in functions](./10-builtin-functions/)
- **Goal:** use SQLite's built-in string / numeric / date functions
- **Dataset:** public library checkouts (`checkouts`, 50 rows)
- **You'll learn:** `UPPER` / `LOWER` / `LENGTH` / `TRIM` / `SUBSTR` / `REPLACE`, `ROUND` / `ABS` / `CAST`, `date()` / `strftime()`, `COALESCE` / `IFNULL`

### [11 — Aggregate functions](./11-aggregate-functions/)
- **Goal:** collapse many rows into a single summary number (no GROUP BY yet)
- **Dataset:** personal bank transactions (`transactions`, 100 rows)
- **You'll learn:** `COUNT(*)` vs `COUNT(col)` (the NULL difference), `SUM`, `AVG`, `MIN` / `MAX`, `COUNT(DISTINCT col)`

### [12 — GROUP BY](./12-group-by/)
- **Goal:** group rows by a column and aggregate per group
- **Dataset:** convenience-store sales (`sales`, 120 rows)
- **You'll learn:** `GROUP BY`, multi-column grouping, `GROUP BY + ORDER BY` by aggregate value, the "must appear in GROUP BY or be aggregated" rule

### [13 — HAVING vs WHERE](./13-having-vs-where/)
- **Goal:** filter groups (not rows) by their aggregate values; understand the full clause order
- **Dataset:** fitness-tracker daily logs (`daily_logs`, 150 rows)
- **You'll learn:** `HAVING`, the difference between WHERE and HAVING, the canonical `SELECT → FROM → WHERE → GROUP BY → HAVING → ORDER BY → LIMIT` order

### [14 — INNER JOIN](./14-inner-join/)
- **Goal:** combine two tables on a primary/foreign key
- **Dataset:** veterinary clinic (`pets` + `visits`, 20 + 40 rows)
- **You'll learn:** `INNER JOIN ... ON ...`, table aliases, qualified columns to avoid ambiguity, the fact that bare `JOIN` means `INNER JOIN`

### [15 — LEFT JOIN](./15-left-join/)
- **Goal:** keep every left-side row; use LEFT JOIN + IS NULL as an anti-join to find what's missing
- **Dataset:** ride-share (`drivers` + `rides`, 15 + 50 rows; 3 drivers have zero rides)
- **You'll learn:** `LEFT JOIN`, the IS NULL anti-join idiom, `COUNT(col)` vs `COUNT(*)`, how `RIGHT JOIN` rewrites as LEFT-with-tables-swapped

### [16 — Multi-table joins](./16-multi-table-joins/)
- **Goal:** chain joins across three or four tables into a wide report
- **Dataset:** concert ticketing (`customers` + `venues` + `events` + `tickets`, 20 + 6 + 12 + 80 rows)
- **You'll learn:** 3- and 4-table joins, mixing INNER and LEFT, aggregating across a multi-join (revenue per venue / artist), how join order affects readability

### [17 — Self-join](./17-self-join/)
- **Goal:** join a table to itself to navigate hierarchies
- **Dataset:** retail-chain staff org chart (`staff` self-referencing, 20 rows, 3 levels deep)
- **You'll learn:** self-join via two aliases of the same table, `IS NULL` to find the top of the tree, counting direct reports, two-hop (employee → manager → grand-manager)

### [18 — Subqueries in WHERE](./18-subqueries-in-where/)
- **Goal:** use a subquery in WHERE for membership tests
- **Dataset:** dating app (`users` + `matches`, 30 + 54 rows)
- **You'll learn:** `IN (subquery)`, the `NOT IN` + NULL gotcha (returns 0 rows), `EXISTS` / `NOT EXISTS` (the NULL-safe alternative), comparison subqueries

### [19 — Scalar and derived-table subqueries](./19-scalar-and-derived-subqueries/)
- **Goal:** use subqueries in SELECT and FROM, not just WHERE
- **Dataset:** monthly subscription box (`subscribers` + `shipments`, 25 + 89 rows)
- **You'll learn:** scalar subqueries in SELECT, derived tables in FROM, correlated subqueries, the "pre-aggregate, then join" pattern

### [20 — CTEs (`WITH`)](./20-cte-with/)
- **Goal:** name intermediate result sets so multi-step queries read like prose
- **Dataset:** real-estate listings (`agents` + `listings` + `transactions`, 10 + 40 + 20 rows)
- **You'll learn:** single CTE, multiple chained CTEs, refactoring nested subqueries into CTEs, joining a CTE back to base tables

### [21 — Set operations](./21-set-operations/)
- **Goal:** combine, intersect, and subtract two result sets
- **Dataset:** coffee shop dine-in vs takeout (`dine_in_orders` + `takeout_orders`, 30 + 30 rows)
- **You'll learn:** `UNION ALL`, `UNION` (deduped), `INTERSECT`, `EXCEPT`, the column-count and type-compatibility rules

### [22 — Window functions, part 1: ranking](./22-window-functions-ranking/)
- **Goal:** rank rows without collapsing them — see each row alongside its rank
- **Dataset:** soccer-league match results (`match_results`, 80 rows)
- **You'll learn:** `ROW_NUMBER()`, `RANK()` vs `DENSE_RANK()` on ties, `PARTITION BY` for per-group ranking, the "top-N per group" idiom

### [23 — Window functions, part 2: aggregates + LAG / LEAD](./23-window-functions-aggregates/)
- **Goal:** running totals, rolling averages, period-over-period changes — aggregates used as window functions
- **Dataset:** city weather, one row per day (`weather_days`, 181 rows over 6 months)
- **You'll learn:** `SUM/AVG OVER (PARTITION BY ...)`, cumulative sums (`ROWS BETWEEN UNBOUNDED PRECEDING ...`), rolling averages, `LAG` / `LEAD`, day- and month-over-month calculations
