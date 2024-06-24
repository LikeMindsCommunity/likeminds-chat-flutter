import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/core/configurations.dart';
import 'package:likeminds_chat_flutter_core/src/utils/firebase/firebase.dart';
import 'package:likeminds_chat_flutter_core/src/utils/preferences/preferences.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:likeminds_chat_flutter_core/src/utils/callback/lm_chat_callback.dart';

class LMChatCore {
  //Instance variables
  late final LMChatClient lmChatClient;
  late final LMChatConfig chatConfig;
  late String _clientDomain;
  late LMChatWidgetUtility _widgetUtility;
  // LMChatSDKCallbackImplementation? _lmChatSDKCallback;

  /// Singleton class for LMChatCore
  LMChatCore._();
  static LMChatCore? _instance;
  static LMChatCore get instance => _instance ??= LMChatCore._();

  /// Instance of client [LMChatClient] accessible through core class.
  static LMChatClient get client => instance.lmChatClient;

  /// Instance of configuration file passed while initialising
  static LMChatConfig get config => instance.chatConfig;

  /// Instance of widget utility class through core.
  static LMChatWidgetUtility get widgets => instance._widgetUtility;

  /// Domain passed from client's end [String]
  static String get domain => instance._clientDomain;

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
    LMChatClient? lmChatClient,
    String? domain,
    LMChatConfig? config,
    LMChatWidgetUtility? widgets,
    LMChatThemeData? theme,
    LMChatCoreCallback? lmChatCallback,
  }) async {
    final lmChatSDKCallback =
        LMChatSDKCallbackImplementation(lmChatCallback: lmChatCallback);
    this.lmChatClient = lmChatClient ??
        (LMChatClientBuilder()..sdkCallback(lmChatSDKCallback)).build();
    if (domain != null) _clientDomain = domain;
    chatConfig = config ?? LMChatConfig();
    if (widgets != null) _widgetUtility = widgets;
    LMChatTheme.instance.initialise(theme: theme);
    LMResponse initDB = await this.lmChatClient.initiateDB();
    if (!initDB.success) {
      return LMResponse.error(
          errorMessage: initDB.errorMessage ?? "Error in initiating DB");
    }
    await initFirebase();
    return LMResponse.success(data: null);
  }

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
    String? cachedAccessToken = LMChatLocalPreference.instance
        .fetchCache(LMChatStringConstants.accessToken)
        ?.value;
    String? cachedRefreshToken = LMChatLocalPreference.instance
        .fetchCache(LMChatStringConstants.refreshToken)
        ?.value;

    if (cachedAccessToken == null || cachedRefreshToken == null) {
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
        if (!memberState.success) {
          return LMResponse(
              success: false, errorMessage: memberState.errorMessage);
        }
      }
      return initiateUserResponse;
    } else {
      return await showChatWithoutApiKey(
        accessToken: cachedAccessToken,
        refreshToken: cachedRefreshToken,
      );
    }
  }

  /// This function is the starting point of the chat.
  /// It must be executed before displaying the chat home screen or accessing any other [LMChatCore] widgets or screens.
  /// The [accessToken] and [refreshToken] parameters are required to show the feed screen.
  /// If the [accessToken] and [refreshToken] parameters are not provided, the function will fetch them from the local preference.
  Future<LMResponse> showChatWithoutApiKey({
    String? accessToken,
    String? refreshToken,
  }) async {
    String? cachedAccessToken;
    String? cachedRefreshToken;
    if (accessToken == null || refreshToken == null) {
      cachedAccessToken = LMChatLocalPreference.instance
          .fetchCache(LMChatStringConstants.accessToken)
          ?.value;

      cachedRefreshToken = LMChatLocalPreference.instance
          .fetchCache(LMChatStringConstants.refreshToken)
          ?.value;
    } else {
      cachedAccessToken = accessToken;
      cachedRefreshToken = refreshToken;
    }

    if (cachedAccessToken == null || cachedRefreshToken == null) {
      return LMResponse(
          success: false,
          errorMessage: "Access token and Refresh token are required");
    }

    ValidateUserRequest request = (ValidateUserRequestBuilder()
          ..accessToken(cachedAccessToken)
          ..refreshToken(cachedRefreshToken))
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

    if (!memberStateResponse.success) {
      return LMResponse(
        success: false,
        errorMessage: memberStateResponse.errorMessage,
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
}
