-- Example 05: LIMIT without ORDER BY -- "whatever the engine picked"
--
-- Business question:
--   "Just give me any 3 entries from the chart -- I don't care which
--    ones, I'm only checking that the table is alive."
--
-- Why this query:
--   This query DOES return 3 rows, but WHICH 3 rows is officially
--   "unspecified" -- the SQL standard says the engine is free to give
--   you whatever it sees first. In practice SQLite will return the
--   first 3 rows of the table's storage order today, but it is NOT
--   guaranteed to keep doing so across versions, after a VACUUM, or
--   when the table grows. Re-run this in production six months from
--   now and the result can silently change.
--
--   THE LESSON: never use bare `LIMIT N` in real reports or in app
--   code that the user will see. Pair it with `ORDER BY` (as in
--   Example 01) so the result is defined and reproducible. This file
--   exists so you recognize the anti-pattern, not so you copy it.
SELECT podcast, episode_title, host, chart_week, listens
FROM chart_entries
LIMIT 3;
