-- Example 02: LIMIT ... OFFSET -- page 2 of the leaderboard
--
-- Business question:
--   "I already saw the top 5 most-listened episodes. Now show me ranks
--    6 through 10 -- the next page of the leaderboard."
--
-- Why this query:
--   `OFFSET 5` tells SQLite to SKIP the first 5 rows of the sorted
--   result before it starts collecting any. `LIMIT 5` then takes the
--   next 5 rows. Same `ORDER BY listens DESC` as Example 01 -- the
--   ordering MUST stay identical between pages, otherwise rows could
--   appear on both pages or get skipped entirely.
SELECT podcast, episode_title, host, chart_week, listens
FROM chart_entries
ORDER BY listens DESC
LIMIT 5 OFFSET 5;
