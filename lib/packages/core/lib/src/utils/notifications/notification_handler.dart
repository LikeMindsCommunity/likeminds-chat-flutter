import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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

  // Placeholder for background message handling (e.g., using Firebase background handler)
  Future<void> handleBackgroundNotification(RemoteMessage message) {
    debugPrint("--- Handling background notification (placeholder) ---");
    // You might want to increment a badge count or store data,
    // but navigation typically happens when the app is opened from terminated/background state.
    return Future.value();
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
      debugPrint(
          "Route host '$host' not recognized for chatroom ID extraction.");
      return null; // Not a recognized chat route
    } catch (e) {
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
    //  debugPrint("Message Data: ${message.data}");
    // 'show' parameter might be less relevant now, as displaying foreground
    // notifications is handled in `handleForegroundNotifications`.
    // This function now primarily focuses on ROUTING based on data.

    if (message.data.containsKey('category') &&
        message.data["category"].toString().toLowerCase().contains("chat")) {
      if (message.data.isNotEmpty && message.data.containsKey('route')) {
        debugPrint("Routing notification based on data payload.");
        // Extract the notification data and route to the appropriate screen
        routeNotification(message.data, navigatorKey); // Pass data map directly
      } else {
        debugPrint("Chat notification received, but data or route is missing.");
      }
    } else {
      debugPrint("Notification category is not chat or category key missing.");
    }
  }

  // Modified to accept data map directly
  void routeNotification(
    Map<String, dynamic> notificationData,
    GlobalKey<NavigatorState> navigatorKey,
  ) async {
    final String? route = notificationData["route"];
    if (route == null) {
      debugPrint("Route is null in notification data. Cannot navigate.");
      return;
    }

    debugPrint("Attempting to route for: $route");

    int? targetChatroomId = _getChatroomIdFromRoute(route);

    if (targetChatroomId == null) {
      debugPrint("Could not extract valid chatroom ID from route: $route");
      return;
    }

    int? currentChatroomId = LMChatConversationBloc
        .currentChatroomId; //does not give correct id after pushing
    // int? currentChatroomId = LMChatConversationBloc.currentChatroomId;
    debugPrint(
        "Routing: Target Chatroom ID: $targetChatroomId, Current Open Chatroom ID: $currentChatroomId");

    if (navigatorKey.currentState == null) {
      debugPrint("Navigator state is null. Cannot perform navigation.");
      // Handle this scenario - maybe queue the navigation?
      return;
    }

    // Logic:
    // 1. If a chatroom is open (`currentChatroomId != null`):
    //    - If it's the *same* chatroom (`currentChatroomId == targetChatroomId`), do nothing (already there).
    //    - If it's a *different* chatroom, replace the current screen.
    // 2. If *no* chatroom is open (`currentChatroomId == null`):
    //    - Push the new chatroom screen onto the stack.

    final chatroomPageRoute = MaterialPageRoute(
      builder: (context) => LMChatroomScreen(
        chatroomId: targetChatroomId,
      ),
    );

    if (currentChatroomId != null) {
      if (currentChatroomId != targetChatroomId) {
        LMChatConversationBloc.currentChatroomId = targetChatroomId;
        LMChatRealtime.instance.chatroomId = targetChatroomId;
        debugPrint(
            "Different chatroom open. Replacing screen with chatroom $targetChatroomId");
        // LMChatRealtime.instance.chatroomId = targetChatroomId;
        // navigatorKey.currentState?.pop();
        // TODO : implement a pop and push replacement
        navigatorKey.currentState?.pop();
        //  navigatorKey.currentState?.pushReplacement(chatroomPageRoute);
      } else {
        debugPrint(
            "Target chatroom $targetChatroomId is already open. Doing nothing.");
        // Optional: Maybe refresh the current chatroom?
        // LMChatRealtime.instance.notifyChatroomRefreshed(targetChatroomId);
      }
    } else {
      debugPrint(
          "No chatroom open. Pushing screen for chatroom $targetChatroomId");
      navigatorKey.currentState?.push(chatroomPageRoute);
    }
  }
}
