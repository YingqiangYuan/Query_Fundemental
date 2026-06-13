-- Example 05: comparison against a scalar subquery
--
-- Business question:
--   "Which of our users are older than the average user on the platform?
--    Show them sorted oldest first."
--
-- Why this query:
--   `(SELECT AVG(age) FROM users)` is a SCALAR subquery -- it returns
--   exactly one value (one row, one column). That makes it usable on
--   the right-hand side of any comparison operator (`=`, `>`, `<`, ...)
--   just like a literal number.
--
--   The database evaluates the inner SELECT once, then plugs that single
--   number into the WHERE clause for every outer row. This pattern is
--   how you compare each row against a summary of the whole table
--   without hard-coding the threshold (which would go stale).
SELECT user_id, username, age
FROM users
WHERE age > (SELECT AVG(age) FROM users)
ORDER BY age DESC;
