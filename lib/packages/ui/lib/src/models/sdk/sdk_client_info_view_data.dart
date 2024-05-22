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
}

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
