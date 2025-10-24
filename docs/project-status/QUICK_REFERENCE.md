# 🚀 Quick Reference Card
**CricketApp - Production Deployment**

---

## 📍 Key Information

### Backend
- **URL:** http://13.233.117.234:8080
- **API:** http://13.233.117.234:8080/api/v1
- **Status:** 🟢 LIVE

### Mobile App
- **APK:** `C:\Users\ASUS\Documents\CricketApp\cricketapp-release.apk`
- **Size:** 53.68 MB
- **Version:** 1.0.0+1

---

## 🔧 Quick Commands

### Check Backend Status
```powershell
.\check_deployment.ps1
```

### Build New APK
```powershell
.\build_apk.ps1
```

### SSH to Server
```bash
ssh -i "Secret Key\cricket-app-keypair.pem" ubuntu@13.233.117.234
```

### Test Backend Health
```powershell
curl http://13.233.117.234:8080/health
```

---

## 📱 Install APK

1. Transfer `cricketapp-release.apk` to phone
2. Tap to install
3. Allow "Unknown Sources" if prompted
4. Open app and test

---

## 🧪 Test Accounts

### Register New User
```
Email: your-email@example.com
Password: Test123!
Name: Your Name
Phone: +919876543210
Role: player
```

---

## 📚 Documentation

| File | Purpose |
|------|---------|
| `PRODUCTION_READY_STATUS.md` | Complete status overview |
| `APK_TESTING_GUIDE.md` | Testing instructions |
| `docs/README.md` | Documentation index |
| `docs/api/API_QUICK_REFERENCE.md` | API endpoints |

---

## 🆘 Troubleshooting

### Backend Not Responding
```bash
# SSH into server
ssh -i "Secret Key\cricket-app-keypair.pem" ubuntu@13.233.117.234

# Check Docker
docker ps

# View logs
docker logs cricketapp_backend

# Restart if needed
cd ~/cricketapp && docker-compose restart
```

### App Connection Failed
1. Check backend is running
2. Check phone internet connection
3. Verify API URL in app
4. Check security group allows port 8080

---

## ✅ Success Checklist

- [ ] Backend running at 13.233.117.234:8080
- [ ] APK installed on phone
- [ ] User registration works
- [ ] User login works
- [ ] Profile displays correctly

---

**Need Help?** Check `PRODUCTION_READY_STATUS.md` for detailed information.
