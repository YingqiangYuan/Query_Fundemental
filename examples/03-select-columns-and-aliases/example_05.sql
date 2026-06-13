-- Example 05: Same column twice with different aliases
--
-- Business question:
--   "On the price-tag sheet we want to show the price twice -- once
--    labelled 'menu_price' for the front of the tag and once labelled
--    'register_price' for the back. They're the same number today, but
--    the two labels keep the print template consistent."
--
-- Why this query:
--   Nothing stops you from listing the same column more than once in a
--   SELECT -- each occurrence is independent and can carry its own
--   alias. This pattern shows up whenever a downstream consumer
--   (report, spreadsheet, UI) expects the same value under multiple
--   names, or when you later want to compute two different
--   transformations of the same source column side by side.
SELECT
    name  AS drink_name,
    price AS menu_price,
    price AS register_price
FROM drinks;
