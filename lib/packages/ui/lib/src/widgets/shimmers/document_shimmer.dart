import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

/// {@template lm_chat_document_shimmer}
/// A shimmer loading widget that is shown while document tile is loading
/// {@endtemplate}
class LMChatDocumentShimmer extends StatelessWidget {
  /// The style for the document shimmer.
  final LMChatDocumentShimmerStyle? style;

  ///{@macro lm_chat_document_shimmer}
  const LMChatDocumentShimmer({super.key, this.style});

  @override
  Widget build(BuildContext context) {
    final style = this.style ?? LMChatDocumentShimmerStyle.basic();
    return Container(
      height: style.height ?? 80, // Default height
      width: style.width ?? 55.w, // Default width
      margin: style.margin,
      decoration: BoxDecoration(
        border: Border.all(
          color: style.borderColor ??
              LMChatTheme.theme.onContainer.withOpacity(0.5),
          width: style.borderWidth ?? 1,
        ),
        borderRadius: style.borderRadius,
      ),
      padding: style.padding,
      child: Shimmer.fromColors(
        baseColor:
            style.baseColor ?? LMChatTheme.theme.onContainer.withOpacity(0.2),
        highlightColor: style.highlightColor ??
            LMChatTheme.theme.onContainer.withOpacity(0.5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: style.iconSize ?? 40, // Default icon size
              width: style.iconSize ?? 40, // Default icon size
              color: LMChatTheme.theme.container,
            ),
            kHorizontalPaddingLarge,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: style.titleHeight ?? 16, // Default title height
                  width: style.titleWidth ?? 28.w, // Default title width
                  color: LMChatTheme.theme.container,
                ),
                kVerticalPaddingMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height:
                          style.subtitleHeight ?? 12, // Default subtitle height
                      width:
                          style.subtitleWidth ?? 16.w, // Default subtitle width
                      color: LMChatTheme.theme.container,
                    ),
                    kHorizontalPaddingXSmall,
                    Text(
                      '·',
                      style: TextStyle(
                        fontSize: kFontSmall,
                        color: LMChatTheme.theme.disabledColor,
                      ),
                    ),
                    kHorizontalPaddingXSmall,
                    Container(
                      height: style.subtitleHeight,
                      width: style.subtitleWidth,
                      color: LMChatTheme.theme.container,
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

/// Defines the style properties for the LMChatDocumentShimmer widget.
class LMChatDocumentShimmerStyle {
  /// Creates an LMChatDocumentShimmerStyle instance.
  const LMChatDocumentShimmerStyle({
    this.height,
    this.width,
    this.margin,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.padding,
    this.baseColor,
    this.highlightColor,
    this.iconSize,
    this.titleHeight,
    this.titleWidth,
    this.subtitleHeight,
    this.subtitleWidth,
  });

  /// The height of the shimmer container.
  final double? height;

  /// The width of the shimmer container.
  final double? width;

  /// The margin around the shimmer container.
  final EdgeInsetsGeometry? margin;

  /// The border radius of the shimmer container.
  final BorderRadius? borderRadius;

  /// The border color of the shimmer container.
  final Color? borderColor;

  /// The border width of the shimmer container.
  final double? borderWidth;

  /// The padding inside the shimmer container.
  final EdgeInsetsGeometry? padding;

  /// The base color for the shimmer effect.
  final Color? baseColor;

  /// The highlight color for the shimmer effect.
  final Color? highlightColor;

  /// The size of the icon placeholder.
  final double? iconSize;

  /// The height of the title placeholder.
  final double? titleHeight;

  /// The width of the title placeholder.
  final double? titleWidth;

  /// The height of the subtitle placeholder.
  final double? subtitleHeight;

  /// The width of the subtitle placeholder.
  final double? subtitleWidth;

  /// Creates a basic LMChatDocumentShimmerStyle with default values.
  factory LMChatDocumentShimmerStyle.basic() {
    return LMChatDocumentShimmerStyle(
      margin: const EdgeInsets.only(bottom: 10),
      borderRadius: BorderRadius.circular(kBorderRadiusMedium),
      borderColor: LMChatDefaultTheme.greyColor,
      borderWidth: 1,
      padding: const EdgeInsets.all(kPaddingLarge),
      baseColor: Colors.black26,
      highlightColor: Colors.black12,
    );
  }

  /// Creates a copy of this LMChatDocumentShimmerStyle but with the given fields replaced with the new values.
  LMChatDocumentShimmerStyle copyWith({
    double? height,
    double? width,
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
    Color? borderColor,
    double? borderWidth,
    EdgeInsetsGeometry? padding,
    Color? baseColor,
    Color? highlightColor,
    double? iconSize,
    double? titleHeight,
    double? titleWidth,
    double? subtitleHeight,
    double? subtitleWidth,
  }) {
    return LMChatDocumentShimmerStyle(
      height: height ?? this.height,
      width: width ?? this.width,
      margin: margin ?? this.margin,
      borderRadius: borderRadius ?? this.borderRadius,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      padding: padding ?? this.padding,
      baseColor: baseColor ?? this.baseColor,
      highlightColor: highlightColor ?? this.highlightColor,
      iconSize: iconSize ?? this.iconSize,
      titleHeight: titleHeight ?? this.titleHeight,
      titleWidth: titleWidth ?? this.titleWidth,
      subtitleHeight: subtitleHeight ?? this.subtitleHeight,
      subtitleWidth: subtitleWidth ?? this.subtitleWidth,
    );
  }
}
