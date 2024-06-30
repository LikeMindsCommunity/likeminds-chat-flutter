import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
// import 'package:likeminds_chat_flutter_core/src/utils/constants/enums.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:likeminds_chat_flutter_core/src/views/views.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:overlay_support/overlay_support.dart';

/// This class handles all the notification related logic
/// It registers the device for notifications in the SDK
/// It handles the notification when it is received and shows it
/// It routes the notification to the appropriate screen
/// Since this is a singleton class, it is initialized on the client side
class LMChatNotificationHandler {
  String? deviceId;
  String? fcmToken;
  int? memberId;

  static LMChatNotificationHandler? _instance;
  static LMChatNotificationHandler get instance =>
      _instance ??= LMChatNotificationHandler._();

  LMChatNotificationHandler._();

  /// Initialize the notification handler
  /// This is called from the client side
  /// It initializes the [fcmToken] and the [deviceId]
  void init({
    required String deviceId,
    required String fcmToken,
  }) {
    this.deviceId = deviceId;
    this.fcmToken = fcmToken;
  }

  /// Register the device for notifications
  /// This is called from the client side
  /// It calls the [registerDevice] method of the [LikeMindsService]
  /// It initializes the [memberId] which is used to route the notification
  /// If the registration is successful, it prints success message
  void registerDevice(int memberId) async {
    if (fcmToken == null || deviceId == null) {
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
      throw Exception("Device registration for notification failed");
    }
  }

  /// Handle the notification when it is received
  /// This is called from the client side when notification [message] is received
  /// and is needed to be handled, i.e. shown and routed to the appropriate screen
  Future<void> handleNotification(RemoteMessage message, bool show,
      GlobalKey<NavigatorState> rootNavigatorKey) async {
    debugPrint("--- Notification received in LEVEL 2 ---");
    if (message.data["category"].contains("Chat")) {
      message.toMap().forEach((key, value) {
        debugPrint("$key: $value");
        if (key == "data") {
          message.data.forEach((key, value) {
            debugPrint("$key: $value");
          });
        }
      });
      // First, check if the message contains a data payload.
      if (show && message.data.isNotEmpty) {
        //Add LM check for showing LM notifications
        showNotification(message, rootNavigatorKey);
      } else if (message.data.isNotEmpty) {
        // Second, extract the notification data and routes to the appropriate screen
        routeNotification(message, rootNavigatorKey);
      }
    }
  }

  void routeNotification(
    RemoteMessage message,
    GlobalKey<NavigatorState> rootNavigatorKey,
  ) async {
    Map<String, String> queryParams = {};
    String host = "";

    // Only notifications with data payload are handled
    if (message.data.isNotEmpty) {
      final Map<String, dynamic> notifData = message.data;
      final String category = notifData["category"];
      final String route = notifData["route"]!;

      // If the notification is a feed notification, extract the route params
      if (category.toString().toLowerCase() == "chat room") {
        final Uri routeUri = Uri.parse(route);
        final Map<String, String> routeParams =
            routeUri.hasQuery ? routeUri.queryParameters : {};
        final String routeHost = routeUri.host;
        host = routeHost;
        debugPrint("The route host is $routeHost");
        queryParams.addAll(routeParams);
        queryParams.forEach((key, value) {
          debugPrint("$key: $value");
        });
      }
    }

    if (host == "collabcard") {
      rootNavigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => const LMChatHomeScreen(
              // chatroomType: LMChatroomType.dm,
              ),
        ),
      );

      rootNavigatorKey.currentState!.push(MaterialPageRoute(
        builder: (context) => LMChatroomScreen(
          chatroomId: int.parse(
            queryParams["collabcard_id"]!,
          ),
        ),
      ));
    } else if (host == 'chatroom_detail') {
      rootNavigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => const LMChatHomeScreen(
              // chatroomType: LMChatroomType.dm,
              ),
        ),
      );
      rootNavigatorKey.currentState!.push(MaterialPageRoute(
        builder: (context) => LMChatroomScreen(
          chatroomId: int.parse(
            queryParams["chatroom_id"]!,
          ),
        ),
      ));
    }
  }

  /// Show a simple notification using overlay package
  /// This is a dismissable notification shown on the top of the screen
  /// It is shown when the notification is received in foreground
  void showNotification(
    RemoteMessage message,
    GlobalKey<NavigatorState> rootNavigatorKey,
  ) {
    if (message.data.isNotEmpty) {
      showSimpleNotification(
        GestureDetector(
          onTap: () {
            routeNotification(
              message,
              rootNavigatorKey,
            );
          },
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LMChatText(
                message.data["title"],
                style: const LMChatTextStyle(
                  textStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: LMChatDefaultTheme.blackColor),
                ),
              ),
              const SizedBox(height: 4),
              LMChatText(
                message.data["sub_title"],
                style: const LMChatTextStyle(
                  maxLines: 1,
                  textStyle: TextStyle(
                    fontSize: 10,
                    color: LMChatDefaultTheme.greyColor,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
        background: Colors.white,
        duration: const Duration(seconds: 3),
        leading: LMChatIcon(
          type: LMChatIconType.icon,
          icon: Icons.notifications,
          style: LMChatIconStyle(
            color: LMChatTheme.theme.secondaryColor,
            size: 28,
          ),
        ),
        trailing: const LMChatIcon(
          type: LMChatIconType.icon,
          icon: Icons.swipe_right_outlined,
          style: LMChatIconStyle(
            color: LMChatDefaultTheme.greyColor,
            size: 28,
          ),
        ),
        position: NotificationPosition.top,
        slideDismissDirection: DismissDirection.horizontal,
      );
    }
  }
}
