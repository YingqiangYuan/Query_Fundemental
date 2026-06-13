-- Example 06: IS NULL and IS NOT NULL
--
-- Business question:
--   "Two related questions:
--     1) Which showtimes have NO subtitle track listed?
--     2) Which ones DO have subtitles, and in what language?"
--
-- Why this query:
--   NULL means "no value recorded" -- it is NOT the empty string and
--   NOT zero. The big gotcha (Lesson 04 planted this): `WHERE col =
--   NULL` returns NOTHING, because NULL is never equal to anything,
--   not even itself.
--   The correct tests are `IS NULL` and `IS NOT NULL`. We run them
--   side by side so you can see both sets clearly. The first SELECT
--   returns rows whose `subtitle_lang` is missing (the showing is in
--   the original audio only); the second returns rows with a subtitle
--   language recorded.

-- Showtimes with NO subtitles listed
SELECT showtime_id, movie_title, language, subtitle_lang
FROM showtimes
WHERE subtitle_lang IS NULL
ORDER BY movie_title;

-- Showtimes that DO have subtitles
SELECT showtime_id, movie_title, language, subtitle_lang
FROM showtimes
WHERE subtitle_lang IS NOT NULL
ORDER BY subtitle_lang, movie_title;
