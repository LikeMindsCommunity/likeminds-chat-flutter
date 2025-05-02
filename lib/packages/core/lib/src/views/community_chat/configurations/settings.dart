/// {@template lm_community_chat_setting}
/// [LMCommunityChatSetting] is a class used to configure the Community Chat Screen
/// (LMCommunityChatScreen).
/// {@endtemplate}
class LMCommunityChatSetting {
  /// Custom tags to be used for fetching group chatrooms
  final String? tag;

  /// {@macro lm_community_chat_setting}
  const LMCommunityChatSetting({
    this.tag,
  });
}
