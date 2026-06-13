-- Example 03: Two-branch CASE as a 0/1 flag
--
-- Business question:
--   "I want a simple yes/no flag for each order -- did it actually get
--    delivered, or is it still in flight / cancelled? Show 1 for done
--    and 0 for anything else."
--
-- Why this query:
--   `CASE WHEN ... THEN ... ELSE ... END` is SQL's inline if/else. Here
--   we collapse five possible statuses down to a binary flag: 1 when
--   `status = 'delivered'`, 0 otherwise. The flag is handy because you
--   can later `SUM(is_done)` to count completed orders or `AVG(is_done)`
--   to get a completion rate -- much friendlier than juggling string
--   comparisons everywhere.
SELECT
    order_id,
    restaurant,
    status,
    CASE WHEN status = 'delivered' THEN 1 ELSE 0 END AS is_done
FROM delivery_orders
LIMIT 20;
