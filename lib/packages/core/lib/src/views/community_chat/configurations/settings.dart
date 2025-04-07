/// {@template lm_community_chat_setting}
/// [LMCommunityChatSetting] is a class which is used to configure the home
/// screen. It is used to customize the home screen.
/// {@endtemplate}
class LMCommunityChatSetting {
  /// Custom tags to be used for fetching group chatrooms
  final String? tag;

  /// {@macro lm_community_chat_setting}
  const LMCommunityChatSetting({
    this.tag,
  });
}
