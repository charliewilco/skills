---
name: research
description: Source-grounded research for Charlie's product, engineering, naming, API, platform, legal-ish, and strategy questions. Use when the user asks to research, verify, compare options, inspect docs, look up current facts, or produce a cited note.
---

# Research

Investigate from primary sources and produce a durable, cited answer or Markdown note.

## Source Priority

1. Local repo files, product artifacts, screenshots, logs, generated outputs, and existing docs.
2. Official docs, specifications, source repositories, standards, platform release notes, API references, first-party support pages.
3. Direct product pages, legal records, patent records, filings, changelogs, or issue trackers.
4. Secondary sources only for context, never as the sole basis for a claim.

Browse when facts may have changed, when the user gives a URL, or when exact citations matter.

## Charlie Defaults

- For Apple/iOS/macOS planning, prefer Apple Developer documentation and session material.
- For OpenAI, use official OpenAI docs or local installed tooling first.
- For Cloudflare, use official Cloudflare docs and the actual repo configuration.
- For naming, product, and legal-ish work, state collision and product implications, not just search results.
- For architecture comparisons, ground conclusions in the current repo before recommending a rewrite.

## Output

Use this shape:

```markdown
## Answer
<direct conclusion>

## Evidence
- <claim> — <source/path/link>

## Implications
- <what this changes for the product or implementation>

## Open Questions
- <only unresolved decisions or unavailable proof>
```

If creating a file, save it where the repo already keeps research notes. If there is no convention, use `docs/research/` or the user-requested output directory.
