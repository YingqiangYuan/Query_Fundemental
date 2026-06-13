-- Example 04: CTE that joins back to base tables for a final report
--
-- Business question:
--   "Give me a monthly-closing report by neighborhood: for each month,
--    each neighborhood, how many deals closed and what was the total
--    dollar volume? Also tell me how that neighborhood's monthly volume
--    compares to its own all-time average."
--
-- Why this query:
--   A real report often needs more than one slice of the same fact
--   table. Here we want both the per-month breakdown AND a per-
--   neighborhood baseline to compare against. CTEs make that natural:
--     - `monthly_closings`  : month + neighborhood grain
--     - `neighborhood_baseline` : neighborhood grain (all months)
--   Then the final SELECT joins both back to `listings` for the report.
--
--   Notice we deliberately reach back to `listings` in the final SELECT
--   even though we already used it inside the CTEs -- CTEs do not "hide"
--   the base tables; you can still join to them.
WITH monthly_closings AS (
    SELECT strftime('%Y-%m', t.closed_at) AS close_month,
           l.neighborhood,
           COUNT(*)          AS deals_closed,
           SUM(t.sale_price) AS monthly_volume
    FROM listings l
    INNER JOIN transactions t ON t.listing_id = l.listing_id
    GROUP BY close_month, l.neighborhood
),
neighborhood_baseline AS (
    SELECT l.neighborhood,
           AVG(t.sale_price) AS avg_sale_price,
           COUNT(*)          AS lifetime_deals
    FROM listings l
    INNER JOIN transactions t ON t.listing_id = l.listing_id
    GROUP BY l.neighborhood
)
SELECT mc.close_month,
       mc.neighborhood,
       mc.deals_closed,
       mc.monthly_volume,
       ROUND(nb.avg_sale_price, 0) AS neighborhood_avg_price,
       nb.lifetime_deals
FROM monthly_closings mc
INNER JOIN neighborhood_baseline nb ON nb.neighborhood = mc.neighborhood
ORDER BY mc.close_month, mc.monthly_volume DESC;
