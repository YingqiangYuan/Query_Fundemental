-- ============================================================
-- Forum Database Schema
-- ============================================================
-- A tiny forum / message-board system.
--
-- Business rules:
--   * Many users can sign up.
--   * Each user can create many top-level posts.
--   * Each post can receive many replies from any user.
--   * Replies are flat: a reply cannot itself be replied to.
-- ============================================================

DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS users;

-- ------------------------------------------------------------
-- users
--   Forum members. Each member has a unique username and email.
-- ------------------------------------------------------------
CREATE TABLE users (
    user_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    username    TEXT    NOT NULL UNIQUE,
    email       TEXT    NOT NULL UNIQUE,
    joined_at   TEXT    NOT NULL    -- ISO 8601 date string, e.g. '2025-01-15'
);

-- ------------------------------------------------------------
-- posts
--   Top-level posts (threads). Each post is authored by one user.
-- ------------------------------------------------------------
CREATE TABLE posts (
    post_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    author_id   INTEGER NOT NULL,
    title       TEXT    NOT NULL,
    body        TEXT    NOT NULL,
    created_at  TEXT    NOT NULL,
    FOREIGN KEY (author_id) REFERENCES users(user_id)
);

-- ------------------------------------------------------------
-- replies
--   Replies attached directly to a post. Flat structure: a reply
--   cannot be replied to (no parent_reply_id column on purpose).
-- ------------------------------------------------------------
CREATE TABLE replies (
    reply_id    INTEGER PRIMARY KEY AUTOINCREMENT,
    post_id     INTEGER NOT NULL,
    author_id   INTEGER NOT NULL,
    body        TEXT    NOT NULL,
    created_at  TEXT    NOT NULL,
    FOREIGN KEY (post_id)   REFERENCES posts(post_id),
    FOREIGN KEY (author_id) REFERENCES users(user_id)
);
