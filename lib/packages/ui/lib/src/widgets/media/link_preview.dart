import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/models/models.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

/// {@template lm_chat_link_preview}
/// A widget to display a link preview in a chatroom.
/// The [LMChatLinkPreview] can be customized by passing in the required parameters
/// and can be used in a chatroom.
/// {@endtemplate}
class LMChatLinkPreview extends StatelessWidget {
  /// {@macro lm_chat_link_preview}
  const LMChatLinkPreview({
    super.key,
    required this.ogTags,
    this.onTap,
    this.imageBuilder,
    this.titleBuilder,
    this.subtitleBuilder,
    this.style,
  });

  /// The data required to display the Open Graph tags in the chat.
  final LMChatOGTagsViewData ogTags;

  /// The callback function for the onTap event.
  final VoidCallback? onTap;

  /// The builder function for the image widget in the link preview.
  final Widget Function(BuildContext, LMChatImage)? imageBuilder;

  /// The builder function for the title widget in the link preview.
  final LMChatTextBuilder? titleBuilder;

  /// The builder function for the subtitle widget in the link preview .
  final LMChatTextBuilder? subtitleBuilder;

  /// The style configuration for the link preview .
  final LMChatLinkPreviewStyle? style;

  /// Creates a copy of the current LMChatLinkPreview instance with the provided values.
  LMChatLinkPreview copyWith({
    LMChatOGTagsViewData? ogTags,
    VoidCallback? onTap,
    Widget Function(BuildContext, LMChatImage)? imageBuilder,
    LMChatTextBuilder? titleBuilder,
    LMChatTextBuilder? subtitleBuilder,
    LMChatLinkPreviewStyle? style,
  }) {
    return LMChatLinkPreview(
      ogTags: ogTags ?? this.ogTags,
      onTap: onTap ?? this.onTap,
      imageBuilder: imageBuilder ?? this.imageBuilder,
      titleBuilder: titleBuilder ?? this.titleBuilder,
      subtitleBuilder: subtitleBuilder ?? this.subtitleBuilder,
      style: style ?? this.style,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return ClipRRect(
      borderRadius: style?.decoration?.borderRadius ?? BorderRadius.circular(8),
      child: GestureDetector(
        onTap: () {
          if (onTap != null) {
            onTap!();
          } else if (ogTags.url != null && ogTags.url!.isNotEmpty) {
            launchUrl(Uri.parse(ogTags.url!));
          }
        },
        child: Container(
          width: style?.width ?? double.infinity,
          height: style?.height,
          margin: style?.margin,
          padding: style?.padding,
          decoration: style?.decoration ??
              const BoxDecoration(
                color: Color(0x1a9b9b9b),
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((ogTags.imageUrl != null && ogTags.imageUrl!.isNotEmpty) ||
                  imageBuilder != null)
                AbsorbPointer(
                  child:
                      imageBuilder?.call(context, _defImage()) ?? _defImage(),
                ),
              if ((ogTags.title != null && ogTags.title!.isNotEmpty) ||
                  titleBuilder != null)
                titleBuilder?.call(context, _defTitle()) ?? _defTitle(),
              if ((ogTags.description != null &&
                      ogTags.description!.isNotEmpty) ||
                  subtitleBuilder != null)
                subtitleBuilder?.call(context, _defSubTitle()) ??
                    _defSubTitle(),
            ],
          ),
        ),
      ),
    );
  }

  LMChatText _defSubTitle() {
    return LMChatText(
      ogTags.description ?? "",
      style: style?.subtitleStyle ??
          const LMChatTextStyle(
            padding: EdgeInsets.only(
              top: 2,
              bottom: 16,
              left: 8,
              right: 8,
            ),
            textStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 2,
          ),
    );
  }

  LMChatText _defTitle() {
    return LMChatText(
      ogTags.title ?? "",
      style: style?.titleStyle ??
          const LMChatTextStyle(
            padding: EdgeInsets.only(
              top: 8,
              bottom: 2,
              left: 8,
              right: 8,
            ),
            textStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 2,
          ),
    );
  }

  LMChatImage _defImage() {
    return LMChatImage(
      imageUrl: ogTags.imageUrl,
      style: style?.imageStyle ??
          const LMChatImageStyle(
            height: 20,
            width: 20,
            boxFit: BoxFit.fill,
            errorWidget: LMChatIcon(
              type: LMChatIconType.icon,
              icon: Icons.link,
              style: LMChatIconStyle(
                size: 32,
                boxSize: 20,
              ),
            ),
          ),
    );
  }
}

/// {@template chat_link_preview_style}
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
class LMChatLinkPreviewStyle {
  /// The style for the leading image.
  final LMChatImageStyle? imageStyle;

  /// The style for the title text.
  final LMChatTextStyle? titleStyle;

  /// The style for the subtitle text.
  final LMChatTextStyle? subtitleStyle;

  /// The margin around the widget.
  final EdgeInsets? margin;

  /// The padding around the widget.
  final EdgeInsets? padding;

  /// The padding inside the widget.
  final EdgeInsets? innerPadding;

  /// The height of the widget.
  final double? height;

  /// The width of the widget.
  final double? width;

  /// The decoration for the widget.
  final BoxDecoration? decoration;

  /// Creates a new instance of LMChatLinkPreviewStyle.
  /// {@macro chat_link_preview_style}
  LMChatLinkPreviewStyle({
    this.imageStyle,
    this.titleStyle,
    this.subtitleStyle,
    this.margin,
    this.padding,
    this.innerPadding,
    this.height,
    this.width,
    this.decoration,
  });

  /// Creates a copy of the current LMChatLinkPreviewStyle instance with the provided values.
  /// If no values are provided, the current values are used.
  /// {@macro chat_link_preview_style}
  LMChatLinkPreviewStyle copyWith({
    LMChatImageStyle? imageStyle,
    LMChatTextStyle? titleStyle,
    LMChatTextStyle? subtitleStyle,
    EdgeInsets? margin,
    EdgeInsets? padding,
    EdgeInsets? innerPadding,
    double? height,
    double? width,
    BoxDecoration? decoration,
  }) {
    return LMChatLinkPreviewStyle(
      imageStyle: imageStyle ?? this.imageStyle,
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      innerPadding: innerPadding ?? this.innerPadding,
      height: height ?? this.height,
      width: width ?? this.width,
      decoration: decoration ?? this.decoration,
    );
  }

  /// Creates a new instance of LMChatLinkPreviewStyle with the default values.
  /// {@macro chat_link_preview_style}
  factory LMChatLinkPreviewStyle.basic({
    Color? inactiveColor,
    Color? containerColor,
  }) {
    return LMChatLinkPreviewStyle(
      decoration: BoxDecoration(
        color: containerColor?.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(
        bottom: 8,
      ),
      padding: const EdgeInsets.only(
        bottom: 6,
      ),
      innerPadding: const EdgeInsets.only(
        top: 8,
        bottom: 8,
        left: 8,
        right: 30,
      ),
      imageStyle: const LMChatImageStyle(
        height: 190,
        width: double.infinity,
        boxFit: BoxFit.fill,
        errorWidget: LMChatIcon(
          type: LMChatIconType.icon,
          icon: Icons.link,
          style: LMChatIconStyle(
            size: 24,
            boxSize: 32,
          ),
        ),
      ),
      titleStyle: const LMChatTextStyle(
        padding: EdgeInsets.only(
          top: 8,
          bottom: 2,
          left: 8,
          right: 8,
        ),
        textStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          overflow: TextOverflow.ellipsis,
        ),
        maxLines: 2,
      ),
      subtitleStyle: LMChatTextStyle(
        padding: const EdgeInsets.only(
          top: 2,
          bottom: 8,
          left: 8,
          right: 8,
        ),
        textStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: inactiveColor,
          overflow: TextOverflow.ellipsis,
        ),
        maxLines: 2,
      ),
    );
  }
}
