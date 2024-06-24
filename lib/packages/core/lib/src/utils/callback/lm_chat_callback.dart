import 'package:flutter/foundation.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/preferences/preferences.dart';

class LMChatCoreCallback {
  Function(String accessToken, String refreshToken)?
      onAccessTokenExpiredAndRefreshed;
  Future<LMAuthToken> Function()? onRefreshTokenExpired;

  LMChatCoreCallback({
    this.onAccessTokenExpiredAndRefreshed,
    this.onRefreshTokenExpired,
  });
}

class LMChatSDKCallbackImpl implements LMChatSDKCallback {
  final LMChatCoreCallback? _lmFeedCallback;
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
