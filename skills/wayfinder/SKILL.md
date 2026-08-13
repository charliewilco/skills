---
name: wayfinder
description: Map a large ambiguous effort into decision tickets and proof gates for Charlie's products. Use when a plan is too large for one session, has many unknowns, spans repositories, or needs a shared route before implementation.
disable-model-invocation: true
---

# Wayfinder

Use this when the destination is too large or foggy for one implementation session. Produce a map of decisions, not a pile of tasks.

## Defaults For Charlie

- Burton is the default priority unless the work is clearly supporting infrastructure.
- Prefer a GitHub issue map when the repo uses GitHub. Use local Markdown only when no tracker is available.
- Keep implementation out of the map unless a small task is required to unblock a decision.
- Treat live proof as a first-class decision: local tests, simulator screenshots, physical-device launch, deployed smoke, or real provider write are different gates.
- For migrations, use `migration-playbook`.
- For issue batches, use `issue-batch-planner`.
- For unknown external facts, use `research`.
- For user decisions, use `grill-me`.

## Map Template

```markdown
## Destination
<what must be true when the way is clear>

## Product Priority
<Burton/Passage/Meramon/downwrite/Tome/etc. and why it matters>

## Proof Gates
- <local deterministic proof>
- <rendered or device proof>
- <live/deployed proof if needed>

## Decisions So Far
- <linked decision> — <one-line gist>

## Frontier
- <decision currently ready to resolve>

## Not Yet Specified
- <fog that is in scope but not precise enough for a ticket>

## Out Of Scope
- <explicitly excluded work>
```

## Ticket Types

- `research`: facts from docs, APIs, source, products, legal records, or local artifacts.
- `grilling`: Charlie must choose a product, scope, UX, risk, or tradeoff.
- `prototype`: a rough artifact is needed to make a decision concrete.
- `task`: manual or technical setup required before a decision can be made.

## Workflow

1. Name the destination and scope boundary.
2. Identify proof gates and production risks.
3. Create only the tickets whose questions are sharp now.
4. Record fog separately instead of inventing fake tasks.
5. Resolve one non-research ticket per session unless Charlie explicitly asks for execution.
6. After each resolution, update the map and graduate any newly clear fog into tickets.

Stop when the route is clear enough to hand to implementation skills or a focused PR.
