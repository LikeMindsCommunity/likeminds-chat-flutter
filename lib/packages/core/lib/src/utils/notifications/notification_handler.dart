import 'dart:convert'; // Import for jsonEncode/Decode
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/realtime/realtime.dart';

/// This class handles all the notification related logic
/// It registers the device for notifications in the SDK
/// It handles the notification when it is received and shows it (if appropriate)
/// It routes the notification to the appropriate screen on tap
/// Since this is a singleton class, it is initialized on the client side
class LMChatNotificationHandler {
  String? deviceId;
  String? fcmToken;
  int? memberId;
  GlobalKey<NavigatorState>? _rootNavigatorKey; // Store the navigator key

  static LMChatNotificationHandler? _instance;
  static LMChatNotificationHandler get instance =>
      _instance ??= LMChatNotificationHandler._();

  LMChatNotificationHandler._();

  /// Initialize the notification handler
  /// This is called from the client side
  /// It initializes the [fcmToken], [deviceId], and stores the [rootNavigatorKey]
  Future<void> init({
    required String deviceId,
    required String fcmToken,
    required GlobalKey<NavigatorState> rootNavigatorKey, // Accept navigator key
  }) async {
    this.deviceId = deviceId;
    this.fcmToken = fcmToken;
    this._rootNavigatorKey = rootNavigatorKey; // Store the key
    await initializeNotifications();
  }

  /// Register the device for notifications
  /// This is called from the client side
  /// It calls the [registerDevice] method of the [LikeMindsService]
  /// It initializes the [memberId] which is used to route the notification
  /// If the registration is successful, it prints success message
  void registerDevice(int memberId) async {
    if (fcmToken == null || deviceId == null) {
      debugPrint("FCM Token or Device ID is null. Cannot register device.");
      return;
    }
    RegisterDeviceRequest request = RegisterDeviceRequest(
      token: fcmToken!,
      memberId: memberId,
      deviceId: deviceId!,
    );
    this.memberId = memberId;
    final response = await LMChatCore.client.registerDevice(request);
    if (response.success) {
      debugPrint("Device registered for notifications successfully");
    } else {
      debugPrint(
          "Device registration for notification failed: ${response.errorMessage}");
      // Consider how to handle this failure - maybe retry logic?
      // throw Exception("Device registration for notification failed"); // Maybe don't throw
    }
  }

  /// Placeholder for background message handling (e.g., using Firebase background handler)
  Future<void> handleBackgroundNotification(RemoteMessage message) {
    debugPrint("--- Handling background notification (placeholder) ---");
    // You might want to increment a badge count or store data,
    // but navigation typically happens when the app is opened from terminated/background state.
    return Future.value();
  }

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    // Initialize Android settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            '@mipmap/ic_launcher'); // Use your app icon

    // Initialize iOS settings
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // onDidReceiveLocalNotification: onDidReceiveLocalNotification, // Older callback if needed
    );

    // Combine initialization settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Initialize the plugin and set up the tap handler
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap, // <= Handle taps
      // onDidReceiveBackgroundNotificationResponse: onNotificationTap, // Optional: Handle taps from background state if needed
    );

    // Create notification channel for Android
    if (Platform.isAndroid) {
      await createNotificationChannel();
    }
    debugPrint("Local notifications initialized.");
  }

  /// Callback for when a local notification displayed by the plugin is tapped
  void onNotificationTap(NotificationResponse notificationResponse) {
    debugPrint('--- Foreground Notification Tapped ---');
    final String? payload = notificationResponse.payload;
    if (payload != null && payload.isNotEmpty) {
      try {
        debugPrint('Payload: $payload');
        final Map<String, dynamic> data = jsonDecode(payload);

        // Reconstruct a RemoteMessage or adapt handleNotification
        // Here, we create a basic RemoteMessage with the necessary data
        final RemoteMessage message = RemoteMessage(data: data);

        // Check if navigator key is available before attempting navigation
        if (_rootNavigatorKey?.currentState != null) {
          debugPrint("Navigator key found, routing notification.");
          // Call handleNotification, show = false because we are reacting to a tap, not showing a new one
          handleNotification(message, _rootNavigatorKey!);
        } else {
          debugPrint(
              "Root navigator key is null or has no state. Cannot navigate from notification tap.");
          // Handle this case - maybe store the route info and navigate when the key becomes available?
        }
      } on Exception catch (e, stackTrace) {
        LMChatCore.instance.lmChatClient.handleException(e, stackTrace);
        debugPrint('Error parsing notification payload or routing: $e');
      }
    } else {
      debugPrint('Notification tapped, but no payload found.');
    }
  }

  /// Create a notification channel for Android
  Future<void> createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'likeminds_chat_channel', // ID - Make it specific
      'LikeMinds Chat Notifications', // Name
      description:
          'Channel for LikeMinds chat messages and related notifications.', // Description
      importance: Importance.max, // Use max importance for chat messages
      playSound: false,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    debugPrint("Android Notification Channel Created.");
  }

  /// Handle foreground notifications - Display them using local notifications
  Future<void> handleForegroundNotifications(RemoteMessage message) async {
    // Basic check for chat category
    if (!(message.data.containsKey('category') &&
        message.data["category"].toString().toLowerCase().contains("chat"))) {
      return;
    }

    // --- Check if the user is already in the specific chatroom ---
    int? targetChatroomId = _getChatroomIdFromRoute(message.data['route']);
    int? currentChatroomId = LMChatRealtime.instance.chatroomId;

    if (targetChatroomId != null && currentChatroomId == targetChatroomId) {
      return; // Don't show the notification
    }
    // --- End Check ---

    // Extract notification details for display
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android; // Can be null

    // Ensure we have content to display
    final String title = notification?.title ??
        message.data['title'] ??
        'New Message'; // Fallback title
    final String body =
        notification?.body ?? message.data['body'] ?? ''; // Fallback body

    if (body.isEmpty) {
      return; // Avoid showing notifications with no body
    }

    // Use platform check for clarity, although android check isn't strictly needed if iOS details are present
    if (Platform.isAndroid || Platform.isIOS) {
      // Display the notification using flutter_local_notifications
      await _flutterLocalNotificationsPlugin.show(
        notification?.hashCode ??
            DateTime.now()
                .millisecondsSinceEpoch
                .remainder(100000), // Unique ID for the notification
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'likeminds_chat_channel', // Use the channel ID created earlier
            'LikeMinds Chat Notifications', // Channel Name
            channelDescription: 'Channel for LikeMinds chat messages',
            importance: Importance.max, // Match channel importance
            priority: Priority.high,
            playSound: false,

            showWhen: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true, // Show alert banner
            presentBadge:
                true, // Update app badge count (ensure backend sends badge count if needed)
            presentSound: false, // Play sound
          ),
        ),
        // Pass the necessary data for routing when the notification is tapped
        payload: jsonEncode(message.data),
      );
    } else {
      debugPrint("Platform not supported for local notification display.");
    }
  }

  /// Extracts chatroom ID from the route string.
  /// Returns null if parsing fails or route is not recognized.
  int? _getChatroomIdFromRoute(String? route) {
    if (route == null) return null;
    try {
      final Uri routeUri = Uri.parse(route);
      final String host = routeUri.host.toLowerCase();
      final Map<String, String> queryParams = routeUri.queryParameters;

      if (host == "collabcard" && queryParams.containsKey("collabcard_id")) {
        return int.tryParse(queryParams["collabcard_id"]!);
      } else if (host == 'chatroom_detail' &&
          queryParams.containsKey("chatroom_id")) {
        return int.tryParse(queryParams["chatroom_id"]!);
      }
      return null; // Not a recognized chat route
    } on Exception catch (e, stackTrace) {
      LMChatCore.instance.lmChatClient.handleException(e, stackTrace);
      debugPrint("Error parsing route URI '$route': $e");
      return null; // Error during parsing
    }
  }

  /// Handle the notification data payload for routing.
  /// This is called EITHER when a background/terminated notification is tapped (via initial message logic)
  /// OR when a foreground notification shown by local_notifications is tapped (via onNotificationTap).
  Future<void> handleNotification(
      RemoteMessage message, GlobalKey<NavigatorState> navigatorKey) async {
    debugPrint("--- handleNotification called ---");
    // notifications is handled in `handleForegroundNotifications`.
    // This function now primarily focuses on ROUTING based on data.

    if (message.data.containsKey('category') &&
        message.data["category"].toString().toLowerCase().contains("chat")) {
      if (message.data.isNotEmpty && message.data.containsKey('route')) {
        // Extract the notification data and route to the appropriate screen
        routeNotification(message.data, navigatorKey); // Pass data map directly
      } else {
        throw Exception(
            "Chat notification received, but data or route is missing.");
      }
    } else {
      throw Exception(
          "Notification category is not chat or category key missing.");
    }
  }

  // Modified to accept data map directly
  void routeNotification(
    Map<String, dynamic> notificationData,
    GlobalKey<NavigatorState> navigatorKey,
  ) async {
    final String? route = notificationData["route"];
    if (route == null) {
      throw Exception("Route is null in notification data. Cannot navigate.");
    }

    debugPrint("Attempting to route for: $route");

    int? targetChatroomId = _getChatroomIdFromRoute(route);

    if (targetChatroomId == null) {
      throw Exception("Could not extract valid chatroom ID from route: $route");
    }

    int? currentChatroomId = LMChatRealtime.instance.chatroomId;

    if (navigatorKey.currentState == null) {
      throw Exception("Navigator state is null. Cannot perform navigation.");
    }

    // Logic:
    // 1. If a chatroom is open (`currentChatroomId != null`):
    //    - If it's the *same* chatroom (`currentChatroomId == targetChatroomId`), do nothing (already there).
    //    - If it's a *different* chatroom, replace the current screen.
    // 2. If *no* chatroom is open (`currentChatroomId == null`):
    //    - Push the new chatroom screen onto the stack.

    final chatroomPageRoute = MaterialPageRoute(
      maintainState: false,
      builder: (context) => LMChatroomScreen(
        chatroomId: targetChatroomId,
      ),
    );

    if (currentChatroomId != null) {
      if (currentChatroomId != targetChatroomId) {
        LMChatRealtime.instance.chatroomId = targetChatroomId;

        LMChatroomBloc.instance.close();
        LMChatroomActionBloc.instance.close();
        LMChatConversationBloc.instance.close();
        LMChatConversationActionBloc.instance.close();

        navigatorKey.currentState?.pushReplacement(chatroomPageRoute);
      } else {}
    } else {
      navigatorKey.currentState?.push(chatroomPageRoute);
    }
  }
}
