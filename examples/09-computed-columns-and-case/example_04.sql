-- Example 04: Multi-branch CASE for bucketing
--
-- Business question:
--   "Bucket every order by total spend so we can see the mix of small,
--    medium, large and extra-large orders at a glance: under $10 is S,
--    $10-$20 is M, $20-$40 is L, $40+ is XL."
--
-- Why this query:
--   A multi-branch `CASE` walks WHEN clauses top-to-bottom and stops at
--   the first match -- so the order of the WHENs encodes the bucket
--   boundaries. We reuse the `qty * unit_price + delivery_fee + tip`
--   expression from Example 01 inside the CASE; SQLite evaluates it
--   per row. The `ELSE` is a safety net for anything that somehow
--   slips through (it shouldn't here, but it's good hygiene).
SELECT
    order_id,
    restaurant,
    item_name,
    qty * unit_price + delivery_fee + tip AS total,
    CASE
        WHEN qty * unit_price + delivery_fee + tip < 10  THEN 'S'
        WHEN qty * unit_price + delivery_fee + tip < 20  THEN 'M'
        WHEN qty * unit_price + delivery_fee + tip < 40  THEN 'L'
        ELSE 'XL'
    END AS size_bucket
FROM delivery_orders;
