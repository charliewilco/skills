# Mocking

Mock at boundaries:

- Network providers and OAuth exchanges.
- Time, randomness, filesystem, pasteboard, notifications, device services, and process runners.
- Databases when there is no cheap test database or in-memory adapter.
- Cloud services when live smoke proof is a separate required gate.

Do not mock:

- Internal collaborators you can exercise through a public seam.
- Model transformations that can be tested with fixtures.
- View state just to avoid creating a small test harness.

Prefer typed fakes over generic fetch mocks. A fake `PullRequestProvider` or `RunnerClient` is usually clearer than a mock that branches on URL strings.

When live proof matters, keep the distinction explicit:

- `local deterministic proof`: unit/package/build tests passed.
- `rendered proof`: simulator/browser/device screenshot or launch evidence captured.
- `live proof`: real provider/service/device interaction completed.
