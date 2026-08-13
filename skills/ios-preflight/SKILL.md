---
name: ios-preflight
description: Run a lightweight preflight for iOS or macOS repos before feature work or debugging, with focus on Xcode project discovery, simulator readiness, destination handling, generated-file boundaries, and environment blockers. Use whenever the user asks to validate an Apple-platform repo, troubleshoot flaky local builds/tests, or "make sure this is workable before we start".
---

# iOS Preflight

Quickly determine whether an Apple-platform repo is actually ready for implementation, testing, and review before spending time on changes that the environment cannot validate.

## When to use

- "Check whether this iOS/macOS repo is in a workable state"
- "Why are local tests or simulator runs flaky?"
- "Run a preflight before we implement this issue"
- "Audit the Xcode and simulator setup"

## Workflow

### Phase 1: Discover the workspace shape

Inspect:

- `Package.swift`
- `.xcodeproj` and `.xcworkspace`
- `Justfile`, `Makefile`, or package scripts that wrap `xcodebuild`
- test targets, UI test targets, and preview-heavy SwiftUI targets
- generated code directories such as `Generated/`, OpenAPI output, or build-produced Swift files

Identify the canonical build entrypoints:

- direct `xcodebuild`
- SwiftPM-only
- wrapper commands such as `just ios build`

### Phase 2: Run lightweight viability checks

Prefer lightweight discovery before expensive builds:

- confirm the project or workspace can be listed
- confirm destinations are discoverable
- confirm simulator state is sane if UI tests are expected
- confirm dependencies can resolve in the current environment

Look specifically for:

- invalid or stale workspace references
- simulator state failures before tests start
- destination strings that are fragile to pass through wrappers
- network or package-resolution blockers
- generated files that get reformatted during normal lint or format commands

### Phase 3: Audit developer ergonomics

Check whether the repo makes common Apple work harder than it needs to be:

- `just ios ...` wrappers that cannot safely pass destinations with spaces
- shared DerivedData causing concurrent build lock failures
- UI test recipes that assume a ready simulator but never boot or wait for it
- formatter scope hitting generated OpenAPI clients
- pure model code trapped in app-level actor isolation because it lives in the app target

### Phase 4: Report

Present the result in this shape:

```text
## Preflight status

- Project entrypoint: <workspace/project/package>
- Build viability: <ready/blocked/partially blocked>
- Test viability: <ready/blocked/partially blocked>
- Main blockers: <list>

## Environment findings

1. <finding>
2. <finding>

## Recommended fixes

1. <highest-leverage fix>
2. <next fix>
3. <optional ergonomics fix>
```

If the environment is blocked, say so early and clearly. Do not pretend full validation happened.

### Phase 5: Fix the minimum necessary path

If the user wants changes, prioritize:

1. reliable project and destination discovery
2. simulator preflight and stable test entrypoints
3. generated-file exclusions from formatting
4. command ergonomics like destination-safe wrappers
5. architecture cleanup only if it directly affects validation

## Rules

- Prefer lightweight preflight commands before full builds or UI tests.
- When a simulator or network blocker prevents validation, surface it explicitly instead of continuing as if results are trustworthy.
- Treat generated Swift clients as a separate tooling concern; do not mix them into normal hand-written formatting unless the repo clearly intends that.
- If SwiftUI code would benefit from one view per file and previews, note it as a follow-up, not a blocker, unless the user asked for structural cleanup.
