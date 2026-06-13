-- Example 04: LAG -- show yesterday's high next to today's
--
-- Business question:
--   "For every day, also tell me what yesterday's high temperature was,
--    so I can see the two side by side."
--
-- Why this query:
--   `LAG(temp_high_c) OVER (ORDER BY reading_date)` looks one row
--   *back* in the ordered sequence and returns that row's
--   `temp_high_c`. The very first row has no previous row, so its
--   `yesterday_high_c` comes back as NULL -- that's the expected
--   "edge of the window" behavior, not a bug. `LAG` is the workhorse
--   for any "compare each row to its predecessor" question.
SELECT
    reading_date,
    temp_high_c,
    LAG(temp_high_c) OVER (ORDER BY reading_date) AS yesterday_high_c
FROM weather_days
ORDER BY reading_date;
