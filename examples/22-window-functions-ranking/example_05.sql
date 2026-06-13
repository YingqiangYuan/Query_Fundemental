-- Example 05: OVER (...) vs GROUP BY -- windows don't collapse rows
--
-- Business question:
--   "For every match Arsenal played, show the goals they scored AND,
--    on the SAME row, Arsenal's average goals per match for the season
--    -- so I can eyeball whether each match was above or below
--    Arsenal's typical output."
--
-- Why this query:
--   GROUP BY would collapse all of Arsenal's matches into a single row
--   showing the average -- you'd lose the per-match detail. A window
--   function with `OVER (PARTITION BY team)` computes the same average
--   but ATTACHES it to every original row instead of collapsing them.
--   That's the headline difference: GROUP BY changes the grain of the
--   output; window functions keep the grain and add a column. The
--   second window column (sum) demonstrates the same idea -- any
--   aggregate can ride on top of an OVER (...) clause.
SELECT team,
       match_date,
       opponent,
       goals_for,
       ROUND(AVG(goals_for) OVER (PARTITION BY team), 2) AS team_avg_goals,
       SUM(goals_for)       OVER (PARTITION BY team)     AS team_total_goals
FROM match_results
WHERE team = 'Arsenal'
ORDER BY match_date;
