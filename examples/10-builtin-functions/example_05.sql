-- Example 05: NULL handling -- COALESCE and IFNULL
--
-- Business question:
--   "Some members haven't returned their books yet, so returned_date is
--    NULL. And many checkouts didn't incur a late fee, so late_fee is
--    NULL too. For a user-friendly report, replace those NULLs with
--    something readable: 'not returned yet' for missing return dates,
--    and 0.00 for missing fees -- so a non-technical reader doesn't see
--    blank cells everywhere."
--
-- Why this query:
--   `COALESCE(x, y, z, ...)` returns the first non-NULL argument from
--   its list. Use it whenever you have multiple possible fallbacks.
--   `IFNULL(x, y)` is a SQLite-specific shorthand for the two-argument
--   case: if `x` is NULL, return `y`. Equivalent to COALESCE(x, y).
--   We use both side-by-side here so you can see they produce identical
--   output -- pick whichever reads cleaner in your codebase.
--   Notice how rows where returned_date IS NULL get the 'not returned
--   yet' label, and rows where late_fee IS NULL get 0.00 -- the data
--   itself is unchanged, we're only changing how it's displayed.
SELECT
    checkout_id,
    member_name,
    book_title,
    returned_date                                          AS raw_returned,
    COALESCE(returned_date, 'not returned yet')            AS returned_display,
    late_fee                                               AS raw_fee,
    IFNULL(late_fee, 0.00)                                 AS fee_display,
    COALESCE(late_fee, 0.00)                               AS fee_display_alt
FROM checkouts
WHERE returned_date IS NULL OR late_fee IS NOT NULL
ORDER BY checkout_id
LIMIT 15;
