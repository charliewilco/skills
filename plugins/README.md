# Plugins

## Enabled In Current Installation

- `github@openai-curated`
- `documents@openai-primary-runtime`
- `spreadsheets@openai-primary-runtime`
- `presentations@openai-primary-runtime`
- `build-ios-apps@openai-curated`
- `build-macos-apps@openai-curated`
- `codex-security@openai-curated`
- `cloudflare@openai-curated`
- `openai-developers@openai-curated`
- `pdf@openai-primary-runtime`
- `computer-use@openai-bundled`
- `record-and-replay@openai-bundled`
- `template-creator@openai-primary-runtime`
- `sites@openai-bundled`
- `visualize@openai-bundled`
- `browser@openai-bundled`

## Disabled Or Historical

- `vercel@openai-curated`
- `expo@openai-curated`

## High-Value Missing Connectors To Consider

- Linear: useful if product issue tracking moves there or if validated security/product findings should become tracked issues.
- Sentry: useful for Burton, Reviewer, Meramon, or downwrite production crash/error triage.
- Slack: useful only if operational alerts and PR/status pings actually live there.
- Google Calendar or Outlook Calendar: useful for reminders and planning, not core build work.
- Figma: useful only if design source-of-truth moves out of Sketch or screenshots.

Do not install broad connectors just because they exist. Prefer plugins that turn repeated manual proof loops into inspectable evidence.
