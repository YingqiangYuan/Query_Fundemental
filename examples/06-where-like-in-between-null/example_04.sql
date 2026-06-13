-- Example 04: NOT IN (...)
--
-- Business question:
--   "Which showtimes are NOT rated G or PG? I want to flag the
--    grown-up screenings."
--
-- Why this query:
--   `NOT IN (...)` is the inverse of `IN (...)` -- it keeps rows whose
--   value is NOT in the given list. Here we exclude family-friendly
--   ratings to find the PG-13 and R showings.
--   Heads-up for later (Lesson 18): if the list inside `NOT IN` itself
--   contains a NULL, the result is surprising -- you'll get zero rows
--   back. Safe here because we hard-code the values ourselves.
SELECT showtime_id, movie_title, rating, theater, start_time
FROM showtimes
WHERE rating NOT IN ('G', 'PG')
ORDER BY rating, start_time;
