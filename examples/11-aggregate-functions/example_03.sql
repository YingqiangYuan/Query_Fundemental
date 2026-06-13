-- Example 03: AVG(amount)
--
-- Business question:
--   "What's my average debit charge? Are most of my purchases tiny
--    coffee runs or chunky bills?"
--
-- Why this query:
--   `AVG(amount)` returns the arithmetic mean of `amount` across the
--   filtered rows. It's equivalent to `SUM(amount) / COUNT(amount)`.
--   Like the others, NULLs in `amount` would be skipped, and the divisor
--   would shrink to match -- AVG never silently treats NULL as zero.
--   We filter to debits only so the big monthly paycheck credits don't
--   skew the picture of "an average purchase".
SELECT
    AVG(amount) AS avg_debit_amount
FROM transactions
WHERE type = 'debit';
