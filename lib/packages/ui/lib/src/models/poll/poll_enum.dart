/// {@template lm_chat_poll_multi_select_state}
/// Enum to define the multi select state of the poll
/// i.e. exactly, at least, at most
/// {@endtemplate}
enum LMChatPollMultiSelectState {
  /// User can select exactly n options
  exactly(
    value: 0,
    name: 'exactly',
  ),

  /// User can select at most n options
  atMax(
    value: 1,
    name: 'at most',
  ),

  /// User can select at least n options
  atLeast(
    value: 2,
    name: 'at least',
  );

  /// Value of the enum
  final int value;

  /// Display String of the enum
  final String name;

  const LMChatPollMultiSelectState({
    required this.value,
    required this.name,
  });

  factory LMChatPollMultiSelectState.fromValue(int? value) {
    switch (value) {
      case 0:
        return LMChatPollMultiSelectState.exactly;
      case 1:
        return LMChatPollMultiSelectState.atMax;
      case 2:
        return LMChatPollMultiSelectState.atLeast;
      default:
        return LMChatPollMultiSelectState.exactly;
    }
  }
}

/// {@template lm_chat_poll_type}
/// Enum to define the type of poll
/// i.e. instant, deferred and open
/// {@endtemplate}
enum LMChatPollType {
  /// Instant poll
  /// User can see the results as soon as they vote
  instant(
    value: 0,
  ),

  /// Deferred poll
  /// User can see the results only after the poll ends
  deferred(
    value: 1,
  ),

  /// Open poll
  /// User can see the results without voting or waiting for the poll to end
  open(
    value: 2,
  );

  /// Value of the enum
  final int value;

  const LMChatPollType({
    required this.value,
  });

  factory LMChatPollType.fromValue(int? value) {
    switch (value) {
      case 0:
        return LMChatPollType.instant;
      case 1:
        return LMChatPollType.deferred;
      case 2:
        return LMChatPollType.open;
      default:
        return LMChatPollType.instant;
    }
  }
}
