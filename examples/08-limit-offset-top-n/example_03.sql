-- Example 03: SQLite shorthand `LIMIT offset, count`
--
-- Business question:
--   "Same thing again -- ranks 6 through 10 -- but written in the more
--    compact form some SQLite tutorials use."
--
-- Why this query:
--   SQLite (and MySQL) accept a two-argument shorthand: `LIMIT 5, 5`
--   means OFFSET 5, then take 5. Note the order is (offset, count) --
--   the OPPOSITE of how you read it out loud ("limit five, offset
--   five"). That reversal trips people up, which is exactly why most
--   style guides recommend the explicit `LIMIT 5 OFFSET 5` form from
--   Example 02. This shorthand is NOT standard SQL -- Postgres and SQL
--   Server reject it. Recognize it when you see it; don't reach for it
--   when you write it.
SELECT podcast, episode_title, host, chart_week, listens
FROM chart_entries
ORDER BY listens DESC
LIMIT 5, 5;
