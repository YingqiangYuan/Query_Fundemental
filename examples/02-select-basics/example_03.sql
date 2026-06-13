-- Example 03: SELECT COUNT(*)
--
-- Business question:
--   "How many books are in the catalog in total?"
--
-- Why this query:
--   `COUNT(*)` is an aggregate function: instead of returning the rows
--   themselves, it returns a single number -- the row count.
--   `AS total_books` renames the output column so the result reads
--   nicely. Without `AS`, the column header would literally be
--   `COUNT(*)`, which is correct but awkward to look at.
SELECT COUNT(*) AS total_books
FROM books;
