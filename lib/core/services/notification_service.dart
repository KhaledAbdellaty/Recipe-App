import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final FirebaseMessaging _messaging;
  final SharedPreferences _prefs;

  NotificationService(this._messaging, this._prefs);

  Future<void> initialize() async {
    final settings = await _messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await _messaging.getToken();
      await _saveToken(token!);
      
      _messaging.onTokenRefresh.listen(_saveToken);
      
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    }
  }

  Future<void> _saveToken(String token) async {
    await _prefs.setString('fcm_token', token);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // Handle foreground message
  }
}

Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  // Handle background message
}