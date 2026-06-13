-- Example 02: String concatenation with `||`
--
-- Business question:
--   "Give me a single human-friendly label for each order line, like
--    'Shake Shack -- ShackBurger', so I can paste it into a report
--    without combining columns in Excel afterwards."
--
-- Why this query:
--   In SQLite, `||` glues strings together. We sandwich a literal
--   ' -- ' between the restaurant name and the item name to produce
--   one tidy label per row. Computed string columns work the same way
--   as computed numeric columns -- they live only in the result set,
--   the underlying table is untouched.
SELECT
    order_id,
    restaurant || ' -- ' || item_name AS order_label,
    qty,
    unit_price
FROM delivery_orders
LIMIT 15;
