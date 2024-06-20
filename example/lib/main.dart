import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_sample/app.dart';
import 'package:likeminds_chat_flutter_sample/utils/firebase_options.dart';
import 'package:likeminds_chat_flutter_sample/utils/mock_intiate_user.dart';

/// Flutter flavour/environment manager v0.0.1
const isDebug = bool.fromEnvironment('DEBUG');

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// First level notification handler
/// Essential to declare it outside of any class or function as per Firebase docs
/// Call [LMChatNotificationHandler.instance.handleNotification] in this function
/// to handle notifications at the second level (inside the app)
/// Make sure to call [setupNotifications] before this function
Future<void> _handleNotification(RemoteMessage message) async {
  debugPrint("--- Notification received in LEVEL 1 ---");
  await LMChatNotificationHandler.instance
      .handleNotification(message, false, rootNavigatorKey);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupNotifications();
  await LMChatCore.instance.initialize(
    lmChatCallback: LMChatCoreCallback(
        onAccessTokenExpiredAndRefreshed: (accessToken, refreshToken) async {
      debugPrint(
          "onAccessTokenExpiredAndRefreshed: $accessToken, $refreshToken");
    }, onRefreshTokenExpired: () async {
      debugPrint("onRefreshTokenExpired");
      final (a, b) = await mockInitiateUser(
        apiKey: "",
        userName: "divi",
        userId: "divi",
      );
      return (LMAuthTokenBuilder()
            ..accessToken(a)
            ..refreshToken(b))
          .build();
    }),
  );
  runApp(const LMChatSampleApp());
}

/// Setup notifications
/// 1. Initialize Firebase
/// 2. Get device id - [deviceId]
/// 3. Get FCM token - [setupMessaging]
/// 4. Register device with LM - [LMChatNotificationHandler]
/// 5. Listen for FG and BG notifications
/// 6. Handle notifications - [_handleNotification]
void setupNotifications() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final devId = await deviceId();
  final fcmToken = await setupMessaging();
  if (fcmToken == null) {
    debugPrint("FCM token is null or permission declined");
    return;
  }
  // Register device with LM, and listen for notifications
  LMChatNotificationHandler.instance.init(deviceId: devId, fcmToken: fcmToken);
  FirebaseMessaging.onBackgroundMessage(_handleNotification);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    await LMChatNotificationHandler.instance
        .handleNotification(message, true, rootNavigatorKey);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    debugPrint("---The app is opened from a notification---");
    await LMChatNotificationHandler.instance
        .handleNotification(message, false, rootNavigatorKey);
  });
  FirebaseMessaging.instance.getInitialMessage().then(
    (RemoteMessage? message) async {
      if (message != null) {
        debugPrint("---The terminated app is opened from a notification---");
        await LMChatNotificationHandler.instance
            .handleNotification(message, false, rootNavigatorKey);
      }
    },
  );
}

/// Get device id
/// 1. Get device info
/// 2. Get device id
/// 3. Return device id
Future<String> deviceId() async {
  final deviceInfo = await DeviceInfoPlugin().deviceInfo;
  final deviceId =
      deviceInfo.data["identifierForVendor"] ?? deviceInfo.data["id"];
  debugPrint("Device id - $deviceId");
  return deviceId.toString();
}

/// Setup Firebase messaging on your app
/// The UI package needs your Firebase instance to be initialized
/// 1. Get messaging instance
/// 2. Get FCM token
/// 3. Request permission
/// 4. Return FCM token
Future<String?> setupMessaging() async {
  final messaging = FirebaseMessaging.instance;
  if (Platform.isIOS) {
    await messaging.requestPermission(
      alert: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  final token = await messaging.getToken();
  debugPrint("Token - $token");
  return token.toString();
}
