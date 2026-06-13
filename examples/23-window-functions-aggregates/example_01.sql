-- Example 01: Window aggregate with PARTITION BY -- monthly average alongside each day
--
-- Business question:
--   "For every day in our log, show that day's high temperature next to
--    the average high temperature for the whole month it belongs to, so
--    I can tell at a glance whether the day was warmer or cooler than
--    the monthly norm."
--
-- Why this query:
--   `AVG(temp_high_c) OVER (PARTITION BY strftime('%Y-%m', reading_date))`
--   computes the average high *within each month*, but unlike GROUP BY
--   it does NOT collapse the rows -- every original day is still
--   returned, with the monthly average attached as a new column. That
--   side-by-side layout is the whole point of window functions: keep
--   the row-level detail AND show a group-level aggregate.
SELECT
    reading_date,
    condition,
    temp_high_c,
    ROUND(
        AVG(temp_high_c) OVER (PARTITION BY strftime('%Y-%m', reading_date)),
        2
    ) AS monthly_avg_high_c
FROM weather_days
ORDER BY reading_date;
