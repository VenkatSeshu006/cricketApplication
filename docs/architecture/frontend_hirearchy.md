cricnet-app/
└── frontend/
    ├── .gitignore
    ├── pubspec.yaml            # Project dependencies and metadata
    ├── pubspec.lock
    ├── README.md
    ├── test/                   # Unit and widget tests
    │   └── ...
    ├── lib/
    │   ├── main.dart           # Entry point of the application
    │   │
    │   ├── core/               # App-wide foundational elements
    │   │   ├── constants/        # Static values (API keys, strings, colors, fonts)
    │   │   │   ├── app_constants.dart
    │   │   │   └── ui_constants.dart
    │   │   ├── error/            # Error handling models and utilities
    │   │   │   └── failures.dart
    │   │   ├── network/          # HTTP client setup, interceptors
    │   │   │   └── dio_client.dart
    │   │   ├── routes/           # Named routes and route generation
    │   │   │   └── app_router.dart
    │   │   ├── services/         # Platform-specific services (e.g., location, notifications)
    │   │   │   └── ...
    │   │   └── utils/            # General utility functions (date formatters, validators)
    │   │       └── app_utils.dart
    │   │
    │   ├── features/           # Each feature gets its own directory
    │   │   │
    │   │   ├── auth/             # User authentication (login, register, logout)
    │   │   │   ├── data/
    │   │   │   │   ├── datasources/  # Remote/local data sources
    │   │   │   │   │   └── auth_remote_datasource.dart
    │   │   │   │   └── models/       # Data models (user, token)
    │   │   │   │       └── user_model.dart
    │   │   │   ├── domain/
    │   │   │   │   ├── entities/     # Core domain entities
    │   │   │   │   │   └── user_entity.dart
    │   │   │   │   ├── repositories/ # Repository interfaces
    │   │   │   │   │   └── auth_repository.dart
    │   │   │   │   └── usecases/     # Business logic
    │   │   │   │       └── sign_in_usecase.dart
    │   │   │   ├── presentation/
    │   │   │   │   ├── bloc/         # State management (e.g., BLoC, Cubit, Provider)
    │   │   │   │   │   ├── auth_bloc.dart
    │   │   │   │   │   └── auth_event.dart
    │   │   │   │   └── pages/        # UI pages
    │   │   │   │       ├── login_page.dart
    │   │   │   │       └── signup_page.dart
    │   │   │   │   └── widgets/      # Reusable UI components specific to auth
    │   │   │   │       └── auth_form_field.dart
    │   │   │   └── di/               # Dependency injection setup for the feature
    │   │   │       └── auth_injector.dart
    │   │   │
    │   │   ├── user_profile/     # User profile viewing and editing
    │   │   │   ├── data/
    │   │   │   ├── domain/
    │   │   │   └── presentation/
    │   │   │       └── pages/
    │   │   │           └── profile_page.dart
    │   │   │
    │   │   ├── ground_booking/   # Ground discovery and booking
    │   │   │   ├── data/
    │   │   │   ├── domain/
    │   │   │   └── presentation/
    │   │   │       └── pages/
    │   │   │           └── ground_booking_page.dart
    │   │   │
    │   │   └── (other_features)/ # e.g., live_matches, physio_consult, hire_staff
    │   │       └── ...
    │   │
    │   └── shared/             # Components used across multiple features but not core
    │       ├── widgets/          # Global reusable UI widgets (buttons, loading indicators)
    │       │   ├── custom_button.dart
    │       │   └── loading_indicator.dart
    │       ├── themes/           # App themes and styles
    │       │   └── app_theme.dart
    │       └── models/           # Shared models (e.g., common API response structure)
    │           └── api_response.dart
    │
    ├── assets/                 # Static assets
    │   ├── images/
    │   │   ├── logo.png
    │   │   └── splash.png
    │   ├── icons/
    │   └── fonts/
    └── web/                    # Web-specific files (index.html)
        └── index.html