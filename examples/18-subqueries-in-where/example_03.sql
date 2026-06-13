-- Example 03: EXISTS (correlated subquery)
--
-- Business question:
--   "Show me users who have at least one 'serious' conversation going --
--    where they kicked off a match (as user_a) that has racked up 50+
--    messages."
--
-- Why this query:
--   `EXISTS (SELECT 1 FROM ... WHERE m.user_a_id = u.user_id ...)` checks,
--   for each candidate row in `users u`, whether ANY row in `matches`
--   satisfies the condition. The inner query is CORRELATED -- it
--   references `u.user_id` from the outer query.
--
--   We don't care WHAT the inner query returns (hence `SELECT 1`); we
--   only care WHETHER it returns at least one row. EXISTS short-circuits
--   on the first hit, which makes it efficient for "does any matching
--   row exist?" questions.
--
--   Compared to `IN (subquery)`, EXISTS is more flexible: you can
--   reference multiple columns from the outer table inside the WHERE.
SELECT user_id, username, city
FROM users u
WHERE EXISTS (
    SELECT 1
    FROM matches m
    WHERE m.user_a_id = u.user_id
      AND m.message_count >= 50
);
