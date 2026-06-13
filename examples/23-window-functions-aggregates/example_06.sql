-- Example 06: Day-over-day change using LAG arithmetic
--
-- Business question:
--   "How much warmer or colder was each day compared with the day
--    before? I want a single 'change vs yesterday' column so I can
--    spot the biggest temperature swings at a glance."
--
-- Why this query:
--   The day-over-day delta pattern is:
--     `today_value - LAG(today_value) OVER (ORDER BY ...)`.
--   Subtracting yesterday's high from today's high gives a positive
--   number on warming days and a negative number on cooling days. The
--   first row has no previous day, so its delta is NULL -- nothing to
--   compare against. We sort by the absolute change in the outer query
--   so the wildest swings bubble to the top.
SELECT
    reading_date,
    temp_high_c,
    LAG(temp_high_c) OVER (ORDER BY reading_date) AS yesterday_high_c,
    ROUND(
        temp_high_c - LAG(temp_high_c) OVER (ORDER BY reading_date),
        2
    ) AS change_vs_yesterday_c
FROM weather_days
ORDER BY ABS(
    COALESCE(
        temp_high_c - LAG(temp_high_c) OVER (ORDER BY reading_date),
        0
    )
) DESC
LIMIT 15;
