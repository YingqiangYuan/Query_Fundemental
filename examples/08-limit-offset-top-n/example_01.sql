-- Example 01: ORDER BY ... DESC LIMIT 5 -- the top-N idiom
--
-- Business question:
--   "What were the 5 most-listened-to podcast episodes across the whole
--    chart period? Just give me the leaderboard."
--
-- Why this query:
--   `ORDER BY listens DESC` sorts the rows from highest listens to lowest.
--   `LIMIT 5` then keeps only the first 5 rows of that sorted result.
--   Together they form the canonical "top-N" pattern. The golden rule:
--   ALWAYS pair LIMIT with ORDER BY when you care which rows you get --
--   LIMIT alone does NOT mean "the biggest"; it means "stop the scan after
--   N rows", whatever order they happen to come back in.
SELECT podcast, episode_title, host, chart_week, listens
FROM chart_entries
ORDER BY listens DESC
LIMIT 5;
