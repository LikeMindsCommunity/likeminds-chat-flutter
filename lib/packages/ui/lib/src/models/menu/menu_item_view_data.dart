import 'package:flutter/material.dart';

/// `LMChatMenuItemViewData` is a model class that holds the data for the menu item view.
/// This class is used to display the menu items in the chat screen.
class LMChatMenuItemViewData {
  const LMChatMenuItemViewData._({
    required this.leading,
    required this.title,
    required this.onTap,
  });
  final Widget leading;
  final Widget title;
  final VoidCallback onTap;

  /// copyWith method is used to create a new instance of `LMChatMenuItemViewData` with the updated values.
  /// If the new values are not provided, the old values are used.
  LMChatMenuItemViewData copyWith({
    Widget? leading,
    Widget? title,
    VoidCallback? onTap,
  }) {
    return LMChatMenuItemViewData._(
      leading: leading ?? this.leading,
      title: title ?? this.title,
      onTap: onTap ?? this.onTap,
    );
  }
}


/// `LMChatMenuItemViewDataBuilder` is a builder class used to create an instance of `LMChatMenuItemViewData`.
class LMChatMenuItemViewDataBuilder {
  Widget? _leading;
  Widget? _title;
  VoidCallback? _onTap;

  void leading(Widget leading) {
    _leading = leading;
  }

  void title(Widget title) {
    _title = title;
  }

  void onTap(VoidCallback onTap) {
    _onTap = onTap;
  }


  /// build method is used to create an instance of `LMChatMenuItemViewData` with the provided values.
  LMChatMenuItemViewData build() {
    return LMChatMenuItemViewData._(
      leading: _leading!,
      title: _title!,
      onTap: _onTap!,
    );
  }
}
