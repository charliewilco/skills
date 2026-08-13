---
name: grill-me
description: Interview Charlie to sharpen a plan, product decision, architecture direction, or ambiguous implementation before work starts. Use when the user asks to be grilled, wants critical questions, or has a large idea that needs decisions before execution.
disable-model-invocation: true
---

# Grill Me

Run a decision interview. The goal is not to slow work down; it is to prevent silent assumptions from becoming code, PRs, or product direction.

## Rules

- Ask only questions Charlie must answer. Research facts yourself.
- Ask in rounds. Each round contains the current decision frontier: questions whose prerequisites are already settled.
- Give a recommended answer for every question.
- Keep questions concrete and tied to a product, repository, surface, user, proof gate, or risk.
- Do not implement until Charlie confirms the direction is settled.

## Question Format

```markdown
1. **<decision title>**: <question and tradeoff>

   Recommended: <specific answer and why>
```

## Charlie-Specific Axes

- Product priority: Burton first unless the supporting work clearly helps Burton ship or operate.
- Proof level: local deterministic, rendered UI, physical-device, live service/provider, deployed production.
- Scope: tiny PR, spike, implementation slice, research note, migration plan, or operating automation.
- Risk: auth, billing, data, provider writes, deployment, build system, user-visible design.
- Platform fit: native Apple conventions, SwiftUI structure, XcodeBuildMCP validation, and device evidence.
- Repo hygiene: dirty worktree isolation, branch base, commit boundaries, PR target.

Stop when every branch has either a decision, an explicit out-of-scope marker, or a named follow-up.
