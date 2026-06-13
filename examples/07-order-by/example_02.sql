-- Example 02: ORDER BY column DESC
--
-- Business question:
--   "What are our highest-rated titles? Show me the best-reviewed stuff
--    at the top of the list."
--
-- Why this query:
--   Adding `DESC` flips the sort direction so the largest IMDb score
--   appears first. This is the more common direction for "top X" style
--   questions -- people almost always want the best at the top. The
--   pairing of `ORDER BY <col> DESC` is one you'll type a lot.
SELECT title, type, imdb_score
FROM titles
ORDER BY imdb_score DESC;
