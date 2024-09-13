/// {@template lm_chat_poll_multi_select_state}
/// Enum to define the multi select state of the poll
/// i.e. exactly, at least, at most
/// {@endtemplate}
enum LMChatPollMultiSelectState {
  /// User can select exactly n options
  exactly(
    value: 'exactly',
    name: 'exactly',
  ),

  /// User can select at least n options
  atLeast(
    value: 'at_least',
    name: 'at least',
  ),

  /// User can select at most n options
  atMax(
    value: 'at_max',
    name: 'at most',
  );

  /// Value of the enum
  final String value;

  /// Display String of the enum
  final String name;

  const LMChatPollMultiSelectState({
    required this.value,
    required this.name,
  });

  factory LMChatPollMultiSelectState.fromValue(String value) {
    switch (value) {
      case 'exactly':
        return LMChatPollMultiSelectState.exactly;
      case 'at_least':
        return LMChatPollMultiSelectState.atLeast;
      case 'at_max':
        return LMChatPollMultiSelectState.atMax;
      default:
        return LMChatPollMultiSelectState.exactly;
    }
  }
}

/// {@template lm_chat_poll_type}
/// Enum to define the type of poll
/// i.e. instant, deferred
/// {@endtemplate}
enum LMChatPollType {
  /// Instant poll
  instant(
    value: 'instant',
  ),

  /// Deferred poll
  deferred(
    value: 'deferred',
  );

  /// Value of the enum
  final String value;

  const LMChatPollType({
    required this.value,
  });

  factory LMChatPollType.fromValue(String value) {
    switch (value) {
      case 'instant':
        return LMChatPollType.instant;
      case 'deferred':
        return LMChatPollType.deferred;
      default:
        return LMChatPollType.instant;
    }
  }
}
