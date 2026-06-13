-- Example 01: SELECT specific columns (projection)
--
-- Business question:
--   "I'm putting together a printed menu -- I only need the drink name,
--    its category, and the price. Skip everything else."
--
-- Why this query:
--   Listing column names instead of `*` is called projection. You get
--   back only the columns you asked for, in the order you asked for
--   them. This is the most common shape of a real-world SELECT: pull
--   exactly what you need, nothing more.
SELECT name, category, price
FROM drinks;
