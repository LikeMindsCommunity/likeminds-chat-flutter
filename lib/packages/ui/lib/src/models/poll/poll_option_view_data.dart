import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// {@template lm_chat_poll_option_view_data}
/// `LMChatPollOptionViewData` is a model class used to represent the poll option data in the chat.
/// This class is used to display the poll options in the chat screen.
/// {@endtemplate}

class LMChatPollOptionViewData {
  /// Represents the unique identifier for the poll option.
  final int? id;

  /// The text description of the poll option.
  final String text;

  /// Indicates whether the poll option is selected by the user.
  final bool? isSelected;

  /// The percentage of votes received by the poll option.
  final int? percentage;

  /// The number of votes received by the poll option.
  final int? noVotes;

  /// The identifier for the conversation associated with the poll option.
  final int? conversationId;

  /// The user data of the member who created or is associated with the poll option.
  final LMChatUserViewData? member;

  LMChatPollOptionViewData._({
    required this.id,
    required this.text,
    required this.isSelected,
    required this.percentage,
    required this.noVotes,
    required this.conversationId,
    this.member,
  });

  /// copyWith method is used to create a new instance of `LMChatPollOPtionViewData` with the updated values.
  /// If the new values are not provided, the old values are used.
  LMChatPollOptionViewData copyWith({
    int? id,
    String? text,
    bool? isSelected,
    int? percentage,
    int? noVotes,
    int? conversationId,
    LMChatUserViewData? member,
  }) {
    return LMChatPollOptionViewData._(
      id: id ?? this.id,
      text: text ?? this.text,
      isSelected: isSelected ?? this.isSelected,
      percentage: percentage ?? this.percentage,
      noVotes: noVotes ?? this.noVotes,
      conversationId: conversationId ?? this.conversationId,
      member: member ?? this.member,
    );
  }
}

/// {@template lm_chat_poll_option_view_data_builder}
/// `LMChatPollOptionViewDataBuilder` is a builder class used to create an instance of `LMChatPollOPtionViewData`.
/// This class is used to create an instance of `LMChatPollOPtionViewData` with the provided values.
/// {@endtemplate}
class LMChatPollOptionViewDataBuilder {
  int? _id;
  String? _text;
  bool? _isSelected;
  int? _percentage;

  int? _noVotes;

  int? _conversationId;

  LMChatUserViewData? _member;

  /// id method is used to set the unique identifier for the poll option.
  void id(int? id) {
    _id = id;
  }

  /// text method is used to set the text description of the poll option.
  void text(String text) {
    _text = text;
  }

  /// isSelected method is used to set whether the poll option is selected by the user.
  void isSelected(bool? isSelected) {
    _isSelected = isSelected;
  }

  /// percentage method is used to set the percentage of votes received by the poll option.
  void percentage(int? percentage) {
    _percentage = percentage;
  }

  /// noVotes method is used to set the number of votes received by the poll option.
  void noVotes(int? noVotes) {
    _noVotes = noVotes;
  }

  /// conversationId method is used to set the identifier for the conversation associated with the poll option.
  void conversationId(int? conversationId) {
    _conversationId = conversationId;
  }

  /// member method is used to set the user data of the member who created or is associated with the poll option.
  void member(LMChatUserViewData? member) {
    _member = member;
  }

  /// build method is used to create an instance of `LMChatPollOPtionViewData` with the provided values.
  LMChatPollOptionViewData build() {
    if (_text == null) throw Exception('text is required');

    return LMChatPollOptionViewData._(
      id: _id,
      text: _text!,
      isSelected: _isSelected,
      percentage: _percentage,
      noVotes: _noVotes,
      conversationId: _conversationId,
      member: _member,
    );
  }
}
