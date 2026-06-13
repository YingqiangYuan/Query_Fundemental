-- Example 02: GROUP BY + SUM
--
-- Business question:
--   "How much money did each cashier ring up this month? I want a
--    leaderboard of total sales per cashier."
--
-- Why this query:
--   `GROUP BY cashier` bundles every row that shares the same
--   cashier name. `SUM(total_amount)` adds up the dollar amount
--   inside each bundle. The output is one row per cashier, with
--   that cashier's total sales next to it.
SELECT cashier,
       SUM(total_amount) AS total_sales
FROM sales
GROUP BY cashier;
