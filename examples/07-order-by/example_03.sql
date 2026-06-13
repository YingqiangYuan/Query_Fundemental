-- Example 03: ORDER BY with multiple columns
--
-- Business question:
--   "Group titles by type (movies together, series together), and within
--    each group show the best-rated ones first."
--
-- Why this query:
--   You can list more than one column in `ORDER BY`, separated by
--   commas. SQL sorts by the first column first; when rows tie on that
--   column, it breaks the tie using the second column, and so on.
--   Here `type` puts all the movies before all the series alphabetically,
--   and within each type the highest `imdb_score` floats to the top
--   because of the `DESC` on the second sort key.
SELECT type, title, imdb_score
FROM titles
ORDER BY type, imdb_score DESC;
