# ADR-005: Go for Backend Services

> English version · [Русская версия](i18n/ru/ADR-005-go-backend.md)

**Status:** Proposed  
**Date:** 2026-06-15

## Context

The backend consists of multiple independent services (API Gateway, Request,
Inspect, Review, Notification). A language and runtime must be chosen that
performs well under concurrent load, compiles to a single binary for easy
deployment, and is maintainable long-term.

## Decision

Use Go for all backend services.

## Consequences

**Positive:**
- Excellent concurrency model (goroutines) — well suited for an API Gateway and
  event-driven Notification Service
- Compiles to a single static binary — simple Docker images, no runtime
  dependencies
- Strong standard library covers HTTP, JSON, and database access without heavy
  frameworks
- Fast compile times support rapid iteration

**Negative:**
- Less expressive than higher-level languages for complex domain logic
- Smaller ecosystem than Java/Node.js for some integrations (e.g. Keycloak
  admin client libraries)
- Team must be proficient in Go; onboarding new developers may take time
