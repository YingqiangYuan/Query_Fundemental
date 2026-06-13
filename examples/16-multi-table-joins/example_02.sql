-- Example 02: Four-table INNER JOIN (+ venues)
--
-- Business question:
--   "For every ticket sold, I want the whole story on one line: who
--    bought it, which artist, which venue, and which city the show is
--    in."
--
-- Why this query:
--   Extending Example 01 by one more hop: events has a venue_id FK into
--   venues, so adding `INNER JOIN venues ON e.venue_id = v.venue_id`
--   gives us the venue name, city, and capacity columns. Each additional
--   INNER JOIN follows the same shape -- attach one more table along its
--   FK and you can SELECT from it. Notice the join order mirrors the FK
--   graph: tickets -> customers, tickets -> events -> venues. Writing
--   joins in dependency order like this is a strong readability habit;
--   anyone reading the query can trace how each table connects to the
--   next.
SELECT
    t.ticket_id,
    c.full_name AS customer,
    e.artist,
    v.name      AS venue,
    v.city      AS venue_city,
    e.event_date,
    t.price_paid
FROM tickets AS t
INNER JOIN customers AS c ON t.customer_id = c.customer_id
INNER JOIN events    AS e ON t.event_id    = e.event_id
INNER JOIN venues    AS v ON e.venue_id    = v.venue_id
ORDER BY e.event_date, t.ticket_id;
