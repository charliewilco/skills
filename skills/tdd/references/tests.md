# Test Shape

## Good Tests

- Verify behavior users or callers care about.
- Use public APIs, view models, provider protocols, commands, routes, or package entrypoints.
- Survive refactors when behavior stays the same.
- Use independent expected values: literals, fixtures, protocol examples, or source-backed records.
- Keep one logical behavior per test.

## Bad Tests

- Mock internal modules you control.
- Test private methods or implementation structure.
- Assert call counts or call order unless the order is itself user-visible or protocol-required.
- Recompute the expected result with the same logic as the implementation.
- Snapshot a broad UI when a focused semantic assertion would catch the behavior.

## Charlie-Specific Examples

- Swift provider tests should assert request URLs, methods, payloads, decoded provider-neutral models, and error mapping at provider boundaries.
- SwiftUI tests should prefer stable accessibility identifiers and values, not layout accidents.
- Cloudflare Worker tests should exercise route behavior and binding contracts, not only helper functions.
- OpenAPI tests should compare generated spec behavior with runtime routes before regenerating clients.
