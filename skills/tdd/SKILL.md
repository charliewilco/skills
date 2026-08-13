---
name: tdd
description: Test-driven development for Charlie's product repos. Use when building or fixing behavior test-first, when the user mentions TDD, red-green-refactor, regression tests, Swift Testing, Jest/Bun tests, or when a risky behavior change needs a proof loop before implementation.
---

# TDD

Use a red -> green -> refactor loop, but keep it pragmatic: one vertical slice, one public seam, one failing test, one minimal fix.

## Defaults For Charlie

- Inspect repo scripts first: `package.json`, `Package.swift`, `Cargo.toml`, `pyproject.toml`, `Justfile`, `Makefile`, and CI workflows.
- Prefer Swift Testing for new Swift tests. Use XCTest only when existing APIs or test targets require it.
- For iOS/macOS app validation, prefer XcodeBuildMCP when available; otherwise use the repo's documented `xcodebuild` path and say why.
- For Reviewer/Passage provider work, do not treat local mocks as live proof. Add local tests, then clearly state whether real OAuth/workspace/PR smoke proof was run.
- For Burton visual or app-shell work, keep tests focused and preserve seeded launch arguments when deterministic UI evidence matters.
- For Cloudflare Workers, use the repo's configured toolchain. In Reviewer `auth-worker`, prefer Biome over ESLint unless the repo changes.

## Loop

1. Identify the behavior and the public seam.
2. Name the smallest useful test and why that seam is the right boundary.
3. Write the failing test first.
4. Run the narrowest command that proves it fails for the expected reason.
5. Implement only enough code to pass.
6. Run the focused test until green.
7. Run the relevant broader checks for the touched surface.
8. Refactor only after green, and rerun the same checks.

## Good Tests

Good tests verify observable behavior through public interfaces. Avoid private methods, call-order assertions against internal collaborators, broad snapshots, and expected values computed the same way as the implementation.

Read `references/tests.md` when you need examples. Read `references/mocking.md` before adding mocks.

## Stop Conditions

- The seam is unclear and writing a test would lock in a bad interface.
- The expected behavior is a product decision Charlie needs to make.
- The only available test would assert implementation details.
- Required live proof depends on credentials, an unlocked device, or a deployed service that is not available.

When blocked, report the exact missing decision or proof and the command you would run next.
