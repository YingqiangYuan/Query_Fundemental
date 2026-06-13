-- Example 05: Bare JOIN means INNER JOIN
--
-- Business question:
--   "Show me every illness visit in 2024, with the pet's name, the
--    owner's name, and the vet who handled it."
--
-- Why this query:
--   In SQL, the word `INNER` is optional -- a bare `JOIN ... ON ...` is
--   exactly an `INNER JOIN ... ON ...`. Most production codebases drop
--   the `INNER` keyword because it's the default. This example uses the
--   shorter form to prove the equivalence. If you re-ran this query
--   with `INNER JOIN` spelled out, the result would be byte-for-byte
--   identical. The WHERE clause then narrows the joined rows to visits
--   whose reason is `'illness'`.
SELECT p.name      AS pet_name,
       p.species,
       p.owner_name,
       v.visit_date,
       v.vet_name,
       v.cost
FROM pets AS p
JOIN visits AS v
  ON p.pet_id = v.pet_id
WHERE v.reason = 'illness'
ORDER BY v.visit_date;
