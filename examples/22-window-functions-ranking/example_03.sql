-- Example 03: PARTITION BY team -- rank each team's matches separately
--
-- Business question:
--   "For each team, rank that team's matches by goal difference
--    (goals_for - goals_against), so I can see each team's best and
--    worst performances next to each other."
--
-- Why this query:
--   PARTITION BY restarts the ranking inside each group. Without it the
--   single ORDER BY would rank every row in the whole table against
--   every other; with `PARTITION BY team` the window resets at every
--   new team, so each team gets its own 1, 2, 3, ... ladder. Notice
--   that GROUP BY would collapse each team to one row -- the window
--   function keeps every match row but adds a per-team rank column.
SELECT team,
       match_date,
       opponent,
       goals_for,
       goals_against,
       goals_for - goals_against AS goal_diff,
       result,
       RANK() OVER (PARTITION BY team
                    ORDER BY goals_for - goals_against DESC) AS team_rank
FROM match_results
ORDER BY team, team_rank;
