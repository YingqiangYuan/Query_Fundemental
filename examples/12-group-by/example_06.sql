-- Example 06: "Must appear in GROUP BY or be aggregated"
--
-- Business question:
--   "For each cashier, what's their total revenue?  ...and while
--    we're at it, can I just tack `item` onto the SELECT?"
--
-- Why this query:
--   The classic GROUP BY trap. Once you GROUP BY one column, every
--   other column in the SELECT list must EITHER appear in the
--   GROUP BY too, OR be wrapped in an aggregate function. A bare
--   `item` column does neither -- which item should the database
--   pick out of the many rows in each cashier's group?
--
--   The broken query below would error in strict SQL engines like
--   PostgreSQL with a message such as:
--       "column \"sales.item\" must appear in the GROUP BY clause
--        or be used in an aggregate function"
--
--   SQLite is more lenient and would silently return an arbitrary
--   `item` from each group, which is even more dangerous -- you
--   get a result that looks fine but is meaningless. Recognize
--   the smell either way.
--
-- Broken version (do NOT run -- shown for illustration):
--
--     SELECT cashier,
--            item,                       -- <-- not grouped, not aggregated
--            SUM(total_amount) AS total_sales
--     FROM sales
--     GROUP BY cashier;
--
-- Correct version: either add `item` to GROUP BY (one row per
-- cashier+item pair) or aggregate it. Below we go the cleaner
-- route -- group by cashier alone and use COUNT(DISTINCT item)
-- to summarize the item column instead of selecting it raw.
SELECT cashier,
       COUNT(DISTINCT item) AS distinct_items_sold,
       SUM(total_amount) AS total_sales
FROM sales
GROUP BY cashier
ORDER BY total_sales DESC;
