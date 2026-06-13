-- Example 02: String functions -- SUBSTR and REPLACE
--
-- Business question:
--   "I want to know which email providers our members use. For each
--    checkout, pull out just the domain part of the email (everything
--    after the '@'). And while you're at it, show me what each member's
--    email would look like if our library switched its default from
--    'gmail.com' to 'library.org'."
--
-- Why this query:
--   `INSTR(email, '@')` finds the position of the '@' character (1-based).
--   `SUBSTR(email, INSTR(email, '@') + 1)` slices from the character
--   right after '@' to the end -- that's the domain.
--   `REPLACE(email, 'gmail.com', 'library.org')` does a literal string
--   swap; rows that don't contain 'gmail.com' come back unchanged.
--   This is the everyday "extract part of a string / substitute part of
--   a string" pair you'll reach for constantly.
SELECT
    checkout_id,
    member_email,
    SUBSTR(member_email, INSTR(member_email, '@') + 1)        AS email_domain,
    REPLACE(member_email, 'gmail.com', 'library.org')         AS rebranded_email
FROM checkouts
ORDER BY email_domain, checkout_id
LIMIT 15;
