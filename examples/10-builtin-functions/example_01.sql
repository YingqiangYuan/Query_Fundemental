-- Example 01: String functions -- UPPER, LOWER, LENGTH, TRIM
--
-- Business question:
--   "Some of the member names in our checkout system came in with stray
--    spaces around them, and the casing is all over the place. Can you
--    show me each member's name cleaned up -- trimmed, in a consistent
--    uppercase form, in lowercase form, plus how long the raw name is
--    versus the trimmed version?"
--
-- Why this query:
--   `TRIM(member_name)` strips leading/trailing whitespace -- compare
--   `LENGTH(member_name)` to `LENGTH(TRIM(member_name))` and you'll see
--   which rows had stray spaces.
--   `UPPER(...)` and `LOWER(...)` normalize casing for display.
--   We sort by the raw length descending so the messy rows (extra spaces
--   or longer names) bubble to the top.
SELECT
    checkout_id,
    member_name                          AS raw_name,
    LENGTH(member_name)                  AS raw_len,
    TRIM(member_name)                    AS clean_name,
    LENGTH(TRIM(member_name))            AS clean_len,
    UPPER(TRIM(member_name))             AS shouty_name,
    LOWER(TRIM(member_name))             AS quiet_name
FROM checkouts
ORDER BY raw_len DESC, checkout_id
LIMIT 10;
