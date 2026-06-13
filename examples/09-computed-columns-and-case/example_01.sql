-- Example 01: Arithmetic in the SELECT list
--
-- Business question:
--   "For every order line, what's the actual amount the customer paid
--    once we add up the items, the delivery fee, and the tip?"
--
-- Why this query:
--   The raw table only stores `qty`, `unit_price`, `delivery_fee` and
--   `tip` separately -- it never stores the grand total. We compute it
--   on the fly with `qty * unit_price + delivery_fee + tip`. Computed
--   columns are evaluated per row, and `AS total` gives the new column
--   a readable name. Notice the original four columns are still there
--   for transparency -- the total is derived, not magic.
SELECT
    order_id,
    restaurant,
    qty,
    unit_price,
    delivery_fee,
    tip,
    qty * unit_price + delivery_fee + tip AS total
FROM delivery_orders;
