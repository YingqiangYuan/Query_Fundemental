-- Example 05: COUNT(DISTINCT merchant)
--
-- Business question:
--   "How many different merchants did I actually buy from this quarter?
--    Multiple visits to the same Starbucks should still count as one
--    merchant."
--
-- Why this query:
--   `COUNT(merchant)` would count every row -- the same merchant gets
--   counted again on each visit.
--   `COUNT(DISTINCT merchant)` first de-duplicates the values, then
--   counts -- so each unique merchant contributes exactly 1.
--   DISTINCT inside an aggregate is the idiomatic "how many unique X"
--   pattern in SQL. NULLs are still ignored (we have no NULL merchants
--   here, but worth remembering).
SELECT
    COUNT(merchant) AS merchant_rows,
    COUNT(DISTINCT merchant) AS unique_merchants
FROM transactions;
