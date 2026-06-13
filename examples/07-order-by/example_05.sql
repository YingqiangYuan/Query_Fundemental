-- Example 05: ORDER BY with NULLs -- pushing them to the end
--
-- Business question:
--   "Rank titles by their Rotten Tomatoes score, best first. Titles we
--    don't have a Rotten score for should sit at the bottom of the list,
--    not crowd the top."
--
-- Why this query:
--   Some titles have no `rotten_score` (it is NULL). By default, SQLite
--   sorts NULLs as if they were the smallest value -- so `ORDER BY
--   rotten_score DESC` would put them LAST (good), but `ORDER BY
--   rotten_score` (ASC) would put them FIRST (usually not what you
--   want). `NULLS LAST` makes the intent explicit and works the same
--   way regardless of direction. Notice the rows with NULL rotten_score
--   land at the bottom of the result.
SELECT title, type, rotten_score
FROM titles
ORDER BY rotten_score DESC NULLS LAST;
