-- Example 05: RIGHT JOIN -- and why you almost never write one
--
-- Business question:
--   "For every ride in the system, attach the driver who gave it --
--    and don't drop a ride even if its driver record is somehow
--    missing." (Same shape of question as Example 01, but viewed
--    from the rides side.)
--
-- Why this query:
--   `RIGHT JOIN` keeps every row from the RIGHT table even when the
--   left has no match. In our case the right table is `drivers`,
--   so a RIGHT JOIN from `rides` to `drivers` keeps every driver --
--   including the ones with no rides -- and is exactly equivalent
--   to Example 01's LEFT JOIN with the tables swapped.
--
--   In practice almost no one writes RIGHT JOIN. The convention is
--   to put the table you want to preserve on the LEFT and use
--   LEFT JOIN. Reading top-to-bottom: "start from drivers, attach
--   rides where possible" is easier to follow than "start from
--   rides, but actually preserve drivers". SQLite supports RIGHT
--   JOIN since 3.39 (2022) -- older SQLite versions don't, which
--   is another reason to stick with LEFT JOIN.
SELECT
    d.driver_id,
    d.full_name,
    r.ride_id,
    r.fare
FROM rides AS r
RIGHT JOIN drivers AS d
    ON r.driver_id = d.driver_id
ORDER BY d.driver_id, r.ride_id;
