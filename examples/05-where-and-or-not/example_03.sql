-- Example 03: WHERE NOT A
--
-- Business question:
--   "Some guests don't like courtyard-facing rooms -- they want anything
--    BUT a courtyard view. What do we have for them?"
--
-- Why this query:
--   `NOT` inverts the truth value of the condition it sits in front of.
--   `NOT view = 'courtyard'` keeps every room whose view is NOT a
--   courtyard (so city + ocean rooms come back). It is equivalent to
--   `view != 'courtyard'`; both are common, and `NOT` shines when the
--   condition you want to flip is more complex than a single equality.
SELECT room_id, room_type, view, nightly_rate, floor
FROM hotel_rooms
WHERE NOT view = 'courtyard';
