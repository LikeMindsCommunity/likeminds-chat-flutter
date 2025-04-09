import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/common/text/text_span.dart';

/// {@template lm_chat_rich_text}
/// A customizable rich text widget to be used throughout the Chat experience.
///
/// Provides high-level customizability through [LMChatRichTextStyle].
///
/// Also supports onTap functionality and underlays.
/// {@endtemplate}
class LMChatRichText extends StatelessWidget {
  /// The list of [LMChatTextSpan]s to be displayed in the rich text.
  final LMChatTextSpan text;

  /// onTap functionality by providing a [Function].
  final Function()? onTap;

  /// Style class to provide appearance customizability.
  final LMChatRichTextStyle? style;

  /// {@macro lm_chat_rich_text}
  const LMChatRichText({
    required this.text,
    super.key,
    this.style,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    LMChatRichTextStyle inStyle = style ?? LMChatRichTextStyle.basic();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: inStyle.padding ?? EdgeInsets.zero,
        decoration: BoxDecoration(
          color: inStyle.backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(inStyle.borderRadius ?? 4),
          border: inStyle.border,
        ),
        child: AbsorbPointer(
          absorbing: onTap == null,
          child: RichText(
            maxLines: inStyle.maxLines,
            overflow: inStyle.overflow ?? TextOverflow.ellipsis,
            textAlign: inStyle.textAlign ?? TextAlign.start,
            text: text.toTextSpan(),
          ),
        ),
      ),
    );
  }

  /// copyWith function to get a new object of [LMChatRichText]
  /// with specific single values passed.
  LMChatRichText copyWith({
    LMChatTextSpan? text,
    LMChatRichTextStyle? style,
    Function()? onTap,
  }) {
    return LMChatRichText(
      text: text ?? this.text,
      style: style ?? this.style,
      onTap: onTap ?? this.onTap,
    );
  }
}

/// {@template lm_chat_rich_text_style}
/// Style class for [LMChatRichText]; used for customization.
/// {@endtemplate}
class LMChatRichTextStyle {
  /// [int] describing maximum lines a text spans.
  final int? maxLines;

  /// Align behavior for text [TextAlign].
  final TextAlign? textAlign;

  /// Default Flutter styling class for changing the look of the text [TextStyle].
  final TextStyle? defaultTextStyle;

  /// Padding between the surrounding box and text.
  final EdgeInsetsGeometry? padding;

  /// Background color of the surrounding box of text.
  final Color? backgroundColor;

  /// Border radius of the surrounding box of text.
  final double? borderRadius;

  /// Border of the surrounding box of text.
  final BoxBorder? border;

  /// Text overflow behavior.
  final TextOverflow? overflow;

  /// {@macro lm_chat_rich_text_style}
  const LMChatRichTextStyle({
    this.maxLines,
    this.textAlign,
    this.defaultTextStyle,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.overflow,
  });

  /// Basic style factory constructor; used as default.
  factory LMChatRichTextStyle.basic() {
    return const LMChatRichTextStyle(
      textAlign: TextAlign.start,
      defaultTextStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.grey, // Replace with your theme's grey color
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  /// copyWith function to get a new object of [LMChatRichTextStyle]
  /// with specific single values passed.
  LMChatRichTextStyle copyWith({
    int? maxLines,
    TextAlign? textAlign,
    TextStyle? defaultTextStyle,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    double? borderRadius,
    BoxBorder? border,
    TextOverflow? overflow,
  }) {
    return LMChatRichTextStyle(
      maxLines: maxLines ?? this.maxLines,
      textAlign: textAlign ?? this.textAlign,
      defaultTextStyle: defaultTextStyle ?? this.defaultTextStyle,
      padding: padding ?? this.padding,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      border: border ?? this.border,
      overflow: overflow ?? this.overflow,
    );
  }
}
