-- Example 01: LIKE with the `%` wildcard
--
-- Business question:
--   "Pull up every showtime where the movie title starts with the word
--    'The ' -- I want to see how many of our titles begin that way."
--
-- Why this query:
--   `LIKE` does pattern matching on text. The `%` wildcard matches any
--   sequence of characters (including zero characters). So `'The %'`
--   matches strings that begin with `The` followed by a space and then
--   anything at all -- "The Dark Knight", "The Lion King", etc.
--   We sort by title so the result is easy to scan.
SELECT showtime_id, movie_title, theater, start_time
FROM showtimes
WHERE movie_title LIKE 'The %'
ORDER BY movie_title;
