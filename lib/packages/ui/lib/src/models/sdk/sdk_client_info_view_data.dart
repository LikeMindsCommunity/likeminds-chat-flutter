import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// `LMChatSDKClientInfoViewData` is a model class that holds the data for the client info view.
/// This class is used to display the client information in the chat screen.
class LMChatSDKClientInfoViewData {
  int community;
  int user;
  String uuid;
  String? widgetId;

  LMChatSDKClientInfoViewData._({
    required this.community,
    required this.user,
    required this.uuid,
    this.widgetId,
  });

  /// copyWith method is used to create a new instance of `LMChatSDKClientInfoViewData` with the updated values.
  /// If the new values are not provided, the old values are used.
  LMChatSDKClientInfoViewData copyWith({
    int? community,
    int? user,
    String? uuid,
    String? widgetId,
  }) {
    return LMChatSDKClientInfoViewData._(
      community: community ?? this.community,
      user: user ?? this.user,
      uuid: uuid ?? this.uuid,
      widgetId: widgetId ?? this.widgetId,
    );
  }
}


/// `LMChatSDKClientInfoViewDataBuilder` is a builder class used to create an instance of `LMChatSDKClientInfoViewData`.
/// This class is used to create an instance of `LMChatSDKClientInfoViewData` with the provided values.
class LMSDKClientInfoViewDataBuilder {
  int? _community;
  int? _user;
  String? _uuid;
  String? _widgetId;

  void community(int community) {
    _community = community;
  }

  void user(int user) {
    _user = user;
  }

  void uuid(String uuid) {
    _uuid = uuid;
  }

  void widgetId(String widgetId) {
    _widgetId = widgetId;
  }

  LMChatSDKClientInfoViewData build() {
    return LMChatSDKClientInfoViewData._(
      community: _community!,
      user: _user!,
      uuid: _uuid!,
      widgetId: _widgetId,
    );
  }
}