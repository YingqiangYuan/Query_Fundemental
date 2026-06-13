-- Example 01: ORDER BY column (default ASC)
--
-- Business question:
--   "Which titles in our catalog have the lowest IMDb scores? I want to
--    start with the worst-rated and work my way up."
--
-- Why this query:
--   `ORDER BY imdb_score` sorts the rows by IMDb score. SQL's default
--   sort direction is ASC (ascending: smallest first), so you do not
--   need to write `ASC` explicitly -- but you can if you want to be
--   loud about it. The lowest-scoring title appears at the top.
SELECT title, type, imdb_score
FROM titles
ORDER BY imdb_score;
