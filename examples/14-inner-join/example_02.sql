-- Example 02: Table aliases (`p`, `v`)
--
-- Business question:
--   "Same report as before -- pet name + visit reason + cost -- but I
--    don't want to type the long table names everywhere."
--
-- Why this query:
--   `pets AS p` and `visits AS v` give each table a short nickname.
--   Inside the rest of the query we can write `p.name` and `v.reason`
--   instead of `pets.name` and `visits.reason`. Aliases are pure
--   shorthand -- they don't change the result -- but on real queries
--   with 3+ tables they save a lot of typing and make the JOIN
--   condition easier to read.
SELECT p.name,
       p.species,
       v.visit_date,
       v.reason,
       v.cost
FROM pets AS p
INNER JOIN visits AS v
        ON p.pet_id = v.pet_id
ORDER BY v.visit_date;
