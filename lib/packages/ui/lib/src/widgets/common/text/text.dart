import 'package:flutter/material.dart';

/// {@template lm_chat_text}
/// A simple text widget to be used throughout the Chat experience
///
/// Provides high level customisability through [LMChatTextStyle]
///
/// Also, can add onTap functionality, and underlays
/// {@endtemplate}
class LMChatText extends StatelessWidget {
  /// text to be shown as [String]
  final String text;

  /// onTap functionality by providing a [Function]
  final Function()? onTap;

  /// style class to provide appearance customisability
  final LMChatTextStyle? style;

  /// {@macro lm_chat_text}
  const LMChatText(
    this.text, {
    Key? key,
    this.style,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LMChatTextStyle inStyle = style ?? LMChatTextStyle.basic();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: inStyle.padding ?? EdgeInsets.zero,
        decoration: BoxDecoration(
          color: inStyle.backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(inStyle.borderRadius ?? 4),
        ),
        child: AbsorbPointer(
          absorbing: onTap == null,
          child: Text(
            text,
            textAlign: inStyle.textAlign,
            maxLines: inStyle.maxLines,
            style: inStyle.textStyle,
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

/// {@template lm_chat_text_style}
/// Style class for [LMChatText]; used for customization
/// {@endtemplate}
class LMChatTextStyle {
  /// [int] describing maximum lines a text spans
  final int? maxLines;

  /// Align behaviour for text [TextAlign]
  final TextAlign? textAlign;

  /// Default Flutter styling class for changing look of the text [TextStyle]
  final TextStyle? textStyle;

  /// Padding between the surrounding box and text
  final EdgeInsetsGeometry? padding;

  /// Background colour of the surrounding box of text
  final Color? backgroundColor;

  /// Border radius of the surrounding box of text
  final double? borderRadius;

  /// Background colour of the surrounding box of text
  final BoxBorder? border;

  /// The minimum number of lines to be supported
  final int? minLines;

  /// {@macro lm_chat_text}
  const LMChatTextStyle({
    this.textStyle,
    this.maxLines,
    this.minLines,
    this.textAlign,
    this.padding,
    this.border,
    this.borderRadius,
    this.backgroundColor,
  });

  /// Basic style factory constructor; used as default
  factory LMChatTextStyle.basic() {
    return const LMChatTextStyle(
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
    int? minLines,
    TextOverflow? overflow,
    TextAlign? textAlign,
    EdgeInsetsGeometry? padding,
    BoxBorder? border,
    double? borderRadius,
    Color? backgroundColor,
  }) {
    return LMChatTextStyle(
      textStyle: textStyle ?? this.textStyle,
      maxLines: maxLines ?? this.maxLines,
      minLines: minLines ?? this.minLines,
      textAlign: textAlign ?? this.textAlign,
      padding: padding ?? this.padding,
      border: border ?? this.border,
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}
