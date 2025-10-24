# 🛠️ CricketApp - Utility Scripts

This folder contains utility scripts for building, deploying, and testing the CricketApp.

---

## 📜 Available Scripts

### 🏗️ Build Scripts

#### `build_apk.ps1`
Builds a production-ready Android APK that connects to the cloud backend.

**Usage:**
```powershell
.\scripts\build_apk.ps1                # Build release APK
.\scripts\build_apk.ps1 -Clean         # Clean build
.\scripts\build_apk.ps1 -Release:$false # Build debug APK
```

**Output:** `cricketapp-release.apk` in project root

---

### 🔍 Deployment Scripts

#### `check_deployment.ps1`
Checks the status of your backend deployment on AWS EC2.

**Usage:**
```powershell
.\scripts\check_deployment.ps1                           # Interactive mode
.\scripts\check_deployment.ps1 -EC2_IP "13.233.117.234" # Check specific IP
```

**Tests:**
- Backend health check
- API endpoint availability
- EC2 connectivity
- SSH access

---

### ⚡ Application Control

#### `start_app.ps1`
Starts all application services (backend, database, etc.)

**Usage:**
```powershell
.\scripts\start_app.ps1
```

#### `stop_app.ps1`
Stops all application services.

**Usage:**
```powershell
.\scripts\stop_app.ps1
```

---

### 🧪 Testing Scripts

#### `test_application.ps1`
Runs comprehensive tests on the application.

**Usage:**
```powershell
.\scripts\test_application.ps1
```

---

## 🚀 Quick Commands

```powershell
# Navigate to project root
cd C:\Users\ASUS\Documents\CricketApp

# Build APK
.\scripts\build_apk.ps1

# Check deployment
.\scripts\check_deployment.ps1

# Start services
.\scripts\start_app.ps1

# Stop services
.\scripts\stop_app.ps1

# Run tests
.\scripts\test_application.ps1
```

---

## 📚 Related Documentation

- **Deployment:** [docs/deployment/](../docs/deployment/)
- **Testing:** [docs/testing/](../docs/testing/)
- **Project Status:** [docs/project-status/](../docs/project-status/)

---

## 💡 Tips

1. **Always run scripts from the project root directory**
2. **Use `-ErrorAction Stop` for strict error handling**
3. **Check script outputs for detailed information**
4. **Scripts are designed to be idempotent (safe to run multiple times)**

---

**Last Updated:** October 24, 2025
