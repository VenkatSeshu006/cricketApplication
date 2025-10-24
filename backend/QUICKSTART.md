# CricketApp Backend - Quick Start

## ✅ What's Running

- **PostgreSQL Database**: Running in Docker on port 5432
- **Backend API**: Running on http://localhost:8080

## 🧪 Test the API

### Health Check
```powershell
Invoke-WebRequest -Uri http://localhost:8080/health
```

### Using curl (if installed)
```bash
curl http://localhost:8080/health
```

## 📝 Commands

### Start PostgreSQL (Docker)
```powershell
cd backend
docker-compose up -d
```

### Stop PostgreSQL
```powershell
docker-compose down
```

### Start Backend Server
```powershell
cd backend
go run main.go
```

### Check Docker Status
```powershell
docker-compose ps
```

## 🗄️ Database Info

- **Host**: localhost
- **Port**: 5432
- **Database**: cricketapp
- **User**: postgres
- **Password**: postgres

### Connect to Database
```powershell
docker exec -it cricketapp_db psql -U postgres -d cricketapp
```

## ✅ Current Status

Your backend is LIVE and ready for development! 🚀

Next steps:
1. ✅ Build authentication service
2. ✅ Add user registration/login
3. ✅ Connect frontend
