import 'package:flutter/material.dart';

/// {@template chat_menu_item}
/// The chat menu item widget.
/// This widget is used to show the chat menu item.
/// The [LMChatMenuItem] widget takes the following parameters:
/// - [leading]: The leading widget.
/// - [title]: The title widget.
/// - [onTap]: The onTap function.
/// {@endtemplate}
class LMChatMenuItem {
  /// Creates a new [LMChatMenuItem] with the provided values.
  const LMChatMenuItem({
    this.leading,
    required this.title,
    required this.onTap,
  });

  /// The leading widget.
  final Widget? leading;

  /// The title widget.
  final Widget title;

  /// The onTap function.
  final VoidCallback onTap;

  /// copyWith method
  /// This method is used to create a copy of the [LMChatMenuItem] but with the given fields replaced with the new values.
  /// If the new values are null, the old values are used.
  /// The method returns a new [LMChatMenuItem] object.
  LMChatMenuItem copyWith({
    Widget? leading,
    Widget? title,
    VoidCallback? onTap,
  }) {
    return LMChatMenuItem(
      leading: leading ?? this.leading,
      title: title ?? this.title,
      onTap: onTap ?? this.onTap,
    );
  }
}
/// {@template chat_menu_item_style}
/// The style for the chat menu item.
/// This class is used to style the chat menu item.
/// The [LMChatMenuItemStyle] widget takes the following parameters:
/// {@endtemplate}
class LMChatMenuItemStyle {}
