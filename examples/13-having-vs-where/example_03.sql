-- Example 03: Full pipeline -- WHERE, GROUP BY, HAVING, ORDER BY, LIMIT
--
-- Business question:
--   "Looking only at the FIRST WEEK of May (May 1-7), give me the top 3
--    users whose average daily steps in that week was at least 9,000.
--    Sort the leaderboard so the strongest performer is on top."
--
-- Why this query:
--   This is the canonical "all five clauses together" example. SQL
--   evaluates them in a fixed logical order, and it matters:
--
--     1. FROM         -- pick the table
--     2. WHERE        -- drop rows we don't care about (here: dates
--                        outside May 1-7). Cheap, happens BEFORE
--                        grouping.
--     3. GROUP BY     -- collapse remaining rows into one row per user
--     4. HAVING       -- drop groups whose aggregate fails the test
--                        (here: weekly avg below 9000)
--     5. ORDER BY     -- sort what's left
--     6. LIMIT        -- keep only the top N
--
--   Writing the clauses in this order in your SQL also matches how you
--   should THINK about the query: "from this data, keep these rows,
--   group them, keep these groups, sort, take top N."
SELECT
    user_name,
    ROUND(AVG(steps), 0) AS avg_steps_week_1
FROM daily_logs
WHERE log_date BETWEEN '2025-05-01' AND '2025-05-07'
GROUP BY user_name
HAVING AVG(steps) >= 9000
ORDER BY avg_steps_week_1 DESC
LIMIT 3;
