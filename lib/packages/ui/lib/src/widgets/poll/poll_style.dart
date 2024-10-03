import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// {@template lm_chat_poll_style}
/// Style class for Poll widget
/// {@endtemplate}
class LMChatPollStyle {
  ///[EdgeInsets] for margin
  final EdgeInsets? margin;

  ///[EdgeInsets] for padding
  final EdgeInsets? padding;

  ///[BoxDecoration] for decoration
  final BoxDecoration? decoration;

  ///[Color] for background color of the poll
  final Color? backgroundColor;

  ///[TextStyle] for poll question text
  final TextStyle? pollQuestionStyle;

  /// [String] for poll question expanded text
  final String? pollTypeTextStyle;

  ///[LMChatTextStyle] for poll info text
  final LMChatTextStyle? voteTypeTextStyle;

  ///[LMChatTextStyle] for poll answer text
  final LMChatTextStyle? pollAnswerStyle;

  /// [LMChatTextStyle] for time stamp text
  final LMChatTextStyle? timeStampStyle;

  /// [LMChatTextStyle] for submit poll text style
  final LMChatTextStyle? pollInfoStyle;

  /// [LMChatButtonStyle] for submit poll button style
  final LMChatButtonStyle? submitPollButtonStyle;

  ///[LMChatTextStyle] for edit poll options text
  final LMChatButtonStyle? editPollButtonStyle;

  /// [LMChatPollButtonStyle] for add poll option button style
  final LMChatButtonStyle? addPollOptionButtonStyle;

  /// [LMPollOptionStyle] for poll option style
  final LMChatPollOptionStyle? pollOptionStyle;

  /// {@macro lm_chat_poll_style}
  const LMChatPollStyle({
    this.margin,
    this.padding,
    this.decoration,
    this.backgroundColor,
    this.pollQuestionStyle,
    this.pollTypeTextStyle,
    this.voteTypeTextStyle,
    this.pollAnswerStyle,
    this.timeStampStyle,
    this.pollInfoStyle,
    this.submitPollButtonStyle,
    this.editPollButtonStyle,
    this.pollOptionStyle,
    this.addPollOptionButtonStyle,
  });

  /// basic poll style method for [LMChatPollStyle]
  factory LMChatPollStyle.basic({
    Color? primaryColor,
    Color? containerColor,
    Color? onContainer,
    Color? inActiveColor,
  }) {
    return LMChatPollStyle(
      backgroundColor: containerColor ?? Colors.white,
      decoration: BoxDecoration(
        color: containerColor ?? Colors.white,
      ),
      pollQuestionStyle: TextStyle(
        color: onContainer,
        fontSize: 16,
      ),
      pollInfoStyle: const LMChatTextStyle(
        textStyle: TextStyle(
          height: 1.33,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
        ),
      ),
      pollAnswerStyle: LMChatTextStyle(
        textStyle: TextStyle(
          height: 1.33,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: primaryColor,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 6,
        ),
      ),
      voteTypeTextStyle: LMChatTextStyle(
        textStyle: TextStyle(
          height: 1.33,
          fontSize: 14,
          color: inActiveColor,
        ),
      ),
      editPollButtonStyle: LMChatButtonStyle(
        icon: LMChatIcon(
          type: LMChatIconType.icon,
          icon: Icons.edit,
          style: LMChatIconStyle(
            color: primaryColor,
          ),
        ),
        backgroundColor: containerColor,
        borderRadius: 100,
        border: Border.all(
          color: primaryColor ?? LMChatDefaultTheme.primaryColor,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        margin: const EdgeInsets.only(top: 12, bottom: 6),
        spacing: 8,
      ),
      submitPollButtonStyle: LMChatButtonStyle(
        icon: LMChatIcon(
          type: LMChatIconType.icon,
          icon: Icons.touch_app_outlined,
          style: LMChatIconStyle(
            color: primaryColor,
          ),
        ),
        backgroundColor: containerColor,
        borderRadius: 100,
        border: Border.all(
          color: primaryColor ?? LMChatDefaultTheme.primaryColor,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        margin: const EdgeInsets.only(top: 12, bottom: 6),
        spacing: 8,
      ),
      addPollOptionButtonStyle: LMChatButtonStyle(
        backgroundColor: containerColor,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        borderRadius: 8,
        border: Border.all(
          color: primaryColor ?? LMChatDefaultTheme.primaryColor,
        ),
      ),
    );
  }

  /// copyWith method for [LMChatPollStyle]
  /// [LMChatPollStyle] object with values that are passed in the method
  /// will be updated and returned
  /// If a value is not passed in the method, then the value will remain the same
  /// as the original object
  LMChatPollStyle copyWith({
    EdgeInsets? margin,
    EdgeInsets? padding,
    BoxDecoration? decoration,
    Color? backgroundColor,
    TextStyle? pollQuestionStyle,
    String? pollTypeTextStyle,
    LMChatTextStyle? voteTypeTextStyle,
    LMChatTextStyle? pollAnswerStyle,
    LMChatTextStyle? timeStampStyle,
    LMChatTextStyle? pollInfoStyle,
    LMChatButtonStyle? submitPollButtonStyle,
    LMChatButtonStyle? editPollButtonStyle,
    LMChatButtonStyle? addPollOptionButtonStyle,
    LMChatPollOptionStyle? pollOptionStyle,
  }) {
    return LMChatPollStyle(
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      decoration: decoration ?? this.decoration,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      pollQuestionStyle: pollQuestionStyle ?? this.pollQuestionStyle,
      pollTypeTextStyle: pollTypeTextStyle ?? this.pollTypeTextStyle,
      voteTypeTextStyle: voteTypeTextStyle ?? this.voteTypeTextStyle,
      pollAnswerStyle: pollAnswerStyle ?? this.pollAnswerStyle,
      timeStampStyle: timeStampStyle ?? this.timeStampStyle,
      pollInfoStyle: pollInfoStyle ?? this.pollInfoStyle,
      submitPollButtonStyle:
          submitPollButtonStyle ?? this.submitPollButtonStyle,
      editPollButtonStyle: editPollButtonStyle ?? this.editPollButtonStyle,
      addPollOptionButtonStyle:
          addPollOptionButtonStyle ?? this.addPollOptionButtonStyle,
      pollOptionStyle: pollOptionStyle ?? this.pollOptionStyle,
    );
  }
}

/// {@template lm_chat_poll_option_style}
/// Style class for Poll option widget
/// {@endtemplate}
class LMChatPollOptionStyle {
  ///[Color] for poll option selected color
  final Color? pollOptionSelectedColor;

  ///[Color] for poll option other color
  final Color? pollOptionOtherColor;

  ///[Color] for tick in poll option selected
  final Color? pollOptionSelectedTickColor;

  ///[Color] for border of selected poll option
  final Color? pollOptionSelectedBorderColor;

  /// [Color] for text color of selected poll option
  final Color? pollOptionSelectedTextColor;

  /// [Color] for text color of other poll option
  final Color? pollOptionOtherTextColor;

  ///[LMChatTextStyle] for votes count text
  final LMChatTextStyle? votesCountStyles;

  ///[LMChatTextStyle] for poll option text style
  final LMChatTextStyle? pollOptionTextStyle;

  /// [BoxDecoration] for poll option decoration
  final BoxDecoration? pollOptionDecoration;

  /// {@macro lm_chat_poll_option_style}
  const LMChatPollOptionStyle({
    this.pollOptionSelectedColor,
    this.pollOptionOtherColor,
    this.pollOptionSelectedTickColor,
    this.pollOptionSelectedBorderColor,
    this.pollOptionSelectedTextColor,
    this.votesCountStyles,
    this.pollOptionOtherTextColor,
    this.pollOptionTextStyle,
    this.pollOptionDecoration,
  });

  /// copyWith method for [LMChatPollOptionStyle]
  LMChatPollOptionStyle copyWith({
    Color? pollOptionSelectedColor,
    Color? pollOptionOtherColor,
    Color? pollOptionSelectedTickColor,
    Color? pollOptionSelectedBorderColor,
    Color? pollOptionSelectedTextColor,
    Color? pollOptionOtherTextColor,
    LMChatTextStyle? votesCountStyles,
    LMChatTextStyle? pollOptionTextStyle,
    BoxDecoration? pollOptionDecoration,
  }) {
    return LMChatPollOptionStyle(
      pollOptionSelectedColor:
          pollOptionSelectedColor ?? this.pollOptionSelectedColor,
      pollOptionOtherColor: pollOptionOtherColor ?? this.pollOptionOtherColor,
      pollOptionSelectedTickColor:
          pollOptionSelectedTickColor ?? this.pollOptionSelectedTickColor,
      pollOptionSelectedBorderColor:
          pollOptionSelectedBorderColor ?? this.pollOptionSelectedBorderColor,
      pollOptionSelectedTextColor:
          pollOptionSelectedTextColor ?? this.pollOptionSelectedTextColor,
      pollOptionOtherTextColor:
          pollOptionOtherTextColor ?? this.pollOptionOtherTextColor,
      votesCountStyles: votesCountStyles ?? this.votesCountStyles,
      pollOptionTextStyle: pollOptionTextStyle ?? this.pollOptionTextStyle,
      pollOptionDecoration: pollOptionDecoration ?? this.pollOptionDecoration,
    );
  }

  /// basic poll option style method for [LMChatPollOptionStyle]
  factory LMChatPollOptionStyle.basic(
      {Color? primaryColor, Color? inActiveColor}) {
    return LMChatPollOptionStyle(
      pollOptionSelectedColor: primaryColor?.withOpacity(0.2) ??
          LMChatDefaultTheme.primaryColor.withOpacity(0.2),
      pollOptionOtherColor:
          inActiveColor ?? const Color.fromRGBO(230, 235, 245, 1),
    );
  }
}
