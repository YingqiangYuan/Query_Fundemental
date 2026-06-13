-- Example 06: Multiple aggregates in one SELECT -- a one-row summary
--
-- Business question:
--   "Give me a single-row summary of my finances this quarter: how many
--    transactions, total money in, total money out, net change, average
--    debit, and my biggest single charge."
--
-- Why this query:
--   You can put as many aggregates as you want in one SELECT and they
--   all reduce the whole table down to a single output row. This is the
--   classic "dashboard tile" query.
--   Inside SUM we use a `CASE` expression to conditionally include
--   amounts: `SUM(CASE WHEN type = 'credit' THEN amount ELSE 0 END)`
--   only adds an amount when the row is a credit, zero otherwise. This
--   gives us money-in and money-out without writing two separate
--   queries. (You learned CASE in Lesson 09.)
--   `MAX(amount)` finds the single largest transaction across the whole
--   period -- useful for spotting the rent payment without scanning.
SELECT
    COUNT(*) AS txn_count,
    SUM(CASE WHEN type = 'credit' THEN amount ELSE 0 END) AS money_in,
    SUM(CASE WHEN type = 'debit'  THEN amount ELSE 0 END) AS money_out,
    SUM(CASE WHEN type = 'credit' THEN amount ELSE -amount END) AS net_change,
    AVG(CASE WHEN type = 'debit' THEN amount END) AS avg_debit,
    MAX(amount) AS largest_txn
FROM transactions;
