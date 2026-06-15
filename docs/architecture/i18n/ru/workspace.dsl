workspace "Appraisal CRM" "CRM для автоматизации полного цикла оценки объектов" {

    model {
        # ──────────────────────────────────────────
        # Акторы
        # ──────────────────────────────────────────
        client    = person "Клиент"        "Физическое или юридическое лицо"
        appraiser = person "Оценщик"       "Сотрудник компании"
        inspector = person "Осмотрщик"     "Сотрудник компании"
        admin     = person "Администратор" "Сотрудник компании"

        # ──────────────────────────────────────────
        # Внешние системы
        # ──────────────────────────────────────────
        emailProvider = softwareSystem "Email Provider" "SMTP-провайдер для отправки уведомлений" "External System"

        # ──────────────────────────────────────────
        # Система
        # ──────────────────────────────────────────
        appraisalCRM = softwareSystem "Appraisal CRM" "CRM для автоматизации оценки объектов: от заявки до отчёта" {

            # Frontend
            clientSPA    = container "Client Portal"        "Личный кабинет: подача заявки, статус, скачивание отчёта"    "TypeScript, React" "Web Browser"
            appraisalSPA = container "Appraiser Interface"  "Управление заявками, ввод данных оценки, отправка отчёта"    "TypeScript, React" "Web Browser"
            inspectorSPA = container "Inspector Interface"  "Получение заданий, загрузка фото и данных осмотра"           "TypeScript, React" "Web Browser"
            adminSPA     = container "Admin Panel"          "Управление пользователями, заявками, назначение осмотрщиков" "TypeScript, React" "Web Browser"

            # Gateway & Auth
            apiGateway  = container "API Gateway"  "Маршрутизация запросов, валидация JWT, rate limiting"          "Go"
            authService = container "Auth Service" "Аутентификация и авторизация, выдача JWT (OAuth2/OIDC)"        "Keycloak"
            redis       = container "Cache"        "Кэширование сессий и часто запрашиваемых данных"               "Redis"    "Cache"

            # Бэкенд-сервисы
            requestService      = container "Request Service"      "Управление заявками и статусами, хранение данных клиентов"       "Go"
            inspectService      = container "Inspect Service"      "Управление заданиями осмотра, загрузка фотоматериалов"           "Go"
            reviewService       = container "Review Service"       "Ввод данных оценки, расчёт, формирование и хранение отчётов"     "Go"
            notificationService = container "Notification Service" "Консумирует события из Kafka, отправляет email-уведомления"      "Go"

            # Базы данных
            requestDB = container "Request DB" "Заявки, статусы, данные клиентов" "PostgreSQL" "Database"
            inspectDB = container "Inspect DB" "Данные осмотров, задания"         "PostgreSQL" "Database"
            reviewDB  = container "Review DB"  "Данные оценки, отчёты"            "PostgreSQL" "Database"

            # Инфраструктура
            kafka = container "Message Broker" "Event bus для событий смены статусов и завершения этапов" "Apache Kafka" "Message Bus"
            s3    = container "File Storage"   "Фотографии осмотра и готовые отчёты"                      "S3 Yandex Cloud" "Storage"
        }

        # ──────────────────────────────────────────
        # Связи: Акторы → Frontend
        # ──────────────────────────────────────────
        client    -> clientSPA    "Подаёт заявку, отслеживает статус, скачивает отчёт"
        appraiser -> appraisalSPA "Управляет заявками, проводит оценку, отправляет отчёт"
        inspector -> inspectorSPA "Получает задания, загружает фото и данные осмотра"
        admin     -> adminSPA     "Управляет пользователями и назначениями"

        # ──────────────────────────────────────────
        # Связи: Frontend → Auth & Gateway
        # ──────────────────────────────────────────
        clientSPA    -> authService "Авторизация" "OAuth2/OIDC"
        appraisalSPA -> authService "Авторизация" "OAuth2/OIDC"
        inspectorSPA -> authService "Авторизация" "OAuth2/OIDC"
        adminSPA     -> authService "Авторизация" "OAuth2/OIDC"

        clientSPA    -> apiGateway "REST" "HTTPS"
        appraisalSPA -> apiGateway "REST" "HTTPS"
        inspectorSPA -> apiGateway "REST" "HTTPS"
        adminSPA     -> apiGateway "REST" "HTTPS"

        # ──────────────────────────────────────────
        # Связи: Gateway → Services
        # ──────────────────────────────────────────
        apiGateway -> authService    "Валидация JWT"      "HTTP"
        apiGateway -> redis          "Кэш"
        apiGateway -> requestService "Проксирует запросы" "HTTP"
        apiGateway -> inspectService "Проксирует запросы" "HTTP"
        apiGateway -> reviewService  "Проксирует запросы" "HTTP"

        # ──────────────────────────────────────────
        # Связи: Services → Databases
        # ──────────────────────────────────────────
        requestService -> requestDB "Чтение/запись"
        inspectService -> inspectDB "Чтение/запись"
        reviewService  -> reviewDB  "Чтение/запись"

        # ──────────────────────────────────────────
        # Связи: Services → Kafka (publish)
        # ──────────────────────────────────────────
        requestService -> kafka "request.created, request.status_changed" "Publish"
        inspectService -> kafka "inspect.completed"                        "Publish"
        reviewService  -> kafka "report.ready"                             "Publish"

        # ──────────────────────────────────────────
        # Связи: Kafka → Notification
        # ──────────────────────────────────────────
        kafka -> notificationService "Консумирует события"  "Subscribe"
        notificationService -> emailProvider "Отправка email" "SMTP"

        # ──────────────────────────────────────────
        # Связи: File storage
        # ──────────────────────────────────────────
        inspectService -> s3 "Загружает фото осмотра"
        reviewService  -> s3 "Сохраняет готовые отчёты"
        clientSPA      -> s3 "Скачивает отчёт" "presigned URL"
    }

    views {
        systemContext appraisalCRM "Context" {
            include *
            autolayout lr
            title "Уровень 1: System Context"
        }

        container appraisalCRM "Containers" {
            include *
            autolayout lr
            title "Уровень 2: Container Diagram"
        }

    }

}
