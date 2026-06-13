-- Example 05: LEAD -- show tomorrow's high next to today's
--
-- Business question:
--   "For each day, what was tomorrow's high temperature? I want to see
--    today and tomorrow side by side so I can spot upcoming warm-ups or
--    cold snaps."
--
-- Why this query:
--   `LEAD(temp_high_c) OVER (ORDER BY reading_date)` is the mirror
--   image of `LAG`: it peeks one row *ahead* in the ordered sequence.
--   The very last row has no following row, so its `tomorrow_high_c`
--   will be NULL -- again, expected edge behavior. Use `LEAD` whenever
--   you want each row to know something about the next row.
SELECT
    reading_date,
    temp_high_c,
    LEAD(temp_high_c) OVER (ORDER BY reading_date) AS tomorrow_high_c
FROM weather_days
ORDER BY reading_date;
