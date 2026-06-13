-- Example 03: Nested subquery refactored into a CTE
--
-- Business question:
--   "Which agents closed at least one sale where the buyer paid MORE than
--    the average sale price for that agent's neighborhood?"
--
-- Why this query:
--   This is the kind of question that, written as a nested subquery,
--   produces a query you have to read inside-out. We show the messy
--   version first (commented out, for reference) and then the clean CTE
--   version that reads top-to-bottom.
--
--   The CTE version names the intermediate result -- "average sale price
--   per neighborhood" -- so the final SELECT is just a join. You don't
--   have to re-derive what the inner subquery means every time your eye
--   passes over it.

/*
 * Nested-subquery version (works, but harder to read):
 *
 *   SELECT DISTINCT a.full_name, l.neighborhood
 *   FROM agents a
 *   INNER JOIN listings l ON l.agent_id = a.agent_id
 *   INNER JOIN transactions t ON t.listing_id = l.listing_id
 *   WHERE t.sale_price > (
 *       SELECT AVG(t2.sale_price)
 *       FROM listings l2
 *       INNER JOIN transactions t2 ON t2.listing_id = l2.listing_id
 *       WHERE l2.neighborhood = l.neighborhood
 *   )
 *   ORDER BY a.full_name;
 */

-- CTE version (same answer, easier to follow):
WITH neighborhood_avg AS (
    SELECT l.neighborhood,
           AVG(t.sale_price) AS avg_sale_price
    FROM listings l
    INNER JOIN transactions t ON t.listing_id = l.listing_id
    GROUP BY l.neighborhood
)
SELECT DISTINCT a.full_name,
       l.neighborhood,
       t.sale_price,
       ROUND(n.avg_sale_price, 0) AS neighborhood_avg
FROM agents a
INNER JOIN listings l       ON l.agent_id = a.agent_id
INNER JOIN transactions t   ON t.listing_id = l.listing_id
INNER JOIN neighborhood_avg n ON n.neighborhood = l.neighborhood
WHERE t.sale_price > n.avg_sale_price
ORDER BY a.full_name, l.neighborhood;
