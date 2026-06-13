-- Example 01: WHERE col = 'value' (equality filter on text)
--
-- Business question:
--   "Pull up just the yoga classes -- I want to see what we offer on
--    the yoga side and who teaches them."
--
-- Why this query:
--   `WHERE` is how SQL filters rows. The condition `type = 'yoga'`
--   keeps only rows where the `type` column equals the literal string
--   `'yoga'`. Text literals use single quotes; the comparison is
--   case-sensitive in SQLite by default, so `'Yoga'` would match zero
--   rows here. Notice how `WHERE` sits AFTER `FROM` -- that order is
--   fixed.
SELECT class_id, instructor, type, day_of_week, start_time
FROM gym_classes
WHERE type = 'yoga';
