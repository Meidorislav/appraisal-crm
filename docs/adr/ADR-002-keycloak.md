# ADR-002: Keycloak for Authentication and Authorization

> English version · [Русская версия](i18n/ru/ADR-002-keycloak.md)

**Status:** Proposed  
**Date:** 2026-06-15

## Context

The system has four distinct roles (Client, Appraiser, Inspector, Administrator)
with different access levels. Authentication and authorization logic needs to be
consistent across all SPAs and backend services. Building a custom auth system
would introduce security risk and significant development overhead.

## Decision

Use Keycloak as the identity provider. Keycloak handles OAuth2/OIDC flows,
issues JWTs, and manages role assignments. The API Gateway validates tokens on
every request before proxying to backend services.

## Consequences

**Positive:**
- No custom auth code — reduces attack surface
- Role management is centralized in Keycloak admin UI
- Standard OAuth2/OIDC — all SPAs use the same flow
- Client accounts can be created programmatically via Keycloak Admin API
  (satisfies BR-003: auto-create client account on request confirmation)

**Negative:**
- Adds another service to deploy and maintain
- Keycloak is resource-heavy for a small deployment
- Team needs familiarity with Keycloak configuration
