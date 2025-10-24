# 📱 APK Testing Guide
**Build Date:** October 24, 2025  
**APK Version:** 1.0.0+1  
**Backend:** AWS EC2 (13.233.117.234:8080)

---

## ✅ Build Status

**APK Details:**
- **Location:** `C:\Users\ASUS\Documents\CricketApp\cricketapp-release.apk`
- **Size:** 53.68 MB
- **Type:** Release (Production)
- **Backend URL:** http://13.233.117.234:8080/api/v1
- **Status:** ✅ Successfully Built

**Backend Status:**
- **IP:** 13.233.117.234
- **Port:** 8080
- **Status:** ✅ LIVE
- **Health:** ✅ Responding

---

## 📲 Installation Methods

### Method 1: Direct File Transfer (Easiest)

1. **Copy APK to Phone:**
   - Connect phone via USB
   - Copy `cricketapp-release.apk` to phone's Downloads folder
   - OR send via WhatsApp/Telegram to yourself
   - OR upload to Google Drive and download on phone

2. **Install on Phone:**
   - Open "Files" or "My Files" app on phone
   - Navigate to Downloads folder
   - Tap on `cricketapp-release.apk`
   - Tap "Install" (you may need to allow "Install from Unknown Sources")
   - Wait for installation
   - Tap "Open"

### Method 2: ADB Installation (For Developers)

```powershell
# 1. Enable USB Debugging on phone (Settings > Developer Options > USB Debugging)
# 2. Connect phone via USB
# 3. Run this command:

adb install "C:\Users\ASUS\Documents\CricketApp\cricketapp-release.apk"
```

### Method 3: Flutter Install (If phone is connected)

```powershell
cd C:\Users\ASUS\Documents\CricketApp\frontend
flutter install
```

---

## 🧪 Testing Checklist

### Pre-Testing Setup

- [ ] Backend is running at http://13.233.117.234:8080
- [ ] Phone has internet connection (WiFi or Mobile Data)
- [ ] Phone can access internet freely
- [ ] APK is installed on phone

### Test 1: App Launch
- [ ] App icon appears on home screen
- [ ] App launches without crashing
- [ ] Splash screen appears (if any)
- [ ] Welcome/Login screen loads

### Test 2: Backend Connectivity
- [ ] App connects to backend
- [ ] No "Network Error" or "Connection Failed" messages
- [ ] API calls succeed

### Test 3: User Registration
```
Test Account 1:
Email: test1@cricketapp.com
Password: Test123!
Name: Test User 1
Phone: +919876543210
Role: player
```

**Steps:**
1. [ ] Open app
2. [ ] Tap "Register" or "Sign Up"
3. [ ] Fill in registration form
4. [ ] Submit registration
5. [ ] Verify success message
6. [ ] Check if redirected to login or home

**Expected Result:**
- ✅ Registration successful
- ✅ User account created
- ✅ Can proceed to next screen

### Test 4: User Login
```
Use the account you just created:
Email: test1@cricketapp.com
Password: Test123!
```

**Steps:**
1. [ ] Enter email and password
2. [ ] Tap "Login"
3. [ ] Wait for authentication
4. [ ] Verify successful login

**Expected Result:**
- ✅ Login successful
- ✅ JWT token received
- ✅ Redirected to home screen

### Test 5: Profile Access
1. [ ] Navigate to profile screen
2. [ ] Verify user details display correctly
3. [ ] Check profile data matches registration

### Test 6: Network Error Handling
1. [ ] Turn off WiFi/Mobile Data
2. [ ] Try to perform an action
3. [ ] Verify error message appears
4. [ ] Turn internet back on
5. [ ] Verify app recovers

---

## 🐛 Common Issues & Solutions

### Issue 1: "App Not Installed"
**Solution:**
- Uninstall any previous version of the app
- Clear cache: Settings > Apps > Package Installer > Clear Cache
- Try installing again

### Issue 2: "Parse Error"
**Solution:**
- APK file might be corrupted during transfer
- Re-copy the APK file
- Make sure you're copying the correct file

### Issue 3: "Network Error" or "Connection Failed"
**Solution:**
- Check if backend is running: http://13.233.117.234:8080/health
- Check phone's internet connection
- Check if phone can access external IPs (not on restricted network)
- Try pinging: `ping 13.233.117.234` from another device

### Issue 4: "Unable to Connect to Server"
**Solution:**
- Verify backend URL in app
- Check EC2 security group allows port 8080 from anywhere (0.0.0.0/0)
- Restart backend if needed

### Issue 5: App Crashes on Launch
**Solution:**
- Check if your Android version is supported (Android 5.0+)
- Clear app data: Settings > Apps > CricketApp > Clear Data
- Reinstall the app

---

## 📝 Test Results Template

```
Date: ___________________
Tester: ___________________
Phone Model: ___________________
Android Version: ___________________

Test Results:
[ ] App Installation: PASS / FAIL
[ ] App Launch: PASS / FAIL
[ ] Backend Connection: PASS / FAIL
[ ] User Registration: PASS / FAIL
[ ] User Login: PASS / FAIL
[ ] Profile View: PASS / FAIL

Notes:
_________________________________
_________________________________
_________________________________

Backend Response Times:
- Registration: _____ ms
- Login: _____ ms
- Profile Load: _____ ms

Issues Found:
1. _________________________________
2. _________________________________
3. _________________________________
```

---

## 🔍 Debugging

### View Backend Logs (SSH into EC2)
```bash
ssh -i "C:\Users\ASUS\Documents\CricketApp\Secret Key\cricket-app-keypair.pem" ubuntu@13.233.117.234

# View logs
docker logs cricketapp_backend

# View live logs
docker logs -f cricketapp_backend

# Restart backend if needed
cd ~/cricketapp
docker-compose restart
```

### Check Backend Health
```powershell
# From your computer
curl http://13.233.117.234:8080/health

# Should return:
# {"message":"CricketApp API is running","status":"success","version":"1.0.0"}
```

### Test Specific Endpoints
```powershell
# Test registration endpoint
Invoke-WebRequest -Uri "http://13.233.117.234:8080/api/v1/auth/register" -Method POST -ContentType "application/json" -Body '{"email":"test@test.com","password":"Test123!","full_name":"Test User","phone":"+919999999999","role":"player"}'
```

---

## 🚀 Next Features to Test

Once basic functionality works:

1. **Ground Booking:**
   - [ ] View available grounds
   - [ ] Book a ground
   - [ ] View booking history

2. **Match Management:**
   - [ ] Create a match
   - [ ] View match details
   - [ ] Update match score

3. **Community Features:**
   - [ ] View community feed
   - [ ] Create a post
   - [ ] Like/comment on posts

4. **Tournament Features:**
   - [ ] Create tournament
   - [ ] Join tournament
   - [ ] View tournament brackets

---

## 📞 Support

**Documentation:**
- Backend API: `docs/api/API_QUICK_REFERENCE.md`
- Architecture: `docs/architecture/architecture.md`
- Deployment: `CLOUD_DEPLOYMENT_GUIDE.md`

**Scripts:**
- Check Deployment: `.\check_deployment.ps1`
- Build APK: `.\build_apk.ps1`
- Test Backend: `.\backend\test_auth.ps1`

---

## ✅ Success Criteria

The APK is considered **successfully tested** when:

1. ✅ App installs without errors
2. ✅ App launches and runs smoothly
3. ✅ User can register a new account
4. ✅ User can login successfully
5. ✅ User can view their profile
6. ✅ All API calls to backend succeed
7. ✅ No crashes or major bugs

---

**Happy Testing! 🎉**

If you encounter any issues, check the troubleshooting section or review the backend logs.
