# Architecture — C4 Diagrams

> English version · [Русская версия](i18n/ru/README.md)

C4 model for the Appraisal CRM system, described in [Structurizr DSL](workspace.dsl).

Two levels are covered:
- **Level 1 — System Context**: actors and external systems
- **Level 2 — Container Diagram**: services, databases, and infrastructure

## Running locally

### Option 1: Structurizr Local (Docker)

The simplest way — no account required.

```bash
docker run -it --rm -p 8080:8080 \
  --user $(id -u):$(id -g) \
  -v $(pwd):/usr/local/structurizr \
  structurizr/structurizr local
```

Run this command from the `docs/architecture/` directory, then open [http://localhost:8080](http://localhost:8080).


### Option 2: Structurizr CLI (export to PNG/SVG)

Install the CLI and export diagrams as static files:

```bash
# macOS
brew install structurizr-cli

# or download manually:
# https://github.com/structurizr/cli/releases
```

Export all views:

```bash
structurizr export -workspace workspace.dsl -format png
```

Supported formats: `png`, `svg`, `plantuml`, `mermaid`.

### Option 3: Structurizr cloud

1. Create a free workspace at [structurizr.com](https://structurizr.com)
2. Copy the contents of `workspace.dsl` into the DSL editor
3. Click **Render**

## File structure

```
docs/architecture/
├── workspace.dsl       # C4 model (English)
├── README.md           # This file
└── i18n/
    └── ru/
        ├── workspace.dsl  # C4 model (Russian)
        └── README.md      # Instructions (Russian)
```

## Editing the diagram

The DSL file defines actors, containers, and their relationships.
After saving, Structurizr Lite reloads automatically — no restart needed.

Key sections in `workspace.dsl`:

| Section | What it contains |
|---------|-----------------|
| `model { person ... }` | Actors |
| `model { softwareSystem ... }` | System boundary and containers |
| `person -> container` | Relationships |
| `views { container ... }` | What to render and how |
