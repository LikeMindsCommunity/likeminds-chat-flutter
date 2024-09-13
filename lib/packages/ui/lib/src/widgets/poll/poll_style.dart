import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

class LMChatPollStyle {
  ///[bool] to check if the poll is composable
  final bool isComposable;

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
  final String? pollQuestionExpandedText;

  ///[LMChatTextStyle] for poll info text
  final LMChatTextStyle? pollInfoStyles;

  ///[LMChatTextStyle] for poll answer text
  final LMChatTextStyle? pollAnswerStyle;

  /// [LMChatTextStyle] for time stamp text
  final LMChatTextStyle? timeStampStyle;

  ///[LMChatTextStyle] for percentage text
  final LMChatTextStyle? percentageStyle;

  ///[LMChatTextStyle] for edit poll options text
  final LMChatTextStyle? editPollOptionsStyles;

  /// [LMChatTextStyle] for submit poll text style
  final LMChatTextStyle? submitPollTextStyle;

  /// [LMChatButtonStyle] for submit poll button style
  final LMChatButtonStyle? submitPollButtonStyle;

  /// [LMPollOptionStyle] for poll option style
  final LMChatPollOptionStyle? pollOptionStyle;

  const LMChatPollStyle({
    this.isComposable = false,
    this.margin,
    this.padding,
    this.decoration,
    this.backgroundColor,
    this.pollQuestionStyle,
    this.pollQuestionExpandedText,
    this.pollInfoStyles,
    this.pollAnswerStyle,
    this.timeStampStyle,
    this.percentageStyle,
    this.editPollOptionsStyles,
    this.submitPollTextStyle,
    this.submitPollButtonStyle,
    this.pollOptionStyle,
  });

  factory LMChatPollStyle.basic({
    Color? primaryColor,
    Color? containerColor,
    Color? inActiveColor,
    bool isComposable = false,
  }) {
    return LMChatPollStyle(
      isComposable: isComposable,
      margin: EdgeInsets.symmetric(
          vertical: 8, horizontal: isComposable ? 16.0 : 0),
      backgroundColor: containerColor ?? Colors.white,
      decoration: BoxDecoration(
        color: containerColor ?? Colors.white,
        borderRadius: isComposable ? BorderRadius.circular(8) : null,
        border: isComposable
            ? Border.all(
                color: Colors.grey,
              )
            : null,
      ),
      pollOptionStyle: LMChatPollOptionStyle.basic(
          primaryColor: primaryColor, inActiveColor: inActiveColor),
    );
  }

  LMChatPollStyle copyWith({
    bool? isComposable,
    EdgeInsets? margin,
    EdgeInsets? padding,
    BoxDecoration? decoration,
    Color? backgroundColor,
    TextStyle? pollQuestionStyle,
    String? pollQuestionExpandedText,
    LMChatTextStyle? pollInfoStyles,
    LMChatTextStyle? pollAnswerStyle,
    LMChatTextStyle? timeStampStyle,
    LMChatTextStyle? votesCountStyles,
    LMChatTextStyle? percentageStyle,
    LMChatTextStyle? editPollOptionsStyles,
    LMChatTextStyle? submitPollTextStyle,
    LMChatButtonStyle? submitPollButtonStyle,
    LMChatPollOptionStyle? pollOptionStyle,
  }) {
    return LMChatPollStyle(
      isComposable: isComposable ?? this.isComposable,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      decoration: decoration ?? this.decoration,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      pollQuestionStyle: pollQuestionStyle ?? this.pollQuestionStyle,
      pollQuestionExpandedText:
          pollQuestionExpandedText ?? this.pollQuestionExpandedText,
      pollInfoStyles: pollInfoStyles ?? this.pollInfoStyles,
      pollAnswerStyle: pollAnswerStyle ?? this.pollAnswerStyle,
      timeStampStyle: timeStampStyle ?? this.timeStampStyle,
      percentageStyle: percentageStyle ?? this.percentageStyle,
      editPollOptionsStyles:
          editPollOptionsStyles ?? this.editPollOptionsStyles,
      submitPollTextStyle: submitPollTextStyle ?? this.submitPollTextStyle,
      submitPollButtonStyle:
          submitPollButtonStyle ?? this.submitPollButtonStyle,
      pollOptionStyle: pollOptionStyle ?? this.pollOptionStyle,
    );
  }
}

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
