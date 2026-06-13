-- Example 01: UNION ALL -- stack two result sets, keep every row
--
-- Business question:
--   "Give me a single feed of every customer interaction this week --
--    dine-in and takeout together -- so I can see total order volume.
--    I don't care if the same customer shows up twice; I want every
--    single order in one list."
--
-- Why this query:
--   UNION ALL concatenates the rows of two SELECTs into one result set.
--   The two SELECTs must return the **same number of columns** in the
--   **same order with compatible types**. Column names come from the
--   FIRST SELECT, which is why we alias `receipt_id` to `order_id` and
--   `customer_email` stays the same on both sides.
--   UNION ALL keeps duplicates -- if the same email appears in both
--   tables, it appears twice here. That is exactly what we want when
--   counting total interactions.
SELECT
    order_id,
    customer_email,
    items_total,
    ordered_at,
    'dine_in' AS channel
FROM dine_in_orders
UNION ALL
SELECT
    receipt_id   AS order_id,
    customer_email,
    items_total,
    ordered_at,
    'takeout'    AS channel
FROM takeout_orders
ORDER BY ordered_at;
