# ADR-003: Database per Service

> English version · [Русская версия](i18n/ru/ADR-003-database-per-service.md)

**Status:** Proposed  
**Date:** 2026-06-15

## Context

The system is built with a microservices architecture. A shared database between
services would create tight coupling — schema changes in one service could break
others, and services could not be deployed or scaled independently.

## Decision

Each backend service owns its own PostgreSQL database:

| Service | Database |
|---------|----------|
| Request Service | Request DB — requests, statuses, client data |
| Inspect Service | Inspect DB — inspection assignments and data |
| Review Service | Review DB — appraisal data and reports |

Services communicate via API calls (through the API Gateway) or Kafka events,
never by querying another service's database directly.

## Consequences

**Positive:**
- Services are independently deployable and scalable
- Schema changes in one service do not affect others
- Clear ownership of data per domain

**Negative:**
- Cross-service queries require API calls or event-driven data replication
- More databases to provision and back up
- No foreign key constraints across service boundaries
