-- Example 02: WHERE A OR B
--
-- Business question:
--   "A guest is flexible: they'd be happy with EITHER an ocean view OR
--    any suite (because suites are nice regardless of view). Show me
--    every room that fits at least one of those two preferences."
--
-- Why this query:
--   `OR` keeps rows where AT LEAST ONE of the two conditions is true.
--   A room qualifies if it has an ocean view, or if it's a suite, or
--   both. This is the natural fit when the guest gives you alternative
--   acceptable options instead of a strict checklist.
SELECT room_id, room_type, view, nightly_rate, floor
FROM hotel_rooms
WHERE view = 'ocean'
   OR room_type = 'suite';
