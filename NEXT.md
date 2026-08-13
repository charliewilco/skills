# What To Add Next

## Promote Existing Private Skills

These already exist as memory-derived workflows in this Codex installation and should be copied into `skills/` once reviewed for public/private details:

- `burton-pr-validate-merge`
- `burton-next-fix-pr`
- `burton-stacked-slice-pr`
- `ios-named-device-validation`
- `ios-physical-device-run`
- `tome-rc-pr-validation`

## Add Missing Skills

- `xcode-churn-classifier`: explain Xcode-created diffs, classify generated/user-state/project changes, and recommend ignores or cleanup.
- `reviewer-provider-live-proof`: require configured OAuth and real workspace/PR smoke tests for provider support claims.
- `reviewer-voice-capture`: preserve voice-first capture, local draft editing, file/line context, and deferred publish behavior.
- `developer-storage-cleanup`: measure disk usage and safely remove only confirmed regenerable developer artifacts.
- `codex-state-backup`: archive `~/.codex` and `~/Documents/Codex` before Mac resets or migration.
- `artifact-grounded-research`: force primary-source research and local artifact inspection before strategy or naming recommendations.

## Recently Added From Matt Pocock-Inspired Workflows

- `tdd`
- `wait-what`
- `wayfinder`
- `research`
- `grill-me`
- `handoff`

## Add Automation Definitions

Start with report-only, paused automations:

- Weekly Codex operating repo sync.
- Weekly Burton PR drift monitor.
- Weekday Reviewer provider proof monitor.
- Monthly developer storage audit.
- Weekly plugin inventory review.

## Add Plugin Manifests Only When Useful

Prefer small plugin notes or manifests for recurring external systems:

- Sentry for production crash/error triage.
- Linear for durable product/security finding tracking.
- Figma only if it becomes a real design source of truth.

Avoid adding connector inventories that do not map to recurring work.
