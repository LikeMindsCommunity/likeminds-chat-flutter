import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';

class LMChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LMChatAppBar({
    super.key,
    this.leading,
    this.trailing,
    this.title,
    this.subtitle,
    this.style,
    this.banner,
    this.backButtonCallback,
  });

  final Widget? leading;
  final List<Widget>? trailing;
  final Widget? title;
  final Widget? subtitle;
  final LMChatProfilePicture? banner;

  final Function? backButtonCallback;

  final LMChatAppBarStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = LMChatTheme.theme;
    final inStyle = style ?? LMChatAppBarStyle.basic();

    return Container(
      decoration: BoxDecoration(
        color: inStyle.backgroundColor ?? Colors.white,
        border: inStyle.border,
        boxShadow: inStyle.shadow,
      ),
      child: Container(
        height: inStyle.height,
        width: inStyle.width ?? double.infinity,
        margin: inStyle.margin ?? EdgeInsets.zero,
        padding: inStyle.padding ??
            const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
        child: Row(
          children: [
            leading ??
                LMChatButton(
                  onTap: () {
                    Navigator.of(context).pop();
                    backButtonCallback?.call();
                  },
                  style: LMChatButtonStyle(
                    height: 28,
                    width: 28,
                    borderRadius: 6,
                    padding: EdgeInsets.zero,
                    icon: LMChatIcon(
                      type: LMChatIconType.icon,
                      icon: Icons.arrow_back,
                      style: LMChatIconStyle(
                        color: LMChatTheme.theme.onPrimary,
                        size: 20,
                        boxSize: 28,
                      ),
                    ),
                    backgroundColor: LMChatTheme.theme.primaryColor,
                  ),
                ),
            SizedBox(width: inStyle.gap ?? 12),
            banner ??
                const LMChatProfilePicture(
                  fallbackText: "L M",
                ),
            SizedBox(width: inStyle.gap ?? 12),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                title ?? const SizedBox.shrink(),
                subtitle != null
                    ? const SizedBox(height: 4)
                    : const SizedBox.shrink(),
                subtitle ?? const SizedBox.shrink(),
              ],
            ),
            const Spacer(),
            if (trailing != null) ...trailing!
          ],
        ),
      ),
    );
  }

  LMChatAppBar copyWith({
    Widget? leading,
    List<Widget>? trailing,
    Widget? title,
    Function? backButtonCallback,
    LMChatAppBarStyle? style,
  }) {
    return LMChatAppBar(
      leading: leading ?? this.leading,
      trailing: trailing ?? this.trailing,
      title: title ?? this.title,
      backButtonCallback: backButtonCallback ?? this.backButtonCallback,
      style: style ?? this.style,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(style?.height ?? 48);
}

class LMChatAppBarStyle {
  final Color? backgroundColor;
  final double? height;
  final double? width;
  final double? gap;
  final Border? border;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final List<BoxShadow>? shadow;
  final bool centerTitle;

  const LMChatAppBarStyle({
    this.backgroundColor,
    this.border,
    this.margin,
    this.padding,
    this.height,
    this.width,
    this.shadow,
    this.gap,
    this.centerTitle = false,
  });

  LMChatAppBarStyle copyWith({
    Color? backgroundColor,
    double? height,
    double? width,
    Border? border,
    EdgeInsets? padding,
    EdgeInsets? margin,
    List<BoxShadow>? shadow,
    bool? centerTitle,
    double? gap,
  }) {
    return LMChatAppBarStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      height: height ?? this.height,
      width: width ?? this.width,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      border: border ?? this.border,
      shadow: shadow ?? this.shadow,
      centerTitle: centerTitle ?? this.centerTitle,
      gap: gap ?? this.gap,
    );
  }

  factory LMChatAppBarStyle.basic() {
    return LMChatAppBarStyle(
      backgroundColor: LMChatTheme.theme.container,
      width: double.infinity,
    );
  }
}
