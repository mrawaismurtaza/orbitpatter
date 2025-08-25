import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:orbitpatter/core/utils/logger.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

class NotificationService {

  final FirebaseMessaging _firebaseMessaging;

  NotificationService(this._firebaseMessaging);

  Future<void> init() async {


    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      provisional: false,
      sound: true,
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if(settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    String? fcmtToken = await getToken();

    if (fcmtToken != null) {
      LoggerUtil.info('FCM Token: $fcmtToken');
    } else {
      LoggerUtil.error('Failed to retrieve FCM Token');
    }


    // When app is in Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        LoggerUtil.info('Foreground message received: ${message.messageId}');
      }
      // Handle the message and show notification if needed
    });

    //When user taps a noification in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        LoggerUtil.info('Notification caused app to open from background state: ${message.messageId}');
      }
      // Handle the message and navigate to specific screen if needed

    });


    // When user taps a notification in terminated state
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if(initialMessage != null) {
      if (kDebugMode) {
        LoggerUtil.info('Notification caused app to open from terminated state: ${initialMessage.messageId}');
      }
      // Handle the message and navigate to specific screen if needed
    }

  }


  Future<bool> sendNotification(
  List<String> fcmTokens,
  String title,
  String body,
) async {
  final accessToken = await getAccessToken();
  const projectId = 'orbitpatter'; // <-- double check your Firebase project ID
  final url = 'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';

  bool success = true;

  for (final token in fcmTokens) {
    final message = {
      'message': {
        'token': token,
        'notification': {
          'title': title,
          'body': body,
        },
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        }
      }
    };

    try {
      final response = await Dio().post(
        url,
        data: message,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        LoggerUtil.info('Notification sent to $token: ${response.data}');
      } else {
        LoggerUtil.error('Failed to send notification to $token');
        success = false;
      }
    } catch (e) {
      LoggerUtil.error('Error sending notification to $token: $e');
      success = false;
    }
  }

  return success;
}





  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }


  Future<String> getAccessToken() async {
  final jsonStr = await rootBundle.loadString('assets/fcm_service_account.json');
  final creds = auth.ServiceAccountCredentials.fromJson(jsonDecode(jsonStr));
  
  final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
  final client = await auth.clientViaServiceAccount(creds, scopes);

  final token = client.credentials.accessToken.data;
  client.close();
  return token;
}
}




// Background handler (must be outside the class)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Background message: ${message.messageId}");
  }
}