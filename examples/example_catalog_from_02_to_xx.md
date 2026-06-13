# Course Catalog — Lessons 02 → 23

Plan input for a follow-up session: read this + [SKILL.md](../.claude/skills/sql-example/SKILL.md), spawn sub-agents to generate `examples/03..23/`.

- **Scope:** `SELECT` only, SQLite.
- **Existing:** `01_sharpen_your_tools/` (intro, don't touch). `02-select-basics/` (canonical reference implementation).
- **Design choice:** **maximum industry variety.** Almost every lesson uses a different everyday-life domain (café, gym, hotel, library, bank, vet clinic, ride-share, weather, …). Students see SQL applied to many real-world shapes. Authoring cost is higher — every lesson ships its own CSVs — but the course is more memorable.

---

## Progression

| #  | Slug                              | Industry / Domain                          |
|----|-----------------------------------|--------------------------------------------|
| 02 | `02-select-basics`                | bookstore inventory (done)                 |
| 03 | `03-select-columns-and-aliases`   | café menu                                  |
| 04 | `04-where-basics`                 | gym class schedule                         |
| 05 | `05-where-and-or-not`             | hotel rooms                                |
| 06 | `06-where-like-in-between-null`   | movie theater showtimes                    |
| 07 | `07-order-by`                     | streaming-service catalog                  |
| 08 | `08-limit-offset-top-n`           | podcast weekly charts                      |
| 09 | `09-computed-columns-and-case`    | food-delivery orders                       |
| 10 | `10-builtin-functions`            | public library checkouts                   |
| 11 | `11-aggregate-functions`          | personal bank transactions                 |
| 12 | `12-group-by`                     | convenience-store sales                    |
| 13 | `13-having-vs-where`              | fitness-tracker daily logs                 |
| 14 | `14-inner-join`                   | veterinary clinic (pets + visits)          |
| 15 | `15-left-join`                    | ride-share (drivers + rides)               |
| 16 | `16-multi-table-joins`            | concert ticketing                          |
| 17 | `17-self-join`                    | retail-chain staff org chart               |
| 18 | `18-subqueries-in-where`          | dating app (users + matches)               |
| 19 | `19-scalar-and-derived-subqueries`| monthly subscription box                   |
| 20 | `20-cte-with`                     | real-estate listings                       |
| 21 | `21-set-operations`               | coffee shop: dine-in vs takeout            |
| 22 | `22-window-functions-ranking`     | soccer-league match results                |
| 23 | `23-window-functions-aggregates`  | city weather (daily readings)              |

---

## Per-lesson outline

For each lesson: business framing → dataset (table(s) + must-have constraints) → sub-topics. Each sub-topic = one `example_NN.sql`.

### 03 — Café menu — pick columns, alias with `AS`
**Dataset:** `drinks` (single table) — drink_id, name, category (coffee/tea/cold-brew/pastry/smoothie), size, milk_type, syrup, calories, price, is_seasonal (0/1). ~30 rows.
- `SELECT col1, col2` — projection
- Reorder columns in SELECT list
- Column alias with `AS`
- Alias without `AS` (note: prefer `AS`)
- Same column twice with different aliases

### 04 — Gym class schedule — `WHERE` basics
**Dataset:** `gym_classes` — class_id, instructor, type (yoga/spin/HIIT/pilates/zumba), day_of_week, start_time, duration_min, level (beginner/intermediate/advanced, some NULL), max_capacity, current_signups. ~40 rows.
- `WHERE type = 'yoga'`
- `WHERE type != / <>`
- `WHERE duration_min > / <`
- `WHERE col >= / <=`
- `WHERE level = NULL` returns nothing — plant the gotcha (fixed in Lesson 06)

### 05 — Hotel rooms — compound `WHERE` (AND / OR / NOT)
**Dataset:** `hotel_rooms` — room_id, room_type (standard/deluxe/suite), view (city/ocean/courtyard), beds, max_occupancy, has_balcony (0/1), nightly_rate, floor. ~50 rows.
- `WHERE A AND B`
- `WHERE A OR B`
- `WHERE NOT A`
- `WHERE A AND (B OR C)` — parentheses change meaning
- 3+ conditions ("under $300, ocean view, balcony, sleeps ≥ 2")

### 06 — Movie theater showtimes — `LIKE` / `IN` / `BETWEEN` / `IS NULL`
**Dataset:** `showtimes` — showtime_id, movie_title, theater, screen_number, start_time (datetime), end_time, rating (G/PG/PG-13/R), language, subtitle_lang (nullable — many rows NULL), ticket_price. ~50 rows.
- `LIKE 'The %'` (`%` wildcard)
- `LIKE '_he %'` (`_` wildcard)
- `IN ('Screen 1', 'Screen 2', 'IMAX')`
- `NOT IN (...)`
- `BETWEEN '2025-07-01' AND '2025-07-07'` (inclusive; ISO strings sort right)
- `IS NULL` / `IS NOT NULL` on `subtitle_lang`

### 07 — Streaming-service catalog — `ORDER BY`
**Dataset:** `titles` — title_id, title, type (movie/series), release_year, runtime_minutes, imdb_score, rotten_score (nullable for some), watch_hours_millions. ~40 rows.
- `ORDER BY imdb_score` (default ASC)
- `ORDER BY imdb_score DESC`
- Multi-column sort (`type, imdb_score DESC`)
- Mixed ASC/DESC
- `ORDER BY rotten_score DESC NULLS LAST`
- `ORDER BY 2` (column-number shorthand; works, fragile)

### 08 — Podcast weekly charts — `LIMIT` / `OFFSET` / top-N
**Dataset:** `chart_entries` — entry_id, podcast, episode_title, host, chart_week (date), listens, rank. ~80 rows spread across ~8 weeks.
- `ORDER BY listens DESC LIMIT 5` — top-5 idiom (always pair LIMIT with ORDER BY)
- `LIMIT 5 OFFSET 5` — page 2
- SQLite shorthand `LIMIT 5, 5` (offset, count)
- Pagination, 10 per page over the full chart
- Warning: `LIMIT 3` with no `ORDER BY` returns "whatever the engine picked"

### 09 — Food-delivery orders — computed columns and `CASE`
**Dataset:** `delivery_orders` — order_id, restaurant, item_name, qty, unit_price, delivery_fee, tip, status (placed/preparing/out-for-delivery/delivered/cancelled), placed_at (datetime). ~60 rows.
- Arithmetic: `qty * unit_price + delivery_fee + tip AS total`
- String concat: `restaurant || ' — ' || item_name`
- `CASE WHEN status = 'delivered' THEN 1 ELSE 0 END AS is_done`
- Multi-branch `CASE` to bucket totals into S/M/L/XL
- `CASE` inside `ORDER BY` for custom status order (placed → preparing → out → delivered → cancelled)

### 10 — Public library checkouts — built-in functions
**Dataset:** `checkouts` — checkout_id, member_name, member_email, book_title, checkout_date, due_date, returned_date (nullable for active checkouts), late_fee (nullable, numeric). ~50 rows.
- String: `UPPER`, `LOWER`, `LENGTH`, `TRIM` on `member_name` / `member_email`
- String: `SUBSTR`, `REPLACE` (e.g. extract domain from email)
- Numeric: `ROUND(late_fee, 2)`, `ABS`, `CAST(... AS INTEGER)`
- Date: `date(checkout_date)`, `strftime('%Y-%m', checkout_date)` (SQLite-specific; used again in Lesson 12)
- NULL handling: `COALESCE(returned_date, 'not returned')`, `IFNULL`

### 11 — Personal bank transactions — aggregates (no `GROUP BY` yet)
**Dataset:** `transactions` — txn_id, account, txn_date, category (nullable — uncategorized rows), merchant, amount, type (debit/credit). ~100 rows.
- `COUNT(*)` vs `COUNT(category)` — the NULL difference
- `SUM(amount)`
- `AVG(amount)`
- `MIN(txn_date)` / `MAX(txn_date)` — first and latest txn
- `COUNT(DISTINCT merchant)` — unique merchants
- Multiple aggregates in one SELECT — a single-row "monthly summary"

### 12 — Convenience-store sales — `GROUP BY`
**Dataset:** `sales` — sale_id, item, category (drinks/snacks/tobacco/household/lottery), sale_date, quantity, total_amount, cashier. ~120 rows over ~30 days.
- `GROUP BY category` + `COUNT(*)`
- `GROUP BY cashier` + `SUM(total_amount)`
- Multiple aggregates per group (count + sum + avg)
- `GROUP BY` two columns (e.g. month via `strftime` + category)
- `GROUP BY` + `ORDER BY` sorted by aggregate value
- "Must appear in GROUP BY or be aggregated" — show the error so they recognize it later

### 13 — Fitness-tracker daily logs — `HAVING` (vs `WHERE`)
**Dataset:** `daily_logs` — log_id, user_name, log_date, steps, calories_burned, active_minutes, distance_km. ~150 rows, ~10 users × ~15 days each.
- `GROUP BY user_name HAVING AVG(steps) >= 8000`
- Side-by-side: WHERE (filter rows before grouping) vs HAVING (filter groups after)
- Full statement: `WHERE → GROUP BY → HAVING → ORDER BY → LIMIT`
- `HAVING` with multiple conditions (avg steps high AND total active_minutes high)

### 14 — Veterinary clinic — `INNER JOIN`
**Dataset:**
- `pets` — pet_id, name, species (dog/cat/rabbit/parrot), breed, owner_name, date_of_birth. ~20 rows.
- `visits` — visit_id, pet_id (FK), visit_date, reason (checkup/vaccine/illness/surgery), vet_name, cost. ~40 rows.

Sub-topics:
- `INNER JOIN ... ON ...` — pet name + visit reason
- Table aliases (`p`, `v`)
- Qualified columns when both sides have a `name`-like column
- INNER JOIN + WHERE on a column from either side
- Note: bare `JOIN` means `INNER JOIN`

### 15 — Ride-share — `LEFT JOIN`
**Dataset:**
- `drivers` — driver_id, full_name, signup_date, city, car_make, car_model. ~15 rows.
- `rides` — ride_id, driver_id (FK), rider_name, pickup_time, dropoff_time, distance_km, fare. ~50 rows.
- Must include: ≥2 drivers with **zero rides** (just signed up).

Sub-topics:
- `LEFT JOIN` basic — drivers + rides
- `WHERE r.ride_id IS NULL` — anti-join idiom ("drivers who've never given a ride")
- `COUNT(r.ride_id)` (NOT `COUNT(*)`) per driver — the common bug
- Same query INNER vs LEFT, different counts
- Brief note on RIGHT JOIN (rare; rewrite as LEFT swapped)

### 16 — Concert ticketing — multi-table joins (3–4 tables)
**Dataset:**
- `customers` — customer_id, full_name, email, city. ~20 rows.
- `venues` — venue_id, name, city, capacity. ~6 rows.
- `events` — event_id, artist, venue_id (FK), event_date. ~12 rows.
- `tickets` — ticket_id, event_id (FK), customer_id (FK), section, price_paid, purchase_date. ~80 rows.

Sub-topics:
- 3-table join: customers + tickets + events
- 4-table: + venues (every ticket with customer name, artist, venue, city)
- Mixing INNER and LEFT (e.g. customers LEFT JOIN tickets to include people who bought nothing)
- Aggregate across the multi-join: revenue per venue, revenue per artist
- Readability tip: write joins in dependency order

### 17 — Retail-chain staff — self-join
**Dataset:** `staff` — employee_id, full_name, role (cashier/floor lead/assistant manager/store manager/regional manager), store_location, manager_id (FK self, NULL for top of chain). ~20 rows, 3 levels deep.
- Employee + their manager: `FROM staff e JOIN staff m ON e.manager_id = m.employee_id`
- Top-level (regional managers): `LEFT JOIN` + `WHERE m.employee_id IS NULL`
- Count direct reports per manager
- Two-hop: employee → manager → grand-manager
- Sidebar: aliases let the same table play two roles

### 18 — Dating app — subqueries in `WHERE`
**Dataset:**
- `users` — user_id, username, age, city, last_active_at (some NULL for inactive accounts). ~30 rows.
- `matches` — match_id, user_a_id (FK), user_b_id (FK), matched_at, message_count. ~50 rows.

Sub-topics:
- `IN (subquery)` — users who matched with users in a given city
- `NOT IN` + NULL gotcha (if subquery returns NULL, NOT IN returns no rows)
- `EXISTS (subquery)`
- `NOT EXISTS` — the NULL-safe alternative
- Comparison subquery: `WHERE age > (SELECT AVG(age) FROM users)`

### 19 — Monthly subscription box — scalar / derived-table subqueries
**Dataset:**
- `subscribers` — subscriber_id, full_name, plan (basic/premium/luxury), signup_date, city. ~25 rows.
- `shipments` — shipment_id, subscriber_id (FK), ship_date, box_theme, item_count, declared_value. ~80 rows.

Sub-topics:
- Scalar subquery in SELECT — per-row "vs overall avg declared_value"
- Derived table in FROM — pre-aggregate shipments per subscriber, join back to subscriber name
- Correlated subquery in SELECT (slower; stepping stone to CTEs)
- Pre-aggregate-then-join idiom (cleaner version of the correlated one)

### 20 — Real-estate listings — CTEs (`WITH`)
**Dataset:**
- `agents` — agent_id, full_name, agency, hire_date. ~10 rows.
- `listings` — listing_id, agent_id (FK), address, neighborhood, bedrooms, bathrooms, list_price, listed_at, status (active/pending/sold/withdrawn). ~40 rows.
- `transactions` — txn_id, listing_id (FK), sale_price, closed_at, buyer_name. ~25 rows.

Sub-topics:
- Single CTE — agent + total sold value (rewrite a derived-table query)
- Multiple CTEs in one query
- Nested-subquery → CTE refactor (show the ugly and the clean side by side)
- CTE that joins back to base tables for a final report ("monthly closings per neighborhood")
- Note: `WITH RECURSIVE` exists, out of scope here

### 21 — Coffee shop: dine-in vs takeout — set operations
**Dataset:**
- `dine_in_orders` — order_id, customer_email, items_total, ordered_at, table_number.
- `takeout_orders` — receipt_id, customer_email, items_total, ordered_at, pickup_time.
- Must include: `customer_email` values present in **both** tables (so INTERSECT is non-trivial).

Sub-topics:
- `UNION ALL` — all customer interactions concatenated
- `UNION` — same, deduped
- `INTERSECT` — customers who came BOTH for dine-in AND takeout
- `EXCEPT` — dine-in-only customers
- Column-count / type compatibility rules + a deliberate error example

### 22 — Soccer-league match results — window functions: ranking
**Dataset:** `match_results` (single table, one row per team per match) — match_id, team, match_date, opponent, goals_for, goals_against, result (W/D/L), competition (league/cup). ~80 rows over a ~6-month span.
- `ROW_NUMBER() OVER (ORDER BY goals_for DESC)` — highest-scoring performances
- `RANK()` vs `DENSE_RANK()` on ties
- `PARTITION BY team` — rank each team's matches by goal difference
- Top-3 highest-scoring matches per team (CTE + `WHERE rn <= 3`)
- Sidebar: what `OVER (...)` means; contrast with `GROUP BY` (windows don't collapse rows)

### 23 — City weather — window aggregates, `LAG` / `LEAD`
**Dataset:** `weather_days` (single table, one row per day for one city) — reading_date, temp_high_c, temp_low_c, precipitation_mm, humidity_pct, condition (sunny/cloudy/rain/snow). ~180 rows (~6 months).
- `AVG(temp_high_c) OVER (PARTITION BY strftime('%Y-%m', reading_date))` — monthly average alongside each day
- Running total: cumulative precipitation since start of year (`ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`)
- 7-day rolling avg of `temp_high_c`
- `LAG(temp_high_c) OVER (ORDER BY reading_date)` — yesterday's high
- `LEAD(...)` — tomorrow's high
- Day-over-day change pattern: `temp_high_c - LAG(temp_high_c) OVER (...)`

---

## Out of scope (don't generate)

- Recursive CTEs, JSON columns, pivoting, full-text search (FTS5)
- `INSERT` / `UPDATE` / `DELETE`, DDL, views, indexes
- `EXPLAIN` / optimization, transactions, stored procs, triggers, `PIVOT`/`UNPIVOT`, `MERGE`

---

## Notes for the generating session

1. **Parallelize.** Lessons are independent — spawn one sub-agent per lesson (or per pair when two share a dataset, e.g. 14/15 if you choose to consolidate; the catalog deliberately gives them **different** industries to maximize variety, but the SQL contrast still works).
2. **Follow SKILL.md strictly.** `NN_` prefixed CSVs in FK order; English `.sql` headers with the business-question template; bilingual READMEs (`README-cn.md` written first, then translated); every sibling-file mention is a markdown link; `db.sqlite` is generated AND committed; the only mention of `gen_db.py` in any README is the single recovery block-quote.
3. **No `mise inst` repetition.** Lesson 02 owns the one-time setup section; 03+ skip it.
4. **Each industry should feel real.** Use plausible names, plausible prices, plausible dates. Avoid `foo`/`bar`/`item_1` content — the whole point of the variety is that students recognize the domain.
5. **Verify each lesson.** Every `example_NN.sql` must run against the committed `db.sqlite` and produce a result that genuinely answers its business question (unless the empty result IS the teaching point, e.g. `WHERE col = NULL` in Lesson 04).
