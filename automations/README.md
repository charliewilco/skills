# Automations

No active Codex automation files were found in this installation during the audit. Add these as Codex automations only after choosing which loops should run unattended.

## Good Candidates

1. Weekly Codex operating repo sync
   - Check `~/.codex/AGENTS.md`, installed skills, enabled plugins, and local memory-derived skill candidates against this repo.
   - Produce a diff-only report and do not auto-commit.

2. Weekly Burton PR drift monitor
   - Inspect open Burton PRs targeting `next`, `release`, or `main`.
   - Report stale base branches, failing required checks, unresolved review threads, and PRs ready for manual validation.

3. Weekday Reviewer provider proof monitor
   - Check whether GitHub, GitLab, Bitbucket, and Azure DevOps provider paths have current live proof.
   - Distinguish local mocks/builds from real OAuth plus workspace/PR smoke tests.

4. Monthly developer storage audit
   - Measure Xcode DerivedData, CoreSimulator, SwiftPM `.build`, Codex worktrees, and large plugin caches.
   - Recommend only confirmed regenerable cleanup unless Charlie explicitly authorizes simulator/device-state deletion.

5. Weekly quality gate drift scan
   - Run `quality-gates-audit` against active product repos and flag local/CI script drift.
   - Prioritize Burton, Reviewer, downwrite, Tome, Meramon, and charliewil.co.

6. Weekly plugin inventory review
   - Compare enabled plugins with actual recent work.
   - Suggest installing missing high-value connectors only when they support recurring workflows.

## Suggested Cadence

- Start with paused or suggested automations.
- Prefer report-only prompts first.
- Promote to active only after two useful manual runs.
- Keep notification policy to failed runs only for noisy maintenance loops.
