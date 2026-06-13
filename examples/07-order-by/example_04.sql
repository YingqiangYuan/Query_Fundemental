-- Example 04: Mixed ASC and DESC across columns
--
-- Business question:
--   "List titles from the newest release year down to the oldest, and
--    within the same year put the shortest runtime first."
--
-- Why this query:
--   Each column in `ORDER BY` gets its own direction. `release_year
--   DESC` lines newer titles up first; `runtime_minutes ASC` (the `ASC`
--   is explicit here just for clarity) breaks ties by putting the
--   shorter runtime first. The two directions are independent -- mix
--   them however the question demands.
SELECT title, release_year, runtime_minutes
FROM titles
ORDER BY release_year DESC, runtime_minutes ASC;
