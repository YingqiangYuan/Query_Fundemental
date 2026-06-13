-- Example 04: EXCEPT -- rows in the first set but NOT in the second
--
-- Business question:
--   "Which customers ONLY ever dined in this week and never grabbed
--    takeout? I want to send them a 'try our mobile-order pickup' promo
--    to nudge them into the takeout channel."
--
-- Why this query:
--   EXCEPT returns rows that appear in the first SELECT but NOT in the
--   second SELECT (set difference).
--   Read the query top-to-bottom: "all dine-in emails, MINUS any email
--   that also appears in takeout." What's left is dine-in-exclusive
--   customers.
--   Order matters: `A EXCEPT B` is NOT the same as `B EXCEPT A`. Swap
--   the two SELECTs and you'd get takeout-only customers instead.
SELECT customer_email FROM dine_in_orders
EXCEPT
SELECT customer_email FROM takeout_orders
ORDER BY customer_email;
