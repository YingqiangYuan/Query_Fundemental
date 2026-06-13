-- Example 03: COUNT(r.ride_id) vs COUNT(*) under a LEFT JOIN
--   (the most common LEFT-JOIN bug)
--
-- Business question:
--   "How many rides has each driver given? Drivers with zero rides
--    must show up as 0 -- not be hidden, and not be miscounted as 1."
--
-- Why this query:
--   Under a LEFT JOIN, a driver with no rides still produces ONE row
--   in the joined result, with every `r.*` column set to NULL.
--   - `COUNT(*)` counts that NULL row and reports 1 -- WRONG.
--   - `COUNT(r.ride_id)` ignores NULLs (that's how COUNT(col) works)
--     and reports 0 -- CORRECT.
--   We show both side by side so the difference is obvious.
--   Rule of thumb: when counting the "many" side of a LEFT JOIN,
--   COUNT a non-nullable column from that side -- never COUNT(*).
SELECT
    d.driver_id,
    d.full_name,
    COUNT(*)          AS bad_count_star,
    COUNT(r.ride_id)  AS correct_ride_count
FROM drivers AS d
LEFT JOIN rides AS r
    ON d.driver_id = r.driver_id
GROUP BY d.driver_id, d.full_name
ORDER BY correct_ride_count, d.driver_id;
