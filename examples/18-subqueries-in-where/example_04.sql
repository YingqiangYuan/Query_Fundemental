-- Example 04: NOT EXISTS -- the NULL-safe alternative to NOT IN
--
-- Business question:
--   Same as example_02.sql -- "which users have never been anyone's
--   user_b?" -- but written correctly this time.
--
-- Why this query:
--   `NOT EXISTS (SELECT 1 FROM matches m WHERE m.user_b_id = u.user_id)`
--   asks, per outer row: "is there NO match row whose user_b_id equals
--   this user_id?" Critically, the equality comparison `m.user_b_id =
--   u.user_id` simply does NOT match when m.user_b_id IS NULL -- those
--   NULL rows are silently skipped, not promoted to UNKNOWN-poisoning
--   the whole result like NOT IN did.
--
--   So NOT EXISTS returns the correct four wallflower users (10, 14,
--   22, 30) where NOT IN returned zero rows. As a rule of thumb: prefer
--   NOT EXISTS over NOT IN whenever the inner column could be NULL.
SELECT user_id, username
FROM users u
WHERE NOT EXISTS (
    SELECT 1
    FROM matches m
    WHERE m.user_b_id = u.user_id
);
