# ADR-006: S3 Yandex Cloud for File Storage

> English version · [Русская версия](i18n/ru/ADR-006-s3-storage.md)

**Status:** Proposed  
**Date:** 2026-06-15

## Context

The system stores two types of files: inspection photos (uploaded by inspectors
in the field) and generated appraisal reports (PDF). Files must be stored
durably, accessible via the web, and downloadable by clients without routing
through a backend service on every request.

Data retention period is **5 years**.

## Decision

Use S3 Yandex Cloud for all file storage. Files are uploaded by backend services
(Inspect Service for photos, Review Service for reports) and served to clients
via presigned URLs with a short TTL — clients download directly from S3 without
hitting the backend.

## Consequences

**Positive:**
- Clients download files directly from S3 — no bandwidth load on backend
  services
- Presigned URLs limit access without requiring authentication on every download
- Managed service — no infrastructure to maintain for storage
- S3-compatible API — can be replaced with any S3-compatible provider if needed

**Negative:**
- Ongoing cost (monthly/annual) — depends on total storage volume over 5 years
- Data is stored outside the company's own infrastructure
- Requires internet access for inspectors to upload photos in the field
