-- Example 05: Revenue per artist + readability tip (joins in dependency order)
--
-- Business question:
--   "Which artists are bringing in the most ticket revenue across all
--    their shows? Include the venue city so I can see where each artist
--    played."
--
-- Why this query:
--   Same join skeleton as Example 04, but we GROUP BY artist instead of
--   venue. The interesting lesson here is *how the query reads*. We
--   deliberately write the FROM/JOIN block in FK-dependency order:
--
--     FROM tickets             -- the fact table (one row per sale)
--     JOIN events  ON ...      -- each ticket belongs to one event
--     JOIN venues  ON ...      -- each event happens at one venue
--
--   SQLite does not care about the order -- the optimizer is free to
--   pick whatever join order it wants -- but a human reading the query
--   can trace the relationships left-to-right without backtracking. When
--   queries grow to 5+ tables this discipline pays for itself.
--   (We're also showing that the same join graph can answer multiple
--   business questions just by changing GROUP BY and SELECT.)
SELECT
    e.artist,
    v.city                       AS venue_city,
    COUNT(*)                     AS tickets_sold,
    ROUND(SUM(t.price_paid), 2)  AS total_revenue
FROM tickets AS t
INNER JOIN events AS e ON t.event_id = e.event_id
INNER JOIN venues AS v ON e.venue_id = v.venue_id
GROUP BY e.artist, v.city
ORDER BY total_revenue DESC;
