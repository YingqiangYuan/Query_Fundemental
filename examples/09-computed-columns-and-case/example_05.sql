-- Example 05: CASE inside ORDER BY for a custom sort order
--
-- Business question:
--   "Sort the orders the way an ops dashboard would show them --
--    'placed' first (needs attention), then 'preparing', then
--    'out-for-delivery', then 'delivered', and finally 'cancelled' at
--    the bottom. Alphabetical order is useless here."
--
-- Why this query:
--   Sorting on `status` alphabetically gives the wrong order
--   (cancelled, delivered, out-for-delivery, placed, preparing). We
--   want a *workflow* order. `CASE` lets us map each status to a small
--   integer -- a sort key -- and ORDER BY uses that key instead of the
--   raw string. We add `placed_at` as a tiebreaker so orders inside
--   the same bucket are ordered by time.
SELECT
    order_id,
    restaurant,
    status,
    placed_at
FROM delivery_orders
ORDER BY
    CASE status
        WHEN 'placed'           THEN 1
        WHEN 'preparing'        THEN 2
        WHEN 'out-for-delivery' THEN 3
        WHEN 'delivered'        THEN 4
        WHEN 'cancelled'        THEN 5
    END,
    placed_at;
