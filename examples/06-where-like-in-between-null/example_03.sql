-- Example 03: IN (...)
--
-- Business question:
--   "Show me only the showtimes playing on Screen 1, Screen 2, or our
--    IMAX hall -- I want to ignore everything else."
--
-- Why this query:
--   `IN (...)` is the clean way to say "column equals any value in this
--   list". It's equivalent to
--     screen_number = 'Screen 1' OR screen_number = 'Screen 2'
--     OR screen_number = 'IMAX'
--   but much shorter and easier to read once the list grows. Order of
--   values inside `IN (...)` does not matter.
SELECT showtime_id, movie_title, theater, screen_number, start_time
FROM showtimes
WHERE screen_number IN ('Screen 1', 'Screen 2', 'IMAX')
ORDER BY screen_number, start_time;
