-- Example 04: MIN / MAX on a date column
--
-- Business question:
--   "What's the date range of the transactions in this dataset? When
--    did the first one happen, and when did the most recent one happen?"
--
-- Why this query:
--   `MIN(txn_date)` and `MAX(txn_date)` give you the earliest and
--   latest values. MIN/MAX work on any orderable type -- numbers, dates,
--   even text (lexicographic order). ISO-8601 date strings like
--   `2025-01-02` sort correctly as plain text, which is why we store
--   dates that way in SQLite.
--   Handy as a sanity check: "is my data really covering the period I
--   think it is?".
SELECT
    MIN(txn_date) AS first_txn_date,
    MAX(txn_date) AS last_txn_date
FROM transactions;
