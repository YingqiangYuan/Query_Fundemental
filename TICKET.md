# TICKET: SQL Query Fundamentals — Learning Checklist

[Tutorial](https://github.com/easyscale-academy/learn_sql_query_basic-project/tree/01-Learn-This-Project/)

## Objective

Absorb the SELECT-only SQL course (23 lessons, one industry per lesson) deeply enough to translate plain-English business questions into queries, defend every design decision in the course, and ship a clean portfolio version of the repo on your own GitHub.

## Checklist

### Setup

- [X] Clone the repo and switch to the `01-Learn-This-Project` branch
- [X] Install mise, then run `mise install` from the repo root
- [X] Bootstrap the env: `mise run venv-create && mise run inst`
- [X] Verify the toolchain works: `python examples/check_examples.py` should print `OK` for every `example_*.sql` and exit `0`
- [X] Install DBeaver Community (or have `sqlite3` CLI ready) — `examples/01-sharpen-your-tools/README.md` walks the DBeaver setup if you've never done it
- [X] Open `examples/02-select-basics/db.sqlite` in DBeaver and run `SELECT * FROM books LIMIT 5;` — confirms the "DB committed to git → open immediately" path works

### Absorb (learn the content)

- [X] Run `/learn-this-project-absorb` in **Orient mode** for the high-level map and the explicit `files to READ` vs `files to RUN/DO` split
- [X] Work through every lesson on the run-list yourself — open the lesson's `db.sqlite` in DBeaver, browse the data, then run `example_01.sql` … `example_0N.sql` one at a time, reading the header comment first and predicting the result
- [X] Use `/learn-this-project-absorb` in **Context-dive mode** whenever a specific SQL line, a `csv_to_sqlite.py` mechanism, or a `check_examples.py` decision needs unpacking
- [X] Articulate **why every lesson uses a different industry** instead of one big shared dataset (forces you to re-encode the business question each time)
- [X] Articulate **why `db.sqlite` is pre-committed to git** rather than regenerated on first run (removes the "Python before SQL" friction for the learner)
- [X] Articulate **why the course is SELECT-only** and what it costs the learner (no schema design, no writes, no `EXPLAIN` literacy — and why the tradeoff is defensible for the target audience)
- [X] Walk through `learn_sql_query_basic/csv_to_sqlite.py` end-to-end — explain why the `NN_` CSV prefix matters, why `db_path.unlink()` is unconditional, and why SQLAlchemy Core was chosen over ORM
- [X] Read `examples/12-group-by/example_06.sql` and explain why it shows a *broken* GROUP BY in the comment block — this is the course's most distinctive teaching shape

### Quiz (verify understanding)

- [ ] Run `/learn-this-project-quiz` in **Bank mode** — clear a 10-question round with no ⚠️ partial or ❌ wrong scores
- [ ] Use **Open-ended mode** to drill 2-3 topics where you came up shallow (likely candidates: `csv_to_sqlite.py` design choices, the GROUP BY / HAVING boundary, the JOIN-family curriculum order)
- [ ] If anything keeps scoring ⚠️ partial, go back to the relevant lesson README or `01-knowhow-inventory.md` and re-quiz that tag

### Elevate (see what's beyond)

- [ ] Run `/learn-this-project-elevate` and explore at least 1-2 upgrade directions (good starting picks: **test depth** — snapshot-based result tests over `check_examples.py`'s parse-only check; **CI** — a GitHub Actions workflow; **cross-engine portability** — a Postgres or DuckDB lane)
- [ ] **Converge each chosen direction into a concrete starter deliverable** — e.g. "add `tests/test_examples.py` that snapshots every SQL's result rows via syrupy, parametrized over `examples/**/example_*.sql`"
- [ ] (Optional, high-value) Hand the deliverable to `/learn-this-project-absorb` in **Build mode** and actually build the first iteration end-to-end
- [ ] Note down the upgrade directions you'd pursue, defer, or skip — these become the bullets in your portfolio README's "What's next" section

### Interview (pressure-test yourself)

- [ ] Run `/learn-this-project-interview`, complete a full mock session — calibrate it to a mid-level data-analyst or backend-engineer screen
- [ ] Survive at least one pushback round per question (especially Round 3 alternatives — "why polars not pandas?", "why Core not ORM?", "why committed `db.sqlite` not regen-on-clone?")
- [ ] Review the debrief; for the 3 weak-spot questions, return to quiz / absorb and re-cover the gap before moving on

### Demo (learn to present)

- [ ] Run `/learn-this-project-demo` — pick your most likely real audience and rehearse at least the 5-minute version
- [ ] Walk through the **cardinal-rule "do NOT show" list** — at minimum you should know to hide `docs/learn-this-project/`, all 24 `README-cn.md` files, `README-ORIGINAL.md`, the 5 sibling skills, `.idea/`, `.venv/`, and `tmp/` during a live demo
- [ ] Practice the golden-path beats: open `examples/README.md` → open `examples/12-group-by/` folder → open `example_01.sql` (show the business-question + why headers) → run the SQL live in DBeaver

### Mastery Gate

- [ ] You can answer ~70% of quiz questions to the **3-part standard** (where + what + why), not just factually
- [ ] You can survive at least one pushback round per interview question without backing down or hand-waving
- [ ] You have a clear list of "what I'd study next" from the elevate session — concrete, named topics, not "more SQL"
- [ ] You can deliver the demo without notes and without exposing any cardinal-rule teaching artifact

### Publish (turn it into a portfolio artifact)

- [ ] Decide on a new public repo name — pattern: `<firstname>-<lastname>-sql-query-basics-poc` (or similar)
- [ ] Run `/learn-this-project-publish` in **Transform mode** — the skill walks you through:
  - [ ] Intake: new repo name + your name (used in commit-message tone and optional README byline)
  - [ ] Delete cardinal teaching artifacts — with dry-run preview before each `rm`, on your consent (skill performs the deletes; you don't manually `rm`)
  - [ ] Borderline review: keep-or-delete decisions on `.idea/`, `.venv/`, `CLAUDE.md`, the `lesson-smith-*` skill family, and the empty `tmp/`
  - [ ] String-rename `learn_sql_query_basic` → your new repo name where it appears in code/config
  - [ ] Generate `tmp/publish-commit-plan.md` — a 17-commit cheat-sheet ordered by dependency (toolchain → loader → harness → lesson 01 → lesson 02 → … → lesson 23 → course index → final README)
  - [ ] Co-write your English `README.md` in D-mode — section-by-section, your words, no fabricated insight
- [ ] Verify **Audit mode** returns **0 🔴 HIGH RISK findings** before publishing — if any cardinal artifact survived, fix before pushing
- [ ] Create the public GitHub repo yourself (the skill won't create the GitHub repo)
- [ ] Open `tmp/publish-commit-plan.md` and run the commits one at a time, copy-pasting each `git add` + `git commit` block
- [ ] `git remote add origin <github-url>` and `git push -u origin main`
