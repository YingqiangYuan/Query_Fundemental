-- Example 02: Reorder columns in the SELECT list
--
-- Business question:
--   "For the cashier-facing receipt template I want the price first,
--    then the size, then the drink name -- in that exact order."
--
-- Why this query:
--   The result column order matches the SELECT list order, not the
--   order the columns were defined in the table. Reordering costs
--   nothing and is purely a presentation choice -- handy when you're
--   feeding a report, spreadsheet, or UI that expects a specific layout.
SELECT price, size, name
FROM drinks;
