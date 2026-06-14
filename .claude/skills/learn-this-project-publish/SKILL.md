---
name: learn-this-project-publish
description: Convert the learn_sql_query_basic teaching repo into a publish-ready portfolio repo on the user's own GitHub. Walks through deleting teaching artifacts, generating a dependency-ordered commit cheat-sheet, co-writing a personal README in the user's voice, and finally running a hostile-scan audit to make sure nothing leaks the tutorial origin. Use when the user says "publish this", "put this on my GitHub", "make this look like my own project", "clean up before showing", "scan my repo for teaching leftovers", "audit my repo", or "show your work".
allowed-tools: Read Grep Glob Edit Write Bash(ls *) Bash(rm *) Bash(mv *) Bash(find *) Bash(pwd) Bash(cat *) Bash(git log *) Bash(git status *) Bash(git diff *) Bash(git tag *) Bash(git branch *)
argument-hint: [transform | audit | resume]
---

# learn-this-project-publish

You help the user turn this teaching repo into a **publish-ready portfolio piece** on their own GitHub. This skill is the long-term leverage step in the learn-this-project flow — every absorbed skill becomes a portfolio artifact, and a hostile reader must not be able to detect that the artifact came from a tutorial. The cardinal rule: **the published repo cannot read as teaching material**.

## What this skill does and does not do

This skill operates on local files. It deletes teaching artifacts, renames things, generates a commit cheat-sheet, and co-writes a personal README. **It never touches git** — the user does all `git add` / `git commit` / `git push` themselves using the cheat-sheet you generate. It also never creates a GitHub repository — that's the user's deliberate publication act.

## Knowledge sources

- Primary: `docs/learn-this-project/07-publish-checklist.md` — the project-specific cardinal-rule deletes, borderline list, commit-plan template, README co-write outline, and hostile-scan rules.
- Cross-reference: `docs/learn-this-project/06-demo-playbook.md` § "Do NOT show" — overlap with the cardinal-rule artifact list; treat them as consistent.
- Live source: read actual project files when generating the commit plan and when scanning in Audit mode. The filesystem is ground truth — the doc may be stale.

If `07-publish-checklist.md` is missing or looks stale (e.g., it references files that don't exist anymore), tell the user and suggest re-running `/lesson-smith-learn-this-project-meta refresh publish` before continuing.

## How to use this skill — three modes

| Mode          | Trigger                                                                                | What you do                                                                       |
| :------------ | :------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------- |
| **Transform** | First invocation, user wants to publish-ify this repo (default if unclear)             | Ask repo+student name → delete → rename → commit plan → README co-write → Audit   |
| **Audit**     | "Just check my repo" / "I already did the cleanup, scan for leaks" / end of Transform  | Hostile-scan; report HIGH/MEDIUM/LOW findings; offer to fix on user's pick        |
| **Resume**    | "Pick up where we left off" / user invokes mid-flow                                    | Infer state from filesystem; resume at the right step                             |

Detect the mode from the argument or the user's opening message. If unclear, default to Transform.

## Transform mode — the main path

### Step 1 — Intake (the first interaction, no exceptions)

Before doing anything else, ask the user for two things, **one at a time**:

1. **"What's the name of the new public repo you'll publish this to?"** Typical pattern: `<firstname>-<lastname>-<topic>-poc`. If they haven't decided, suggest 2–3 candidates based on the project name.
2. **"What's your name (or the byline you want)?"** This goes into commit-message tone and optionally into the README byline.

Store both. You'll use the repo name in the commit cheat-sheet's header and the student name when drafting first-person commit messages.

After intake, summarize: "Got it — `<repo name>` by `<student name>`. Let me start by removing the teaching artifacts."

### Step 2 — Delete cardinal-rule teaching artifacts

1. Read `07-publish-checklist.md` § 1 (cardinal-rule deletes).
2. For each entry, verify it exists in the current repo (use Read / `ls` / Glob). If an entry is a glob pattern (e.g., `**/README-cn.md`), expand it via Glob and list every actual match individually in the dry-run — do not collapse them into the pattern, since the user needs to see exactly what will be deleted.
3. Print a **dry-run preview** as one combined `ls`-style block, showing every file/directory that would be deleted. Example:

   ```
   The following will be deleted:

     README-cn.md
     README-ORIGINAL.md
     examples/README-cn.md
     examples/01-<topic>/README-cn.md
     examples/02-<topic>/README-cn.md
     docs/learn-this-project/
       ├── 01-knowhow-inventory.md
       ├── 02-runbook.md
       └── ...
     .claude/skills/learn-this-project-absorb/
     .claude/skills/learn-this-project-quiz/
     .claude/skills/learn-this-project-elevate/
     .claude/skills/learn-this-project-interview/
     .claude/skills/learn-this-project-demo/

   .claude/skills/lesson-smith-learn-this-project-meta/ will be KEPT (portfolio bonus).
   ```

4. Ask: "Proceed with deletion? (yes / no)". On yes, run `rm -rf` for each entry. On no, abort the Transform — explain that without these deletions the repo will fail Audit.

### Step 3 — Borderline review

1. Read `07-publish-checklist.md` § 2 (project-specific borderline).
2. For each entry, ask the user one focused question. Example: "`tmp/notes.md` — looks like local scratch notes. Keep or delete?"
3. On `delete`, run `rm`. On `keep`, leave it but flag for Audit's attention.
4. If the borderline list is `_(none found in this repo)_`, skip this step.

### Step 4 — Rename / string-replace (if applicable)

1. Grep the repo for the old project name (use the project's name from `pyproject.toml` / `package.json` / etc.).
2. For each hit, present a diff: "I'd change `<old>` to `<new repo name>` at `<file>:<line>`. OK?"
3. On consent, use Edit. Skip files where the rename doesn't make sense (e.g., changelog entries that should preserve history).
4. Also consider: if the package directory itself is named after the old project (`learn_this_project/` → maybe rename to match the new repo), confirm with user before `mv`.

### Step 5 — Generate commit cheat-sheet

1. Read `07-publish-checklist.md` § 3 (commit plan template). Cross-reference against the actual surviving files in the repo after Steps 2–4.
2. Build the commit plan — 10–15+ commits, dependency-ordered (least-dependent first). Typical shape:
   - C1: root config (`mise.toml`, `pyproject.toml`, `.gitignore`)
   - C2: empty package skeleton
   - C3: shared utilities
   - C4: on-ramp prose (e.g., `examples/README.md`)
   - C5–C(N–1): individual source files, one per commit
   - CN: hand-written `README.md`
3. **Ask the user before writing**: "Want me to write the commit cheat-sheet to `tmp/publish-commit-plan.md`? You'll copy-paste from it; I won't run any `git` commands."
4. On yes, write the file. Format as a numbered table:

   ```markdown
   # Commit plan for <new repo name>

   Run these in order. The skill does NOT run git — you do.

   ## C1 — Add mise + uv toolchain setup
   Files: mise.toml, pyproject.toml, .gitignore
   Rationale: root configuration; nothing depends on it but everything else builds on it.
   ```bash
   git add mise.toml pyproject.toml .gitignore
   git commit -m "Add mise + uv toolchain setup"
   ```

   ## C2 — Add empty package skeleton
   ...
   ```

   Include the exact `git add` and `git commit -m "..."` commands so the user can copy-paste. Suggest commit messages in **first-person past tense** ("Add ...", "Wire up ...", "Document ...") — not "chore:" or imperative.

### Step 6 — README co-write (English, D-mode — co-write)

1. Read `07-publish-checklist.md` § 4 (README outline + question prompts).
2. For each section in order (typically: Project description → Install & run → What I learned → What's next):
   - Print the section name and goal.
   - Ask the user the 2–4 prompts **one at a time**. Don't stack questions.
   - Listen to the user's answers. Take their actual words — don't paraphrase into your own voice yet.
   - Draft the section in ~50–120 words. The voice must reflect the user's answers — use their phrasing where you can, expand into complete sentences where they were terse, but **do not invent insight they didn't supply**.
   - Print the draft. Ask: "Does this sound like you? Want to edit any line, or move on?"
   - On `edit`: take their edits as ground truth. On `move on`: lock that section.
3. After all sections are locked, assemble the full README in this order: title (the new repo name as `# <Title Case>`) → sections in the order written → optional byline at the bottom.
4. Write the complete `README.md` to the repo root. Show the user the final file path and total word count.

**Voice guardrails during co-write**:
- Don't write "this tutorial taught me..." or "in this project we...". If the user accidentally uses those phrases, soften them ("I built this to..." instead of "we built this to...").
- Don't write "I learned a lot" — that's filler. Push for specifics.
- First-person, past tense for what was built; present tense for what the project is.

### Step 7 — Final auto-Audit

Once the README is written, transition into Audit mode automatically. Tell the user: "README done. Now let me run a hostile scan over the repo to catch anything that still leaks the tutorial origin."

Then proceed with the Audit flow (next section). After Audit completes:

- If 🔴 HIGH RISK findings remain and the user hasn't accepted them → Transform is **incomplete**. Tell the user what's left and offer to fix.
- If only 🟡 MEDIUM / 🔵 LOW findings remain → Transform is complete. Print a closing summary with next steps:

  ```
  Transform complete. Next:
  1. Create the public repo on GitHub: <new repo name>
  2. Open tmp/publish-commit-plan.md and run the commits one at a time
  3. git remote add origin <github-url>
  4. git push -u origin main
  ```

## Audit mode — hostile scanner

Assume the reader is a hostile interviewer scanning the repo with the question "did this come from a tutorial?". Find every tell. Be specific.

### Audit flow

1. Read `07-publish-checklist.md` § 5 (hostile-scan rules).
2. Run each rule category against the current repo:
   - **File-pattern flags**: Glob for the patterns. Report exact paths.
   - **README phrase flags**: Read `README.md` (and any other `*.md` at the repo root). Grep for the phrase set. Report exact lines.
   - **Commit-message phrase flags**: `git log --all --oneline` then `git log --all --format="%s%n%b"`. Grep for the same phrase set in subjects and bodies.
   - **Git ref flags**: `git tag --list` and `git branch --all`. Match against the suspicious-name patterns.
   - **Residual directory flags**: Glob `.claude/skills/learn-this-project-*` and confirm only `lesson-smith-learn-this-project-meta` survives (if at all).
   - **Hygiene flags**: Glob for `.idea/`, `__pycache__/`, `.venv/`, `*.egg-info/`, `.DS_Store`.
   - **Suspicious symmetry flags**: heuristic — look for identical comment banners across multiple files, identical docstring shapes, or other "obviously templated" patterns.
3. Group findings by severity:

   ```
   🔴 HIGH RISK (3 findings)
   - docs/learn-this-project/01-knowhow-inventory.md still present
     → Cardinal artifact. Run: rm -rf docs/learn-this-project/
   - README.md line 12: "in this tutorial we learn..."
     → Phrase signals tutorial origin. Suggest: "I built this to learn..."
   - .claude/skills/learn-this-project-quiz/ still present
     → Cardinal artifact. Run: rm -rf .claude/skills/learn-this-project-quiz/

   🟡 MEDIUM RISK (2 findings)
   - Commit "chore: add tutorial files" — message reads templated.
     → Suggest rebase + reword (or accept if you don't want to rewrite history).
   - Three source files use identical 8-line banner comments — looks templated.
     → Optional: vary the banner style or remove banners entirely.

   🔵 LOW RISK (1 finding)
   - .DS_Store committed.
     → Add to .gitignore and `git rm --cached .DS_Store`.
   ```

4. Ask: "Want me to fix any of these? Pick the ones you want me to apply (e.g. `1, 3` or `all HIGH`)." On the user's pick, apply the fix using the same consent-gated `rm` / `Edit` patterns from Transform. For findings that require git rewrites (commit messages, history), only generate the commands — don't run them.

### Audit honesty rule

If the repo passes (zero HIGH, near-zero MEDIUM), say so explicitly: "This repo passes hostile-scan. Safe to publish." If it doesn't, do not soften the finding count — a hostile reader won't soften theirs.

## Resume mode

When the user invokes with `resume`, infer the last completed step:

- `tmp/publish-commit-plan.md` exists → Steps 1–5 done, ask if README co-write is next.
- Teaching artifacts still present → Step 2 not done, restart at Step 2.
- `README.md` looks like the teaching version (long, with "this course" or similar) → Step 6 not done.
- Otherwise → ask the user where they stopped.

## Forbidden behaviors

- **Never run any mutating `git` command.** The skill's `allowed-tools` deliberately excludes them. Print commands for the user instead.
- **Never delete anything without printing a dry-run first and getting yes.** Even cardinal artifacts get the dry-run.
- **Never finalize Transform with cardinal-rule artifacts still present.** If the user refused to delete one, Transform cannot succeed — explain and stop.
- **Never invent README content the user didn't supply.** D-mode co-write means the user's words are the source; you draft from those words, not from the project's docs or your own ideas about what they should have said.
- **Never create a GitHub repo or push.** Those are deliberate user acts.
- **Never manipulate commit timestamps.** Real time only.
- **Never modify `.claude/skills/lesson-smith-learn-this-project-meta/`** even if asked — that one is allowed to stay (portfolio bonus per the cardinal-rule list).

## Handoff to siblings

- "I want to add a feature before I publish" → `/learn-this-project-absorb` in Build mode (then come back here when done).
- "I'm not sure I understand the project well enough to write the README" → `/learn-this-project-absorb` first, then come back.
- "I'm about to demo the published repo" → `/learn-this-project-demo` after publish completes.
