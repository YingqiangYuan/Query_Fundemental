-- Example 05: Combining 3+ conditions in one WHERE
--
-- Business question:
--   "A couple is booking a short stay. They want a room under $300 a
--    night, with an ocean view, a balcony, and that sleeps at least
--    two people. Which rooms qualify?"
--
-- Why this query:
--   Real-world filters rarely stop at two conditions. Chain as many
--   `AND`s as you need, one per requirement, and put each on its own
--   line for readability. Every row that comes back satisfies ALL four
--   conditions at once -- if a row fails any single check, it's gone.
--   Notice how naturally the SQL maps to the bullet list of
--   requirements: that's why splitting the conditions onto separate
--   lines pays off when the WHERE clause grows.
SELECT room_id, room_type, view, beds, max_occupancy, has_balcony, nightly_rate
FROM hotel_rooms
WHERE nightly_rate < 300
  AND view = 'ocean'
  AND has_balcony = 1
  AND max_occupancy >= 2;
