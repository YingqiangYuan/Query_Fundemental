-- Example 03: WHERE col > N  and  WHERE col < N  (numeric comparisons)
--
-- Business question:
--   "Which classes run LONGER than an hour? Our members keep asking
--    about the long-format sessions."
--
-- Why this query:
--   `>` and `<` are strict numeric comparisons -- "greater than" and
--   "less than", NOT inclusive of the boundary. `duration_min > 60`
--   means strictly more than 60, so a class that lasts exactly 60
--   minutes will NOT show up. If you want it included, use `>=` (see
--   the next example). Try swapping `>` for `<` to flip the question
--   to "short classes under 60 minutes" -- same shape, opposite
--   answer.
SELECT class_id, instructor, type, day_of_week, duration_min
FROM gym_classes
WHERE duration_min > 60;
