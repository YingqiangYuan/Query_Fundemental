-- Example 02: Running total with ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
--
-- Business question:
--   "How much rain (and snowmelt) have we accumulated so far this
--    season? For every day, show that day's precipitation and the
--    running total of precipitation since the very first reading."
--
-- Why this query:
--   `SUM(precipitation_mm) OVER (ORDER BY reading_date ROWS BETWEEN
--   UNBOUNDED PRECEDING AND CURRENT ROW)` is the canonical running-total
--   recipe: walk the rows in date order, and at each row sum every
--   precipitation value from the start up to and including today. The
--   `ROWS BETWEEN ...` clause is the *window frame* -- it controls which
--   neighbours fall inside the window for the current row.
SELECT
    reading_date,
    condition,
    precipitation_mm,
    ROUND(
        SUM(precipitation_mm) OVER (
            ORDER BY reading_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        1
    ) AS cumulative_precip_mm
FROM weather_days
ORDER BY reading_date;
