# Git Maid

## Purpose

Git Maid turns a dirty Git working tree into a clean sequence of logical commits.

Use this skill when the current branch contains uncommitted work that may include modified files, deleted files, new files, partial work, refactors, fixes, experiments, tests, config changes, or unrelated changes mixed together.

The goal is not to change the product. The goal is to recover the intent of the working tree and organize it into a reviewable commit stack.

## When to Use

Use this skill when the user says things like:

- "clean up this branch"
- "carve this dirty branch into commits"
- "turn this working tree into commits"
- "organize my uncommitted changes"
- "split this branch into logical commits"
- "git maid this branch"
- "I came back to an old branch and it is dirty"

## Core Behavior

Operate autonomously.

Do not ask the user to approve each commit.

Inspect the working tree, infer the intent of the changes, stage related hunks/files together, create logical commits, run obvious validation, and then report what happened.

## Procedure

### 1. Inspect the repository

Run:

```sh
git status --short
git diff
git diff --staged
git log --oneline -20
````

Also inspect untracked files, deleted files, renamed files, lockfiles, generated files, and config changes.

### 2. Classify the changes

Group changes by concern:

* feature work
* bug fixes
* refactors
* tests
* documentation
* build/config/tooling
* dependency or lockfile changes
* generated files
* incomplete/WIP work
* accidental/local-only files

Prefer preserving the story of the work over creating a perfectly aesthetic commit history.

### 3. Create commits directly

Create commits without waiting for approval.

Use `git add -p` when a file contains multiple unrelated changes.

Use `git add <file>` when the entire file clearly belongs to one commit.

Prefer multiple small, coherent commits over one large commit.

Keep pure refactors separate from behavior changes when possible.

Keep tests near the behavior they validate.

Keep dependency, generated, and lockfile changes separate unless they are inseparable from the feature.

Put incomplete or uncertain work into a clearly labeled WIP commit rather than mixing it into finished work.

### 4. Protect risky files

Do not commit obvious secrets or local machine state.

Leave these uncommitted unless they are clearly intended examples/templates:

* `.env`
* credentials
* tokens
* certificates
* private keys
* local editor settings
* machine-specific config
* build artifacts
* caches
* dependency directories such as `node_modules`

If a risky file appears important, leave it uncommitted and mention it in the final report.

### 5. Stop conditions

Stop and report instead of committing when:

* merge conflict markers are present
* the repository appears corrupted
* committing would likely destroy work
* there are obvious secrets mixed into required files
* the branch is in the middle of an unfinished rebase, merge, cherry-pick, or bisect

Do not discard work.

Do not reset the branch.

Do not run destructive Git commands.

Do not delete untracked files unless they are obviously generated junk, and explain that decision.

### 6. Commit messages

Use concise imperative commit messages.

Good examples:

```text
Add timeline loading state
Fix empty feed rendering
Refactor profile repository
Update API response models
Add tests for notification parsing
Separate workflow scheduling logic
Capture remaining WIP changes
```

Avoid vague messages like:

```text
Updates
Changes
Fix stuff
More work
Cleanup
```

### 7. Validation

After committing, run the most obvious available checks.

Look for commands in:

* README
* package scripts
* Makefile
* justfile
* Taskfile
* CI config
* project files

Run relevant checks such as:

```sh
npm test
npm run lint
npm run typecheck
swift test
xcodebuild test
go test ./...
cargo test
```

Do not invent an elaborate validation process if the repo does not make one obvious.

If checks fail, report the failure clearly.

Do not hide failures.

### 8. Final Report

End with a concise report:

* commits created, in order
* commit hash and message for each
* short explanation of what each commit contains
* checks/tests run and results
* files left uncommitted and why
* risks or follow-up work

## User-Facing Summary Template

```text
Git Maid finished.

Created commits:

1. <hash> <message>
   - <what changed>

2. <hash> <message>
   - <what changed>

Checks run:
- <command>: <result>

Left uncommitted:
- <file>: <reason>

Risks / follow-up:
- <item>
```




