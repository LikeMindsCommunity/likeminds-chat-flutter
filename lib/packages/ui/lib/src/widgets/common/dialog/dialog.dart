import 'package:flutter/material.dart';

/// {@template lm_chat_dialog}
/// A widget to show a chat dialog.
/// {@endtemplate}
class LMChatDialog extends StatelessWidget {
  /// {@macro lm_chat_dialog}
  /// Creates a [LMChatDialog] widget.
  const LMChatDialog({
    super.key,
    this.style,
    this.title,
    this.content,
    this.actions,
  });

  /// The style of the dialog.
  final LMChatDialogStyle? style;

  /// The title of the dialog.
  final Widget? title;

  /// The content of the dialog.
  final Widget? content;

  /// The actions of the dialog.
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: style?.backgroundColor,
      shape: style?.shape,
      title: title,
      content: content,
      actions: actions,
    );
  }
}

/// The style of the [LMChatDialog].
class LMChatDialogStyle {
  /// The background color of the dialog.
  final Color? backgroundColor;

  /// Shape of the dialog.
  final ShapeBorder? shape;

  /// Constructs an instance of [LMChatDialogStyle].
  const LMChatDialogStyle({
    this.backgroundColor,
    this.shape,
  });

  /// Creates a copy of this [LMChatDialogStyle] but with the given fields
  /// replaced with the new values.
  /// If the new values are null, the original values will be used.
  LMChatDialogStyle copyWith({
    Color? backgroundColor,
    ShapeBorder? shape,
  }) {
    return LMChatDialogStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      shape: shape ?? this.shape,
    );
  }

  /// basic style
  /// The default style of the dialog.
  factory LMChatDialogStyle.basic() {
    return const LMChatDialogStyle();
  }
}
