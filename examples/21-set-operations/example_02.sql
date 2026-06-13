-- Example 02: UNION -- stack two result sets, drop duplicates
--
-- Business question:
--   "Give me the full list of distinct customer emails we've served this
--    week, across dine-in and takeout combined. Each email should appear
--    only once -- I'm building a mailing list, not counting orders."
--
-- Why this query:
--   UNION (without ALL) does the same stacking as UNION ALL, then
--   removes duplicate rows from the combined result. Since we only
--   SELECT `customer_email` on both sides, "duplicate" means "same
--   email", which is exactly what we want for a mailing list.
--   Rule of thumb: reach for UNION ALL by default (it's cheaper);
--   only use UNION when you actually need the dedupe.
SELECT customer_email FROM dine_in_orders
UNION
SELECT customer_email FROM takeout_orders
ORDER BY customer_email;
