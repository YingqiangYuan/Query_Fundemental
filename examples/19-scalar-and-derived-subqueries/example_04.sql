-- Example 04: Pre-aggregate-then-join (cleaner rewrite of Example 03)
--
-- Business question:
--   "Same question as Example 03 -- each subscriber and their personal
--    average box value -- but I'd like it written in a way that scales
--    when we eventually have hundreds of thousands of shipments."
--
-- Why this query:
--   Same answer as Example 03, but rewritten so the aggregation happens
--   *once* inside a derived table and is then joined back to
--   `subscribers`. Instead of "for each subscriber, re-scan shipments"
--   (correlated), it's "scan shipments once, group, then join." On
--   small data both feel instant; on big data, this shape is much
--   friendlier to the planner.
--
--   This pattern -- pre-aggregate in a subquery, join back for human
--   labels -- is the natural stepping stone to the `WITH ... AS (...)`
--   CTE syntax you'll meet in the next lesson. A CTE is essentially
--   this derived table, lifted out and named.
SELECT
    s.subscriber_id,
    s.full_name,
    s.plan,
    ROUND(agg.avg_box_value, 2) AS avg_box_value
FROM subscribers AS s
LEFT JOIN (
    SELECT
        subscriber_id,
        AVG(declared_value) AS avg_box_value
    FROM shipments
    GROUP BY subscriber_id
) AS agg
    ON agg.subscriber_id = s.subscriber_id
ORDER BY agg.avg_box_value DESC NULLS LAST;
