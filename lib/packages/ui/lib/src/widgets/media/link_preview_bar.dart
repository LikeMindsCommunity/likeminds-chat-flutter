import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:url_launcher/url_launcher.dart';

/// {@template chat_link_preview_bar}
/// A widget to display a link preview bar on top of the chat bar textfield.
///
/// The [LMChatLinkPreviewBar] can be customized by passing in the required parameters
/// and can be used in a chatroom.
/// {@endtemplate}
class LMChatLinkPreviewBar extends StatelessWidget {
  /// {@macro chat_link_preview_bar}
  const LMChatLinkPreviewBar({
    super.key,
    required this.ogTags,
    this.onCanceled,
    this.onTap,
    this.leadingBuilder,
    this.titleBuilder,
    this.subtitleBuilder,
    this.linkTextBuilder,
    this.cancelButtonBuilder,
    this.style,
  });

  /// The [LMChatOGTagsViewData] to be displayed in the link preview bar.
  final LMChatOGTagsViewData ogTags;

  /// The onCanceled function of the link preview bar.
  final VoidCallback? onCanceled;

  /// The onTap function of the link preview bar.
  final VoidCallback? onTap;

  /// The builder function for the leading widget in the link preview bar.
  final Widget Function(BuildContext, LMChatImage)? leadingBuilder;

  /// The builder function for the title widget in the link preview bar.
  final LMChatTextBuilder? titleBuilder;

  /// The builder function for the subtitle widget in the link preview bar.
  final LMChatTextBuilder? subtitleBuilder;

  /// The builder function for link text
  final LMChatTextBuilder? linkTextBuilder;

  /// The builder function for the cancel button widget in the link preview bar.
  final LMChatButtonBuilder? cancelButtonBuilder;

  /// The style configuration for the link preview bar.
  final LMChatLinkPreviewBarStyle? style;

  /// Creates a copy of the current LMChatLinkPreviewBar instance with the provided values.
  /// If no values are provided, the current values are used.
  LMChatLinkPreviewBar copyWith({
    LMChatOGTagsViewData? ogTags,
    VoidCallback? onCanceled,
    VoidCallback? onTap,
    Widget Function(BuildContext, LMChatImage)? leadingBuilder,
    LMChatTextBuilder? titleBuilder,
    LMChatTextBuilder? subtitleBuilder,
    LMChatTextBuilder? linkTextBuilder,
    LMChatButtonBuilder? cancelButtonBuilder,
    LMChatLinkPreviewBarStyle? style,
  }) {
    return LMChatLinkPreviewBar(
      ogTags: ogTags ?? this.ogTags,
      onCanceled: onCanceled ?? this.onCanceled,
      onTap: onTap ?? this.onTap,
      leadingBuilder: leadingBuilder ?? this.leadingBuilder,
      titleBuilder: titleBuilder ?? this.titleBuilder,
      subtitleBuilder: subtitleBuilder ?? this.subtitleBuilder,
      linkTextBuilder: linkTextBuilder ?? this.linkTextBuilder,
      cancelButtonBuilder: cancelButtonBuilder ?? this.cancelButtonBuilder,
      style: style ?? this.style,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = LMChatTheme.theme;
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else if (ogTags.url != null && ogTags.url!.isNotEmpty) {
          launchUrl(Uri.parse(ogTags.url!));
        }
      },
      child: Container(
        width: style?.width ?? 80.w,
        height: style?.height,
        decoration: style?.decoration?.copyWith(
              color: themeData.container,
            ) ??
            BoxDecoration(
              color: themeData.container,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
        margin: style?.margin,
        padding: style?.padding,
        child: Container(
          decoration: style?.decoration ??
              BoxDecoration(
                color: themeData.onContainer.withOpacity(0.05),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Padding(
                padding: style?.innerPadding ??
                    const EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                      left: 8,
                      right: 30,
                    ),
                child: Row(
                  children: [
                    leadingBuilder?.call(context, _defLeading()) ??
                        _defLeading(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          titleBuilder?.call(context, _defTitle()) ??
                              _defTitle(),
                          subtitleBuilder?.call(context, _defSubTitle()) ??
                              _defSubTitle(),
                          linkTextBuilder?.call(context, _defLinkText()) ??
                              _defLinkText(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              cancelButtonBuilder?.call(
                    _defCancelButton(),
                  ) ??
                  _defCancelButton(),
            ],
          ),
        ),
      ),
    );
  }

  LMChatText _defLinkText() {
    // convert link text in lower case to avoid case sensitivity
    String link = ogTags.url?.toLowerCase() ?? "";
    return LMChatText(
      link,
      style: style?.linkTextStyle ??
          LMChatTextStyle(
            padding: EdgeInsets.symmetric(horizontal: 1.w),
            textStyle: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
    );
  }

  LMChatImage _defLeading() {
    return LMChatImage(
      imageUrl: ogTags.imageUrl,
      style: style?.leadingStyle ??
          const LMChatImageStyle(
            borderRadius: BorderRadius.all(
              Radius.circular(2),
            ),
            height: 80,
            width: 80,
            boxFit: BoxFit.fill,
            margin: EdgeInsets.symmetric(horizontal: 6),
            errorWidget: LMChatIcon(
              type: LMChatIconType.icon,
              icon: Icons.link,
              style: LMChatIconStyle(
                size: 32,
              ),
            ),
          ),
    );
  }

  LMChatText _defTitle() {
    return LMChatText(
      ogTags.title ?? "",
      style: style?.titleStyle ??
          LMChatTextStyle(
            padding: EdgeInsets.symmetric(horizontal: 1.w),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 2,
          ),
    );
  }

  LMChatText _defSubTitle() {
    return LMChatText(
      ogTags.description ?? "",
      style: style?.subtitleStyle ??
          LMChatTextStyle(
            padding: EdgeInsets.symmetric(horizontal: 1.w),
            textStyle: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 2,
          ),
    );
  }

  LMChatButton _defCancelButton() {
    return LMChatButton(
      onTap: onCanceled,
      icon: const LMChatIcon(
        type: LMChatIconType.icon,
        icon: Icons.close,
        style: LMChatIconStyle(
          size: 20,
        ),
      ),
      style: style?.cancelButtonStyle ??
          const LMChatButtonStyle(
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.all(6),
            borderRadius: 100,
            margin: EdgeInsets.all(8),
          ),
    );
  }
}

/// {@template chat_link_preview_bar_style}
/// Represents the style configuration for the LMChatLinkPreviewBar widget.
/// The [leadingStyle] defines the style for the leading image.
/// The [titleStyle] defines the style for the title text.
/// The [subtitleStyle] defines the style for the subtitle text.
/// The [cancelButtonStyle] defines the style for the cancel button.
/// The [margin] defines the margin around the widget.
/// The [padding] defines the padding around the widget.
/// The [innerPadding] defines the padding inside the widget.
/// The [height] defines the height of the widget.
/// The [width] defines the width of the widget.
/// The [decoration] defines the decoration for the widget.
/// {@endtemplate}
class LMChatLinkPreviewBarStyle {
  final LMChatImageStyle? leadingStyle;
  final LMChatTextStyle? titleStyle;
  final LMChatTextStyle? subtitleStyle;
  final LMChatTextStyle? linkTextStyle;
  final LMChatButtonStyle? cancelButtonStyle;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final EdgeInsets? innerPadding;
  final double? height;
  final double? width;
  final BoxDecoration? decoration;

  /// Creates a new instance of LMChatLinkPreviewBarStyle.
  /// {@macro chat_link_preview_bar_style}
  LMChatLinkPreviewBarStyle({
    this.leadingStyle,
    this.titleStyle,
    this.subtitleStyle,
    this.linkTextStyle,
    this.cancelButtonStyle,
    this.margin,
    this.padding,
    this.innerPadding,
    this.height,
    this.width,
    this.decoration,
  });

  /// Creates a copy of the current LMChatLinkPreviewBarStyle instance with the provided values.
  /// If no values are provided, the current values are used.
  /// {@macro chat_link_preview_bar_style}
  LMChatLinkPreviewBarStyle copyWith({
    LMChatImageStyle? leadingStyle,
    LMChatTextStyle? titleStyle,
    LMChatTextStyle? subtitleStyle,
    LMChatTextStyle? linkTextStyle,
    LMChatButtonStyle? cancelButtonStyle,
    EdgeInsets? margin,
    EdgeInsets? padding,
    EdgeInsets? innerPadding,
    double? height,
    double? width,
    BoxDecoration? decoration,
  }) {
    return LMChatLinkPreviewBarStyle(
      leadingStyle: leadingStyle ?? this.leadingStyle,
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      linkTextStyle: linkTextStyle ?? this.linkTextStyle,
      cancelButtonStyle: cancelButtonStyle ?? this.cancelButtonStyle,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      innerPadding: innerPadding ?? this.innerPadding,
      height: height ?? this.height,
      width: width ?? this.width,
      decoration: decoration ?? this.decoration,
    );
  }

  /// Creates a new instance of LMChatLinkPreviewBarStyle with the default values.
  /// {@macro chat_link_preview_bar_style}
  factory LMChatLinkPreviewBarStyle.basic({
    Color? inActiveColor,
    Color? containerColor,
  }) {
    return LMChatLinkPreviewBarStyle(
      decoration: BoxDecoration(
        color: containerColor?.withOpacity(0.05),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(8),
        ),
      ),
      innerPadding: const EdgeInsets.only(
        top: 8,
        bottom: 8,
        left: 8,
        right: 30,
      ),
      width: 80.w,
      linkTextStyle: LMChatTextStyle(
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        textStyle: TextStyle(
          fontSize: 12,
          color: inActiveColor,
          fontWeight: FontWeight.w400,
          overflow: TextOverflow.ellipsis,
        ),
        maxLines: 1,
      ),
      leadingStyle: const LMChatImageStyle(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
        height: 80,
        width: 80,
        boxFit: BoxFit.fill,
        margin: EdgeInsets.symmetric(horizontal: 6),
        errorWidget: LMChatIcon(
          type: LMChatIconType.icon,
          icon: Icons.link,
          style: LMChatIconStyle(
            size: 32,
          ),
        ),
      ),
      titleStyle: LMChatTextStyle(
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          overflow: TextOverflow.ellipsis,
        ),
        maxLines: 2,
      ),
      subtitleStyle: LMChatTextStyle(
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        textStyle: TextStyle(
          fontSize: 14,
          color: inActiveColor,
          fontWeight: FontWeight.w400,
          overflow: TextOverflow.ellipsis,
        ),
        maxLines: 2,
      ),
      cancelButtonStyle: const LMChatButtonStyle(
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.all(6),
        borderRadius: 100,
        margin: EdgeInsets.all(8),
      ),
    );
  }
}
