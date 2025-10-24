# CricketApp Frontend - Flutter Authentication

## 🎯 What's Implemented

### ✅ Complete Authentication System
- **Login Screen** - Email & Password authentication
- **Register Screen** - Full user registration with role selection
- **Home Screen** - Authenticated user dashboard
- **Token Management** - Secure storage using FlutterSecureStorage
- **State Management** - BLoC pattern for reactive UI

### 📁 Architecture
```
lib/
├── core/
│   ├── error/failures.dart         # Error handling
│   └── (other core utilities)
├── features/
│   └── auth/
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── auth_api_service.dart        # API calls
│       │   │   └── auth_local_datasource.dart   # Local storage
│       │   ├── models/
│       │   │   ├── user_model.dart
│       │   │   └── auth_response_model.dart
│       │   └── repositories/
│       │       └── auth_repository_impl.dart    # Repository implementation
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── user.dart
│       │   │   └── auth_tokens.dart
│       │   ├── repositories/
│       │   │   └── auth_repository.dart         # Repository interface
│       │   └── usecases/
│       │       ├── login_usecase.dart
│       │       ├── register_usecase.dart
│       │       └── logout_usecase.dart
│       ├── presentation/
│       │   ├── bloc/
│       │   │   ├── auth_bloc.dart
│       │   │   ├── auth_event.dart
│       │   │   └── auth_state.dart
│       │   └── pages/
│       │       ├── login_screen.dart
│       │       ├── register_screen.dart
│       │       └── home_screen.dart
│       └── di/
│           └── auth_injection.dart              # Dependency injection
└── main.dart
```

## 🚀 Running the App

### Prerequisites
- Flutter SDK 3.9.2+
- Backend server running on `http://localhost:8080`

### For Android Emulator
If testing on Android emulator, update the base URL in `lib/features/auth/di/auth_injection.dart`:
```dart
static const String _baseUrl = 'http://10.0.2.2:8080/api/v1'; // Android emulator
```

### For iOS Simulator / Physical Device
Update the base URL to your computer's IP address:
```dart
static const String _baseUrl = 'http://192.168.x.x:8080/api/v1'; // Replace with your IP
```

### Run Commands

1. **Install dependencies:**
```bash
flutter pub get
```

2. **Run on Chrome (Web):**
```bash
flutter run -d chrome
```

3. **Run on Android:**
```bash
flutter run -d <device-id>
```

4. **Run on Windows:**
```bash
flutter run -d windows
```

## 📱 Features

### Login Screen
- Email validation
- Password visibility toggle
- Loading state with spinner
- Error handling with snackbar
- Navigation to register screen

### Register Screen
- Full name input
- Email validation
- Phone number (optional)
- Role selection (Player, Organizer, Ground Owner)
- Password confirmation
- All fields validated
- Navigation to login screen

### Home Screen
- Display user information
- Logout functionality
- Success message
- User details card

## 🔐 Security Features
- JWT token storage in FlutterSecureStorage
- Password input obfuscation
- Secure API communication
- Token expiry handling

## 🧪 Testing the Flow

1. **Start Backend Server:**
   - Ensure PostgreSQL is running in Docker
   - Start Go backend: `cd backend && go run main.go`

2. **Run Flutter App:**
   ```bash
   cd frontend
   flutter run -d chrome
   ```

3. **Test Registration:**
   - Click "Register" on login screen
   - Fill in all details
   - Submit form
   - Should redirect to home screen

4. **Test Login:**
   - Use registered credentials
   - Submit form
   - Should redirect to home screen

5. **Test Logout:**
   - Click logout icon in app bar
   - Should redirect to login screen

## 📦 Dependencies
- **flutter_bloc** (^8.1.3) - State management
- **equatable** (^2.0.5) - Value equality
- **http** (^1.1.0) - HTTP requests
- **dartz** (^0.10.1) - Functional programming (Either)
- **shared_preferences** (^2.2.2) - Simple local storage
- **flutter_secure_storage** (^9.0.0) - Secure token storage
- **intl** (^0.19.0) - Internationalization

## 🐛 Troubleshooting

### "Connection refused" error
- Check backend is running
- Verify base URL in `auth_injection.dart`
- For Android emulator, use `10.0.2.2` instead of `localhost`

### "Network error" in app
- Ensure backend server is accessible
- Check firewall settings
- Verify API endpoint paths

### Hot reload not working
- Try hot restart (Ctrl+Shift+F5 / Cmd+Shift+F5)
- Or stop and run again

## 🎨 UI Features
- Material Design 3
- Green color scheme (cricket theme)
- Rounded input fields
- Loading indicators
- Form validation
- Responsive layout
- Error snackbars

## 🔄 Next Steps
- [ ] Add refresh token functionality
- [ ] Implement "Remember Me" feature
- [ ] Add password reset flow
- [ ] Implement profile screen
- [ ] Add image upload for profile picture
- [ ] Implement ground booking screens
- [ ] Add push notifications
