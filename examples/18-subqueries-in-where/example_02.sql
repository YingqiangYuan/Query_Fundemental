-- Example 02: NOT IN (subquery) -- the NULL gotcha
--
-- Business question:
--   "Which users have NEVER been on the receiving end of a match? I.e.,
--    no one has ever matched-to them as user_b. Show me the wallflowers."
--
-- Why this query (and why it's BROKEN):
--   The natural translation is: user_id NOT IN (list of all user_b_id
--   values). We expect to see users 10, 14, 22, and 30 -- they really
--   are never anyone's user_b.
--
--   But run this and you get ZERO rows. That's the famous NOT IN + NULL
--   gotcha. The `matches` table has a few rows where `user_b_id IS NULL`
--   (pending one-sided invites). When `NOT IN` sees a NULL in the list,
--   SQL three-valued logic turns every comparison into UNKNOWN, which
--   is not TRUE -- so every row is filtered out.
--
--   The fix is in example_04.sql (NOT EXISTS), which is NULL-safe.
SELECT user_id, username
FROM users
WHERE user_id NOT IN (
    SELECT user_b_id
    FROM matches
);
