-- Example 05: Sidebar — aliases let the same table play two roles
--
-- Business question:
--   "For every employee in the company, tell me three things on one row:
--    their own name + role, their manager's name + role, and -- if the
--    manager has one -- their grand-manager's name. Don't drop anyone,
--    even the regional managers at the top."
--
-- Why this query:
--   This is the same self-join trick as example 04, but the takeaway is
--   about the ALIASES, not the SQL keywords. The single physical table
--   `staff` is referenced three times and given three different aliases
--   (`e`, `m`, `gm`). From SQL's point of view those are three separate
--   logical tables that happen to share the same underlying rows. We
--   use LEFT JOIN this time so EVERYONE shows up: regional managers get
--   NULL for manager and grand_manager; store managers get a manager
--   but NULL grand_manager; frontline staff get both filled in. The
--   `COALESCE(..., '-')` calls turn those NULLs into a readable dash so
--   the output is easy to scan.
SELECT
    e.full_name                       AS employee,
    e.role                            AS employee_role,
    COALESCE(m.full_name,  '-')       AS manager,
    COALESCE(m.role,       '-')       AS manager_role,
    COALESCE(gm.full_name, '-')       AS grand_manager
FROM staff AS e
LEFT JOIN staff AS m
    ON e.manager_id = m.employee_id
LEFT JOIN staff AS gm
    ON m.manager_id = gm.employee_id
ORDER BY e.full_name;
