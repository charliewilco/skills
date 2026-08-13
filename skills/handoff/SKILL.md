---
name: handoff
description: Write a compact handoff document so another agent can continue the work. Use when Charlie asks for a handoff, context transfer, summary for another task, or when a long thread needs a durable continuation point.
argument-hint: "<next-session-focus>"
disable-model-invocation: true
---

# Handoff

Create a handoff document that lets a fresh agent continue without rereading the whole thread.

## Location

Save outside the repo unless Charlie asks otherwise:

- macOS: `/tmp/<short-topic>-handoff.md`
- If a durable deliverable is requested in Codex, use the task `outputs/` directory.

## Include

- Current objective and next-session focus.
- Repo path, branch, base branch, PR URL, and dirty/clean status.
- Decisions made, with links to issues, PRs, files, docs, screenshots, or sources.
- Exact files changed or relevant paths.
- Commands run and their results.
- Proof level achieved: local deterministic, rendered UI, physical-device, live provider/service, deployed.
- Blockers, missing credentials, unavailable devices, failing checks, or user decisions needed.
- Suggested skills for the next agent.

## Do Not Include

- Secrets, tokens, auth URLs, private keys, credentials, or full sensitive payloads.
- Long pasted diffs or logs already available in files, commits, or PRs.
- Claims that were not verified.

Prefer links and exact paths over narrative. If the handoff depends on volatile state, say what must be refreshed first.
