# Firebase Crashlytics Setup

Firebase Crashlytics has been successfully implemented in your Flutter app. This document explains how to use it and what has been configured.

## What's Been Added

### 1. Dependencies
- `firebase_crashlytics: ^4.0.8` added to `pubspec.yaml`

### 2. Android Configuration
- Added Crashlytics Gradle plugin to `android/build.gradle`
- Added Crashlytics plugin to `android/app/build.gradle`

### 3. Code Implementation
- **Main.dart**: Automatic crash reporting setup
- **CrashlyticsService**: Utility class for easy Crashlytics usage
- **ApiService**: Enhanced error logging for API calls

## How to Use Crashlytics

### Automatic Crash Reporting
The app automatically captures:
- Unhandled Flutter errors
- Platform errors
- Fatal crashes

### Manual Error Logging

#### 1. Log Non-Fatal Errors
```dart
try {
  // Your code here
} catch (e, stackTrace) {
  await CrashlyticsService.logError(e, stackTrace);
}
```

#### 2. Log Fatal Errors
```dart
try {
  // Your code here
} catch (e, stackTrace) {
  await CrashlyticsService.logFatalError(e, stackTrace);
}
```

#### 3. Set User Information
```dart
// Set user ID for crash reports
await CrashlyticsService.setUserIdentifier('user123');

// Set custom key-value pairs
await CrashlyticsService.setCustomKey('user_type', 'premium');
await CrashlyticsService.setCustomKey('app_version', '1.0.0');
```

#### 4. Log Custom Messages
```dart
await CrashlyticsService.log('User completed onboarding');
```

#### 5. Enable/Disable Collection
```dart
// Enable crash collection
await CrashlyticsService.setCrashlyticsCollectionEnabled(true);

// Disable crash collection (e.g., for debug builds)
await CrashlyticsService.setCrashlyticsCollectionEnabled(false);
```

## Best Practices

### 1. User Identification
Set user ID when user logs in:
```dart
// In your login service
await CrashlyticsService.setUserIdentifier(user.id);
```

### 2. Custom Keys
Add relevant context to crash reports:
```dart
await CrashlyticsService.setCustomKey('screen_name', 'home_page');
await CrashlyticsService.setCustomKey('user_role', 'admin');
```

### 3. Error Context
Always include stack trace when logging errors:
```dart
try {
  // Your code
} catch (e, stackTrace) {
  await CrashlyticsService.logError(e, stackTrace);
  // Add context
  await CrashlyticsService.setCustomKey('operation', 'data_fetch');
}
```

### 4. Debug vs Release
Consider disabling Crashlytics in debug mode:
```dart
// In main.dart
await CrashlyticsService.setCrashlyticsCollectionEnabled(
  !kDebugMode // Only enable in release mode
);
```

## Viewing Crash Reports

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Navigate to **Crashlytics** in the left sidebar
4. View crash reports, trends, and user impact

## Testing Crashlytics

### Test Fatal Crash
```dart
// This will cause a crash and send report to Crashlytics
FirebaseCrashlytics.instance.crash();
```

### Test Non-Fatal Error
```dart
// This will log an error without crashing
FirebaseCrashlytics.instance.recordError(
  Exception('Test error'),
  StackTrace.current,
);
```

## API Service Integration

The API service has been enhanced to automatically log errors to Crashlytics with context:
- API endpoint being called
- HTTP method used
- Full error details and stack trace

This helps identify API-related issues quickly.

## Troubleshooting

### Common Issues

1. **Crashes not appearing**: Ensure you're testing on a release build
2. **Missing user data**: Make sure to set user identifier after login
3. **No custom keys**: Verify you're calling `setCustomKey` before the crash occurs

### Debug Mode
For development, you might want to disable Crashlytics:
```dart
// Add this to main.dart
import 'package:flutter/foundation.dart';

// In main() function
await CrashlyticsService.setCrashlyticsCollectionEnabled(!kDebugMode);
```

## Next Steps

1. Test the implementation with a release build
2. Set up user identification in your authentication flow
3. Add custom keys for important user actions
4. Monitor crash reports in Firebase Console
5. Set up alerts for critical crashes

Firebase Crashlytics is now fully integrated and ready to help you monitor and fix crashes in your app!
