-- Example 02: Multiple CTEs chained in one query
--
-- Business question:
--   "For every agent who has closed at least one sale, show their average
--    sale price -- and flag whether they're above or below the
--    company-wide average."
--
-- Why this query:
--   We need two intermediate things:
--     1. Each agent's average sale price (per-agent aggregate).
--     2. The overall average sale price (a single scalar).
--   Then we want to combine them in the final SELECT.
--
--   You can stack as many CTEs as you want by separating them with a
--   comma after the closing `)`. Each CTE can reference any earlier CTE.
--   Reading top-to-bottom mirrors how you'd explain the query to a
--   colleague: "first this, then that, then the answer."
WITH agent_avg AS (
    SELECT l.agent_id,
           AVG(t.sale_price) AS agent_avg_price,
           COUNT(*)          AS deals_closed
    FROM listings l
    INNER JOIN transactions t ON t.listing_id = l.listing_id
    GROUP BY l.agent_id
),
overall AS (
    SELECT AVG(sale_price) AS company_avg_price
    FROM transactions
)
SELECT a.full_name,
       a.agency,
       ag.deals_closed,
       ROUND(ag.agent_avg_price, 0) AS agent_avg_price,
       ROUND(o.company_avg_price, 0) AS company_avg_price,
       CASE
           WHEN ag.agent_avg_price >= o.company_avg_price THEN 'above'
           ELSE 'below'
       END AS vs_company_avg
FROM agents a
INNER JOIN agent_avg ag ON ag.agent_id = a.agent_id
CROSS JOIN overall o
ORDER BY ag.agent_avg_price DESC;
