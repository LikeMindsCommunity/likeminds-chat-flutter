import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:likeminds_chat_flutter_ui/src/models/models.dart';

/// {@template lm_chat_poll_view_data}
/// `LMChatPollViewData` is a model class that holds the data for the poll info view.
/// This class is used to display the poll information in the chat screen.
/// {@endtemplate}
class LMChatPollViewData {
  /// Indicates if the poll is anonymous.
  final bool? isAnonymous;

  /// Allows adding new options to the poll.
  final bool? allowAddOption;

  /// Type of the poll.
  final LMChatPollType? pollType;

  /// Text description of the poll type.
  final String? pollTypeText;

  /// Text description of the submit type.
  final String? submitTypeText;

  /// Expiry time of the poll.
  final int? expiryTime;

  /// Number of selections allowed in multiple select polls.
  final int? multipleSelectNum;

  /// State of multiple select options.
  final LMChatPollMultiSelectState? multipleSelectState;

  /// List of poll options.
  final List<LMChatPollOptionViewData>? pollOptions;

  /// Text of the poll answer.
  final String? pollAnswerText;

  /// Indicates if the poll has been submitted.
  final bool? isPollSubmitted;

  /// Indicates if the poll results should be shown.
  final bool? toShowResult;

  /// ID of the conversation associated with the poll.
  final int? conversationId;

  LMChatPollViewData._({
    required this.isAnonymous,
    required this.allowAddOption,
    required this.pollType,
    required this.pollTypeText,
    required this.submitTypeText,
    required this.expiryTime,
    required this.multipleSelectNum,
    required this.multipleSelectState,
    required this.pollOptions,
    required this.pollAnswerText,
    required this.isPollSubmitted,
    required this.toShowResult,
    required this.conversationId,
  });

  /// copyWith method is used to create a new instance of `LMChatPollInfoViewData` with the updated values.
  /// If the new values are not provided, the old values are used.
  LMChatPollViewData copyWith({
    bool? isAnonymous,
    bool? allowAddOption,
    LMChatPollType? pollType,
    String? pollTypeText,
    String? submitTypeText,
    int? expiryTime,
    int? multipleSelectNum,
    LMChatPollMultiSelectState? multipleSelectState,
    List<LMChatPollOptionViewData>? pollOptions,
    String? pollAnswerText,
    bool? isPollSubmitted,
    bool? toShowResult,
    int? conversationId,
  }) {
    return LMChatPollViewData._(
      isAnonymous: isAnonymous ?? this.isAnonymous,
      allowAddOption: allowAddOption ?? this.allowAddOption,
      pollType: pollType ?? this.pollType,
      pollTypeText: pollTypeText ?? this.pollTypeText,
      submitTypeText: submitTypeText ?? this.submitTypeText,
      expiryTime: expiryTime ?? this.expiryTime,
      multipleSelectNum: multipleSelectNum ?? this.multipleSelectNum,
      multipleSelectState: multipleSelectState ?? this.multipleSelectState,
      pollOptions: pollOptions ?? this.pollOptions,
      pollAnswerText: pollAnswerText ?? this.pollAnswerText,
      isPollSubmitted: isPollSubmitted ?? this.isPollSubmitted,
      toShowResult: toShowResult ?? this.toShowResult,
      conversationId: conversationId ?? this.conversationId,
    );
  }
}

/// {@template lm_chat_poll_view_data_builder}
/// `LMChatPollViewDataBuilder` is a builder class that is used to build the `LMChatPollInfoViewData` object.
/// This class is used to set the values for the `LMChatPollInfoViewData` object.
/// {@endtemplate}
class LMChatPollViewDataBuilder {
  bool? _isAnonymous;
  bool? _allowAddOption;
  LMChatPollType? _pollType;
  String? _pollTypeText;
  String? _submitTypeText;
  int? _expiryTime;
  int? _multipleSelectNum;
  LMChatPollMultiSelectState? _multipleSelectState;
  List<LMChatPollOptionViewData>? _pollOptions;
  String? _pollAnswerText;
  bool? _isPollSubmitted;
  bool? _toShowResult;
  int? _conversationId;

  /// isAnonymous method is used to set the value for the isAnonymous field.
  void isAnonymous(bool? isAnonymous) {
    _isAnonymous = isAnonymous;
  }

  /// allowAddOption method is used to set the value for the allowAddOption field.
  void allowAddOption(bool? allowAddOption) {
    _allowAddOption = allowAddOption;
  }

  /// pollType method is used to set the value for the pollType field.
  void pollType(LMChatPollType? pollType) {
    _pollType = pollType;
  }

  /// pollTypeText method is used to set the value for the pollTypeText field.
  void pollTypeText(String? pollTypeText) {
    _pollTypeText = pollTypeText;
  }

  /// submitTypeText method is used to set the value for the submitTypeText field.
  void submitTypeText(String? submitTypeText) {
    _submitTypeText = submitTypeText;
  }

  /// expiryTime method is used to set the value for the expiryTime field.
  void expiryTime(int? expiryTime) {
    _expiryTime = expiryTime;
  }

  /// multipleSelectNum method is used to set the value for the multipleSelectNum field.
  void multipleSelectNum(int? multipleSelectNum) {
    _multipleSelectNum = multipleSelectNum;
  }

  /// multipleSelectState method is used to set the value for the multipleSelectState field.
  void multipleSelectState(LMChatPollMultiSelectState? multipleSelectState) {
    _multipleSelectState = multipleSelectState;
  }

  /// pollOptions method is used to set the value for the pollOptions field.
  void pollOptions(List<LMChatPollOptionViewData>? pollOptions) {
    _pollOptions = pollOptions;
  }

  /// pollAnswerText method is used to set the value for the pollAnswerText field.
  void pollAnswerText(String? pollAnswerText) {
    _pollAnswerText = pollAnswerText;
  }

  /// isPollSubmitted method is used to set the value for the isPollSubmitted field.
  void isPollSubmitted(bool? isPollSubmitted) {
    _isPollSubmitted = isPollSubmitted;
  }

  /// toShowResult method is used to set the value for the toShowResult field.
  void toShowResult(bool? toShowResult) {
    _toShowResult = toShowResult;
  }

  /// conversationId method is used to set the value for the conversationId field.
  void conversationId(int? conversationId) {
    _conversationId = conversationId;
  }

  /// build method is used to create a new instance of `LMChatPollInfoViewData` with the provided values.
  LMChatPollViewData build() {
    return LMChatPollViewData._(
      isAnonymous: _isAnonymous,
      allowAddOption: _allowAddOption,
      pollType: _pollType,
      pollTypeText: _pollTypeText,
      submitTypeText: _submitTypeText,
      expiryTime: _expiryTime,
      multipleSelectNum: _multipleSelectNum,
      multipleSelectState: _multipleSelectState,
      pollOptions: _pollOptions,
      pollAnswerText: _pollAnswerText,
      isPollSubmitted: _isPollSubmitted,
      toShowResult: _toShowResult,
      conversationId: _conversationId,
    );
  }
}
