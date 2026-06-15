# ADR-004: Open Source License (MIT / Apache 2.0)

> English version · [Русская версия](i18n/ru/ADR-004-open-source-license.md)

**Status:** Proposed  
**Date:** 2026-06-15

## Context

The client requires that the source code remain publicly available after
delivery. The license must be permissive enough for the client to use, modify,
and distribute the software freely, while also being compatible with the
open-source dependencies used in the project (Go ecosystem, React, etc.).

## Decision

Release all source code under either **MIT** or **Apache 2.0** license.
The final choice between the two will be made before the first public release.

- **MIT** — simpler, shorter, widely recognized
- **Apache 2.0** — includes an explicit patent grant, better for commercial use

## Consequences

**Positive:**
- Client has full freedom to use, modify, and redistribute the code
- Compatible with all major open-source dependencies in the stack
- Attracts potential contributors from the community

**Negative:**
- Anyone can fork and use the code without contributing back
- No commercial protection for the development team
