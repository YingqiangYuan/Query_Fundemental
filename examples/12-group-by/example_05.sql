-- Example 05: GROUP BY + ORDER BY on the aggregate
--
-- Business question:
--   "Rank our top-selling items by revenue -- I want to see which
--    individual product moved the most money, biggest first."
--
-- Why this query:
--   Aggregates can be used in ORDER BY just like regular columns.
--   We GROUP BY `item` so each distinct product becomes one row,
--   then sort by SUM(total_amount) descending so the highest
--   earners float to the top. Notice we reference the alias
--   `revenue` directly in ORDER BY -- SQLite is happy with either
--   the alias or the full expression here.
SELECT item,
       SUM(total_amount) AS revenue,
       SUM(quantity) AS units_sold
FROM sales
GROUP BY item
ORDER BY revenue DESC;
