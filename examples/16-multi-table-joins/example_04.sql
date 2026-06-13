-- Example 04: Aggregate across a multi-table join -- revenue per venue
--
-- Business question:
--   "How much total ticket revenue did each venue bring in, and how many
--    tickets did they sell? Sort by best venue first."
--
-- Why this query:
--   `tickets.price_paid` lives on `tickets`, but the venue lives on
--   `venues` -- two hops away through `events`. We chain the joins to
--   bring all three together, then GROUP BY the venue. SUM and COUNT
--   are computed AFTER the joins, across every joined row that fell into
--   each group.
--   This is the canonical "aggregate over a join graph" shape: join
--   everything you need into one wide row stream, then collapse with
--   GROUP BY + aggregate functions. Try changing `v.name` to `e.artist`
--   in both SELECT and GROUP BY to instantly get "revenue per artist"
--   instead -- the join skeleton stays the same.
SELECT
    v.name                       AS venue,
    v.city,
    COUNT(*)                     AS tickets_sold,
    ROUND(SUM(t.price_paid), 2)  AS total_revenue
FROM tickets AS t
INNER JOIN events AS e ON t.event_id = e.event_id
INNER JOIN venues AS v ON e.venue_id = v.venue_id
GROUP BY v.venue_id, v.name, v.city
ORDER BY total_revenue DESC;
