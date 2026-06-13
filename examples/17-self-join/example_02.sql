-- Example 02: Top of the chain via LEFT JOIN + IS NULL
--
-- Business question:
--   "Who are the people at the very top of the org chart -- the ones
--    nobody manages?"
--
-- Why this query:
--   Inner-joining `staff` to itself drops the top-level rows because
--   their manager_id is NULL and matches nothing. Switching to LEFT JOIN
--   keeps every employee row and fills the manager columns with NULL
--   when no manager exists. Then `WHERE m.employee_id IS NULL` keeps
--   only the rows where the lookup failed -- i.e. the regional managers
--   who report to nobody. This is the standard "find the roots of the
--   hierarchy" idiom.
SELECT
    e.employee_id   AS emp_id,
    e.full_name     AS employee,
    e.role          AS employee_role,
    e.store_location
FROM staff AS e
LEFT JOIN staff AS m
    ON e.manager_id = m.employee_id
WHERE m.employee_id IS NULL
ORDER BY e.full_name;
