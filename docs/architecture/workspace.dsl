workspace "Appraisal CRM" "CRM for automating the full property appraisal cycle" {

    model {
        # ──────────────────────────────────────────
        # Actors
        # ──────────────────────────────────────────
        client    = person "Client"        "Individual or legal entity"
        appraiser = person "Appraiser"     "Company employee"
        inspector = person "Inspector"     "Company employee"
        admin     = person "Administrator" "Company employee"

        # ──────────────────────────────────────────
        # External systems
        # ──────────────────────────────────────────
        emailProvider = softwareSystem "Email Provider" "SMTP provider for sending notifications" "External System"

        # ──────────────────────────────────────────
        # System
        # ──────────────────────────────────────────
        appraisalCRM = softwareSystem "Appraisal CRM" "CRM for property appraisal automation: from request to report" {

            # Frontend
            clientSPA    = container "Client Portal"       "Personal account: submit request, track status, download report" "TypeScript, React" "Web Browser"
            appraisalSPA = container "Appraiser Interface" "Manage requests, enter appraisal data, send report"             "TypeScript, React" "Web Browser"
            inspectorSPA = container "Inspector Interface" "Receive assignments, upload photos and inspection data"          "TypeScript, React" "Web Browser"
            adminSPA     = container "Admin Panel"         "Manage users, requests, assign inspectors"                      "TypeScript, React" "Web Browser"

            # Gateway & Auth
            apiGateway  = container "API Gateway"  "Request routing, JWT validation, rate limiting"           "Go"
            authService = container "Auth Service" "Authentication and authorization, JWT issuing (OAuth2/OIDC)" "Keycloak"
            redis       = container "Cache"        "Session and hot-data caching"                              "Redis"    "Cache"

            # Backend services
            requestService      = container "Request Service"      "Request and status management, client data storage"      "Go"
            inspectService      = container "Inspect Service"      "Inspection assignment management, photo upload"           "Go"
            reviewService       = container "Review Service"       "Appraisal data entry, calculation, report generation"    "Go"
            notificationService = container "Notification Service" "Consumes Kafka events, sends email notifications"        "Go"

            # Databases
            requestDB = container "Request DB" "Requests, statuses, client data"  "PostgreSQL" "Database"
            inspectDB = container "Inspect DB" "Inspection data, assignments"     "PostgreSQL" "Database"
            reviewDB  = container "Review DB"  "Appraisal data, reports"          "PostgreSQL" "Database"

            # Infrastructure
            kafka = container "Message Broker" "Event bus for status change and stage completion events" "Apache Kafka" "Message Bus"
            s3    = container "File Storage"   "Inspection photos and generated reports"                 "S3 Yandex Cloud" "Storage"
        }

        # ──────────────────────────────────────────
        # Relationships: Actors → Frontend
        # ──────────────────────────────────────────
        client    -> clientSPA    "Submits request, tracks status, downloads report"
        appraiser -> appraisalSPA "Manages requests, conducts appraisal, sends report"
        inspector -> inspectorSPA "Receives assignments, uploads photos and inspection data"
        admin     -> adminSPA     "Manages users and assignments"

        # ──────────────────────────────────────────
        # Relationships: Frontend → Auth & Gateway
        # ──────────────────────────────────────────
        clientSPA    -> authService "Authorization" "OAuth2/OIDC"
        appraisalSPA -> authService "Authorization" "OAuth2/OIDC"
        inspectorSPA -> authService "Authorization" "OAuth2/OIDC"
        adminSPA     -> authService "Authorization" "OAuth2/OIDC"

        clientSPA    -> apiGateway "REST" "HTTPS"
        appraisalSPA -> apiGateway "REST" "HTTPS"
        inspectorSPA -> apiGateway "REST" "HTTPS"
        adminSPA     -> apiGateway "REST" "HTTPS"

        # ──────────────────────────────────────────
        # Relationships: Gateway → Services
        # ──────────────────────────────────────────
        apiGateway -> authService    "JWT validation"     "HTTP"
        apiGateway -> redis          "Cache"
        apiGateway -> requestService "Proxies requests"   "HTTP"
        apiGateway -> inspectService "Proxies requests"   "HTTP"
        apiGateway -> reviewService  "Proxies requests"   "HTTP"

        # ──────────────────────────────────────────
        # Relationships: Services → Databases
        # ──────────────────────────────────────────
        requestService -> requestDB "Read/write"
        inspectService -> inspectDB "Read/write"
        reviewService  -> reviewDB  "Read/write"

        # ──────────────────────────────────────────
        # Relationships: Services → Kafka (publish)
        # ──────────────────────────────────────────
        requestService -> kafka "request.created, request.status_changed" "Publish"
        inspectService -> kafka "inspect.completed"                        "Publish"
        reviewService  -> kafka "report.ready"                             "Publish"

        # ──────────────────────────────────────────
        # Relationships: Kafka → Notification
        # ──────────────────────────────────────────
        kafka -> notificationService "Consumes events"    "Subscribe"
        notificationService -> emailProvider "Send email" "SMTP"

        # ──────────────────────────────────────────
        # Relationships: File storage
        # ──────────────────────────────────────────
        inspectService -> s3 "Uploads inspection photos"
        reviewService  -> s3 "Saves generated reports"
        clientSPA      -> s3 "Downloads report"          "presigned URL"
    }

    views {
        systemContext appraisalCRM "Context" {
            include *
            autolayout lr
            title "Level 1: System Context"
        }

        container appraisalCRM "Containers" {
            include *
            autolayout lr
            title "Level 2: Container Diagram"
        }

    }

}
