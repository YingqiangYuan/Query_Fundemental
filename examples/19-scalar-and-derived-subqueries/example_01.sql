-- Example 01: Scalar subquery in SELECT
--
-- Business question:
--   "For each shipment, show me the declared value AND how it compares
--    to the overall average declared value across all shipments. I want
--    to spot the boxes that are way above or below normal at a glance."
--
-- Why this query:
--   A scalar subquery is a SELECT that returns exactly one row, one
--   column -- a single value. Here `(SELECT AVG(declared_value) FROM
--   shipments)` returns one number, and we reuse it on every row of the
--   outer query. That lets us compute a per-row "diff vs overall avg"
--   without having to hard-code the average. SQLite evaluates the inner
--   query once and plugs the number into each row, which is exactly the
--   shape we want when "the comparison baseline is a single aggregate."
SELECT
    shipment_id,
    subscriber_id,
    box_theme,
    declared_value,
    ROUND((SELECT AVG(declared_value) FROM shipments), 2) AS overall_avg,
    ROUND(declared_value - (SELECT AVG(declared_value) FROM shipments), 2) AS diff_vs_avg
FROM shipments
ORDER BY diff_vs_avg DESC
LIMIT 10;
