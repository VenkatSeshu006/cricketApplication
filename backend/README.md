# CricketApp Backend

Go backend server for CricketApp.

## Quick Start

### Prerequisites
- Go 1.21+
- PostgreSQL 15+

### Setup

1. Install dependencies:
```bash
go mod download
```

2. Set up environment variables:
```bash
cp .env.example .env
# Edit .env with your database credentials
```

3. Create database:
```bash
createdb cricketapp
```

4. Run the server:
```bash
go run main.go
```

Server will start on http://localhost:8080

### Test the API

```bash
# Health check
curl http://localhost:8080/health
```

## Project Structure

```
backend/
├── config/          # Configuration
├── internal/        # Private application code
│   ├── database/   # Database connection
│   └── http/       # HTTP server
└── main.go         # Entry point
```
