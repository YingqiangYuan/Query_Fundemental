-- Example 01: LEFT JOIN basics
--
-- Business question:
--   "For every driver on our platform, show me their ride history --
--    and make sure brand-new drivers who haven't given a ride yet
--    still show up in the list."
--
-- Why this query:
--   `LEFT JOIN rides r ON d.driver_id = r.driver_id` keeps every row
--   from the left table (drivers) even when there is no matching row
--   on the right (rides). Drivers with no rides still appear, with
--   NULLs filled in for every `r.*` column. That NULL-row behaviour
--   is what makes LEFT JOIN the right tool whenever the question
--   says "for every X, even ones with no Y".
SELECT
    d.driver_id,
    d.full_name,
    d.city,
    r.ride_id,
    r.rider_name,
    r.fare
FROM drivers AS d
LEFT JOIN rides AS r
    ON d.driver_id = r.driver_id
ORDER BY d.driver_id, r.ride_id;
