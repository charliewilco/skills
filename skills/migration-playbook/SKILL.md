---
name: migration-playbook
description: Plan and guide risky runtime, platform, service, or architecture migrations using a repeatable staged playbook with contract extraction, parity validation, shadowing, rollout, and rollback. Use whenever the user is migrating APIs, edge functions, runtimes, services, or legacy routes and needs a safer path than a big-bang rewrite.
---

# Migration Playbook

Make risky migrations boring by turning them into staged, testable work with explicit parity checks and rollback points.

## When to use

- "Plan this migration"
- "Move from legacy runtime to new runtime"
- "Replace these edge functions with a local API"
- "Split this service without breaking behavior"
- "Retire old routes safely"

## Workflow

### Phase 1: Define the migration unit

Name the thing being migrated:

- runtime
- API surface
- service boundary
- edge function set
- client route surface
- storage or execution path

Identify:

- current source of truth
- target architecture
- durability and data-consistency risks
- auth and identity implications
- observability gaps
- rollback constraints

### Phase 2: Extract the existing contract

Before proposing rewrites, capture what exists today:

- routes, actions, headers, and method constraints
- payload shapes and known error behavior
- side effects and persistence writes
- upstream and downstream dependencies
- parity expectations from clients or legacy surfaces

If the contract is implicit, say so and recommend the smallest extraction artifact:

- acceptance fixtures
- route inventory
- parity matrix
- generated checklist

### Phase 3: Design the staged path

Prefer a staged rollout such as:

1. ADR or architecture decision
2. compatibility audit
3. contract extraction
4. adapter or shadow mode
5. parity validation
6. client cutover
7. decommission and rollback removal

Useful modes include:

- proxy: new surface forwards to legacy
- shadow: run both and compare outputs
- native: new surface owns production traffic

### Phase 4: Define proof and safety gates

For each stage, define:

- what proves parity
- what metrics or diffs are captured
- what blocks rollout
- how rollback works

Always consider:

- duplicate execution prevention
- idempotency and data consistency
- auth propagation
- CI checks against drift
- migration progress tracking

### Phase 5: Report

Present a report in this shape:

```text
## Migration scope

- From: <current state>
- To: <target state>
- Main risks: <list>

## Contract artifacts

- <artifact>

## Staged plan

1. <stage>
2. <stage>

## Safety gates

- <gate>

## Rollback

- <rollback path>
```

## Rules

- Reject big-bang rewrites when a staged path is available.
- If the existing contract is undocumented, extraction comes before implementation.
- Always include rollback and data-consistency discussion for production migrations.
- Prefer a few clean runtime roles over service-per-feature sprawl.
- When legacy routes are retired, require an explicit mapping from old surface to new destination.
