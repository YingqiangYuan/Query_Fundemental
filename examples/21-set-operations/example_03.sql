-- Example 03: INTERSECT -- rows that appear in BOTH result sets
--
-- Business question:
--   "Which customers came in BOTH ways this week -- they dined in AND
--    also placed a takeout order? Those are our most engaged regulars
--    and I want to send them a loyalty perk."
--
-- Why this query:
--   INTERSECT returns rows that appear in the first SELECT AND in the
--   second SELECT. Just like UNION, both sides must produce the same
--   number of columns with compatible types.
--   By projecting only `customer_email` on each side, we're asking
--   "which emails show up in both tables?" -- the set-operation way to
--   express "customers who did both."
--   You could write the same thing with a JOIN or an IN-subquery;
--   INTERSECT is the most direct way when you only care about the
--   overlap of one (or a few) columns.
SELECT customer_email FROM dine_in_orders
INTERSECT
SELECT customer_email FROM takeout_orders
ORDER BY customer_email;
