-- Example 04: Date functions -- date() and strftime()
--
-- Business question:
--   "We want a monthly breakdown of checkout activity. For each
--    checkout, show the original checkout_date, a clean date-only
--    version, the year-month it falls in (so we can group later), the
--    day-of-week the book was borrowed, and how many days the member
--    has had to keep the book (due_date - checkout_date)."
--
-- Why this query:
--   `date(checkout_date)` normalizes the value to a pure YYYY-MM-DD
--   string. Our column is already a date string, but `date()` is the
--   safe way to be sure (it would also strip a time portion if one
--   existed).
--   `strftime('%Y-%m', checkout_date)` formats the date into a
--   year-month bucket like '2025-03' -- this is the SQLite idiom for
--   "group by month" that you'll see again in Lesson 12.
--   `strftime('%w', ...)` returns the day-of-week as a number 0-6
--   (Sunday = 0). Handy for "do members borrow more on weekends?"
--   questions.
--   `julianday(due_date) - julianday(checkout_date)` gives the loan
--   length in days as a number, by converting both dates to Julian-day
--   numbers and subtracting.
SELECT
    checkout_id,
    checkout_date,
    date(checkout_date)                                            AS clean_date,
    strftime('%Y-%m', checkout_date)                               AS year_month,
    strftime('%w', checkout_date)                                  AS day_of_week,
    CAST(julianday(due_date) - julianday(checkout_date) AS INTEGER) AS loan_days
FROM checkouts
ORDER BY checkout_date
LIMIT 12;
