# learn_sql_query_basic — Master SQL Query Fundamentals

A **SELECT-only** SQL course delivered as 23 self-contained mini-projects. Each lesson uses a different industry (bookstore, café, vet clinic, ride-share, soccer league, city weather…) and ships its own pre-generated `db.sqlite`. By the end you go from "I can write `SELECT *`" to "I can read window functions". No writes, no DDL, no performance tuning — the scope is deliberately narrow so the one thing it teaches, it teaches deeply.

## What is "learn-this-project" — the methodology in 30 seconds

This is a learn-this-project repo: a small, deliberately-scoped codebase that teaches one vertical skill end-to-end. The point isn't to ship the code — it's to **absorb** the skill by running it, reading it, being able to defend every design choice, and finishing with a portfolio version on your own GitHub.

Six interactive skills make up the process:

- **`/learn-this-project-absorb`** — on-call mentor for the repo. Multi-mode: **Orient** (gives you the map + a `files to READ` vs `files to RUN/DO` split), **Context-dive** (you bring a `file:line`, it unpacks that spot), **Next-step**, **Build** (helps you extend the repo). It's a mentor, not a curriculum — use it when you need help, not as something to sit through linearly.
- **`/learn-this-project-quiz`** — discussion-style Q&A. Each answer is scored against the 3-part standard: **where to look + what + why**. A factually correct one-liner doesn't pass. Two modes: a pre-written bank (lower-bound coverage) and open-ended (you name a topic, it generates fresh questions).
- **`/learn-this-project-elevate`** — what's beyond this repo's current state. For each upgrade direction it walks current state → senior target → alternatives → prerequisite knowledge, and **converges into a concrete starter deliverable** you can hand back to Absorb Build mode to actually build.
- **`/learn-this-project-interview`** — full-project mock interview with pushback. Tests whether you can defend the work to a stranger.
- **`/learn-this-project-demo`** — script your live walk-through; the highest-value part is the "don't show teaching artifacts" cardinal-rule list.
- **`/learn-this-project-publish`** — convert this teaching repo into a portfolio version on your own GitHub. Deletes teaching artifacts, generates a commit cheat-sheet for you to copy-paste, co-writes your README in your own voice, finishes with a hostile-scan audit.

**Recommended order: absorb → quiz → elevate → interview → demo → publish.** But remember, these skills are mentors on call — invoke when you need orientation, context, or help. Don't treat them as a linear curriculum to check off.

## What's in this repo

```
.
├── examples/
│   ├── README.md              ← course index (22 lessons)
│   ├── 01-sharpen-your-tools/ ← Lesson 01: DBeaver + SQLite onboarding (unique shape)
│   ├── 02-select-basics/      ← Lesson 02: SELECT basics (bookstore inventory)
│   ├── 03-select-columns-and-aliases/  ← projection + AS aliases (café menu)
│   ├── ...                    ← lessons 04-21, each a new industry + a new SQL topic
│   ├── 22-window-functions-ranking/    ← Lesson 22: window functions, ranking (soccer)
│   ├── 23-window-functions-aggregates/ ← Lesson 23: window functions, aggregates (weather)
│   └── check_examples.py      ← batch self-test: runs every .sql against its db.sqlite
├── learn_sql_query_basic/
│   └── csv_to_sqlite.py       ← shared loader: CSV → SQLite (97 lines)
├── docs/learn-this-project/   ← knowledge base the 6 interactive skills read (7 docs)
├── mise.toml                  ← toolchain: Python 3.12 + uv
└── pyproject.toml             ← deps: polars + SQLAlchemy 2.x
```

Every `examples/NN-<topic>/` folder is self-contained: `README.md` + `README-cn.md` (bilingual), `data/NN_<table>.csv` (CSV seeds prefixed with `NN_` to control FK load order), **a pre-generated `db.sqlite` committed to git** (so you can open DBeaver and query immediately, no Python required), a 5-line `gen_db.py` (rebuilds the DB from CSVs if anything corrupts), and 3-6 `example_NN.sql` teaching queries. Every SQL file opens with two comment blocks: **"Business question"** (what real-world question this query answers) and **"Why this query"** (the principle the SQL embodies) — that pair of comments is the course's pedagogical signature.

## Tech stack + setup

| Tool | Version | Purpose |
| :--- | :------ | :------ |
| `mise` | latest | Toolchain manager; pins Python + uv + project tasks |
| Python | 3.12 | Pinned in `mise.toml` |
| `uv` | latest | Package manager |
| polars | `>=1.40.1,<2.0.0` | CSV reading + dtype inference |
| SQLAlchemy | `>=2.0.33,<2.1.0` | Core-layer table construction + bulk insert |
| DBeaver Community (or `sqlite3` CLI) | any recent | The learner-facing SQL editor |

From the repo root:

```bash
mise install          # one-time: pin versions per mise.toml
mise run venv-create  # = uv venv (creates .venv/)
mise run inst         # = uv sync --all-extras
```

Then any time:

```bash
python examples/check_examples.py    # batch-verify every teaching SQL still runs
```

Open any lesson's `db.sqlite` directly in DBeaver (or `sqlite3 examples/02-select-basics/db.sqlite`) and start querying — **you don't need to run Python before you can write SQL.**

## Recommended learning flow

| Skill | One-line how-to |
| :---- | :-------------- |
| `/learn-this-project-absorb` | **Orient** for the map → **Context-dive** with a `file:line` for a specific spot → **Build** when you want to extend |
| `/learn-this-project-quiz` | Bank mode for a 10-question floor; open-ended for topics where you came up shallow; grade yourself on "where + what + why" |
| `/learn-this-project-elevate` | Pick 1-2 upgrade directions (e.g. "add pytest snapshot tests", "add a Postgres CI lane") and converge each to a concrete first deliverable |
| `/learn-this-project-interview` | Run one full mock; treat the 3 weak-spot questions in the debrief as a study list |
| `/learn-this-project-demo` | Rehearse the 5-min version; memorize the "do NOT show" list (24 `README-cn.md` files, `docs/learn-this-project/`, the 5 sibling skills) |
| `/learn-this-project-publish` | Transform: new repo name → delete teaching artifacts → generate commit cheat-sheet → co-write your README → final Audit |

> **If you took an earlier learn-this-project course**: absorb is now multi-mode (not linear), quiz scores against a 3-part standard (not 80% pass rate), elevate now converges to a concrete starter deliverable, and publish is a new sixth skill. The descriptions above reflect the current behavior.

## Turn this into your own portfolio

When you're done, use `/learn-this-project-publish` to **convert this teaching repo into a portfolio version on your own GitHub**. The cardinal rule: **a hostile reader must not be able to tell this came from a tutorial**. The publish skill handles it for you:

- Deletes every "this is teaching material" file (24 `README-cn.md` files, `docs/learn-this-project/`, the 5 sibling skills, etc. — keeps `lesson-smith-learn-this-project-meta` as a deliberate "show your method" bonus);
- Generates `tmp/publish-commit-plan.md` — a dependency-ordered 10-15+ commit cheat-sheet you copy-paste into `git add / git commit` yourself; **the skill never runs git**;
- Co-writes your English `README.md` in D-mode — it asks the prompts, you answer, it drafts the section, you edit; **it does not invent insight you didn't supply**;
- Finishes with an Audit pass (hostile scan). Zero 🔴 HIGH RISK findings means safe to publish.

The whole process happens on your local machine. You create the new GitHub repo and `git push` yourself — that "publishing" act stays in your hands.

## What mastery looks like

By the end of this course you should be able to: translate plain-English business questions ("which category has the highest repeat-purchase rate?", "how many trips did each driver run this month?") into a SELECT; explain why each lesson chose its specific industry, table shape, and SQL pattern; type out `GROUP BY ... HAVING ...`, every JOIN flavor, subqueries, CTEs, and window functions in DBeaver without looking; articulate what this course **does not** teach (writes, schema design, indexes, dialect differences) and what you'd study next. And you should have a clean, publishable GitHub repo with **your** version of the work — not the tutorial's.
