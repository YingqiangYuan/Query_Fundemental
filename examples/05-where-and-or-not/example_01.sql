-- Example 01: WHERE A AND B
--
-- Business question:
--   "A guest wants a deluxe room with an ocean view -- which rooms in
--    our inventory match both of those at the same time?"
--
-- Why this query:
--   `AND` keeps only rows where BOTH conditions are true at the same
--   time. A row is filtered out the moment any one of the two sides
--   evaluates to false. Use `AND` when the guest's request is a list of
--   requirements that all have to be met together.
SELECT room_id, room_type, view, nightly_rate, floor
FROM hotel_rooms
WHERE room_type = 'deluxe'
  AND view = 'ocean';
