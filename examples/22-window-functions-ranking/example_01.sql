-- Example 01: ROW_NUMBER() OVER (ORDER BY ...)
--
-- Business question:
--   "Across the whole season, list every team-match performance from the
--    highest-scoring down to the lowest, and give each row a position
--    number so I can talk about 'the 1st-best, the 2nd-best, ...'"
--
-- Why this query:
--   ROW_NUMBER() is the simplest window function: it stamps a 1-based
--   sequence number onto each row in the order defined by the OVER
--   clause. Unlike GROUP BY, the window function does NOT collapse rows
--   -- every original row is preserved, with one extra column added.
--   Note the secondary sort by match_date: when two performances score
--   the same, ROW_NUMBER still picks ONE winner (no ties), so a tiebreak
--   makes the output deterministic.
SELECT ROW_NUMBER() OVER (ORDER BY goals_for DESC, match_date) AS position,
       team,
       match_date,
       opponent,
       goals_for,
       goals_against,
       result
FROM match_results
ORDER BY position
LIMIT 15;
