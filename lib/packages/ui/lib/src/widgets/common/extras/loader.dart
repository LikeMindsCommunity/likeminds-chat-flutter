import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';

class LMChatLoader extends StatelessWidget {
  final bool isPrimary;
  final LMChatLoaderStyle? style;

  const LMChatLoader({
    super.key,
    this.isPrimary = true,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    LMChatLoaderStyle style = this.style ?? LMChatTheme.theme.loaderStyle;
    return Center(
      child: CircularProgressIndicator.adaptive(
        backgroundColor: style.backgroundColor,
        valueColor: AlwaysStoppedAnimation<Color>(
          style.color ??
              (isPrimary ? LMChatTheme.theme.primaryColor : Colors.white),
        ),
      ),
    );
  }

  LMChatLoader copyWith({
    bool? isPrimary,
    LMChatLoaderStyle? style,
  }) {
    return LMChatLoader(
      isPrimary: isPrimary ?? this.isPrimary,
      style: style ?? this.style,
    );
  }
}

class LMChatLoaderStyle {
  final Color? color;
  final Color? backgroundColor;

  const LMChatLoaderStyle({
    this.color,
    this.backgroundColor,
  });

  LMChatLoaderStyle copyWith({
    Color? color,
    Color? backgroundColor,
  }) {
    return LMChatLoaderStyle(
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}
