-- Example 05: BETWEEN ... AND ... on date strings
--
-- Business question:
--   "Give me every showtime that started during the first week of
--    July 2025 -- July 1 through July 7, inclusive."
--
-- Why this query:
--   `BETWEEN a AND b` is shorthand for `col >= a AND col <= b`. It is
--   INCLUSIVE on both ends.
--   Our `start_time` column is stored as ISO-8601 text (e.g.
--   `2025-07-01 18:30`). ISO strings sort lexicographically the same
--   way they sort chronologically, so a plain string comparison gives
--   us correct date ordering without any date conversion.
--   Subtle point worth noticing in the result: the upper bound
--   `'2025-07-07'` compares as if it were `'2025-07-07 00:00'`, so any
--   showings that started later in the day on July 7 are NOT included.
--   When the column has a time component, picking the right boundary
--   string matters.
SELECT showtime_id, movie_title, theater, start_time
FROM showtimes
WHERE start_time BETWEEN '2025-07-01' AND '2025-07-07'
ORDER BY start_time;
