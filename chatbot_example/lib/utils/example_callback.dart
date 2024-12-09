import 'package:flutter/foundation.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';

/// ExampleCallback represents the callback to be implemented
/// on the customer's end to extend [LMChatSDKCallback]
class ExampleCallback extends LMChatSDKCallback {
  @override
  // A function that handles the event fired callback with the specified event key and properties map.
  void eventFiredCallback(String eventKey, Map<String, dynamic> propertiesMap) {
    debugPrint("EXAMPLE: eventFiredCallback: $eventKey, $propertiesMap");
  }

  @override
  // A function that indicates a login is required.
  void loginRequiredCallback() {
    debugPrint("EXAMPLE: loginRequiredCallback");
  }

  @override
  // A function that handles the logout callback.
  void logoutCallback() {
    debugPrint("EXAMPLE: logoutCallback");
  }

  @override
  // A function that handles the routing of profile callback.
  void profileRouteCallback({required String lmUserId}) {
    debugPrint("LM User ID caught in callback : $lmUserId");
  }

  @override
  // A function that handles access token expired and refreshed callback.
  void onAccessTokenExpiredAndRefreshed(
      String accessToken, String refreshToken) {
    debugPrint(
      "New access token: $accessToken, New refresh token: $refreshToken",
    );
  }

  @override
  // A function that handles expiry of refresh token callback.
  Future<LMAuthToken> onRefreshTokenExpired() {
    // TODO: implement onRefreshTokenExpired
    throw UnimplementedError();
  }
}
