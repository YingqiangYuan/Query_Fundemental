-- Example 01: IN (subquery)
--
-- Business question:
--   "Which users have ever matched with someone who lives in New York?
--    I want to know who's been mixing with the NYC crowd."
--
-- Why this query:
--   We need a list that depends on TWO conditions chained together:
--     1. "users in New York" -- a set produced by an inner SELECT.
--     2. "matches whose user_b_id is in that set" -- another inner SELECT.
--     3. "users whose user_id is in those matches' user_a_id" -- the outer.
--   `WHERE col IN (SELECT ...)` lets us plug a query's result list straight
--   into a filter -- no JOIN required. Nesting two of them reads almost
--   like the English sentence: matched with (someone in (New York)).
SELECT user_id, username, city
FROM users
WHERE user_id IN (
    SELECT user_a_id
    FROM matches
    WHERE user_b_id IN (
        SELECT user_id
        FROM users
        WHERE city = 'New York'
    )
);
