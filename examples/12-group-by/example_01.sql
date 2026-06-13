-- Example 01: GROUP BY one column + COUNT(*)
--
-- Business question:
--   "How many transactions did we ring up in each product category?
--    Drinks, snacks, tobacco, household, lottery -- which one keeps
--    the register busiest?"
--
-- Why this query:
--   `GROUP BY category` collapses all rows that share the same
--   category into a single output row. `COUNT(*)` then counts how
--   many sales rows fell into each bucket. This is the simplest
--   shape of a GROUP BY query: one grouping column, one aggregate.
SELECT category,
       COUNT(*) AS num_transactions
FROM sales
GROUP BY category;
