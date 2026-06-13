-- Example 01: GROUP BY + HAVING on an aggregate
--
-- Business question:
--   "Across the whole logging period, which users averaged at least
--    8,000 steps per day? Those are the people I'd label as 'active'."
--
-- Why this query:
--   `GROUP BY user_name` collapses the raw per-day rows into one row per
--   person. `AVG(steps)` is then computed per group.
--   `HAVING` filters the groups themselves -- you cannot put an
--   aggregate like `AVG(steps)` in a `WHERE` clause, because WHERE runs
--   BEFORE grouping and the average doesn't exist yet at that point.
--   HAVING runs AFTER grouping, when each group has its aggregate value
--   to compare against.
SELECT
    user_name,
    ROUND(AVG(steps), 0) AS avg_steps
FROM daily_logs
GROUP BY user_name
HAVING AVG(steps) >= 8000
ORDER BY avg_steps DESC;
