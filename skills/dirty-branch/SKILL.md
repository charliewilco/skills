---
name: clean-branch
description: Inspect a dirty git branch, report its state in a structured way, infer the intent behind the changes, flag risky hunks, and split the work into a clean series of Conventional Commits. Use whenever the user asks to clean up a branch, untangle WIP, split a messy commit, organize uncommitted changes, "make this into proper commits", review what's changed before committing, or says things like "my branch is a mess" / "what's going on in this branch" / "help me commit this properly". Trigger this even if the user just asks "what have I changed?" in a git context — the reporting half of this skill is useful on its own.
---

# Clean Branch

Turn a dirty, uncommitted working tree into a clean series of Conventional Commits — with a clear report of what's there, why it's probably there, and what's risky about it, before anything is written.

## When to use

- "Clean up this branch" / "my branch is a mess" / "split this into commits"
- "What have I changed?" / "review this diff before I commit"
- "Turn this WIP into proper commits"
- Any request involving `git add`, `git commit`, or branch hygiene where the working tree is dirty

## Workflow

Follow these phases in order. Do not skip ahead — the report must be presented to the user **before** anything is staged or committed.

### Phase 1: Inspect

Gather state without modifying anything. Run these in order:

```bash
git rev-parse --abbrev-ref HEAD       # current branch
git rev-parse --abbrev-ref --symbolic-full-name @{upstream} 2>/dev/null || echo "(no upstream)"
git status --porcelain=v1             # machine-readable status
git diff --stat                       # tracked unstaged
git diff --cached --stat              # staged
git diff                              # full unstaged diff
git diff --cached                     # full staged diff
git log --oneline -10                 # recent history for context
git ls-files --others --exclude-standard  # untracked files
```

Abort and ask the user what to do if any of these are true:

- Current branch is `main`, `master`, `develop`, `trunk`, or `release/*`
- `git status` shows an in-progress merge, rebase, cherry-pick, or bisect (look for `.git/MERGE_HEAD`, `.git/rebase-merge/`, etc.)
- The working tree is clean (nothing to do)

### Phase 2: Report

Present a structured report. Use this exact shape so it's scannable:

```
## Branch state

- Branch: <name> (tracking <upstream> or "no upstream")
- Ahead/behind: <N ahead, M behind> or "n/a"
- Dirty files: <count staged>, <count unstaged>, <count untracked>

## Diffstat

<output of git diff --stat and --cached --stat, combined and deduped>

## Likely intent

<1–3 short paragraphs. Group changes by apparent purpose.
Read the actual diff content — don't just infer from filenames.
Example: "Looks like two unrelated threads: (1) a new `/healthz` endpoint
in cmd/api with matching tests, and (2) a drive-by refactor of logger.go
that changes the signature of Log.Error across 6 callers."
Be honest when you can't tell — say "unclear" rather than guessing.>

## Risky changes

<Flag anything in this list. If none, say "None detected."
- Secrets: API keys, tokens, passwords, private keys, .env files with values
- Large files: >1MB, binary blobs, anything that should probably be in .gitignore
- Deletions: files or large blocks removed, especially tests
- Config: changes to CI, build, Dockerfile, package manifests with version bumps
- Dependencies: lockfile changes, new packages
- Generated code: anything that looks like build output (dist/, build/, *.pb.go)>

## Proposed commits

<Numbered list. Each entry:
N. <type>(<scope>): <subject>
   - files: <list>
   - why: <1 sentence>

Use Conventional Commits types: feat, fix, refactor, chore, docs, test,
style, perf, build, ci. Scope is optional but encouraged.
Keep subjects under 72 chars, imperative mood, no trailing period.>
```

Then stop and ask: **"Want me to proceed with this commit plan, adjust it, or just leave the report?"**

### Phase 3: Split (only on explicit approval)

Only proceed if the user says yes / approves / edits the plan. "Looks good" counts; silence does not.

Before the first commit:

```bash
# Backup ref so the user can recover if anything goes wrong
BACKUP="refs/backup/$(git rev-parse --abbrev-ref HEAD)-$(date +%Y%m%d-%H%M%S)"
git update-ref "$BACKUP" HEAD
echo "Backup saved at $BACKUP (restore with: git reset --hard $BACKUP)"
```

Then for each proposed commit:

1. Reset the index so nothing is pre-staged: `git reset` (keeps working tree, clears index)
2. Stage just the files/hunks for this commit:
   - Whole files: `git add -- <path>...`
   - Partial files: `git add -p -- <path>` and interactively select hunks. If running non-interactively, use `git apply --cached` with a crafted patch instead (see `scripts/stage_hunks.sh` for the pattern).
3. Show what's about to be committed: `git diff --cached --stat`
4. Commit: `git commit -m "<type>(<scope>): <subject>" -m "<body if needed>"`
5. Announce: "Commit N/total done: <hash> <subject>"

**Untracked files**: never `git add` them unless the user's approval explicitly included them. Mention them in the report and ask.

**If staging fails** (e.g. a hunk conflicts with another proposed commit): stop, explain what happened, and ask the user how to proceed. Do not keep going and do not try to "fix" it silently.

### Phase 4: Show the log

After all commits land:

```bash
git log --oneline -<N+2>   # where N = commits just made
git status                  # prove the tree is clean (or show what's left)
```

Then a one-line summary: "Made N commits on <branch>. Backup at <ref>. Tree is clean." (or "<X files still uncommitted — <reason>>").

## Rules

- **Never** force-push, rebase, amend existing commits, or touch any branch other than the current one.
- **Never** commit on `main`, `master`, `develop`, `trunk`, or `release/*` — stop and ask.
- **Never** commit untracked files without explicit approval for those specific files.
- **Never** skip the report. Even if the user says "just commit everything", show the report first — it's fast and it's the whole point.
- **Never** invent a commit message subject that isn't supported by the actual diff. If intent is unclear, say so and ask.
- **Always** create the backup ref before the first commit.
- **Always** use Conventional Commits format: `<type>(<optional-scope>): <subject>`.
- **Always** surface secrets before committing. If a potential secret is detected, **stop** and ask — do not commit it, even if it's in the proposed plan.

## Notes on inferring intent

You have the full diff — use it. Read function names, imports, test names, comment changes. A good intent inference looks like:

> "Two threads here. The changes in `internal/auth/` add a new `RefreshToken` method with tests — looks like a feature. The changes in `pkg/logger/` are unrelated: they rename `Log.Err` to `Log.Error` across the codebase, which is a refactor. I'd split these."

A bad intent inference looks like:

> "Various changes across multiple files."

When you genuinely can't tell, name the files and ask.
