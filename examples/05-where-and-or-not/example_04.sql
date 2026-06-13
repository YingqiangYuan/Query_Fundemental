-- Example 04: WHERE A AND (B OR C) -- parentheses change the meaning
--
-- Business question:
--   "Find me a room with a balcony, AND the view has to be either ocean
--    or city (definitely not courtyard)."
--
-- Why this query:
--   When `AND` and `OR` mix in the same WHERE clause, `AND` binds
--   tighter than `OR`, so without parentheses the engine reads
--     has_balcony = 1 AND view = 'ocean' OR view = 'city'
--   as
--     (has_balcony = 1 AND view = 'ocean') OR view = 'city'
--   which would return EVERY city-view room, balcony or not -- wrong.
--   The parentheses around `(view = 'ocean' OR view = 'city')` force
--   the OR to be evaluated first, then combined with the balcony
--   requirement. Whenever you mix AND and OR, prefer to be explicit
--   with parentheses even if you think the precedence is on your side.
SELECT room_id, room_type, view, has_balcony, nightly_rate, floor
FROM hotel_rooms
WHERE has_balcony = 1
  AND (view = 'ocean' OR view = 'city');
