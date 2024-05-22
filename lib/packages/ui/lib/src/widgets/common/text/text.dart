import 'package:flutter/material.dart';

/// A simple text widget to be used throughout the Feed experience
/// Provides high level customisability through [LMChatTextStyle]
/// Also, can add onTap functionality
class LMChatText extends StatelessWidget {
  /// text to be shown as [String]
  final String text;

  /// onTap functionality by providing a [Function]
  final Function()? onTap;

  /// style class to provide appearance customisability
  final LMChatTextStyle? style;

  const LMChatText(
    this.text, {
    Key? key,
    this.style,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LMChatTextStyle inStyle = style ?? LMChatTextStyle.basic();

    return Ink(
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          child: SelectableText(
            text,
            textAlign: inStyle.textAlign,
            maxLines: inStyle.maxLines,
            style: inStyle.textStyle,
            enableInteractiveSelection: inStyle.selectable,
          ),
        ),
      ),
    );
  }

  /// copyWith function to get a new object of [LMChatText]
  /// with specific single values passed
  LMChatText copyWith({
    String? text,
    LMChatTextStyle? style,
    Function()? onTap,
  }) {
    return LMChatText(
      text ?? this.text,
      style: style ?? this.style,
      onTap: onTap ?? this.onTap,
    );
  }
}

/// class representing style for a [LMChatText]
class LMChatTextStyle {
  /// [bool] to determine whether the text is selectable or not
  final bool selectable;

  /// [int] describing maximum lines a text spans
  final int? maxLines;

  /// align behaviour for text [TextAlign]
  final TextAlign? textAlign;

  /// default Flutter styling class for changing look of the text [TextStyle]
  final TextStyle? textStyle;

  const LMChatTextStyle({
    this.selectable = false,
    this.textStyle,
    this.maxLines,
    this.textAlign,
  });

  factory LMChatTextStyle.basic() {
    return const LMChatTextStyle(
      maxLines: 1,
      textAlign: TextAlign.start,
      textStyle: TextStyle(
        fontSize: 14,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// copyWith function to get a new object of [LMChatTextStyle]
  /// with specific single values passed
  LMChatTextStyle copyWith({
    bool? selectable,
    TextStyle? textStyle,
    int? maxLines,
    TextOverflow? overflow,
    TextAlign? textAlign,
  }) {
    return LMChatTextStyle(
      selectable: selectable ?? this.selectable,
      textStyle: textStyle ?? this.textStyle,
      maxLines: maxLines ?? this.maxLines,
      textAlign: textAlign ?? this.textAlign,
    );
  }
}
