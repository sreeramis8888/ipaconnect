library data;

import 'package:flutter_dotenv/flutter_dotenv.dart';

String token = '';
bool LoggedIn = false;
String id = '';
String fcmToken = '';
String premium_flow_shown = 'true';

// Helper function to validate authentication state
bool get isAuthenticated {
  return token.isNotEmpty && LoggedIn && id.isNotEmpty;
}

// Helper function to clear all authentication data
void clearAuthenticationData() {
  token = '';
  LoggedIn = false;
  id = '';
  fcmToken = '';
}
