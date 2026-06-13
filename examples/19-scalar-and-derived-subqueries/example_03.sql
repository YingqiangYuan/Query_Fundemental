-- Example 03: Correlated subquery in SELECT
--
-- Business question:
--   "List every subscriber and, next to their name, the average
--    declared value of THE BOXES WE'VE SENT THEM SPECIFICALLY. I want
--    a feel for each customer's typical shipment size."
--
-- Why this query:
--   This is a *correlated* subquery: the inner SELECT references the
--   outer row (`sh.subscriber_id = s.subscriber_id`), so it gets
--   re-run for every subscriber. Conceptually it reads beautifully --
--   "for each subscriber, go fetch their average" -- which is exactly
--   why it's a popular first instinct.
--
--   The catch: on large data this can be slow because the engine may
--   evaluate the inner query once per outer row. Example 04 shows the
--   same answer with a pre-aggregate-and-join shape, which is usually
--   faster and is the natural lead-in to CTEs in the next lesson.
SELECT
    s.subscriber_id,
    s.full_name,
    s.plan,
    ROUND(
        (
            SELECT AVG(sh.declared_value)
            FROM shipments AS sh
            WHERE sh.subscriber_id = s.subscriber_id
        ),
        2
    ) AS avg_box_value
FROM subscribers AS s
ORDER BY avg_box_value DESC NULLS LAST;
