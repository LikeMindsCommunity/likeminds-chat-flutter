import 'package:flutter/material.dart';

class LMChatMenuItemViewData {
  const LMChatMenuItemViewData({
    required this.leading,
    required this.title,
    required this.onTap,
  });
  final Widget leading;
  final Widget title;
  final VoidCallback onTap;
}
