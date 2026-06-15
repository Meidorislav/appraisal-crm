# ADR-004: Open Source License (Apache 2.0)

> English version · [Русская версия](i18n/ru/ADR-004-open-source-license.md)

**Status:** Proposed  
**Date:** 2026-06-15

## Context

The client requires that the source code remain publicly available after
delivery. The license must be permissive enough for the client to use, modify,
and distribute the software freely, while also being compatible with the
open-source dependencies used in the project (Go ecosystem, React, etc.).

Apache 2.0 was chosen over MIT because this is a corporate project: Apache 2.0
includes an explicit patent grant, meaning contributors cannot later assert
patent claims against users of the software. MIT provides no such protection.

## Decision

Release all source code under the **Apache 2.0** license.

## Consequences

**Positive:**
- Explicit patent grant protects users and the client from patent claims by
  contributors
- Client has full freedom to use, modify, and redistribute the code
- Compatible with all major open-source dependencies in the stack
- Attracts potential contributors from the community

**Negative:**
- Anyone can fork and use the code without contributing back
- No commercial protection for the development team
- Requires a NOTICE file with attribution to be preserved in derivative works
- Public source code may help attackers identify vulnerabilities faster

**Mitigation for security risk:**
- Secrets (API keys, passwords, tokens) are never stored in the repository —
  only in environment variables or a secrets vault
- `.env` files are listed in `.gitignore`
- SAST (e.g. `gosec` for Go) runs in CI to catch common vulnerabilities
  before they reach the main branch
- Infrastructure details (server IPs, real DB schemas) are not committed
