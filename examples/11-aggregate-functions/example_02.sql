-- Example 02: SUM(amount)
--
-- Business question:
--   "How much money flowed through my checking account in debits this
--    quarter? I want one number -- my total spending."
--
-- Why this query:
--   `SUM(amount)` adds up `amount` across every row that survives the
--   WHERE filter. We restrict to `type = 'debit'` so credits (paychecks,
--   refunds, interest) don't cancel out the spend.
--   Note that `SUM` also ignores NULL values silently -- here `amount`
--   is never NULL, but it's a habit worth knowing.
SELECT
    SUM(amount) AS total_spend
FROM transactions
WHERE type = 'debit';
