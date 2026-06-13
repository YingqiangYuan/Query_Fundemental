-- Example 04: Top-3 highest-scoring matches per team (CTE + WHERE rn <= 3)
--
-- Business question:
--   "For every team, show me their 3 highest-scoring matches of the
--    season -- the games they'd put on the highlight reel."
--
-- Why this query:
--   This is the classic "top-N per group" pattern. You CANNOT put a
--   window function directly in a WHERE clause because WHERE runs
--   before window functions are computed. The fix is two layers:
--     1. A CTE (`top_scoring`) computes a per-team rank with
--        ROW_NUMBER() over `PARTITION BY team ORDER BY goals_for DESC`.
--     2. The outer query then filters `WHERE rn <= 3`.
--   We use ROW_NUMBER() (not RANK()) so each team gets exactly 3 rows
--   even if there are ties in goals_for -- swap it for RANK() if you'd
--   rather keep all the tied games and risk more than 3 rows per team.
WITH top_scoring AS (
    SELECT team,
           match_date,
           opponent,
           goals_for,
           goals_against,
           result,
           competition,
           ROW_NUMBER() OVER (PARTITION BY team
                              ORDER BY goals_for DESC, match_date) AS rn
    FROM match_results
)
SELECT team,
       rn,
       match_date,
       opponent,
       goals_for,
       goals_against,
       result,
       competition
FROM top_scoring
WHERE rn <= 3
ORDER BY team, rn;
