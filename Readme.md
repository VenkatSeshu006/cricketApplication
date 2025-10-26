# 🏏 CricketApp.(https://github.com/VenkatSeshu006/cricketApplication) - Unified Cricket Ecosystem Platform

> **A comprehensive platform connecting players, coaches, ground owners, medical professionals, and cricket enthusiasts.**

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2-02569B?logo=flutter)](https://flutter.dev)
[![Go](https://img.shields.io/badge/Go-1.21+-00ADD8?logo=go)](https://golang.org)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Development Roadmap](#development-roadmap)
- [Documentation](#documentation)
- [Contributing](#contributing)

---

## 🎯 Overview

CricketApp is designed to be the **one-stop solution** for the entire cricket ecosystem, bringing together:

- 🏏 **Players & Teams** - Profile management, networking, performance tracking
- 👨‍🏫 **Coaches & Trainers** - Offer services, manage teams, share insights
- 🏟️ **Ground Owners** - List facilities, manage bookings, revenue tracking
- 🩺 **Medical Professionals** - Consultations, injury management, health tracking
- 👔 **Umpires & Staff** - Job marketplace, scheduling, certification
- 📺 **Fans & Spectators** - Live streaming, match updates, community engagement

### Vision

To create a **synchronized, real-time platform** that seamlessly connects all stakeholders in the cricket world, from grassroots to professional levels.

---

## ✨ Features

### Phase 1 - Core Platform (In Development)

#### 🔐 Authentication & User Management
- Multi-role user registration (player, coach, ground owner, doctor, umpire)
- JWT-based secure authentication
- Profile creation and management
- Role-based access control
- User search and networking

#### 🏟️ Ground Booking System
- Ground discovery with filters (location, facilities, pricing)
- Real-time availability calendar
- Instant booking and payment processing
- Booking history and management
- Ground owner dashboard

### Phase 2 - Advanced Features (Planned)

#### 📺 Live Match Streaming
- **Video Streaming**: RTMP ingestion, HLS/DASH delivery via CDN
- **Real-time Scoring**: Live scoreboard with WebSocket updates
- **Interactive Chat**: Match commentary and fan discussions
- **Multi-camera Views**: Different angles and replay options

#### 🩺 Medical Consultations
- Doctor/physiotherapist profiles and specializations
- Appointment scheduling system
- Secure text and video consultations (WebRTC)
- Injury history and medical records (with consent)
- Prescription and recovery plan management

#### 👔 Staff Hiring Marketplace
- Job postings for coaches, umpires, statisticians, ground staff
- Skill-based matching algorithm
- Application management system
- Ratings and reviews
- Contract and payment handling

### Phase 3 - AI & Analytics (Future)

- **Player Performance Analytics**: AI-powered insights from match data
- **Injury Prediction**: ML models to predict injury risks
- **Match Recommendations**: Personalized content for fans
- **Smart Scheduling**: Optimal match and ground scheduling
- **Video Analysis**: Computer vision for technique analysis

---

## 🏗️ Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Flutter Frontend                        │
│  (Mobile - iOS/Android, Web, Desktop - Windows/Mac/Linux)  │
└─────────────────┬───────────────────────────────────────────┘
                  │ REST API / GraphQL / WebSockets
┌─────────────────▼───────────────────────────────────────────┐
│                    API Gateway / Load Balancer              │
└─────────────────┬───────────────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────────────┐
│                   Go Backend Services                        │
│  ┌──────────┬──────────┬──────────┬──────────┬──────────┐  │
│  │   Auth   │  User    │ Ground   │ Medical  │ Streaming│  │
│  │ Service  │ Service  │ Booking  │ Service  │ Service  │  │
│  └────┬─────┴────┬─────┴────┬─────┴────┬─────┴────┬─────┘  │
└───────┼──────────┼──────────┼──────────┼──────────┼────────┘
        │          │          │          │          │
┌───────▼──────────▼──────────▼──────────▼──────────▼────────┐
│                     Data Layer                              │
│  ┌─────────────┬──────────────┬───────────┬──────────────┐ │
│  │ PostgreSQL  │    Redis     │  MongoDB  │  S3/Storage  │ │
│  │ (Relational)│   (Cache)    │   (Logs)  │   (Media)    │ │
│  └─────────────┴──────────────┴───────────┴──────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### Frontend Architecture (Clean Architecture)

```
┌────────────────────────────────────────────────────────┐
│                 Presentation Layer                      │
│           (UI, Widgets, BLoC/State Management)         │
└───────────────────────┬────────────────────────────────┘
                        │ Uses
┌───────────────────────▼────────────────────────────────┐
│                   Domain Layer                          │
│          (Business Logic, Entities, Use Cases)         │
└───────────────────────┬────────────────────────────────┘
                        │ Depends on
┌───────────────────────▼────────────────────────────────┐
│                    Data Layer                           │
│        (Repositories, Data Sources, Models)            │
└────────────────────────────────────────────────────────┘
```

### Backend Architecture (Hexagonal/Ports & Adapters)

```
┌──────────────────────────────────────────────────────────┐
│                  Delivery Layer (HTTP)                   │
│               (Controllers, Handlers, DTOs)              │
└─────────────────────────┬────────────────────────────────┘
                          │ Calls
┌─────────────────────────▼────────────────────────────────┐
│                   Domain Layer (Core)                    │
│         (Business Logic, Entities, Interfaces)           │
└─────────────────────────┬────────────────────────────────┘
                          │ Implemented by
┌─────────────────────────▼────────────────────────────────┐
│            Infrastructure Layer (Adapters)               │
│        (Database, External APIs, File Storage)           │
└──────────────────────────────────────────────────────────┘
```

---

## 🛠️ Tech Stack

### Frontend
- **Framework**: Flutter 3.9.2+ (Dart)
- **State Management**: BLoC / Riverpod (to be implemented)
- **HTTP Client**: Dio (to be added)
- **Local Storage**: Hive / SharedPreferences (to be added)
- **Navigation**: GoRouter / Auto Route (to be added)
- **Video**: video_player, flutter_webrtc (planned)
- **Real-time**: socket_io_client / web_socket_channel (planned)

### Backend
- **Language**: Go 1.21+
- **Framework**: Chi / Gin / Echo (to be decided)
- **Database**: PostgreSQL 15+
- **Cache**: Redis 7+
- **Message Queue**: RabbitMQ / Kafka (planned)
- **API Documentation**: Swagger/OpenAPI (planned)

### DevOps & Infrastructure
- **Containerization**: Docker, Docker Compose
- **CI/CD**: GitHub Actions (planned)
- **Cloud Provider**: AWS / GCP / Azure (to be decided)
- **CDN**: CloudFlare / AWS CloudFront (for streaming)
- **Monitoring**: Prometheus, Grafana (planned)
- **Logging**: ELK Stack (planned)

---

## 📁 Project Structure

```
CricketApp/
├── README.md                      # This file
├── PROJECT_STATUS_REPORT.md       # Current status and analysis
├── docs/                          # Documentation
│   ├── api_spec.md               # API endpoints specification
│   ├── architecture.md           # Detailed architecture diagrams
│   ├── backend_hirearchy.md      # Backend folder structure
│   └── frontend_hirearchy.md     # Frontend folder structure
│
├── frontend/                      # Flutter application
│   ├── lib/
│   │   ├── main.dart             # App entry point
│   │   ├── core/                 # Core utilities
│   │   │   ├── constants/        # App constants
│   │   │   ├── error/            # Error handling
│   │   │   ├── network/          # HTTP client
│   │   │   ├── routes/           # Navigation
│   │   │   └── utils/            # Helper functions
│   │   ├── features/             # Feature modules
│   │   │   ├── auth/             # Authentication
│   │   │   ├── user_profile/     # User profiles
│   │   │   ├── ground_booking/   # Ground booking
│   │   │   └── ...               # Other features
│   │   └── shared/               # Shared components
│   │       ├── models/           # Common models
│   │       ├── themes/           # App theming
│   │       └── widgets/          # Reusable widgets
│   ├── test/                     # Unit & widget tests
│   ├── pubspec.yaml              # Dependencies
│   └── ...
│
├── backend/                       # Go backend (to be implemented)
│   ├── cmd/                      # Application entry points
│   ├── internal/                 # Private application code
│   │   ├── auth/                 # Auth service
│   │   ├── ground_booking/       # Booking service
│   │   ├── user_profile/         # User service
│   │   ├── http/                 # HTTP server setup
│   │   └── database/             # Database utilities
│   ├── pkg/                      # Public libraries
│   ├── config/                   # Configuration
│   ├── go.mod                    # Go modules
│   ├── Dockerfile                # Docker setup
│   └── ...
│
└── tools/                         # Development tools
    └── gen_certs.sh              # SSL certificate generation
```

For detailed structure, see:
- [Frontend Hierarchy](docs/frontend_hirearchy.md)
- [Backend Hierarchy](docs/backend_hirearchy.md)

---

## 🚀 Getting Started

### Prerequisites

#### For Frontend Development
- **Flutter SDK**: 3.9.2 or higher
- **Dart**: 3.0+
- **IDE**: VS Code / Android Studio with Flutter plugin
- **Mobile Emulators**: Android Studio / Xcode (for iOS)

#### For Backend Development (Coming Soon)
- **Go**: 1.21 or higher
- **PostgreSQL**: 15+
- **Redis**: 7+
- **Docker**: 20.10+ (recommended)

### Installation

#### 1. Clone the Repository
```bash
git clone https://github.com/your-org/cricket-app.git
cd cricket-app
```

#### 2. Frontend Setup

```bash
cd frontend

# Install dependencies
flutter pub get

# Run code generation (if needed)
flutter pub run build_runner build

# Check for issues
flutter doctor

# Run on desired platform
flutter run -d chrome        # Web
flutter run -d macos         # macOS
flutter run                  # Connected device/emulator
```

#### 3. Backend Setup (Placeholder - Coming Soon)

```bash
cd backend

# Initialize Go modules
go mod download

# Set up environment variables
cp .env.example .env

# Run database migrations
make migrate-up

# Start the server
go run cmd/api/main.go
```

### Running the App

**Development Mode:**
```bash
# Frontend
cd frontend
flutter run --dart-define=ENV=dev

# Backend (when ready)
cd backend
go run main.go
```

**Production Build:**
```bash
# Android APK
flutter build apk --release

# iOS IPA
flutter build ipa --release

# Web
flutter build web --release

# Desktop (Windows)
flutter build windows --release
```

---

## 📊 Development Roadmap

### Current Status: **Phase 0 - Foundation** ✅

| Phase | Status | Duration | Description |
|-------|--------|----------|-------------|
| **Phase 0** | ✅ In Progress | 2 weeks | Project setup, architecture, documentation |
| **Phase 1** | ⏳ Next | 4 weeks | Auth, user management, core infrastructure |
| **Phase 2** | 📅 Planned | 6 weeks | Ground booking, basic features |
| **Phase 3** | 📅 Planned | 8 weeks | Live streaming, real-time features |
| **Phase 4** | 📅 Planned | 4 weeks | Medical consultations, staff hiring |
| **Phase 5** | 🔮 Future | TBD | AI features, advanced analytics |

### Detailed Roadmap

See [PROJECT_STATUS_REPORT.md](PROJECT_STATUS_REPORT.md) for comprehensive timeline and tasks.

---

## 📚 Documentation

Comprehensive documentation is available in the `/docs` directory:

### Core Documentation
- **[Documentation Index](docs/README.md)** - Complete documentation navigation
- **[API Specification](docs/api/api_spec.md)** - REST API endpoints (70+ endpoints)
- **[API Quick Reference](docs/api/API_QUICK_REFERENCE.md)** - Quick API guide
- **[Architecture Guide](docs/architecture/architecture.md)** - System design and patterns
- **[Frontend Structure](docs/architecture/frontend_hirearchy.md)** - Flutter project organization
- **[Backend Structure](docs/architecture/backend_hirearchy.md)** - Go service architecture

### Deployment & Operations
- **[Cloud Deployment](docs/deployment/CLOUD_DEPLOYMENT_GUIDE.md)** - AWS deployment guide
- **[DevOps Tutorial](docs/deployment/DEVOPS_DEPLOYMENT_TUTORIAL.md)** - Complete DevOps tutorial
- **[Quick Setup](docs/deployment/QUICK_CLOUD_SETUP.md)** - Quick cloud setup

### Testing & Status
- **[APK Testing Guide](docs/testing/APK_TESTING_GUIDE.md)** - Mobile app testing
- **[Test Accounts](docs/testing/TEST_ACCOUNTS.md)** - Test credentials
- **[Production Status](docs/project-status/PRODUCTION_READY_STATUS.md)** - Current deployment status
- **[Quick Reference](docs/project-status/QUICK_REFERENCE.md)** - Quick commands

### Utility Scripts
All utility scripts are in the `/scripts` directory:
- `build_apk.ps1` - Build Android APK
- `check_deployment.ps1` - Check backend status
- `start_app.ps1` / `stop_app.ps1` - Control services

**See [scripts/README.md](scripts/README.md) for details**

---

## 🚀 Production Status

**Current Status:** ✅ PRODUCTION READY

| Component | Status | Details |
|-----------|--------|---------|
| Backend | 🟢 LIVE | AWS EC2: 13.233.117.234:8080 |
| Database | 🟢 RUNNING | PostgreSQL 15 |
| Frontend | ✅ BUILT | cricketapp-release.apk (53.68 MB) |
| Documentation | ✅ COMPLETE | Organized in /docs |

**Quick Commands:**
```powershell
# Build APK
.\scripts\build_apk.ps1

# Check deployment
.\scripts\check_deployment.ps1

# Start/Stop services
.\scripts\start_app.ps1
.\scripts\stop_app.ps1
```

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Guidelines

- Follow clean architecture principles
- Write unit tests for business logic
- Document public APIs and complex logic
- Use conventional commits
- Run linters before committing

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Team

- **Project Lead**: [Your Name]
- **Frontend**: Flutter Team
- **Backend**: Go Team
- **DevOps**: Infrastructure Team

---

## 📞 Contact

- **Email**: support@cricketapp.com
- **Website**: https://cricketapp.com (coming soon)
- **Discord**: [Join our community](https://discord.gg/cricketapp)

---

## 🙏 Acknowledgments

- Flutter team for the amazing cross-platform framework
- Go community for excellent backend tools
- Open source contributors

---

<div align="center">

**Built with ❤️ for the cricket community**

[⬆ Back to Top](#-cricketapp---unified-cricket-ecosystem-platform)

</div>
