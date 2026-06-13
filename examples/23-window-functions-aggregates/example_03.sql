-- Example 03: 7-day rolling average of daily highs
--
-- Business question:
--   "Day-to-day temperatures bounce around a lot -- can I see the
--    underlying trend? Give me, for each day, the average daily high of
--    the past 7 days (this day plus the 6 days before)."
--
-- Why this query:
--   `AVG(temp_high_c) OVER (ORDER BY reading_date ROWS BETWEEN 6
--   PRECEDING AND CURRENT ROW)` defines a moving 7-row window. Change
--   the frame and the same function answers a totally different
--   question -- here it smooths noise out of the daily highs and lets
--   you read the seasonal trend. The first 6 rows will average over a
--   shorter window (just whatever rows exist so far), which is normal
--   behavior at the start of a rolling window.
SELECT
    reading_date,
    temp_high_c,
    ROUND(
        AVG(temp_high_c) OVER (
            ORDER BY reading_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS rolling_7day_avg_high_c
FROM weather_days
ORDER BY reading_date;
