-- Example 05: WHERE col = NULL -- the classic "empty result" gotcha
--
-- Business question:
--   "Find every class where the level hasn't been set yet -- the
--    schedule manager wants to fill in the missing levels."
--
-- Why this query:
--   This query LOOKS reasonable but returns ZERO rows. That is the
--   teaching point.
--
--   In SQL, NULL means "unknown". Comparing anything to NULL with `=`
--   does NOT return true or false -- it returns "unknown", which
--   `WHERE` treats the same as false. So `level = NULL` filters out
--   every row, even the ones whose level genuinely IS NULL.
--
--   We KNOW the dataset has NULL-level rows (e.g. class_id 5, 9, 15,
--   ...), and yet this query finds none. That mismatch is the whole
--   lesson -- you cannot use `=` for NULL.
--
--   The fix is `IS NULL` (and its partner `IS NOT NULL`), which we
--   cover properly in Lesson 06. For now, just notice the empty
--   result and remember: "equals NULL never matches".
SELECT class_id, instructor, type, level
FROM gym_classes
WHERE level = NULL;
