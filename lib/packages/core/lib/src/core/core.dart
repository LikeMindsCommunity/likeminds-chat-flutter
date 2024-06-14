import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/core/configurations.dart';
import 'package:likeminds_chat_flutter_core/src/utils/firebase/firebase.dart';
import 'package:likeminds_chat_flutter_core/src/utils/notifications/notification_handler.dart';
import 'package:likeminds_chat_flutter_core/src/utils/preferences/preferences.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:flutter/foundation.dart';

class LMChatCore {
  //Instance variables
  late final LMChatClient lmChatClient;
  late final LMChatConfig chatConfig;
  late String _clientDomain;
  late LMChatWidgetUtility _widgetUtility;

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

  /// Main initialize function for initalising LMChatCore
  Future<LMResponse<void>> initialize({
    required String apiKey,
    LMChatClient? lmChatClient,
    String? domain,
    LMChatConfig? config,
    LMChatWidgetUtility? widgets,
    LMChatThemeData? theme,
  }) async {
    this.lmChatClient =
        lmChatClient ?? (LMChatClientBuilder()..apiKey(apiKey)).build();
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

  Future<LMResponse<void>> logout(LogoutRequest? request) async {
    LMResponse<void> response = await lmChatClient.logout(
      request ?? LogoutRequestBuilder().build(),
    );
    return response;
  }

  Future<LMResponse<InitiateUserResponse>> initiateUser(
      {required InitiateUserRequest initiateUserRequest}) async {
    if (initiateUserRequest.apiKey == null &&
        initiateUserRequest.userId == null &&
        initiateUserRequest.userName == null) {
      return LMResponse(
          success: false,
          errorMessage: "ApiKey, UUID and Username are required");
    } else {
      LMResponse<InitiateUserResponse> response =
          await lmChatClient.initiateUser(initiateUserRequest);

      if (!response.success) {
        return LMResponse(success: false, errorMessage: response.errorMessage);
      } else {
        // String accessToken = initiateUserResponse.data!.accessToken!;
        // String refreshToken = initiateUserResponse.data!.refreshToken!;
        final user = response.data!.initiateUser!.user;
        final memberRights = await getMemberState();
        await LMChatCore.instance.lmChatClient.insertOrUpdateLoggedInUser(user);
        await LMChatCore.instance.lmChatClient
            .insertOrUpdateLoggedInMemberState(memberRights.data!);
        await LMChatCore.instance.lmChatClient
            .insertOrUpdateCommunity(response.data!.initiateUser!.community);
        LMChatNotificationHandler.instance.registerDevice(user.id);
        return response;
      }
    }
  }

  Future<LMResponse<MemberStateResponse>> getMemberState() async {
    return await lmChatClient.getMemberState();
  }
}
