-- Example 03: Qualifying ambiguous columns
--
-- Business question:
--   "For every visit, show me the pet's name AND the vet's name side by
--    side, so I can see who treated whom."
--
-- Why this query:
--   Both tables have a "name"-shaped column: `pets.name` (the pet) and
--   `visits.vet_name` (the vet). If you write a bare `name` in the
--   SELECT, the database can't tell which table you mean -- on columns
--   that exist on both sides it would raise an "ambiguous column"
--   error. The fix is to **qualify** every column with its table (or
--   alias): `p.name AS pet_name`, `v.vet_name`. Aliasing the output
--   column (`AS pet_name`) also keeps the result readable.
SELECT p.name      AS pet_name,
       p.species,
       v.visit_date,
       v.reason,
       v.vet_name
FROM pets AS p
INNER JOIN visits AS v
        ON p.pet_id = v.pet_id
ORDER BY p.name, v.visit_date;
