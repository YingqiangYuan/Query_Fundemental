-- Example 03: Numeric functions -- ROUND, ABS, CAST
--
-- Business question:
--   "Our late_fee column has some ugly floating-point values like 1.25
--    and 8.50, and a few stored with weird precision. Can you tidy them
--    up: round each fee to 2 decimal places (a proper dollar amount),
--    show the absolute value (in case anyone ever entered a negative by
--    mistake), and also show the fee rounded down to a whole dollar
--    (cast to integer) so we can see who owes a 'big' fee?"
--
-- Why this query:
--   `ROUND(late_fee, 2)` keeps two decimals -- the canonical "money"
--   shape.
--   `ABS(late_fee)` gives the magnitude regardless of sign; harmless
--   here because all fees are non-negative, but it's the standard tool
--   when sign noise might creep in.
--   `CAST(late_fee AS INTEGER)` truncates toward zero -- so 8.50
--   becomes 8 and 1.25 becomes 1. Compare with ROUND to see the
--   difference between "truncate" and "round to nearest".
--   We filter out NULL fees because arithmetic on NULL just returns
--   NULL, which would clutter the result.
SELECT
    checkout_id,
    member_name,
    late_fee                                  AS raw_fee,
    ROUND(late_fee, 2)                        AS fee_2dp,
    ABS(late_fee)                             AS fee_abs,
    CAST(late_fee AS INTEGER)                 AS fee_whole_dollars
FROM checkouts
WHERE late_fee IS NOT NULL
ORDER BY late_fee DESC;
