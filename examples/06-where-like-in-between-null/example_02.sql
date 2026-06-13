-- Example 02: LIKE with the `_` wildcard
--
-- Business question:
--   "Find titles whose first word is exactly three letters and ends
--    in 'he' -- I want patterns like 'The ...' AND 'She ...', not just
--    one specific word."
--
-- Why this query:
--   `LIKE` has two wildcards: `%` matches any number of characters,
--   while `_` (underscore) matches EXACTLY ONE character. So `'_he %'`
--   means "any single char, then `he`, then a space, then anything".
--   That hits both "The Dark Knight" and "She Said" -- compare against
--   Example 01, where `'The %'` only matched titles starting with the
--   literal word "The". `_` is precise where `%` is greedy.
SELECT showtime_id, movie_title, theater, start_time
FROM showtimes
WHERE movie_title LIKE '_he %'
ORDER BY movie_title;
