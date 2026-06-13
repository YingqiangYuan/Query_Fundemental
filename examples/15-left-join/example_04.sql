-- Example 04: INNER JOIN vs LEFT JOIN -- same query, different counts
--
-- Business question:
--   "How many of our registered drivers are 'active' (have at least
--    one ride) versus the full roster of drivers we have on file?"
--
-- Why this query:
--   We run the same shape of query twice, switching only the join
--   type, and union the two row-counts together so you can compare
--   them in one result set.
--   - INNER JOIN drops drivers with no matching ride -- you only
--     see active drivers. The count == active drivers.
--   - LEFT JOIN keeps every driver, including the never-drove-yet
--     ones (NULL on the rides side). The DISTINCT count == every
--     driver on the roster.
--   The gap between the two numbers is exactly the anti-join from
--   Example 02: the drivers who signed up but never gave a ride.
SELECT
    'inner_join (active drivers only)' AS join_type,
    COUNT(DISTINCT d.driver_id)        AS driver_count
FROM drivers AS d
INNER JOIN rides AS r
    ON d.driver_id = r.driver_id

UNION ALL

SELECT
    'left_join  (every driver on file)' AS join_type,
    COUNT(DISTINCT d.driver_id)         AS driver_count
FROM drivers AS d
LEFT JOIN rides AS r
    ON d.driver_id = r.driver_id;
