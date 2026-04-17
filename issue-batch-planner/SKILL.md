---
name: issue-batch-planner
description: Triage a milestone, backlog slice, or batch of GitHub or Linear issues into a concrete execution plan with readiness, blockers, dependencies, shared contract questions, and recommended order. Use whenever the user asks to plan several issues at once, size a milestone, generate a parity checklist, or decide what is actionable before coding.
---

# Issue Batch Planner

Turn a loose set of issues into a dependency-aware execution plan before anyone starts implementation.

## When to use

- "Plan this milestone"
- "Which of these issues are actually ready?"
- "Group the blockers across this backlog"
- "Create an implementation order"
- "Turn this migration checklist into actionable work"

## Workflow

### Phase 1: Gather issue context

Inspect each issue and pull out:

- title and summary
- acceptance criteria
- repo or surface affected
- labels, milestone, and owner if present
- dependencies named explicitly or implied by the work
- contract questions such as auth, error schema, telemetry, routing, data model, or platform parity

Do not assume all issues are equally actionable.

### Phase 2: Classify readiness

Classify each issue as one of:

- actionable
- blocked
- partially actionable
- duplicate or superseded

Reasons for blocked status often include:

- missing API contract
- missing design or product decision
- missing parity mapping to an existing surface
- hidden dependency on another issue
- unclear source of truth for schema or routing

### Phase 3: Group shared blockers

Avoid repeating the same question per issue. Group blockers by shared theme, such as:

- identity and auth
- contract and error shape
- telemetry and analytics
- route retirement and redirects
- parity mapping between old and new surfaces

If the batch is a migration, build a parity checklist rather than a flat issue list.

### Phase 4: Recommend execution order

Order work by dependency and leverage:

1. foundation or contract issues
2. shared infrastructure
3. product-facing feature issues
4. parity cleanup and route retirement
5. quality-gate or rollout follow-ups

If branch naming or repo policy matters, defer to repo-local conventions instead of inventing a branch scheme.

### Phase 5: Report

Present the result in this shape:

```text
## Readiness table

| issue | status | why | dependencies |
| --- | --- | --- | --- |

## Shared blockers

1. <blocker>
2. <blocker>

## Recommended order

1. <issue or group>
2. <issue or group>

## Missing decisions

- <question>
```

For parity-heavy work, add:

```text
## Parity checklist

- <old route/surface> -> <new owner or destination>
```

## Rules

- Do not flatten dependencies into a fake "everything can start now" plan.
- Prefer one canonical parity checklist per migration stream over many disconnected notes.
- Call out when issues are missing route/source evidence or destination ownership.
- If issue creation is requested later, recommend dry-run or previewable templates before bulk creation.
