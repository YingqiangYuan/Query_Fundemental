-- Example 04: INNER JOIN + WHERE on columns from either side
--
-- Business question:
--   "Show me every dog that came in for a surgery, with the date and
--    how much the surgery cost."
--
-- Why this query:
--   We need two filters that live on **different** tables:
--     - `p.species = 'dog'`  -- a column on the parent (pets) side.
--     - `v.reason  = 'surgery'` -- a column on the child (visits) side.
--   That's the everyday case for INNER JOIN: once the tables are
--   stitched together, WHERE can filter on any column from either side
--   as if they belonged to one wide combined table. ORDER BY DESC puts
--   the most expensive surgery at the top.
SELECT p.name      AS pet_name,
       p.breed,
       p.owner_name,
       v.visit_date,
       v.cost
FROM pets AS p
INNER JOIN visits AS v
        ON p.pet_id = v.pet_id
WHERE p.species = 'dog'
  AND v.reason  = 'surgery'
ORDER BY v.cost DESC;
