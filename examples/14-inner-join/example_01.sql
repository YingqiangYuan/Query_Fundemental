-- Example 01: INNER JOIN ... ON ...
--
-- Business question:
--   "For every clinic visit on file, show me which pet came in and what
--    they came in for."
--
-- Why this query:
--   The pet's name lives in `pets`; the reason for the visit lives in
--   `visits`. Neither table alone can answer the question. `INNER JOIN`
--   stitches the two tables together on the shared key (`pet_id`),
--   producing one row per visit with the pet's name attached. Only
--   visits whose `pet_id` matches a real pet are returned -- that's the
--   "inner" in INNER JOIN.
SELECT pets.name,
       pets.species,
       visits.visit_date,
       visits.reason
FROM pets
INNER JOIN visits
        ON pets.pet_id = visits.pet_id
ORDER BY visits.visit_date;
