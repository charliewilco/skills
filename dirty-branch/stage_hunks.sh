#!/usr/bin/env bash
# stage_hunks.sh — pattern for staging specific hunks without `git add -p` interactivity.
#
# Codex runs non-interactively, so `git add -p` (which prompts y/n/s per hunk) won't work.
# Instead, generate a patch, edit it to contain only the hunks you want, and apply it to
# the index with `git apply --cached`.
#
# Usage pattern (Codex should adapt this, not run it blindly):
#
#   # 1. Dump the full unstaged diff for a file
#   git diff -- path/to/file.go > /tmp/full.patch
#
#   # 2. Produce a reduced patch containing only the hunks for this commit.
#   #    Keep the file header (`diff --git ...`, `index ...`, `--- a/...`, `+++ b/...`)
#   #    and only the `@@ ... @@` hunks you want. Drop the others entirely.
#   #    Write the reduced patch to /tmp/commit-N.patch
#
#   # 3. Apply to index only (not the working tree)
#   git apply --cached /tmp/commit-N.patch
#
#   # 4. Verify
#   git diff --cached --stat
#
#   # 5. Commit
#   git commit -m "feat(api): add healthz endpoint"
#
#   # 6. The remaining hunks stay in the working tree for the next commit.
#
# Gotchas:
# - Line numbers in @@ headers must match the current state of the file. If you drop
#   earlier hunks, later hunks' line numbers are still valid because git apply --cached
#   applies against the index (which still matches HEAD for those regions).
# - If `git apply --cached` fails with "patch does not apply", the hunks likely depend
#   on each other. Fall back to: stage the whole file with `git add <file>`, then
#   `git reset HEAD -- <file>` and `git checkout -p` to unstage unwanted hunks, then
#   re-stage. Or just commit the file as a whole and tell the user why.
#
# This file is a reference, not an executable to run directly.

echo "This is a reference document. See comments for the hunk-staging pattern."
exit 1
