import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// {@template lm_chat_bar_header}
/// A widget to display the chat bar header.
/// used in the chatroom bar.
/// to display the user name and the message to be replied.
/// or the message to be edited.
/// {@endtemplate}
class LMChatBarHeader extends StatelessWidget {
  /// {@macro lm_chat_bar_header}
  const LMChatBarHeader({
    super.key,
    this.title,
    this.titleText,
    this.subtitle,
    this.trailing,
    this.onCanceled,
    this.titleBuilder,
    this.subtitleBuilder,
    this.trailingBuilder,
    this.style,
  });

  /// The title of the chat bar header.
  final LMChatText? title;

  /// The title text of the chat bar header.
  final String? titleText;

  /// The subtitle of the chat bar header.
  final Widget? subtitle;

  /// The trailing icon of the chat bar header.
  final LMChatIcon? trailing;

  /// The onCanceled function of the chat bar header.
  final VoidCallback? onCanceled;

  /// The title builder of the chat bar header.
  final Widget Function(LMChatText title)? titleBuilder;

  /// The subtitle builder of the chat bar header.
  final Widget Function(LMChatText subtitle)? subtitleBuilder;

  /// The trailing builder of the chat bar header.
  final Widget Function(LMChatIcon trailing)? trailingBuilder;

  final LMChatBarHeaderStyle? style;

  /// Creates a copy of this [LMChatBarHeader] but with the given fields replaced with the new values.
  LMChatBarHeader copyWith({
    LMChatText? title,
    String? titleText,
    LMChatText? subtitle,
    LMChatIcon? trailing,
    VoidCallback? onCanceled,
    Widget Function(LMChatText title)? titleBuilder,
    Widget Function(LMChatText subtitle)? subtitleBuilder,
    Widget Function(LMChatIcon trailing)? trailingBuilder,
    LMChatBarHeaderStyle? style,
  }) {
    return LMChatBarHeader(
      title: title ?? this.title,
      titleText: titleText ?? this.titleText,
      subtitle: subtitle ?? this.subtitle,
      trailing: trailing ?? this.trailing,
      onCanceled: onCanceled ?? this.onCanceled,
      titleBuilder: titleBuilder ?? this.titleBuilder,
      subtitleBuilder: subtitleBuilder ?? this.subtitleBuilder,
      trailingBuilder: trailingBuilder ?? this.trailingBuilder,
      style: style ?? this.style,
    );
  }

  @override
  Widget build(BuildContext context) {
    final LMChatThemeData themeData = LMChatTheme.theme;

    return Container(
      height: style?.height ?? 8.h,
      width: style?.width ?? 80.w,
      padding: style?.padding ?? const EdgeInsets.all(8),
      decoration: style?.decoration ??
          BoxDecoration(
              color: themeData.container,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              )),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              color:
                  LMChatTheme.instance.themeData.disabledColor.withOpacity(0.2),
            ),
            child: Row(
              children: [
                Container(
                  width: 1.w,
                  color: LMChatTheme.instance.themeData.primaryColor,
                  padding: const EdgeInsets.all(4),
                ),
                kHorizontalPaddingMedium,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleBuilder?.call(
                          _defTitleBuilder(themeData),
                        ) ??
                        _defTitleBuilder(themeData),
                    kVerticalPaddingSmall,
                    SizedBox(
                      width: 55.w,
                      height: 2.h,
                      child: subtitle,
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onCanceled,
            icon: trailingBuilder?.call(
                  _defTrailing(themeData),
                ) ??
                _defTrailing(themeData),
          ),
        ],
      ),
    );
  }

  LMChatIcon _defTrailing(LMChatThemeData themeData) {
    return trailing ??
        LMChatIcon(
          type: LMChatIconType.icon,
          icon: Icons.close,
          style: LMChatIconStyle.basic().copyWith(
            color: themeData.inActiveColor,
            backgroundColor: themeData.container,
            boxBorderRadius: 100,
            size: 20,
            boxSize: 28,
          ),
        );
  }

  LMChatText _defTitleBuilder(LMChatThemeData themeData) {
    return title ??
        LMChatText(
          titleText ?? '',
          style: LMChatTextStyle(
            maxLines: 1,
            textStyle: TextStyle(
              overflow: TextOverflow.ellipsis,
              color: themeData.primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
  }
}

/// {@template lm_chat_bar_header_style}
/// A class to style the chat bar header.
/// {@endtemplate}
class LMChatBarHeaderStyle {
  /// [height] of the chat bar header.
  final double? height;

  /// [width] of the chat bar header.
  final double? width;

  /// [padding] of the chat bar header.
  final EdgeInsetsGeometry? padding;

  /// [decoration] of the chat bar header.
  final BoxDecoration? decoration;

  /// {@macro lm_chat_bar_header_style}
  const LMChatBarHeaderStyle({
    this.height,
    this.width,
    this.padding,
    this.decoration,
  });

  /// A basic style for the chat bar header.
  factory LMChatBarHeaderStyle.basic() {
    return LMChatBarHeaderStyle(
      height: 8.h,
      width: 80.w,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: LMChatTheme.theme.container,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
    );
  }

  /// Creates a copy of this [LMChatBarHeaderStyle] but with the given fields replaced with the new values.
  LMChatBarHeaderStyle copyWith({
    double? height,
    double? width,
    EdgeInsetsGeometry? padding,
    BoxDecoration? decoration,
  }) {
    return LMChatBarHeaderStyle(
      height: height ?? this.height,
      width: width ?? this.width,
      padding: padding ?? this.padding,
      decoration: decoration ?? this.decoration,
    );
  }
}
