-- Example 04: WHERE col >= N  and  WHERE col <= N  (inclusive comparisons)
--
-- Business question:
--   "Which classes are nearly full? I want every class with at least
--    18 sign-ups so the front desk can recommend alternatives to new
--    members."
--
-- Why this query:
--   `>=` means "greater than or equal to" -- inclusive of the
--   boundary value. So `current_signups >= 18` keeps rows where
--   current_signups is 18, 19, 20, ... up to the max. Its mirror is
--   `<=` ("less than or equal to"). These four operators -- `<`,
--   `<=`, `>`, `>=` -- cover almost every numeric range filter you
--   will ever write.
SELECT class_id, instructor, type, day_of_week, current_signups, max_capacity
FROM gym_classes
WHERE current_signups >= 18;
