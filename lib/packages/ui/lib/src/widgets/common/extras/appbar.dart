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
    this.bottom,
  });

  final Widget? leading;
  final List<Widget>? trailing;
  final Widget? title;
  final Widget? subtitle;
  final Widget? banner;
  final PreferredSizeWidget? bottom;

  final Function? backButtonCallback;

  final LMChatAppBarStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = LMChatTheme.theme;
    final inStyle = style ?? theme.appBarStyle;

    return Theme(
      data: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: LMChatTheme.theme.primaryColor,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: inStyle.height,
          width: inStyle.width ?? double.infinity,
          margin: inStyle.margin ?? EdgeInsets.zero,
          decoration: BoxDecoration(
            color: inStyle.backgroundColor ?? Colors.white,
            border: inStyle.border,
            boxShadow: inStyle.shadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (bottom != null) const SizedBox(height: 12),
              Padding(
                padding: inStyle.padding ??
                    const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 2.0,
                    ),
                child: Row(
                  children: [
                    leading ??
                        (inStyle.showBackButton
                            ? LMChatButton(
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
                                  backgroundColor:
                                      LMChatTheme.theme.primaryColor,
                                ),
                              )
                            : const SizedBox.shrink()),
                    banner != null
                        ? SizedBox(width: inStyle.gap ?? 16)
                        : const SizedBox.shrink(),
                    banner ?? const SizedBox.shrink(),
                    leading != null || inStyle.showBackButton
                        ? SizedBox(width: inStyle.gap ?? 16)
                        : const SizedBox.shrink(),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              minWidth: 80.w,
                            ),
                            child: title ?? const SizedBox.shrink(),
                          ),
                          subtitle != null
                              ? const SizedBox(height: 1)
                              : const SizedBox.shrink(),
                          subtitle ?? const SizedBox.shrink(),
                        ],
                      ),
                    ),
                    if (trailing != null) ...trailing!
                  ],
                ),
              ),
              if (bottom != null) const SizedBox(height: 12),
              if (bottom != null) bottom!
            ],
          ),
        ),
      ),
    );
  }

  LMChatAppBar copyWith({
    Widget? leading,
    List<Widget>? trailing,
    Widget? title,
    Widget? subtitle,
    Widget? banner,
    PreferredSizeWidget? bottom,
    Function? backButtonCallback,
    LMChatAppBarStyle? style,
  }) {
    return LMChatAppBar(
      leading: leading ?? this.leading,
      trailing: trailing ?? this.trailing,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      banner: banner ?? this.banner,
      bottom: bottom ?? this.bottom,
      backButtonCallback: backButtonCallback ?? this.backButtonCallback,
      style: style ?? this.style,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(style?.height ?? 72);
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
  final bool showBackButton;

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
    this.showBackButton = true,
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
    bool? showBackButton,
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
      showBackButton: showBackButton ?? this.showBackButton,
    );
  }

  factory LMChatAppBarStyle.basic() {
    return const LMChatAppBarStyle(
      backgroundColor: LMChatDefaultTheme.container,
      width: double.infinity,
    );
  }
}
