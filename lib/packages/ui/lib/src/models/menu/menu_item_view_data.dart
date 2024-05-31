import 'package:flutter/material.dart';

class LMChatMenuItemViewData {
  const LMChatMenuItemViewData._({
    required this.leading,
    required this.title,
    required this.onTap,
  });
  final Widget leading;
  final Widget title;
  final VoidCallback onTap;
}

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

  LMChatMenuItemViewData build() {
    return LMChatMenuItemViewData._(
      leading: _leading!,
      title: _title!,
      onTap: _onTap!,
    );
  }
}
