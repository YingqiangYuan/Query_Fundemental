-- Example 05: column-count / type compatibility rules for set operations
--
-- Business question:
--   "I want a combined list of (email, amount spent) across both
--    channels -- one tidy two-column report. How do I make sure the
--    two SELECTs line up so UNION accepts them?"
--
-- Why this query:
--   Every set operation (UNION / UNION ALL / INTERSECT / EXCEPT)
--   enforces TWO rules on the SELECTs it joins:
--
--     1. Same NUMBER of columns on both sides.
--     2. Matching column TYPES, position by position (NOT by name --
--        SQLite pairs columns by their order in the SELECT list).
--
--   Below we deliberately pick TWO columns from each table and put them
--   in the SAME order: text email first, numeric amount second.
--   Note that the two tables use different "id" column names
--   (`order_id` vs `receipt_id`) and different "amount" column names --
--   here they're both `items_total`, but in general you'd need to alias
--   them. The output column names come from the FIRST SELECT.
--
--   Want to see the rule bite? Try this in your editor and watch it
--   fail with "SELECTs to the left and right of UNION do not have the
--   same number of result columns":
--
--       SELECT customer_email, items_total FROM dine_in_orders
--       UNION
--       SELECT customer_email FROM takeout_orders;
--
--   That's the safety net -- SQLite refuses to silently glue mismatched
--   shapes together.
SELECT customer_email, items_total FROM dine_in_orders
UNION
SELECT customer_email, items_total FROM takeout_orders
ORDER BY customer_email, items_total;
