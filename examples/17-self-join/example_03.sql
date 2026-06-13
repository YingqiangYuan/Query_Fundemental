-- Example 03: Count direct reports per manager
--
-- Business question:
--   "How many direct reports does each manager have? I want a leaderboard
--    of managers from biggest team to smallest."
--
-- Why this query:
--   Same self-join shape as before -- `m` is the manager, `e` is the
--   employee -- but now we GROUP BY the manager and COUNT the employee
--   rows. Critical detail: we COUNT(e.employee_id), not COUNT(*). If we
--   used a LEFT JOIN here, COUNT(*) would count a phantom NULL row for
--   managers with zero reports and report `1` instead of `0`. Using
--   INNER JOIN plus COUNT(<column>) makes the count behave correctly.
--   Counts vary across managers because some store managers run a bigger
--   team than others -- that variation is the point of the example.
SELECT
    m.full_name           AS manager,
    m.role                AS manager_role,
    COUNT(e.employee_id)  AS direct_reports
FROM staff AS m
INNER JOIN staff AS e
    ON e.manager_id = m.employee_id
GROUP BY m.employee_id, m.full_name, m.role
ORDER BY direct_reports DESC, manager;
