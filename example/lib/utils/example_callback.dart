import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';

class ExampleCallback extends LMChatSDKCallback {
  @override
  void eventFiredCallback(String eventKey, Map<String, dynamic> propertiesMap) {
    debugPrint("EXAMPLE: eventFiredCallback: $eventKey, $propertiesMap");
  }

  @override
  void loginRequiredCallback() {
    debugPrint("EXAMPLE: loginRequiredCallback");
  }

  @override
  void logoutCallback() {
    debugPrint("EXAMPLE: logoutCallback");
  }

  @override
  void profileRouteCallback({required String lmUserId}) {
    debugPrint("LM User ID caught in callback : $lmUserId");
  }
  
  @override
  void onAccessTokenExpiredAndRefreshed(String accessToken, String refreshToken) {
    debugPrint("New access token: $accessToken, New refresh token: $refreshToken");
  }
  
  @override
  Future<LMAuthToken> onRefreshTokenExpired() {
    // TODO: implement onRefreshTokenExpired
    throw UnimplementedError();
  }
}
