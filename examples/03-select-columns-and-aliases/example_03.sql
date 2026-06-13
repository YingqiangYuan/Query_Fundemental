-- Example 03: Column aliases with AS
--
-- Business question:
--   "Marketing wants a cleaner export -- can you rename the columns so
--    they read 'Drink', 'Type', and 'USD Price' instead of the raw
--    database column names?"
--
-- Why this query:
--   `AS new_name` renames a column in the output. The underlying table
--   is untouched -- only the result header changes. Aliases are the
--   right tool whenever the raw column name is ugly, abbreviated, or
--   ambiguous to the person reading the result.
--   Double-quoted aliases let you include spaces and mixed case.
SELECT
    name     AS "Drink",
    category AS "Type",
    price    AS "USD Price"
FROM drinks;
