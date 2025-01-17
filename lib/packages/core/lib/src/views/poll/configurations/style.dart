import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// {@template lm_chat_poll_style}
/// [LMChatCreatePollStyle] is a class which is used to style the create poll
/// screen. It is used to customize the chatroom screen.
/// {@endtemplate}
class LMChatCreatePollStyle {
  /// {@macro lm_chat_poll_style}
  const LMChatCreatePollStyle({
    this.pollQuestionStyle,
    this.optionStyle,
  });

  /// [LMChatTextFieldStyle] for poll question
  final LMChatTextFieldStyle? pollQuestionStyle;

  /// [LMChatTextFieldStyle] for poll options
  final LMChatTextFieldStyle? optionStyle;
}
