import 'package:flutter/material.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/blocs.dart';
import 'package:likeminds_chat_flutter_core/src/core/configurations/chat_config.dart';
import 'package:likeminds_chat_flutter_core/src/utils/firebase/firebase.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';

import 'package:media_kit/media_kit.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

export 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
export 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
export 'package:custom_pop_up_menu/custom_pop_up_menu.dart';

/// {@template lm_chat_core}
/// The core class of the LikeMinds Chat SDK.
/// This class is used to initialize the chat, show the chat, and logout the user session.
///
/// The [LMChatCore] class is a singleton class.
/// It has a singleton instance [instance] which is used to access the core class.
///
/// {@endtemplate}
class LMChatCore {
  /// Instance of [LMChatClient] class accessible through core class.
  late final LMChatClient lmChatClient;

  /// Instance of [LMChatConfig] class accessible through core class.
  late final LMChatConfig _lmChatConfig;

  /// [String] domain passed from client's end. used in generating the URL for sharing.
  late String _clientDomain;

  /// Singleton class for LMChatCore
  LMChatCore._();
  static LMChatCore? _instance;

  /// Singleton instance of [LMChatCore]
  static LMChatCore get instance => _instance ??= LMChatCore._();

  /// Instance of client [LMChatClient] accessible through core class.
  static LMChatClient get client => instance.lmChatClient;

  /// Instance of configuration file passed while initialising
  static LMChatConfig get config => instance._lmChatConfig;

  /// Domain passed from client's end [String]
  static String get domain => instance._clientDomain;

  /// Static setter for LMChatTheme
  static void setTheme(LMChatThemeData theme) {
    LMChatTheme.setTheme(theme);
  }

  /// Static setter for TextTheme
  static void setTextTheme(TextTheme theme) {
    LMChatTheme.setTextTheme(theme);
  }

  /// This function is used to initialize the chat.
  /// The [lmChatClient] parameter is optional and is used to pass the instance of the [LMChatClient] class.
  /// The [domain] parameter is optional and is used to pass the domain of the client.
  /// The [config] parameter is optional and is used to pass the configuration of the chat.
  /// The [widgets] parameter is optional and is used to pass the utility widgets of the chat.
  /// The [theme] parameter is optional and is used to pass the theme of the chat.
  /// The [lmChatCallback] parameter is optional and is used to pass the callback functions of the chat.
  /// The function returns a [LMResponse] object.
  /// If the initialization is successful, the [LMResponse] object give [success] as true and [data] as null.
  Future<LMResponse<void>> initialize({
    @Deprecated(
        "Use [LMChatCore.instance.client] to get an instance of [LMChatClient] instead of passing it as a parameter.")
    LMChatClient? lmChatClient,
    String? domain,
    LMChatConfig? config,
    LMChatThemeData? theme,
    LMChatCoreCallback? lmChatCallback,
    List<ConversationState>? excludedConversationStates,
    Function(LMChatAnalyticsEventFired)? analyticsListener,
    Function(LMChatProfileState)? profileListener,
  }) async {
    final lmChatSDKCallback =
        LMChatSDKCallbackImpl(lmChatCallback: lmChatCallback);
    this.lmChatClient = lmChatClient ??
        (LMChatClientBuilder()
              ..sdkCallback(lmChatSDKCallback)
              ..excludedConversationStates(excludedConversationStates ?? []))
            .build();
    if (domain != null) _clientDomain = domain;
    LMChatTheme.instance.initialise(theme: theme);
    _lmChatConfig = config ?? LMChatConfig();
    LMResponse isDBInitiated = await this.lmChatClient.initiateDB();
    if (!isDBInitiated.success) {
      return LMResponse.error(
          errorMessage: isDBInitiated.errorMessage ??
              "Error in setting up local storage");
    }
    if (analyticsListener != null) {
      LMChatAnalyticsBloc.instance.stream.listen((LMChatAnalyticsState event) {
        if (event is LMChatAnalyticsEventFired) {
          analyticsListener.call(event);
        }
      });
    }
    if (profileListener != null) {
      LMChatProfileBloc.instance.stream.listen((event) {
        profileListener.call(event);
      });
    }
    await initFirebase();
    MediaKit.ensureInitialized();
    return LMResponse.success(data: null);
  }

  /// This function is used to close the blocs of the chat.
  Future<void> closeBlocs() async {
    // await LMChatPostBloc.instance.close();
    // await LMChatRoutingBloc.instance.close();
    // await LMChatProfileBloc.instance.close();
    // await LMChatAnalyticsBloc.instance.close();
  }

  /// This function is the starting point of the chat.
  /// It must be executed before displaying the chat home screen or accessing any other [LMChatCore] widgets or screens.
  /// The [initiateUserRequest] parameter is required to initiate the user session.
  Future<LMResponse> showChatWithApiKey({
    required String apiKey,
    required String uuid,
    required String userName,
    String? imageUrl,
    bool? isGuest,
  }) async {
    String? existingAccessToken = LMChatLocalPreference.instance
        .fetchCache(LMChatStringConstants.accessToken)
        ?.value;
    String? existingRefreshToken = LMChatLocalPreference.instance
        .fetchCache(LMChatStringConstants.refreshToken)
        ?.value;

    if (existingAccessToken == null || existingRefreshToken == null) {
      InitiateUserRequestBuilder initiateUserRequestBuilder =
          InitiateUserRequestBuilder()
            ..apiKey(apiKey)
            ..userId(uuid)
            ..userName(userName);
      if (imageUrl != null) {
        initiateUserRequestBuilder.imageUrl(imageUrl);
      }
      if (isGuest != null) {
        initiateUserRequestBuilder.isGuest(isGuest);
      }
      InitiateUserRequest initiateUserRequest =
          initiateUserRequestBuilder.build();

      LMResponse<InitiateUserResponse> initiateUserResponse =
          await initiateUser(initiateUserRequest: initiateUserRequest);
      if (initiateUserResponse.success) {
        // get member state and store them in local preference
        LMResponse memberState = await _getMemberState();
        // get community configurations and store them in local preference
        LMResponse communityConfigurations =
            await _getCommunityConfigurations();

        // check if member state or community configurations are not fetched successfully
        if (!memberState.success) {
          return LMResponse(
              success: false, errorMessage: memberState.errorMessage);
        } else if (!communityConfigurations.success) {
          return LMResponse(
              success: false,
              errorMessage: communityConfigurations.errorMessage);
        }
      }
      return initiateUserResponse;
    } else {
      return await showChatWithoutApiKey(
        accessToken: existingAccessToken,
        refreshToken: existingRefreshToken,
      );
    }
  }

  /// This function is the starting point of the chat.
  /// It must be executed before displaying the chat home screen or accessing any other [LMChatCore] widgets or screens.
  /// The [accessToken] and [refreshToken] parameters are required to show the home screen.
  /// If the [accessToken] and [refreshToken] parameters are not provided, the function will fetch them from the local preference.
  Future<LMResponse> showChatWithoutApiKey({
    String? accessToken,
    String? refreshToken,
  }) async {
    String? existingAccessToken;
    String? existingRefreshToken;
    if (accessToken == null || refreshToken == null) {
      existingAccessToken = LMChatLocalPreference.instance
          .fetchCache(LMChatStringConstants.accessToken)
          ?.value;

      existingRefreshToken = LMChatLocalPreference.instance
          .fetchCache(LMChatStringConstants.refreshToken)
          ?.value;
    } else {
      existingAccessToken = accessToken;
      existingRefreshToken = refreshToken;
    }

    if (existingAccessToken == null || existingRefreshToken == null) {
      return LMResponse(
          success: false,
          errorMessage: "Access token and Refresh token are required");
    }

    ValidateUserRequest request = (ValidateUserRequestBuilder()
          ..accessToken(existingAccessToken)
          ..refreshToken(existingRefreshToken))
        .build();

    ValidateUserResponse? validateUserResponse =
        (await _validateUser(request)).data;

    if (validateUserResponse == null) {
      return LMResponse(success: false, errorMessage: "User validation failed");
    }

    LMChatNotificationHandler.instance.registerDevice(
      validateUserResponse.user!.id,
    );

    // get member state store them in local preference
    LMResponse memberStateResponse = await _getMemberState();

    // get community configurations and store them in local preference
    LMResponse communityConfigurations = await _getCommunityConfigurations();

    // check if member state or community configurations are not fetched successfully
    if (!memberStateResponse.success) {
      return LMResponse(
        success: false,
        errorMessage: memberStateResponse.errorMessage,
      );
    } else if (!communityConfigurations.success) {
      return LMResponse(
        success: false,
        errorMessage: communityConfigurations.errorMessage,
      );
    }

    return LMResponse(success: true, data: validateUserResponse);
  }

  /// This function is used to logout the user session.
  Future<LMResponse<void>> logout(LogoutRequest? request) async {
    LMResponse<void> response = await lmChatClient.logout(
      request ?? LogoutRequestBuilder().build(),
    );
    return response;
  }

  /// This function is used to initiate the user session.
  /// The [initiateUserRequest] parameter is required to initiate the user session.
  /// The [initiateUserRequest] parameter must contain the [apiKey], [userId], and [userName].
  Future<LMResponse<InitiateUserResponse>> initiateUser(
      {required InitiateUserRequest initiateUserRequest}) async {
    if (initiateUserRequest.apiKey == null &&
        initiateUserRequest.userId == null &&
        initiateUserRequest.userName == null) {
      return LMResponse.error(
        errorMessage: "ApiKey, UUID and Username are required",
      );
    } else {
      LMResponse<InitiateUserResponse> response =
          await lmChatClient.initiateUser(initiateUserRequest);

      if (!response.success) {
        return LMResponse(success: false, errorMessage: response.errorMessage);
      }
      // register device for push notification
      final User? user = response.data!.user;
      if (user != null) {
        LMChatNotificationHandler.instance.registerDevice(user.id);
      }
      return response;
    }
  }

  /// This function is used to get the member state and store them in the local preference.
  /// The function returns a [LMResponse] object.
  /// If the member state is fetched successfully, the [LMResponse] object gives [success] as true and [data] as [MemberStateResponse].
  Future<LMResponse<MemberStateResponse>> _getMemberState() async {
    LMResponse<MemberStateResponse> response = await client.getMemberState();
    if (response.success && response.data != null) {
      await LMChatLocalPreference.instance.storeMemberRights(response.data!);
    }
    return response;
  }

  /// This function is used to validate the user session. using the [accessToken] and [refreshToken] parameters.
  Future<LMResponse<ValidateUserResponse>> _validateUser(
      ValidateUserRequest request) async {
    return client.validateUser(request);
  }

  Future<LMResponse<GetCommunityConfigurationsResponse>>
      _getCommunityConfigurations() async {
    final response = await lmChatClient.getCommunityConfigurations();

    if (response.success && response.data != null) {
      await LMChatLocalPreference.instance.clearCommunityConfiguration();
      for (CommunityConfigurations configuration
          in response.data!.communityConfigurations) {
        if (configuration.type == 'chat_poll') {
          await LMChatLocalPreference.instance
              .storeCommunityConfiguration(configuration);
          return response;
        }
      }
    }

    return response;
  }
}
