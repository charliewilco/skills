---
name: wait-what
description: Re-explain the last response when it did not land. Use when Charlie says "wait what", "what do you mean", "that doesn't make sense", or asks for a simpler re-pitch of confusing agent reasoning, code, Git state, validation, or product tradeoffs.
disable-model-invocation: true
---

# Wait What

Stop and re-pitch the last answer.

## Response Shape

1. Start with the concrete state: branch, file, command, failing check, PR, device, screenshot, or source of truth.
2. Say what happened in plain English.
3. Separate facts from inference.
4. Explain why it matters for the decision or next step.
5. Give the next action.

Use Charlie's product vocabulary when available: Burton, Passage/Reviewer, Meramon, Tome, downwrite, provider proof, seeded simulator, physical-device launch, dirty worktree, live OAuth, local deterministic proof.

## Style

- Be shorter than the original.
- Do not defend the earlier wording.
- Avoid abstract agent/process language unless that is the subject.
- If the confusion came from a hidden assumption, name it directly.
- If a command output matters, quote or summarize the key line.
