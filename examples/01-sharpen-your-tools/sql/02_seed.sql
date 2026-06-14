-- ============================================================
-- Forum Database Seed Data
-- ============================================================
-- 8 users, 12 posts, 30 replies. Topic: a small tech / coding
-- discussion forum. Dates are ISO 8601 strings so they sort
-- naturally as text.
-- ============================================================

-- ------------------------------------------------------------
-- users
-- ------------------------------------------------------------
INSERT INTO users (user_id, username, email, joined_at) VALUES
    (1, 'alice_dev',       'alice@example.com',   '2024-01-10'),
    (2, 'bob_smith',       'bob@example.com',     '2024-01-22'),
    (3, 'carol_codes',     'carol@example.com',   '2024-02-05'),
    (4, 'dan_data',        'dan@example.com',     '2024-02-18'),
    (5, 'eve_engineer',    'eve@example.com',     '2024-03-03'),
    (6, 'frank_fullstack', 'frank@example.com',   '2024-04-14'),
    (7, 'grace_guru',      'grace@example.com',   '2024-05-09'),
    (8, 'henry_hacker',    'henry@example.com',   '2024-06-21');

-- ------------------------------------------------------------
-- posts
-- ------------------------------------------------------------
INSERT INTO posts (post_id, author_id, title, body, created_at) VALUES
    (1, 1, 'Welcome to the forum!',
        'Hi everyone, this is a friendly place to ask coding questions and share what you are working on.',
        '2024-07-01 09:15:00'),
    (2, 2, 'What is the difference between WHERE and HAVING?',
        'I keep mixing them up. When should I use WHERE and when should I use HAVING in a SQL query?',
        '2024-07-03 14:22:00'),
    (3, 3, 'Best book for learning Python?',
        'Looking for a recommendation for a beginner-friendly Python book. Any suggestions?',
        '2024-07-05 10:40:00'),
    (4, 4, 'SQLite vs PostgreSQL for a side project',
        'I am building a small side project. Should I start with SQLite and migrate later, or just use PostgreSQL from day one?',
        '2024-07-08 19:05:00'),
    (5, 5, 'How do indexes actually work?',
        'I know indexes speed up queries, but I would like a clear mental model of how a B-tree index works under the hood.',
        '2024-07-12 08:30:00'),
    (6, 1, 'Sharing my first open source project',
        'After months of work I finally released a small CLI tool on GitHub. Would love feedback from the community!',
        '2024-07-15 16:45:00'),
    (7, 6, 'Best way to learn JOINs?',
        'INNER, LEFT, RIGHT, FULL ... I understand them one at a time but get lost when there are 4 tables joined together.',
        '2024-07-18 11:00:00'),
    (8, 7, 'Tabs or spaces?',
        'Yes, I am asking. Yes, I know what I am doing. Go.',
        '2024-07-20 21:11:00'),
    (9, 8, 'Why does my query take 30 seconds?',
        'A simple SELECT with two JOINs and a WHERE clause is suddenly very slow. The tables are not even that big. Where do I start debugging?',
        '2024-07-25 13:27:00'),
    (10, 4, 'When should I denormalize?',
        'My reports are getting slow because of all the joins. At what point is it OK to denormalize the schema?',
        '2024-08-02 09:00:00'),
    (11, 3, 'Favorite VS Code extensions for SQL?',
        'Share your favorite VS Code extensions for working with SQL files and databases.',
        '2024-08-09 17:50:00'),
    (12, 2, 'How do you write good commit messages?',
        'My team is trying to clean up our git history. Looking for practical tips, not just "follow conventional commits".',
        '2024-08-14 10:10:00');

-- ------------------------------------------------------------
-- replies (flat: each reply belongs to a post, never to another reply)
-- ------------------------------------------------------------
INSERT INTO replies (reply_id, post_id, author_id, body, created_at) VALUES
    -- replies to post 1 (Welcome)
    (1,  1, 2, 'Glad to be here. Looking forward to learning together!', '2024-07-01 10:02:00'),
    (2,  1, 3, 'Hello everyone, first time on a forum like this.',         '2024-07-01 11:18:00'),
    (3,  1, 5, 'Thanks for setting this up.',                               '2024-07-02 08:44:00'),

    -- replies to post 2 (WHERE vs HAVING)
    (4,  2, 1, 'Short version: WHERE filters rows before GROUP BY, HAVING filters groups after.', '2024-07-03 15:00:00'),
    (5,  2, 5, 'Adding to that: you cannot use aggregate functions like SUM() in WHERE, but you can in HAVING.', '2024-07-03 15:30:00'),
    (6,  2, 2, 'That finally clicks, thank you both!', '2024-07-03 16:05:00'),

    -- replies to post 3 (Python book)
    (7,  3, 6, 'Automate the Boring Stuff with Python is a classic.', '2024-07-05 11:15:00'),
    (8,  3, 7, 'Fluent Python once you are past the basics.',         '2024-07-05 12:00:00'),
    (9,  3, 4, 'I learned a lot from Python Crash Course.',           '2024-07-06 09:20:00'),

    -- replies to post 4 (SQLite vs PostgreSQL)
    (10, 4, 1, 'Start with SQLite, you can always migrate. Most apps never need more.', '2024-07-08 19:40:00'),
    (11, 4, 8, 'Disagree. If you might need concurrent writes, start with Postgres.',    '2024-07-09 08:11:00'),
    (12, 4, 5, 'Both are reasonable. Pick whichever you can actually ship with.',         '2024-07-09 10:05:00'),

    -- replies to post 5 (indexes)
    (13, 5, 7, 'Think of a B-tree as a sorted phone book with shortcut pages.', '2024-07-12 09:00:00'),
    (14, 5, 4, 'Use Mark Russinovich talks if you like deep dives.',             '2024-07-12 13:22:00'),

    -- replies to post 6 (first open source)
    (15, 6, 2, 'Congrats! Drop the link, I will take a look.', '2024-07-15 17:00:00'),
    (16, 6, 7, 'Nice work shipping. The README is the most important file, polish that first.', '2024-07-16 08:50:00'),

    -- replies to post 7 (JOINs)
    (17, 7, 1, 'Draw the tables on paper and connect them with arrows. It really helps.', '2024-07-18 11:45:00'),
    (18, 7, 5, 'Start with two tables, get that solid, then add one more at a time.',     '2024-07-18 14:10:00'),
    (19, 7, 3, 'A whiteboard saved my life when I was learning JOINs.',                    '2024-07-19 09:00:00'),

    -- replies to post 8 (tabs vs spaces)
    (20, 8, 1, 'Spaces.',  '2024-07-20 21:30:00'),
    (21, 8, 4, 'Tabs.',    '2024-07-20 22:00:00'),
    (22, 8, 8, 'Whatever your linter says.', '2024-07-21 07:15:00'),

    -- replies to post 9 (slow query)
    (23, 9, 5, 'Run EXPLAIN QUERY PLAN first. 9 times out of 10 it is a missing index.', '2024-07-25 14:00:00'),
    (24, 9, 1, 'Also check whether you are doing a function call on an indexed column in WHERE. That kills index usage.', '2024-07-25 15:30:00'),

    -- replies to post 10 (denormalize)
    (25, 10, 7, 'Denormalize only when you have measured the problem and a simpler fix did not work.', '2024-08-02 10:00:00'),
    (26, 10, 1, 'Materialized views are often a nice middle ground.',                                    '2024-08-02 11:30:00'),

    -- replies to post 11 (VS Code extensions)
    (27, 11, 6, 'SQLTools plus the SQLite driver is my daily setup.', '2024-08-09 18:30:00'),
    (28, 11, 8, 'I also like the "SQL Formatter" extension.',          '2024-08-10 09:00:00'),

    -- replies to post 12 (commit messages)
    (29, 12, 3, 'Write the why, not the what. The diff already shows the what.', '2024-08-14 11:00:00'),
    (30, 12, 5, 'Imperative mood: "Add", "Fix", "Refactor". Match the style of git itself.', '2024-08-14 13:45:00');
