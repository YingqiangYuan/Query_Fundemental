-- Example 02: Derived table in FROM (pre-aggregate, then join)
--
-- Business question:
--   "Give me each subscriber's name alongside how many boxes we've
--    shipped them and the total declared value -- I want one row per
--    subscriber, ready to paste into a report."
--
-- Why this query:
--   A "derived table" is a subquery in the FROM clause -- you SELECT
--   from it as if it were a real table, giving it an alias. Here we
--   first roll up `shipments` to one row per subscriber (count, sum),
--   then join that mini-table back to `subscribers` for the human name.
--   Reading top-down, the shape of the query mirrors the shape of the
--   answer: "first aggregate, then look up names." Cleaner than trying
--   to do both in a single GROUP BY + JOIN.
SELECT
    s.full_name,
    s.plan,
    s.city,
    agg.shipment_count,
    ROUND(agg.total_value, 2) AS total_value
FROM subscribers AS s
JOIN (
    SELECT
        subscriber_id,
        COUNT(*) AS shipment_count,
        SUM(declared_value) AS total_value
    FROM shipments
    GROUP BY subscriber_id
) AS agg
    ON agg.subscriber_id = s.subscriber_id
ORDER BY agg.total_value DESC;
