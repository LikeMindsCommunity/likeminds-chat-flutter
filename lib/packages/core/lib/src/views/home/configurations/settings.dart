/// {@template lm_chat_home_setting}
/// [LMChatHomeSetting] is a class which is used to configure the home
/// screen. It is used to customize the home screen.
/// {@endtemplate}
class LMChatHomeSetting {
  /// Custom tags to be used for fetching group chatrooms
  final String? tag;

  /// {@macro lm_chat_home_setting}
  const LMChatHomeSetting({
    this.tag,
  });
}
