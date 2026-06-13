-- Example 04: HAVING with multiple conditions (AND)
--
-- Business question:
--   "We're picking ambassadors for the marathon-prep program. To
--    qualify, a user must average at least 10,000 steps a day AND have
--    logged a total of more than 1,200 active minutes across the period.
--    Steps alone aren't enough -- we want people who are also putting in
--    real workout time."
--
-- Why this query:
--   HAVING accepts the same kind of boolean expressions as WHERE,
--   including `AND` / `OR` / `NOT`. The only special thing is that the
--   expressions on either side of `AND` must be things you can compute
--   for a GROUP -- typically aggregate functions like `AVG`, `SUM`,
--   `COUNT`, or a column from the GROUP BY list.
--
--   Here we combine two aggregate predicates:
--     - `AVG(steps) >= 10000`           (per-day step intensity)
--     - `SUM(active_minutes) > 1200`    (total committed workout time)
--   A user has to satisfy BOTH to make the shortlist.
SELECT
    user_name,
    ROUND(AVG(steps), 0)        AS avg_steps,
    SUM(active_minutes)         AS total_active_minutes,
    ROUND(SUM(distance_km), 1)  AS total_distance_km
FROM daily_logs
GROUP BY user_name
HAVING AVG(steps) >= 10000
   AND SUM(active_minutes) > 1200
ORDER BY avg_steps DESC;
