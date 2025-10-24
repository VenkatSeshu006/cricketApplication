cricnet-app/
└── backend/
    ├── .gitignore
    ├── go.mod                  # Go module definition
    ├── go.sum
    ├── main.go                 # Application entry point
    ├── Dockerfile              # Docker container definition
    ├── README.md
    │
    ├── config/                 # Application configuration (env parsing, constants)
    │   └── config.go
    │
    ├── internal/               # Private application code (not meant for public import)
    │   ├── auth/                 # Authentication & Authorization service/module
    │   │   ├── delivery/         # HTTP handlers, controllers, API endpoints
    │   │   │   └── http/
    │   │   │       └── handler.go
    │   │   ├── domain/           # Core business logic, entities, interfaces
    │   │   │   ├── user.go           # User entity/model
    │   │   │   ├── repository.go     # Interface for data access
    │   │   │   └── service.go        # Interface for business logic
    │   │   ├── repository/       # Implementations of domain repository interfaces
    │   │   │   └── postgres/
    │   │   │       └── auth_repository.go
    │   │   ├── service/          # Implementations of domain service interfaces
    │   │   │   └── auth_service.go
    │   │   └── util/             # Auth-specific utilities (e.g., password hashing, JWT generation)
    │   │       └── jwt.go
    │   │
    │   ├── ground_booking/       # Ground booking service/module
    │   │   ├── delivery/
    │   │   │   └── http/
    │   │   │       └── handler.go
    │   │   ├── domain/
    │   │   │   ├── ground.go
    │   │   │   ├── booking.go
    │   │   │   ├── repository.go
    │   │   │   └── service.go
    │   │   ├── repository/
    │   │   │   └── postgres/
    │   │   │       └── booking_repository.go
    │   │   └── service/
    │   │       └── booking_service.go
    │   │
    │   ├── user_profile/         # User profile management
    │   │   └── ... (similar structure to auth)
    │   │
    │   ├── http/                 # General HTTP server setup, middleware
    │   │   ├── server.go
    │   │   └── middleware/
    │   │       └── auth_middleware.go
    │   │
    │   ├── database/             # Database connection, migration, ORM setup
    │   │   ├── postgres.go
    │   │   └── migrations/
    │   │       ├── 000001_create_users_table.up.sql
    │   │       └── 000001_create_users_table.down.sql
    │   │
    │   └── util/                 # Internal utility functions (logging, error handling)
    │       ├── logger.go
    │       └── errors.go
    │
    ├── pkg/                    # Public shared libraries (if any, safe for other projects to import)
    │   └── common_models/        # Common API response structures, shared DTOs
    │       └── api_response.go
    │
    └── cmd/                    # Entry points for different executables (if microservices)
        └── api/                  # Main API server executable
            └── main.go           # Could be main.go in root if it's a single binary