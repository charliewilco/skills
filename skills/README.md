# Skills

## Installed In This Repo

- `clean-branch`: conservative dirty branch inspection and commit planning.
- `git-maid`: autonomous dirty tree commit organization.
- `ios-preflight`: lightweight Apple-platform repo readiness checks.
- `issue-batch-planner`: dependency-aware issue and milestone planning.
- `migration-playbook`: staged migration planning with parity and rollback gates.
- `openapi-parity`: API contract drift and generated-client risk audit.
- `quality-gates-audit`: local and CI quality gate audit.

## Recommended Additions

- `burton-pr-validate-merge`: refresh, validate, comment, and merge Burton PRs only after live GitHub state and local proof are current.
- `burton-next-fix-pr`: create narrow Burton fix branches from `origin/next`, validate, and open PRs back to `next`.
- `burton-stacked-slice-pr`: publish only the newest slice of an existing Burton branch onto a parent branch.
- `ios-named-device-validation`: repeatable XcodeBuildMCP validation against a named simulator with fallback handling.
- `ios-physical-device-run`: build, install, and launch on a named real device such as Monolith IV, separating app, signing, CoreDevice, and device-state failures.
- `reviewer-provider-live-proof`: enforce the difference between local mocks and real provider OAuth/workspace smoke tests.
- `reviewer-voice-capture`: protect the voice-first issue capture workflow and validate local capture UX before provider publishing.
- `xcode-churn-classifier`: classify Xcode-created project/user-state file changes before ignore or cleanup decisions.
- `developer-storage-cleanup`: measure and safely clear regenerable Xcode, simulator, worktree, and build artifacts.
- `codex-state-backup`: preserve Codex sessions, memories, plugins, config, and task workspaces before machine resets or migrations.
