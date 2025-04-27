import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';

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

  /// Creates a copy of this [LMChatDialog] but with the given fields
  /// replaced with the new values.
  /// If the new values are null, the original values will be used.
  LMChatDialog copyWith({
    LMChatDialogStyle? style,
    Widget? title,
    Widget? content,
    List<Widget>? actions,
  }) {
    return LMChatDialog(
      style: style ?? this.style,
      title: title ?? this.title,
      content: content ?? this.content,
      actions: actions ?? this.actions,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: style?.backgroundColor ?? LMChatTheme.theme.container,
      shape: style?.shape,
      title: title,
      content: content,
      actions: actions,
      actionsAlignment: style?.actionsAlignment,
      actionsPadding: style?.actionsPadding,
    );
  }
}

/// The style of the [LMChatDialog].
class LMChatDialogStyle {
  /// The background color of the dialog.
  final Color? backgroundColor;

  /// Shape of the dialog.
  final ShapeBorder? shape;

  /// The alignment of the actions in the dialog.
  final MainAxisAlignment? actionsAlignment;

  /// The padding of the actions in the dialog.
  final EdgeInsetsGeometry? actionsPadding;

  /// Constructs an instance of [LMChatDialogStyle].
  const LMChatDialogStyle({
    this.backgroundColor,
    this.shape,
    this.actionsAlignment,
    this.actionsPadding,
  });

  /// Creates a copy of this [LMChatDialogStyle] but with the given fields
  /// replaced with the new values.
  /// If the new values are null, the original values will be used.
  LMChatDialogStyle copyWith({
    Color? backgroundColor,
    ShapeBorder? shape,
    MainAxisAlignment? actionsAlignment,
    EdgeInsetsGeometry? actionsPadding,
  }) {
    return LMChatDialogStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      shape: shape ?? this.shape,
      actionsAlignment: actionsAlignment ?? this.actionsAlignment,
      actionsPadding: actionsPadding ?? this.actionsPadding,
    );
  }

  /// basic style
  /// The default style of the dialog.
  factory LMChatDialogStyle.basic() {
    return const LMChatDialogStyle();
  }
}
