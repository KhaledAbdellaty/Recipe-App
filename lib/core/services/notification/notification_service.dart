// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class NotificationService {
//   final FirebaseMessaging _messaging;
//   final SharedPreferences _prefs;

//   NotificationService(this._messaging, this._prefs);

//   Future<void> initialize() async {
//     final settings = await _messaging.requestPermission();
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       final token = await _messaging.getToken();
//       await _saveToken(token!);

//       _messaging.onTokenRefresh.listen(_saveToken);

//       FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
//       FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
//     }
//   }

//   Future<void> _saveToken(String token) async {
//     await _prefs.setString('fcm_token', token);
//   }

//   void _handleForegroundMessage(RemoteMessage message) {
//     // Handle foreground message
//   }
// }

// Future<void> _handleBackgroundMessage(RemoteMessage message) async {
//   // Handle background message
// }

import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'notification_type.dart';

class NotificationService {
  final _messaging = FirebaseMessaging.instance;
  final _firestore = FirebaseFirestore.instance;

  NotificationService._();
  static NotificationService get instance => NotificationService._();

  Future<void> initialize() async {
    // Request permission
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get FCM token
      final token = await _messaging.getToken();
      if (token != null) {
        await _updateUserToken(token);
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen(_updateUserToken);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    }
  }

  Future<void> _updateUserToken(String token) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': token,
      });
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    // Handle the notification when app is in foreground
    log('Received foreground message: ${message.notification?.title}');
  }

  Future<void> sendRecipeNotification({
    required String recipeId,
    required String authorId,
    required NotificationType type,
    required String triggerUserId,
    String? content,
  }) async {
    try {
      // Get author's FCM token
      final authorDoc =
          await _firestore.collection('users').doc(authorId).get();
      final fcmToken = authorDoc.data()?['fcmToken'] as String?;

      if (fcmToken == null) return;

      // Get trigger user's name
      final triggerUserDoc =
          await _firestore.collection('users').doc(triggerUserId).get();
      final triggerUserName =
          triggerUserDoc.data()?['username'] as String? ?? 'Someone';

      // Get recipe title
      final recipeDoc =
          await _firestore.collection('recipes').doc(recipeId).get();
      final recipeTitle =
          recipeDoc.data()?['title'] as String? ?? 'your recipe';

      // Create notification message
      final message = _createNotificationMessage(
        type: type,
        userName: triggerUserName,
        recipeTitle: recipeTitle,
        content: content,
      );

      // Save notification to Firestore
      await _firestore.collection('notifications').add({
        'userId': authorId,
        'type': type.toString(),
        'recipeId': recipeId,
        'triggerUserId': triggerUserId,
        'content': content,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Send FCM notification
      await _sendFCMNotification(
        token: fcmToken,
        title: message.title,
        body: message.body,
        data: {
          'type': type.toString(),
          'recipeId': recipeId,
        },
      );
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  Future<void> _sendFCMNotification({
    required String token,
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'key=${const String.fromEnvironment('FCM_SERVER_KEY')}',
        },
        body: jsonEncode({
          'to': token,
          'notification': {
            'title': title,
            'body': body,
          },
          'data': data,
        }),
      );
    } catch (e) {
      print('Error sending FCM notification: $e');
    }
  }

  NotificationMessage _createNotificationMessage({
    required NotificationType type,
    required String userName,
    required String recipeTitle,
    String? content,
  }) {
    switch (type) {
      case NotificationType.like:
        return NotificationMessage(
          title: 'New Like!',
          body: '$userName liked your recipe "$recipeTitle"',
        );
      case NotificationType.comment:
        return NotificationMessage(
          title: 'New Comment!',
          body:
              '$userName commented on your recipe "$recipeTitle": ${content ?? ''}',
        );
      case NotificationType.rating:
        return NotificationMessage(
          title: 'New Rating!',
          body: '$userName rated your recipe "$recipeTitle"',
        );
    }
  }
}
