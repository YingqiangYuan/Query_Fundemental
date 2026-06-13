-- Example 04: Aliases without the AS keyword
--
-- Business question:
--   "Same renamed export as before -- but I've seen some queries skip
--    the word AS. Does that still work?"
--
-- Why this query:
--   SQL lets you omit the `AS` keyword: a bare identifier right after
--   a column is treated as its alias. The result is identical to using
--   `AS`. We still recommend writing `AS` explicitly -- it makes the
--   intent obvious and prevents silent bugs (forget a comma in a long
--   SELECT list and the next column accidentally becomes an alias).
SELECT
    name     drink_name,
    category drink_type,
    price    usd_price
FROM drinks;
