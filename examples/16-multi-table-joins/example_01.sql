-- Example 01: Three-table INNER JOIN (customers + tickets + events)
--
-- Business question:
--   "For every ticket we've sold, who bought it and which artist were
--    they going to see? I want one row per ticket with the customer name
--    and the artist on it."
--
-- Why this query:
--   `tickets` is the fact table -- one row per ticket sold. It has FKs to
--   `customers` and `events`, but no human-readable names on its own. To
--   answer the question we join through both FKs:
--     tickets -> customers (on customer_id)
--     tickets -> events    (on event_id)
--   Two INNER JOINs chain naturally: each one adds another table whose
--   columns become available to SELECT. The result has exactly as many
--   rows as `tickets` because every ticket has a matching customer and
--   event. Aliases (`t`, `c`, `e`) keep the column references short.
SELECT
    t.ticket_id,
    c.full_name AS customer,
    e.artist,
    e.event_date,
    t.section,
    t.price_paid
FROM tickets AS t
INNER JOIN customers AS c ON t.customer_id = c.customer_id
INNER JOIN events    AS e ON t.event_id    = e.event_id
ORDER BY t.ticket_id;
