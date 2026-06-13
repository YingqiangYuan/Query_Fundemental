-- Example 02: LEFT JOIN + IS NULL  (the "anti-join" idiom)
--
-- Business question:
--   "Which drivers have signed up but never actually given a ride?
--    We want to send them an onboarding nudge."
--
-- Why this query:
--   Same LEFT JOIN as Example 01, but we then keep ONLY the rows
--   where `r.ride_id IS NULL`. Those NULL-row leftovers are exactly
--   the drivers that had no matching ride -- the LEFT JOIN
--   manufactured a NULL row for them, and now we're filtering down
--   to that set. This pattern (LEFT JOIN + IS NULL on the right-hand
--   key) is called an "anti-join": rows in A with no match in B.
--   Don't filter on a non-key column like `r.fare IS NULL` -- always
--   filter on the right table's primary/foreign key column so you
--   don't accidentally match real rides that happen to have NULLs.
SELECT
    d.driver_id,
    d.full_name,
    d.city,
    d.signup_date,
    d.car_make,
    d.car_model
FROM drivers AS d
LEFT JOIN rides AS r
    ON d.driver_id = r.driver_id
WHERE r.ride_id IS NULL
ORDER BY d.signup_date;
