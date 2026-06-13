-- Example 04: Pagination -- pick any page, 10 rows per page
--
-- Business question:
--   "Our web UI shows the chart 10 rows per page. Page 3, please --
--    that's rows 21 through 30 of the full ranked list."
--
-- Why this query:
--   This is the generalized pagination formula:
--
--       LIMIT  <page_size>
--       OFFSET <page_size> * (<page_number> - 1)
--
--   Page size 10, page 3 -> OFFSET = 10 * (3 - 1) = 20, so we skip the
--   first 20 rows (pages 1 and 2) and return the next 10.
--   Two real-world cautions:
--     1. Big OFFSETs are SLOW -- the database still has to scan and
--        discard every skipped row. For deep pagination, prefer
--        keyset/cursor pagination ("WHERE listens < <last_seen>"), not
--        ever-growing OFFSET.
--     2. If the underlying data changes between page loads (new entries
--        added), rows can shift across page boundaries.
SELECT podcast, episode_title, host, chart_week, listens
FROM chart_entries
ORDER BY listens DESC
LIMIT 10 OFFSET 20;
