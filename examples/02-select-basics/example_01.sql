-- Example 01: SELECT *
--
-- Business question:
--   "Show me everything we have in the books catalog -- I just want to
--    see what's in there."
--
-- Why this query:
--   `SELECT *` returns every column.
--   `FROM books` picks the table to read from.
--   With no WHERE / LIMIT, every row comes back. This is the simplest
--   possible SELECT and a fine way to inspect a small table. Avoid it
--   on large tables in real systems -- it pulls back everything.
SELECT *
FROM books;
