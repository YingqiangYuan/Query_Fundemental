-- Example 02: WHERE col != 'value'  (also written <>)
--
-- Business question:
--   "Show me every class that is NOT a spin class -- I want to plan a
--    week of training without using the bikes."
--
-- Why this query:
--   `!=` is the "not equal to" operator. SQL also accepts `<>` as a
--   synonym -- pick whichever your team prefers and stay consistent.
--   Heads-up on a NULL gotcha: rows where `type` is NULL would NOT
--   come back from `type != 'spin'`, because comparing NULL to
--   anything is "unknown", not "true". We don't have NULL `type`
--   values in this dataset, but the rule will bite you in Lesson 06.
SELECT class_id, instructor, type, day_of_week, start_time
FROM gym_classes
WHERE type != 'spin';
