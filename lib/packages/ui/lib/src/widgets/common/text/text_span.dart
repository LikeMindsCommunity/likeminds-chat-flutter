import 'package:flutter/material.dart';

/// {@template lm_chat_text_span}
/// A customizable TextSpan widget to be used throughout the Chat experience.
///
/// Provides high-level customizability through [LMChatTextSpanStyle].
/// {@endtemplate}
class LMChatTextSpan {
  /// The text to be displayed in the span.
  final String? text;

  /// List of child [LMChatTextSpan]s to be included in this span (for nested spans).
  final List<LMChatTextSpan>? children;

  /// Style class to provide appearance customizability.
  final LMChatTextSpanStyle? style;

  /// {@macro lm_chat_text_span}
  const LMChatTextSpan({
    this.text,
    this.children,
    this.style,
  });

  /// Converts this [LMChatTextSpan] into a Flutter [TextSpan].
  TextSpan toTextSpan() {
    LMChatTextSpanStyle inStyle = style ?? LMChatTextSpanStyle.basic();

    return TextSpan(
      text: text,
      style: inStyle.textStyle,
      children: children?.map((child) => child.toTextSpan()).toList(),
    );
  }

  /// copyWith function to get a new object of [LMChatTextSpan]
  /// with specific single values passed.
  LMChatTextSpan copyWith({
    String? text,
    List<LMChatTextSpan>? children,
    LMChatTextSpanStyle? style,
  }) {
    return LMChatTextSpan(
      text: text ?? this.text,
      children: children ?? this.children,
      style: style ?? this.style,
    );
  }
}

/// {@template lm_chat_text_span_style}
/// Style class for [LMChatTextSpan]; used for customization.
/// {@endtemplate}
class LMChatTextSpanStyle {
  /// Default Flutter styling class for changing the look of the text [TextStyle].
  final TextStyle? textStyle;

  /// {@macro lm_chat_text_span_style}
  const LMChatTextSpanStyle({
    this.textStyle,
  });

  /// Basic style factory constructor; used as default.
  factory LMChatTextSpanStyle.basic() {
    return const LMChatTextSpanStyle(
      textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.black, // Replace with your theme's default text color
      ),
    );
  }

  /// copyWith function to get a new object of [LMChatTextSpanStyle]
  /// with specific single values passed.
  LMChatTextSpanStyle copyWith({
    TextStyle? textStyle,
  }) {
    return LMChatTextSpanStyle(
      textStyle: textStyle ?? this.textStyle,
    );
  }
}
