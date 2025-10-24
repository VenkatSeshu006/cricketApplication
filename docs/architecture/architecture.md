# CricketApp - System Architecture

## Table of Contents
1. [Overview](#overview)
2. [System Architecture](#system-architecture)
3. [Frontend Architecture](#frontend-architecture)
4. [Backend Architecture](#backend-architecture)
5. [Data Architecture](#data-architecture)
6. [Infrastructure Architecture](#infrastructure-architecture)
7. [Security Architecture](#security-architecture)
8. [Scalability & Performance](#scalability--performance)

---

## Overview

CricketApp follows a **microservices-inspired modular monolith** architecture with clear separation of concerns, allowing future migration to microservices if needed.

### Core Principles

- **Clean Architecture**: Separation of business logic from frameworks
- **Domain-Driven Design**: Features organized by business domains
- **API-First**: Well-defined contracts between frontend and backend
- **Real-time First**: WebSocket support for live features
- **Mobile-First**: Optimized for mobile with web/desktop support

---

## System Architecture

### High-Level Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        Client Layer                              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐        │
│  │  Mobile  │  │   Web    │  │ Desktop  │  │   API    │        │
│  │  (iOS/   │  │ (Browser)│  │(Win/Mac/ │  │ Clients  │        │
│  │ Android) │  │          │  │  Linux)  │  │          │        │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘        │
└───────┼─────────────┼─────────────┼─────────────┼──────────────┘
        │             │             │             │
        │          HTTPS / WSS      │             │
        │             │             │             │
┌───────▼─────────────▼─────────────▼─────────────▼──────────────┐
│                     API Gateway / Load Balancer                 │
│  - Rate Limiting    - Authentication Check    - Routing         │
│  - SSL Termination  - Request Logging         - CORS           │
└─────────────────────────────┬───────────────────────────────────┘
                              │
┌─────────────────────────────▼───────────────────────────────────┐
│                      Application Server (Go)                    │
│  ┌────────────┬────────────┬────────────┬────────────┐         │
│  │   Auth     │   User     │  Ground    │  Payment   │         │
│  │  Service   │  Service   │  Booking   │  Service   │         │
│  └─────┬──────┴─────┬──────┴─────┬──────┴─────┬──────┘         │
│  ┌─────▼──────┬─────▼──────┬─────▼──────┬─────▼──────┐         │
│  │  Medical   │ Streaming  │   Staff    │   Match    │         │
│  │  Service   │  Service   │   Hiring   │  Service   │         │
│  └────────────┴────────────┴────────────┴────────────┘         │
└─────────────────────────────┬───────────────────────────────────┘
                              │
┌─────────────────────────────▼───────────────────────────────────┐
│                         Data Layer                               │
│  ┌─────────────┬──────────────┬──────────────┬──────────────┐  │
│  │ PostgreSQL  │    Redis     │   MongoDB    │  S3 Storage  │  │
│  │             │              │              │              │  │
│  │  - Users    │  - Sessions  │  - Chat logs │  - Videos    │  │
│  │  - Bookings │  - Cache     │  - Analytics │  - Images    │  │
│  │  - Matches  │  - Live data │  - Logs      │  - Docs      │  │
│  └─────────────┴──────────────┴──────────────┴──────────────┘  │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    External Services                             │
│  ┌────────────┬────────────┬────────────┬────────────┐          │
│  │  Payment   │    CDN     │   Email    │   SMS      │          │
│  │  Gateway   │  (Video)   │  Service   │  Service   │          │
│  └────────────┴────────────┴────────────┴────────────┘          │
└─────────────────────────────────────────────────────────────────┘
```

---

## Frontend Architecture

### Clean Architecture Layers

```
┌─────────────────────────────────────────────────────────────────┐
│                     Presentation Layer                           │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  UI Components (Widgets)                                  │   │
│  │  - Screens / Pages                                        │   │
│  │  - Reusable Widgets                                       │   │
│  │  - Forms, Lists, Cards                                    │   │
│  └────────────────────────┬─────────────────────────────────┘   │
│  ┌────────────────────────▼─────────────────────────────────┐   │
│  │  State Management (BLoC / Riverpod)                       │   │
│  │  - Events / States                                        │   │
│  │  - UI Logic                                               │   │
│  │  - Presentation Models                                    │   │
│  └────────────────────────┬─────────────────────────────────┘   │
└─────────────────────────────┼───────────────────────────────────┘
                              │ Calls Use Cases
┌─────────────────────────────▼───────────────────────────────────┐
│                        Domain Layer                              │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Use Cases (Business Logic)                              │   │
│  │  - SignInUseCase                                          │   │
│  │  - BookGroundUseCase                                      │   │
│  │  - GetUserProfileUseCase                                  │   │
│  └────────────────────────┬─────────────────────────────────┘   │
│  ┌────────────────────────▼─────────────────────────────────┐   │
│  │  Entities (Business Models)                               │   │
│  │  - User, Match, Ground, Booking                           │   │
│  └────────────────────────┬─────────────────────────────────┘   │
│  ┌────────────────────────▼─────────────────────────────────┐   │
│  │  Repository Interfaces (Contracts)                        │   │
│  │  - IAuthRepository                                        │   │
│  │  - IGroundRepository                                      │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────┬───────────────────────────────────┘
                              │ Implemented by
┌─────────────────────────────▼───────────────────────────────────┐
│                         Data Layer                               │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Repository Implementations                               │   │
│  │  - AuthRepositoryImpl                                     │   │
│  │  - GroundRepositoryImpl                                   │   │
│  └────────────────────────┬─────────────────────────────────┘   │
│  ┌────────────────────────▼─────────────────────────────────┐   │
│  │  Data Sources                                             │   │
│  │  - Remote: API calls (Dio)                                │   │
│  │  - Local: Cache (Hive/SharedPreferences)                  │   │
│  └────────────────────────┬─────────────────────────────────┘   │
│  ┌────────────────────────▼─────────────────────────────────┐   │
│  │  Data Models (DTOs)                                       │   │
│  │  - JSON serialization                                     │   │
│  │  - API response models                                    │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

### Feature Structure

```
features/auth/
├── data/
│   ├── datasources/
│   │   ├── auth_remote_datasource.dart    # API calls
│   │   └── auth_local_datasource.dart     # Local storage
│   ├── models/
│   │   ├── user_model.dart                # JSON ↔ Dart
│   │   └── token_model.dart
│   └── repositories/
│       └── auth_repository_impl.dart      # Interface implementation
├── domain/
│   ├── entities/
│   │   └── user.dart                      # Business entity
│   ├── repositories/
│   │   └── auth_repository.dart           # Interface
│   └── usecases/
│       ├── sign_in_usecase.dart
│       ├── sign_up_usecase.dart
│       └── sign_out_usecase.dart
├── presentation/
│   ├── bloc/                              # State management
│   │   ├── auth_bloc.dart
│   │   ├── auth_event.dart
│   │   └── auth_state.dart
│   ├── pages/
│   │   ├── login_page.dart
│   │   └── signup_page.dart
│   └── widgets/
│       └── auth_form_field.dart
└── di/
    └── auth_injector.dart                 # Dependency injection
```

### State Management Flow (BLoC Pattern)

```
User Action (Button Press)
         ↓
    UI Widget
         ↓
  Dispatch Event → [AuthBloc]
                       ↓
                  Call UseCase (Domain)
                       ↓
                  Repository (Data)
                       ↓
                  Remote API / Local DB
                       ↓
                  Return Result
                       ↓
                  [AuthBloc] ← Emit State
                       ↓
                  UI Widget (Rebuild)
                       ↓
                  Display Result
```

---

## Backend Architecture

### Hexagonal Architecture (Ports & Adapters)

```
┌─────────────────────────────────────────────────────────────────┐
│                    Delivery / Adapter Layer                      │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  HTTP Handlers (Controllers)                             │   │
│  │  - auth_handler.go                                        │   │
│  │  - ground_handler.go                                      │   │
│  │  - user_handler.go                                        │   │
│  └────────────────────────┬─────────────────────────────────┘   │
│  ┌────────────────────────▼─────────────────────────────────┐   │
│  │  DTOs (Data Transfer Objects)                            │   │
│  │  - Request/Response structs                              │   │
│  │  - Validation                                             │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────┬───────────────────────────────────┘
                              │ Calls
┌─────────────────────────────▼───────────────────────────────────┐
│                          Domain Layer (Core)                     │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Services (Business Logic)                                │   │
│  │  - AuthService                                            │   │
│  │  - BookingService                                         │   │
│  │  - PaymentService                                         │   │
│  └────────────────────────┬─────────────────────────────────┘   │
│  ┌────────────────────────▼─────────────────────────────────┐   │
│  │  Domain Entities                                          │   │
│  │  - User, Ground, Booking, Match                           │   │
│  └────────────────────────┬─────────────────────────────────┘   │
│  ┌────────────────────────▼─────────────────────────────────┐   │
│  │  Repository Interfaces                                    │   │
│  │  - UserRepository                                         │   │
│  │  - GroundRepository                                       │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────┬───────────────────────────────────┘
                              │ Implemented by
┌─────────────────────────────▼───────────────────────────────────┐
│                   Infrastructure / Adapter Layer                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Repository Implementations                               │   │
│  │  - PostgresUserRepository                                 │   │
│  │  - RedisSessionRepository                                 │   │
│  └────────────────────────┬─────────────────────────────────┘   │
│  ┌────────────────────────▼─────────────────────────────────┐   │
│  │  External Adapters                                        │   │
│  │  - Database connection                                    │   │
│  │  - Payment gateway client                                 │   │
│  │  - Email service client                                   │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

### Service Module Structure

```
internal/auth/
├── delivery/
│   └── http/
│       ├── handler.go              # HTTP endpoints
│       ├── dto.go                  # Request/Response models
│       └── routes.go               # Route registration
├── domain/
│   ├── user.go                     # User entity
│   ├── repository.go               # Repository interface
│   └── service.go                  # Service interface
├── service/
│   └── auth_service.go             # Business logic implementation
├── repository/
│   └── postgres/
│       └── auth_repository.go      # Database implementation
└── util/
    ├── jwt.go                      # JWT utilities
    └── password.go                 # Password hashing
```

### Request Flow

```
HTTP Request
     ↓
Router (Chi/Gin)
     ↓
Middleware (Auth, Logging, CORS)
     ↓
Handler (Validation, DTO mapping)
     ↓
Service (Business Logic)
     ↓
Repository (Data Access)
     ↓
Database / External Service
     ↓
Return Result (Error handling)
     ↓
Handler (Response mapping)
     ↓
HTTP Response (JSON)
```

---

## Data Architecture

### Database Schema (PostgreSQL)

#### Core Tables

```sql
-- Users table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(50) NOT NULL, -- player, coach, ground_owner, doctor, umpire
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP,
    is_verified BOOLEAN DEFAULT FALSE,
    profile_picture_url TEXT
);

-- User profiles (polymorphic based on role)
CREATE TABLE player_profiles (
    user_id UUID PRIMARY KEY REFERENCES users(id),
    batting_style VARCHAR(50),
    bowling_style VARCHAR(50),
    playing_role VARCHAR(50),
    teams JSONB,
    stats JSONB
);

CREATE TABLE coach_profiles (
    user_id UUID PRIMARY KEY REFERENCES users(id),
    specialization VARCHAR(100),
    experience_years INT,
    certifications JSONB,
    hourly_rate DECIMAL(10,2)
);

-- Grounds
CREATE TABLE grounds (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID REFERENCES users(id),
    name VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    facilities JSONB, -- [floodlights, pavilion, parking, etc.]
    pricing JSONB,    -- {hourly: 1000, daily: 8000}
    images TEXT[],
    created_at TIMESTAMP DEFAULT NOW()
);

-- Bookings
CREATE TABLE bookings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ground_id UUID REFERENCES grounds(id),
    user_id UUID REFERENCES users(id),
    booking_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    status VARCHAR(50) DEFAULT 'pending', -- pending, confirmed, cancelled
    amount DECIMAL(10,2) NOT NULL,
    payment_id VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Matches
CREATE TABLE matches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ground_id UUID REFERENCES grounds(id),
    team1_id UUID,
    team2_id UUID,
    match_date TIMESTAMP NOT NULL,
    match_type VARCHAR(50), -- T20, ODI, Test
    status VARCHAR(50) DEFAULT 'scheduled',
    live_stream_url TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Medical consultations
CREATE TABLE consultations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    doctor_id UUID REFERENCES users(id),
    patient_id UUID REFERENCES users(id),
    appointment_time TIMESTAMP NOT NULL,
    status VARCHAR(50) DEFAULT 'scheduled',
    consultation_type VARCHAR(50), -- text, video
    notes TEXT,
    prescription TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);
```

### Redis Data Structures

```
# User sessions
session:{user_id} → {token, expires_at, device_info}

# Live match data
match:{match_id}:score → {runs, wickets, overs, current_batsmen}

# Real-time cache
cache:grounds:nearby:{lat}:{lng} → [ground_ids]

# Rate limiting
ratelimit:{user_id}:{endpoint} → request_count (TTL: 1 minute)
```

### MongoDB Collections

```javascript
// Chat messages
{
  _id: ObjectId,
  match_id: "uuid",
  user_id: "uuid",
  message: "string",
  timestamp: ISODate,
  reactions: []
}

// Analytics logs
{
  _id: ObjectId,
  event_type: "page_view" | "match_view" | "booking_attempt",
  user_id: "uuid",
  metadata: {},
  timestamp: ISODate
}
```

---

## Infrastructure Architecture

### Container Architecture (Docker)

```yaml
version: '3.8'

services:
  # API Server
  api:
    build: ./backend
    ports:
      - "8080:8080"
    depends_on:
      - postgres
      - redis
    environment:
      - DB_HOST=postgres
      - REDIS_HOST=redis

  # PostgreSQL
  postgres:
    image: postgres:15
    volumes:
      - postgres_data:/var/lib/postgresql/data
    environment:
      - POSTGRES_DB=cricketapp
      - POSTGRES_USER=admin
      - POSTGRES_PASSWORD=secret

  # Redis
  redis:
    image: redis:7-alpine
    volumes:
      - redis_data:/data

  # nginx (Reverse Proxy)
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    depends_on:
      - api
```

### Deployment Architecture (Cloud)

```
┌─────────────────────────────────────────────────────────────┐
│                      Users (Global)                          │
└────────────────────────┬────────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────┐
│                    CloudFlare CDN                            │
│              (Static Assets, Video Streaming)                │
└────────────────────────┬────────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────┐
│                  Load Balancer (AWS ALB)                     │
└───┬──────────────────┬──────────────────┬──────────────────┘
    │                  │                  │
┌───▼────┐      ┌──────▼──────┐      ┌───▼────┐
│  API   │      │    API      │      │  API   │
│Server 1│      │  Server 2   │      │Server 3│
│(Docker)│      │  (Docker)   │      │(Docker)│
└───┬────┘      └──────┬──────┘      └───┬────┘
    │                  │                  │
    └──────────────────┼──────────────────┘
                       │
    ┌──────────────────┼──────────────────┐
    │                  │                  │
┌───▼────────┐  ┌──────▼──────┐  ┌───────▼──────┐
│PostgreSQL  │  │    Redis    │  │  S3 Storage  │
│(RDS Master)│  │  (ElastiC.) │  │   (Media)    │
│     +      │  │             │  │              │
│Read Replica│  │             │  │              │
└────────────┘  └─────────────┘  └──────────────┘
```

---

## Security Architecture

### Authentication Flow (JWT)

```
1. User Login
   ↓
2. Backend validates credentials
   ↓
3. Generate JWT tokens:
   - Access Token (15 min)
   - Refresh Token (7 days)
   ↓
4. Store refresh token in Redis
   ↓
5. Return tokens to client
   ↓
6. Client stores tokens (secure storage)
   ↓
7. Include access token in API requests
   ↓
8. Backend validates token on each request
   ↓
9. If expired, use refresh token to get new access token
```

### Security Layers

```
┌─────────────────────────────────────────────────────────┐
│  1. Network Security                                     │
│     - HTTPS only (TLS 1.3)                              │
│     - WAF (Web Application Firewall)                    │
│     - DDoS protection                                   │
└───────────────────┬─────────────────────────────────────┘
┌───────────────────▼─────────────────────────────────────┐
│  2. API Gateway                                          │
│     - Rate limiting                                      │
│     - IP whitelisting/blacklisting                      │
│     - Request validation                                │
└───────────────────┬─────────────────────────────────────┘
┌───────────────────▼─────────────────────────────────────┐
│  3. Authentication & Authorization                       │
│     - JWT validation                                     │
│     - Role-based access control (RBAC)                  │
│     - Multi-factor authentication (future)              │
└───────────────────┬─────────────────────────────────────┘
┌───────────────────▼─────────────────────────────────────┐
│  4. Application Security                                 │
│     - Input sanitization                                 │
│     - SQL injection prevention (prepared statements)    │
│     - XSS prevention                                     │
│     - CSRF protection                                    │
└───────────────────┬─────────────────────────────────────┘
┌───────────────────▼─────────────────────────────────────┐
│  5. Data Security                                        │
│     - Password hashing (bcrypt)                          │
│     - Encryption at rest                                 │
│     - Encryption in transit                              │
│     - Database access controls                           │
└─────────────────────────────────────────────────────────┘
```

---

## Scalability & Performance

### Horizontal Scaling Strategy

```
Load Distribution:
- API servers: Auto-scaling based on CPU/Memory (3-10 instances)
- Database: Read replicas for queries, master for writes
- Cache: Redis cluster with replication
- File storage: CDN for global distribution
```

### Performance Optimization

```
1. Caching Strategy:
   - Browser cache (static assets): 1 year
   - CDN cache (images/videos): 1 month
   - API cache (Redis): 5-60 minutes depending on data
   - Database query cache: Enabled

2. Database Optimization:
   - Indexes on frequently queried columns
   - Query optimization (EXPLAIN ANALYZE)
   - Connection pooling (max 100 connections)
   - Partitioning for large tables (match stats)

3. API Optimization:
   - Pagination (default: 20 items per page)
   - Field selection (GraphQL-style)
   - Gzip compression for responses
   - HTTP/2 for multiplexing

4. Frontend Optimization:
   - Code splitting (lazy loading)
   - Image optimization (WebP format)
   - Asset minification
   - Service workers for offline support
```

### Monitoring & Observability

```
┌──────────────────────────────────────────────────────────┐
│  Application Metrics (Prometheus)                        │
│  - Request rate, latency, error rate                     │
│  - Database connection pool status                       │
│  - Cache hit/miss ratio                                  │
└────────────────────┬─────────────────────────────────────┘
┌────────────────────▼─────────────────────────────────────┐
│  Visualization (Grafana)                                  │
│  - Real-time dashboards                                  │
│  - Alerts for anomalies                                  │
└────────────────────┬─────────────────────────────────────┘
┌────────────────────▼─────────────────────────────────────┐
│  Logging (ELK Stack)                                      │
│  - Centralized logs                                       │
│  - Error tracking                                         │
│  - Audit logs                                             │
└──────────────────────────────────────────────────────────┘
┌──────────────────────────────────────────────────────────┐
│  Distributed Tracing (Jaeger)                            │
│  - Request flow visualization                             │
│  - Performance bottleneck identification                 │
└──────────────────────────────────────────────────────────┘
```

---

## Future Enhancements

1. **Microservices Migration**: Break down monolith into independent services
2. **Event-Driven Architecture**: Use message queues (Kafka) for async processing
3. **GraphQL API**: Alternative to REST for flexible data fetching
4. **Server-Side Rendering**: For better SEO (web version)
5. **Edge Computing**: Process video at the edge for lower latency
6. **AI/ML Pipeline**: Separate service for model training and inference

---

**Last Updated:** October 20, 2025  
**Version:** 1.0  
**Status:** Initial Architecture Design
