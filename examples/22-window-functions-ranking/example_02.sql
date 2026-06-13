-- Example 02: RANK() vs DENSE_RANK() on ties
--
-- Business question:
--   "Rank every team-match performance by goals scored. When several
--    performances tied with the same number of goals, what do the
--    standings look like under the two common 'rank with ties' rules?"
--
-- Why this query:
--   Both RANK() and DENSE_RANK() give tied rows the SAME rank, but they
--   disagree about what the NEXT rank should be:
--     - RANK()       leaves gaps: 1, 2, 2, 4, 5, ...
--     - DENSE_RANK() closes gaps: 1, 2, 2, 3, 4, ...
--   ROW_NUMBER() is included for contrast: it never produces ties at
--   all, even when the ORDER BY values are identical. Look at any group
--   of rows where goals_for is the same -- you can see all three
--   functions disagree exactly there.
SELECT goals_for,
       team,
       match_date,
       opponent,
       ROW_NUMBER() OVER (ORDER BY goals_for DESC) AS rn,
       RANK()       OVER (ORDER BY goals_for DESC) AS rk,
       DENSE_RANK() OVER (ORDER BY goals_for DESC) AS drk
FROM match_results
ORDER BY goals_for DESC, team
LIMIT 25;
