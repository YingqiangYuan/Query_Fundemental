-- Example 03: Multiple aggregates in one GROUP BY
--
-- Business question:
--   "For each product category, give me a one-line summary: how
--    many transactions, how much total revenue, and what's the
--    average ticket size?"
--
-- Why this query:
--   You can stack as many aggregate functions as you want in the
--   same SELECT. Here we compute COUNT, SUM, and AVG side-by-side
--   for each `category` group. `ROUND(..., 2)` keeps the average
--   readable -- without it SQLite would show a long decimal tail.
SELECT category,
       COUNT(*) AS num_transactions,
       SUM(total_amount) AS total_revenue,
       ROUND(AVG(total_amount), 2) AS avg_ticket
FROM sales
GROUP BY category;
