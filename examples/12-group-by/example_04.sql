-- Example 04: GROUP BY two columns (month + category)
--
-- Business question:
--   "Break revenue down by month AND by category -- I want to see
--    how each category performed in each calendar month."
--
-- Why this query:
--   `GROUP BY` accepts a list of columns. Every distinct
--   combination of (month, category) becomes one output row.
--   `strftime('%Y-%m', sale_date)` is SQLite's way of pulling the
--   year-month out of an ISO date string. Because our data only
--   covers May 2025, every row will land in the same '2025-05'
--   bucket -- the same query against a multi-month dataset would
--   give you a real month-by-month breakdown.
SELECT strftime('%Y-%m', sale_date) AS sale_month,
       category,
       SUM(total_amount) AS revenue
FROM sales
GROUP BY sale_month, category
ORDER BY sale_month, category;
