---
name: openapi-parity
description: Audit an API or service repo for OpenAPI drift, weak schemas, codegen risk, and mismatches between runtime behavior, generated clients, and published specs. Use whenever the user mentions OpenAPI, Swagger, generated clients/types, schema drift, "the spec is wrong", "why is codegen producing unknown", or wants to tighten API contracts before or during implementation.
---

# OpenAPI Parity

Find the real source of truth in an API repo, compare it to the emitted OpenAPI artifacts and generated clients, and produce an actionable parity plan before making broad contract changes.

## When to use

- "Check whether our OpenAPI matches the implementation"
- "Why is codegen emitting `unknown`, `{}` or `additionalProperties` everywhere?"
- "Audit this repo's API contract setup"
- "Tighten response schemas before we expand the client"
- "Find drift between handlers, docs, and generated clients"

## Workflow

Follow these phases in order. Do not start by regenerating artifacts. First establish where drift actually comes from.

### Phase 1: Discover the contract pipeline

Inspect the repo and identify:

- canonical spec locations such as `openapi.yaml`, `openapi.json`, `api/openapi/*`, `docs/openapi/*`
- generation scripts in `package.json`, `Justfile`, `Makefile`, CI workflows, or custom scripts
- handler or route declaration patterns
- generated client targets such as TypeScript types, Swift clients, SDK packages, or checked-in artifacts
- spec lint or diff tooling such as Redocly, Spectral, `swagger-cli`, or no-drift CI checks

Answer these questions explicitly:

- What is intended to be the source of truth: handlers, schemas, annotations, or committed spec files?
- Is spec generation pure, or does it import runtime code with side effects like DB construction or env-required startup?
- Which generated artifacts are committed, and which are build outputs?

### Phase 2: Compare implementation and spec

Inspect a representative slice of routes and compare:

- route paths and methods
- request bodies and params
- success responses
- documented error responses
- auth headers and idempotency headers
- operation IDs and tags when clients depend on them

Look specifically for these failure modes:

- runtime route exists but is missing from the spec
- spec includes legacy routes that no longer exist
- `200` schemas collapse to `{ [key: string]: unknown }`, `{}`, or broad `additionalProperties`
- error responses are undocumented or flattened to generic blobs
- auth and tenant headers exist in code but not in the contract
- generation requires runtime env because route trees trigger top-level side effects

### Phase 3: Evaluate codegen risk

Inspect generated clients or downstream consumers and identify whether schema drift causes:

- manual runtime narrowing in client code
- `unknown` or untyped payloads where product logic expects stable shapes
- generated Swift or TypeScript artifacts that are hard to lint, format, or isolate
- noisy churn from unstable `operationId` or formatting of generated output

Call out whether the real problem is:

- missing backend response schemas
- weak generator extraction
- poor separation between runtime bootstrap and route definitions
- lack of contract validation in CI

### Phase 4: Report

Present a compact report in this shape:

```text
## Contract map

- Source of truth: <handlers/spec/annotations/other>
- Canonical spec path: <path or none>
- Generation path: <command/script or none>
- Generated clients: <paths or none>

## Drift findings

1. <finding>
2. <finding>

## Codegen risk

- <risk>

## Recommended fixes

1. <highest-leverage fix>
2. <next fix>
3. <validation step>
```

Keep findings concrete. Name files, commands, and route examples. Do not hide behind generic phrases like "some drift exists".

### Phase 5: Implement only the smallest leverage point

If the user wants changes, prefer this order:

1. make spec generation pure and side-effect light
2. add explicit request and response schemas to the highest-value routes
3. add spec validation and no-drift checks
4. regenerate affected clients
5. widen coverage only after the pipeline is trustworthy

## Rules

- Do not mass-regenerate clients until you understand whether the schemas are worth trusting.
- Do not describe a spec as "good" just because generation passes.
- Treat `additionalProperties`, empty objects, and untyped success payloads as contract debt, not harmless defaults.
- Always check documented error behavior and auth headers, not only happy-path `200` responses.
- If generated code is checked in, call out formatter and lint boundaries explicitly.
- If the repo lacks OpenAPI entirely, say so quickly and pivot to recommending the smallest viable contract source.
