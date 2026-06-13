-- Example 01: Self-join — pair each employee with their manager
--
-- Business question:
--   "For every employee in the chain, who is their direct manager?
--    I want one row per employee with both names side by side."
--
-- Why this query:
--   The manager_id column points back into the SAME staff table -- a
--   classic self-referencing foreign key. To get "employee name + manager
--   name" on one row, we join `staff` to itself, using two different
--   aliases so SQL can tell which copy of the table we mean. `e` is the
--   employee side, `m` is the manager side, and the join condition
--   `e.manager_id = m.employee_id` walks one step up the org chart.
--   Regional managers (manager_id IS NULL) are excluded by the INNER JOIN
--   because there's no matching row on the manager side.
SELECT
    e.employee_id   AS emp_id,
    e.full_name     AS employee,
    e.role          AS employee_role,
    m.full_name     AS manager,
    m.role          AS manager_role
FROM staff AS e
INNER JOIN staff AS m
    ON e.manager_id = m.employee_id
ORDER BY m.full_name, e.full_name;
