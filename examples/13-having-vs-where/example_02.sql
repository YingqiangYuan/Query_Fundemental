-- Example 02: WHERE vs HAVING -- side by side
--
-- Business question:
--   "I keep mixing up WHERE and HAVING. Show me a single, concrete
--    example where they answer DIFFERENT questions about the same data,
--    so I can finally see the difference."
--
-- Why this query:
--   Both queries below touch the same table and the same column
--   (`steps`), but they ask different questions.
--
--   Query A uses WHERE. WHERE filters individual ROWS before the rows
--   are grouped. So `WHERE steps >= 8000` keeps only the high-step DAYS
--   for each user, then averages those days. Every user shows up,
--   because almost everyone has at least one big day.
--
--   Query B uses HAVING. HAVING filters whole GROUPS after the average
--   is computed across ALL the user's days. So users whose overall
--   average is below 8,000 vanish entirely.
--
--   Rule of thumb: WHERE filters rows, HAVING filters groups.

-- Query A: WHERE filters rows (the days >= 8k steps), THEN we average.
SELECT
    user_name,
    ROUND(AVG(steps), 0) AS avg_high_step_days,
    COUNT(*) AS high_step_day_count
FROM daily_logs
WHERE steps >= 8000
GROUP BY user_name
ORDER BY user_name;

-- Query B: HAVING filters groups (the users whose overall avg >= 8k).
SELECT
    user_name,
    ROUND(AVG(steps), 0) AS avg_steps_all_days,
    COUNT(*) AS total_days_logged
FROM daily_logs
GROUP BY user_name
HAVING AVG(steps) >= 8000
ORDER BY user_name;
