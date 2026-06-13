-- Example 01: COUNT(*) vs COUNT(category) -- the NULL difference
--
-- Business question:
--   "How many transactions did I make in total this quarter, and how
--    many of them actually have a category tag on them? I want to know
--    how bad my uncategorized backlog is."
--
-- Why this query:
--   `COUNT(*)` counts every row, NULLs and all -- it just answers
--   "how many rows are there?".
--   `COUNT(category)` counts only rows where `category` IS NOT NULL --
--   aggregate functions silently skip NULLs in the column they look at.
--   The gap between the two numbers is exactly the count of
--   uncategorized transactions. This is the single most important
--   gotcha to internalize about aggregates: NULL is ignored.
SELECT
    COUNT(*) AS total_txns,
    COUNT(category) AS categorized_txns,
    COUNT(*) - COUNT(category) AS uncategorized_txns
FROM transactions;
