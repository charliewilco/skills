---
name: quality-gates-audit
description: Audit a repo's local and CI quality gates for coverage gaps, script drift, generated-code churn, and false confidence. Use whenever the user asks whether checks are trustworthy, why CI missed something, how to tighten lint/format/typecheck/build/test coverage, or how to align local scripts with GitHub Actions, Just, Make, or Xcode workflows.
---

# Quality Gates Audit

Inspect how a repo proves quality locally and in CI, find blind spots and redundant drift, and recommend a minimal gate set that people will actually run.

## When to use

- "Audit our CI and local checks"
- "Why did CI miss this regression?"
- "Are our lint and format scripts actually covering the repo?"
- "Clean up the quality pipeline"
- "Make local checks match GitHub Actions"

## Workflow

### Phase 1: Inventory the gate surface

Inspect project config first:

- `package.json`, `Package.swift`, `Cargo.toml`, `go.mod`
- `Justfile`, `Makefile`, repo scripts
- CI workflows under `.github/workflows/`
- formatter, linter, test, and typecheck configs
- generated-code directories and build artifacts

Build a normalized list of available gates:

- format
- lint
- typecheck
- build
- unit tests
- integration tests
- smoke or E2E tests
- packaging or artifact validation

### Phase 2: Compare local and CI coverage

For each gate, answer:

- what command is canonical locally?
- what runs in CI?
- does CI call the same command or reimplement it?
- what paths are included and excluded?
- are generated files intentionally excluded?
- are there services or source folders that quietly escape checks?

Look specifically for:

- narrow script globs that miss active source folders
- workflow files that drift from `Justfile` or package scripts
- generated code getting reformatted or linted unintentionally
- build steps that compile but never execute the built artifact
- broad formatting changes mixed into behavior work
- integration-critical paths with only unit coverage

### Phase 3: Rate the confidence of each gate

Do not treat all green checks equally. Classify each gate as:

- trustworthy
- partial
- misleading
- missing

Examples:

- a formatter that only checks `e2e/` is misleading if product code lives elsewhere
- a build that never runs the built bundle is partial
- CI lanes that skip database-backed paths are partial for storage-heavy repos

### Phase 4: Report

Present a report in this shape:

```text
## Gate matrix

| gate | local command | CI command | confidence | notes |
| --- | --- | --- | --- | --- |

## Coverage gaps

1. <gap>
2. <gap>

## Recommended canonical commands

- <command>

## Minimal repair plan

1. <smallest high-leverage fix>
2. <next fix>
3. <follow-up>
```

### Phase 5: Implement with restraint

If asked to fix the pipeline, prefer:

1. expand obviously wrong file scopes
2. establish one canonical local command per gate
3. make CI call those canonical commands where possible
4. isolate generated-code paths
5. add expensive integration lanes only where product risk justifies them

## Rules

- Do not recommend more gates just because you can. Optimize for signal, not ceremony.
- Treat duplicated command definitions across docs, scripts, and CI as drift risk.
- Call out when a repo needs a one-time formatting baseline before a strict `format:check` rollout.
- Prefer explicit generated-file excludes over accepting noisy churn forever.
- If an integration path is production-relevant, say so directly when CI does not exercise it.
