import 'package:flutter/foundation.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';

/// Callback class for the core module
/// This class is used to handle the callback events from the core module
/// The core module will call the methods in this class when the corresponding events are triggered
class LMChatCoreCallback {
  /// This method is called when the access token is expired and refreshed
  Function(String accessToken, String refreshToken)?
      onAccessTokenExpiredAndRefreshed;

  /// This method is called when the refresh token is expired
  Future<LMAuthToken> Function()? onRefreshTokenExpired;

  /// Constructor for the LMChatCoreCallback
  LMChatCoreCallback({
    this.onAccessTokenExpiredAndRefreshed,
    this.onRefreshTokenExpired,
  });
}


/// Implementation of the LMChatSDKCallback
/// This class is used to handle the callback events from the core module
/// The core module will call the methods in this class when the corresponding events are triggered
class LMChatSDKCallbackImpl implements LMChatSDKCallback {
  final LMChatCoreCallback? _lmFeedCallback;

  /// Constructor for the LMChatSDKCallbackImpl
  LMChatSDKCallbackImpl({LMChatCoreCallback? lmChatCallback})
      : _lmFeedCallback = lmChatCallback;
  @override
  void eventFiredCallback(
      String eventKey, Map<String, dynamic> propertiesMap) {}

  @override
  void loginRequiredCallback() {}

  @override
  void logoutCallback() {}

  @override
  void onAccessTokenExpiredAndRefreshed(
      String accessToken, String refreshToken) {
    debugPrint("onAccessTokenExpiredAndRefreshed: $accessToken, $refreshToken");
    //Redirecting from core to example app
    _lmFeedCallback?.onAccessTokenExpiredAndRefreshed
        ?.call(accessToken, refreshToken);
  }

  @override
  Future<LMAuthToken> onRefreshTokenExpired() async {
    String? apiKey = LMChatLocalPreference.instance
        .fetchCache(LMChatStringConstants.apiKey)
        ?.value as String?;

    if (apiKey != null) {
      User? user = LMChatLocalPreference.instance.getUser();
      if (user == null) {
        throw Exception("User data not found");
      }

      InitiateUserRequest initiateUserRequest = (InitiateUserRequestBuilder()
            ..apiKey(apiKey)
            ..userName(user.name)
            ..userId(user.sdkClientInfo!.uuid ?? ""))
          .build();

      LMResponse<InitiateUserResponse> initiateUserResponse = await LMChatCore
          .instance
          .initiateUser(initiateUserRequest: initiateUserRequest);

      if (initiateUserResponse.success) {
        return (LMAuthTokenBuilder()
              ..accessToken(initiateUserResponse.data!.accessToken!)
              ..refreshToken(initiateUserResponse.data!.refreshToken!))
            .build();
      } else {
        throw Exception(initiateUserResponse.errorMessage);
      }
    } else {
      final onRefreshTokenExpired = _lmFeedCallback?.onRefreshTokenExpired;
      if (onRefreshTokenExpired == null) {
        throw Exception("onRefreshTokenExpired callback is not implemented");
      }
      return onRefreshTokenExpired();
    }
  }

  @override
  void profileRouteCallback({required String lmUserId}) {}
}
