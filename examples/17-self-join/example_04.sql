-- Example 04: Two-hop — employee, their manager, and the manager's manager
--
-- Business question:
--   "Walk two levels up the org chart for me. For each frontline worker,
--    who is their store manager AND who is that store manager's regional
--    manager?"
--
-- Why this query:
--   One self-join climbs one level. To climb two levels we self-join
--   THREE times: `e` (employee), `m` (their manager), and `gm` (grand-
--   manager, i.e. the manager's manager). Each join hop is the same
--   shape -- `child.manager_id = parent.employee_id` -- just applied
--   again. Because we use INNER JOINs all the way up, only employees who
--   have BOTH a manager AND a grand-manager survive: those are the
--   level-3 frontline staff (cashiers, floor leads, assistant managers).
--   Store managers and regional managers drop out, which is exactly
--   right for a "frontline → top" report.
SELECT
    e.full_name   AS employee,
    e.role        AS employee_role,
    m.full_name   AS manager,
    gm.full_name  AS grand_manager
FROM staff AS e
INNER JOIN staff AS m
    ON e.manager_id = m.employee_id
INNER JOIN staff AS gm
    ON m.manager_id = gm.employee_id
ORDER BY gm.full_name, m.full_name, e.full_name;
