-- Example 01: Single CTE -- WITH ... AS (...) SELECT ... FROM cte
--
-- Business question:
--   "For each agent, how much total sale value have they actually closed?
--    I just want one row per agent with a single number."
--
-- Why this query:
--   We need totals per agent, but sale_price lives in `transactions` (not
--   `listings`), and `transactions` doesn't know who the agent is. The
--   bridge is `listings` (which has `agent_id`).
--
--   We could write this as a derived table in FROM, but a CTE -- the
--   `WITH agent_sales AS (...)` block -- gives the intermediate result a
--   name and reads top-to-bottom like a story: "first compute each
--   agent's closed total, then join to the agent name." Same result as
--   a subquery, much easier to follow.
WITH agent_sales AS (
    SELECT l.agent_id,
           SUM(t.sale_price) AS total_sold_value,
           COUNT(*)          AS deals_closed
    FROM listings l
    INNER JOIN transactions t ON t.listing_id = l.listing_id
    GROUP BY l.agent_id
)
SELECT a.full_name,
       a.agency,
       s.deals_closed,
       s.total_sold_value
FROM agents a
INNER JOIN agent_sales s ON s.agent_id = a.agent_id
ORDER BY s.total_sold_value DESC;
