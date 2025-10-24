# 🎯 CricketApp Test Accounts

## Quick Login Credentials

### 1️⃣ Player Account (Recommended for Testing)
```
📧 Email:    test.player@cricketapp.com
🔑 Password: Cricket123!
👤 Name:     Test Player
📱 Phone:    +919876543210
🎭 Role:     player
```

### 2️⃣ Organiser Account
```
📧 Email:    organiser@cricketapp.com
🔑 Password: Organize123!
👤 Name:     Match Organiser
📱 Phone:    +919876543211
🎭 Role:     organiser
```

### 3️⃣ Umpire Account
```
📧 Email:    umpire@cricketapp.com
🔑 Password: Umpire123!
👤 Name:     Test Umpire
📱 Phone:    +919876543212
🎭 Role:     umpire
```

### 4️⃣ Commentator Account
```
📧 Email:    commentator@cricketapp.com
🔑 Password: Comment123!
👤 Name:     Test Commentator
📱 Phone:    +919876543213
🎭 Role:     commentator
```

### 5️⃣ Streamer Account
```
📧 Email:    streamer@cricketapp.com
🔑 Password: Stream123!
👤 Name:     Test Streamer
📱 Phone:    +919876543214
🎭 Role:     streamer
```

### 6️⃣ Personal Coach Account
```
📧 Email:    coach@cricketapp.com
🔑 Password: Coach123!
👤 Name:     Test Coach
📱 Phone:    +919876543215
🎭 Role:     personal_coach
```

### 7️⃣ Physio Account
```
📧 Email:    physio@cricketapp.com
🔑 Password: Physio123!
👤 Name:     Test Physio
📱 Phone:    +919876543216
🎭 Role:     physio
```

---

## 📋 Valid Roles

The following roles are accepted by the backend:
- `player` - Cricket players
- `umpire` - Match umpires
- `commentator` - Match commentators
- `streamer` - Live stream broadcasters
- `organiser` - Tournament/match organisers
- `personal_coach` - Personal cricket coaches
- `physio` - Physiotherapists

---

## 🚀 How to Use

### Frontend (Flutter Web)
1. Open http://localhost:XXXX (the port Flutter assigned)
2. You'll see the Login screen
3. Enter any email and password from above
4. Click "Login"
5. You should be redirected to the Home screen

### Testing Registration
1. Click "Register" link on login screen
2. Fill in the form with new details
3. Submit
4. Should redirect to Home screen

### Testing Logout
1. On the Home screen, click the logout icon (top-right)
2. Should redirect back to Login screen

---

## 🔍 What Was Implemented

### ✅ Backend (Go)
- User registration with validation
- User login with JWT tokens
- Password hashing with bcrypt
- PostgreSQL database integration
- RESTful API endpoints

### ✅ Frontend (Flutter)
- Login screen with validation
- Register screen with role selection
- Home screen showing user details
- BLoC state management
- Secure token storage
- Form validation
- Error handling
- Loading states

---

## 🛠️ Troubleshooting

### "Registration didn't work well"
Common issues and solutions:

1. **Network Error / Connection Refused**
   - Make sure backend server is running: `go run main.go` in backend folder
   - Check backend is accessible at http://localhost:8080
   - Verify PostgreSQL container is running: `docker ps`

2. **Email Already Exists**
   - Use a different email address
   - Or login with existing credentials

3. **Validation Errors**
   - Password must be at least 6 characters
   - Email must be valid format
   - Full name must be at least 2 characters

4. **Token/Authentication Issues**
   - Clear browser cache
   - Clear app data (for mobile)
   - Try logout and login again

### Check Backend Server
```powershell
# Check if server is running
curl http://localhost:8080/api/v1/health

# Should return:
# {"status":"success","message":"CricketApp API is running","version":"1.0.0"}
```

### Check Database
```powershell
# Check PostgreSQL container
docker ps

# Should show: cricketapp-postgres (healthy)
```

---

## 📱 Testing Flow

### Complete Test Scenario
1. ✅ Start Backend: `cd backend && go run main.go`
2. ✅ Start Frontend: `cd frontend && flutter run -d chrome`
3. ✅ Login with: `test.player@cricketapp.com` / `Cricket123!`
4. ✅ See user details on Home screen
5. ✅ Click logout icon
6. ✅ Try register a new account
7. ✅ Login with new account

---

## 🎨 App Features

### Current Features
- 🔐 **Authentication**: Login, Register, Logout
- 💾 **Data Persistence**: Tokens stored securely
- 🎭 **Role Management**: Player, Organizer, Ground Owner
- ✨ **Clean UI**: Material Design 3 with green theme
- 📱 **Responsive**: Works on web, mobile (Android/iOS)
- ⚡ **Real-time State**: BLoC pattern for reactive updates

### Coming Soon
- 🏟️ Ground Booking System
- 📺 Live Match Streaming
- 💬 Chat & Notifications
- 👥 Team Management
- 📊 Statistics & Analytics
- 🏆 Tournaments

---

## 💡 Quick Tips

1. **Use Chrome for Testing**: Best experience on Flutter web
2. **Keep Backend Running**: Don't close the terminal with `go run main.go`
3. **Hot Reload**: Press `r` in Flutter terminal for instant updates
4. **Check Network Tab**: Open DevTools to see API calls
5. **Test All Roles**: Each role will have different features later

---

**Need Help?** Check the error messages in:
- Frontend: Browser console (F12)
- Backend: Terminal where `go run main.go` is running
- Database: Docker logs `docker logs cricketapp-postgres`
