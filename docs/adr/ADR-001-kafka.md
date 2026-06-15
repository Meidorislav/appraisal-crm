# ADR-001: Apache Kafka as Message Broker

> English version · [Русская версия](i18n/ru/ADR-001-kafka.md)

**Status:** Proposed  
**Date:** 2026-06-15

## Context

The system needs to notify participants (appraiser, inspector, client) when a
request status changes or a stage completes. Services must remain decoupled —
Request Service should not call Notification Service directly, as this creates
tight coupling and makes each service responsible for knowing who to notify.

## Decision

Use Apache Kafka as an event bus. Each backend service publishes domain events:

| Service | Events |
|---------|--------|
| Request Service | `request.created`, `request.status_changed` |
| Inspect Service | `inspect.completed` |
| Review Service | `report.ready` |

Notification Service subscribes to all topics and sends email notifications.

## Consequences

**Positive:**
- Services are fully decoupled — Notification Service can be restarted or
  replaced without affecting request processing
- Events are durable — notifications are not lost if Notification Service is
  temporarily down
- New consumers (e.g. analytics, audit log) can subscribe without modifying
  existing services

**Negative:**
- Adds operational complexity: Kafka requires its own deployment and monitoring
- Could be considered overkill for the current event volume — PostgreSQL
  `LISTEN/NOTIFY` would have sufficed for a simpler setup
