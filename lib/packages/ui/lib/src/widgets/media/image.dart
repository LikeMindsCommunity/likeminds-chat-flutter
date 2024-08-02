import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';

/// {@template lm_chat_image}
/// A widget to display an image in a post.
/// The image can be fetched from a URL or from a file.
/// The [LMChatImage] can be customized by passing in the required parameters
/// and can be used in a post.
/// The image can be tapped to perform an action.
/// The image can be customized by passing in the required parameters
/// and can be used in a post.
/// {@endtemplate}
class LMChatImage extends StatefulWidget {
  ///{@macro lm_chat_image}
  const LMChatImage({
    super.key,
    this.imageUrl,
    this.imageFile,
    this.onError,
    this.style,
    this.onTap,
  }) : assert(imageUrl != null || imageFile != null);

  /// The URL of the image (image from network)
  final String? imageUrl;

  /// The file of the image (image from file)
  final File? imageFile;

  /// {@macro chat_error_handler}
  final LMChatErrorHandler? onError;

  /// The style class of this widget, used for customisation
  final LMChatImageStyle? style;

  /// onTap callback for the widget; triggered when tapped
  final VoidCallback? onTap;

  @override
  State<LMChatImage> createState() => _LMImageState();

  /// copyWith function that returns a new instance of LMChatImage
  /// with the values copied from the old one.
  LMChatImage copyWith({
    String? imageUrl,
    File? imageFile,
    LMChatImageStyle? style,
    Function(String, StackTrace)? onError,
    VoidCallback? onMediaTap,
  }) {
    return LMChatImage(
      imageUrl: imageUrl ?? this.imageUrl,
      imageFile: imageFile ?? this.imageFile,
      style: style ?? this.style,
      onError: onError ?? this.onError,
      onTap: onMediaTap ?? onTap,
    );
  }
}

class _LMImageState extends State<LMChatImage> {
  LMChatImageStyle? style;

  @override
  Widget build(BuildContext context) {
    style = widget.style ?? LMChatTheme.theme.imageStyle;
    return GestureDetector(
      onTap: () => widget.onTap?.call(),
      child: widget.imageUrl != null
          ? Container(
              padding: style?.padding,
              margin: style?.margin,
              decoration: BoxDecoration(
                borderRadius: style!.borderRadius ?? BorderRadius.zero,
                color: style?.backgroundColor,
              ),
              clipBehavior: Clip.hardEdge,
              child: CachedNetworkImage(
                cacheKey: widget.imageUrl!,
                height: style!.height,
                width: style!.width,
                imageUrl: widget.imageUrl!,
                fit: style!.boxFit ?? BoxFit.contain,
                fadeInDuration: const Duration(
                  milliseconds: 100,
                ),
                errorWidget: (context, url, error) {
                  if (widget.onError != null) {
                    widget.onError!(error.toString(), StackTrace.empty);
                  }
                  return style!.errorWidget ??
                      Container(
                        color: Colors.grey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LMChatIcon(
                              type: LMChatIconType.icon,
                              icon: Icons.error_outline,
                              style: LMChatIconStyle(
                                size: 24,
                                color: Colors.grey.shade300,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const LMChatText(
                              "An error occurred fetching media",
                              style: LMChatTextStyle(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                },
                progressIndicatorBuilder: (context, url, progress) =>
                    style!.shimmerWidget ?? const SizedBox(),
              ),
            )
          : widget.imageFile != null
              ? Container(
                  padding: style?.padding,
                  margin: style?.margin,
                  decoration: BoxDecoration(
                      borderRadius: style!.borderRadius ?? BorderRadius.zero,
                      color: style?.backgroundColor),
                  child: Image.file(
                    widget.imageFile!,
                    height: style!.height,
                    width: style!.width,
                    fit: style!.boxFit ?? BoxFit.contain,
                  ),
                )
              : const SizedBox(),
    );
  }
}

/// {@template lm_chat_image_style}
/// The style class for [LMChatImage]
///
/// Provides multiple levels of customisations.
/// {@endtemplate}
class LMChatImageStyle {
  /// Height of the image widget
  final double? height;

  /// Width of the image widget
  final double? width;

  /// Aspect ratio of the image widget
  final double? aspectRatio;

  /// Radius of the border of the image widget
  final BorderRadius? borderRadius;

  /// Color of the border of the image widget
  final Color? borderColor;

  /// Padding of the image widget
  final EdgeInsets? padding;

  /// Margin of the image widget from outside
  final EdgeInsets? margin;

  /// Fit of the container box of the image
  final BoxFit? boxFit;

  /// Color of the background of the image widget
  final Color? backgroundColor;

  /// Widget to show while the network image loads
  final Widget? loaderWidget;

  /// Widget to show if the network image fails to load
  final Widget? errorWidget;

  /// Widget to show a shimmer while presenting the image
  final Widget? shimmerWidget;

  const LMChatImageStyle({
    this.height,
    this.width,
    this.aspectRatio,
    this.borderRadius,
    this.borderColor,
    this.loaderWidget,
    this.errorWidget,
    this.shimmerWidget,
    this.boxFit,
    this.padding,
    this.margin,
    this.backgroundColor,
  });

  LMChatImageStyle copyWith({
    double? height,
    double? width,
    double? aspectRatio,
    BorderRadius? borderRadius,
    Color? borderColor,
    Widget? loaderWidget,
    Widget? errorWidget,
    Widget? shimmerWidget,
    BoxFit? boxFit,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Color? backgroundColor,
  }) {
    return LMChatImageStyle(
      height: height ?? this.height,
      width: width ?? this.width,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      borderRadius: borderRadius ?? this.borderRadius,
      borderColor: borderColor ?? this.borderColor,
      loaderWidget: loaderWidget ?? this.loaderWidget,
      errorWidget: errorWidget ?? this.errorWidget,
      shimmerWidget: shimmerWidget ?? this.shimmerWidget,
      boxFit: boxFit ?? this.boxFit,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  factory LMChatImageStyle.basic({Color? primaryColor}) =>
      const LMChatImageStyle();
}
