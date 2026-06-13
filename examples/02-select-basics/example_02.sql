-- Example 02: SELECT * with LIMIT
--
-- Business question:
--   "I just want a quick peek -- show me five books so I know what
--    columns the table has and what the values roughly look like."
--
-- Why this query:
--   `LIMIT 5` caps the result at the first five rows. Perfect for
--   sampling a table without dumping the whole thing to your screen.
--   Note: the row order is not guaranteed without an ORDER BY -- LIMIT
--   alone just stops the scan early.
SELECT *
FROM books
LIMIT 5;
