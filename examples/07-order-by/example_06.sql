-- Example 06: ORDER BY column number (shorthand)
--
-- Business question:
--   "Sort the catalog by watch hours, biggest hits first."
--
-- Why this query:
--   You can reference a SELECT-list column by its position number
--   instead of its name. Here `ORDER BY 3 DESC` means "sort by the 3rd
--   column in the SELECT list" -- which is `watch_hours_millions`. It
--   works and saves typing, but it is fragile: if someone reorders the
--   SELECT list later, the sort silently changes meaning. Prefer the
--   column name in production code; recognize the shorthand when you
--   see it in someone else's query.
SELECT title, type, watch_hours_millions
FROM titles
ORDER BY 3 DESC;
