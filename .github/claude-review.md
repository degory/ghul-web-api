# Cloud code review brief

What this repository is, and what to watch for in it. Everything else — what PR
context is available, how to post a review, what makes a finding worth raising,
comment hygiene, PR-description shape, the versioning mechanism — comes from the
review workflow's runtime notes. Don't restate it here: this file is read first,
so a stale copy would silently override the current text.

Not loaded by local Claude Code; only the cloud reviewer reads this.

## What this repo is

`ghul-web-api` is a worked example: an ASP.NET 10 web API implemented in ghūl,
exposing a CRUD interface over dummy product objects with Swagger documentation.
It exists to be read and copied by people evaluating whether ghūl is usable for
real work.

Clarity outranks cleverness. Code a newcomer to ghūl would find surprising is a
defect here even when it is correct.

## What to watch for here

- Anything that would not build or run for a reader following the README. Drift
  between the README's stated prerequisites and what the project actually requires
  is a real defect in a repo whose purpose is to be followed.
- Non-idiomatic ghūl. This is example code; an idiom nobody would recommend teaches
  the wrong thing.
- ASP.NET correctness: route conflicts, missing or wrong status codes, unhandled
  null paths through the CRUD handlers, Swagger annotations disagreeing with the
  actual signature.
- Docs drifting from code. The README documents build and run steps in detail; a
  structural or dependency change that leaves it stale is worth flagging.

## Versioning

This repo publishes nothing. Version bumps are not a concern here; the compiler
pin should track the latest published release.
