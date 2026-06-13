-- Example 03: Mixing LEFT JOIN and INNER JOIN
--
-- Business question:
--   "Give me every customer in our database, plus how many tickets they
--    have bought and what's the most recent show they're attending. I
--    want customers who have never bought a ticket to show up too -- I
--    need to spot the inactive accounts."
--
-- Why this query:
--   If we INNER-joined customers to tickets, customers who never bought
--   anything would silently disappear from the result. That's the
--   opposite of what we want here. So:
--     customers LEFT JOIN tickets  -- keep every customer, with NULLs if
--                                      they have no tickets
--     tickets   INNER JOIN events  -- but if a ticket DOES exist, we
--                                      definitely want its event info
--   You can mix LEFT and INNER in the same query; what matters is which
--   side of which join you want to preserve. Notice the use of
--   COUNT(t.ticket_id) (not COUNT(*)) -- COUNT(*) would return 1 for the
--   no-ticket customers (the single NULL-padded row), whereas
--   COUNT(t.ticket_id) correctly returns 0 because NULLs are not
--   counted.
SELECT
    c.full_name                AS customer,
    c.city,
    COUNT(t.ticket_id)         AS tickets_bought,
    MAX(e.event_date)          AS latest_event
FROM customers AS c
LEFT  JOIN tickets AS t ON c.customer_id = t.customer_id
LEFT  JOIN events  AS e ON t.event_id    = e.event_id
GROUP BY c.customer_id, c.full_name, c.city
ORDER BY tickets_bought DESC, c.full_name;
