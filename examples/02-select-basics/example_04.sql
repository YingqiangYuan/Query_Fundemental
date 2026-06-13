-- Example 04: SELECT DISTINCT
--
-- Business question:
--   "What genres of books do we carry? I don't need every book -- just
--    the list of distinct categories."
--
-- Why this query:
--   `DISTINCT` drops duplicate values, so each genre appears exactly
--   once even though many books share the same genre. Try removing
--   `DISTINCT` and rerunning -- you will get 20 rows with lots of
--   repeats, which is the same data but a much worse answer to the
--   question.
SELECT DISTINCT genre
FROM books;
