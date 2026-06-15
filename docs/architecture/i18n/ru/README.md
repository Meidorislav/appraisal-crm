# Архитектура — C4-диаграммы

> Русская версия · [English version](../../README.md)

C4-модель системы Appraisal CRM, описанная на [Structurizr DSL](workspace.dsl).

Покрыто два уровня:
- **Уровень 1 — System Context**: акторы и внешние системы
- **Уровень 2 — Container Diagram**: сервисы, базы данных и инфраструктура

## Запуск локально

### Вариант 1: Structurizr Local (Docker)

Самый простой способ — не требует аккаунта.

```bash
docker run -it --rm -p 8080:8080 \
  --user $(id -u):$(id -g) \
  -v $(pwd):/usr/local/structurizr \
  structurizr/structurizr local
```

Запускать из директории `docs/architecture/`, затем открыть [http://localhost:8080](http://localhost:8080).


### Вариант 2: Structurizr CLI (экспорт в PNG/SVG)

Установить CLI и экспортировать диаграммы как статические файлы:

```bash
# macOS
brew install structurizr-cli

# или скачать вручную:
# https://github.com/structurizr/cli/releases
```

Экспорт всех видов:

```bash
structurizr export -workspace workspace.dsl -format png
```

Поддерживаемые форматы: `png`, `svg`, `plantuml`, `mermaid`.

### Вариант 3: Structurizr cloud

1. Создать бесплатный воркспейс на [structurizr.com](https://structurizr.com)
2. Вставить содержимое `workspace.dsl` в DSL-редактор
3. Нажать **Render**

## Структура файлов

```
docs/architecture/
├── workspace.dsl       # C4-модель (английская версия)
├── README.md           # Инструкция (английская версия)
└── i18n/
    └── ru/
        ├── workspace.dsl  # C4-модель (русская версия)
        └── README.md      # Этот файл
```

## Редактирование диаграммы

DSL-файл описывает акторов, контейнеры и связи между ними.
После сохранения Structurizr Lite перезагружается автоматически — рестарт не нужен.

Ключевые секции `workspace.dsl`:

| Секция | Что содержит |
|--------|-------------|
| `model { person ... }` | Акторы |
| `model { softwareSystem ... }` | Граница системы и контейнеры |
| `person -> container` | Связи |
| `views { container ... }` | Что рендерить и как |
