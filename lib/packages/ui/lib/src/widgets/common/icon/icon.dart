import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/enums.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A simple icon widget to be used throughout the Chat
/// Represents three types of icons - icon, png, svg
/// Provides customisability through [LMChatIconStyle]
class LMChatIcon extends StatelessWidget {
  /// enum describing the type of icon to be shown
  final LMChatIconType type;

  /// if [LMChatIconType.icon] then pass icon of type [IconData]
  final IconData? icon;

  /// if [LMChatIconType.png] or [LMChatIconType.svg] then
  /// pass path of icon [String]
  final String? assetPath;

  /// style class for styling the icon [LMChatIconStyle]
  final LMChatIconStyle? style;

  /// either the icon [IconData] or asset path [String] must be provided
  const LMChatIcon({
    super.key,
    required this.type,
    this.assetPath,
    this.icon,
    this.style,
  }) : assert(icon != null || assetPath != null);

  getIconWidget(LMChatIconStyle style) {
    switch (type) {
      case LMChatIconType.icon:
        return Icon(
          icon,
          color: style.color,
          size: style.size?.abs() ?? 24,
        );
      case LMChatIconType.svg:
        return SizedBox(
          width: style.size?.abs() ?? 24,
          height: style.size?.abs() ?? 24,
          child: SvgPicture.asset(
            assetPath!,
            color: style.color,
            colorBlendMode:
                style.color == null ? BlendMode.srcIn : BlendMode.srcATop,
            fit: style.fit ?? BoxFit.contain,
          ),
        );
      case LMChatIconType.png:
        return SizedBox(
          width: style.size?.abs() ?? 24,
          height: style.size?.abs() ?? 24,
          child: Image.asset(
            assetPath!,
            fit: BoxFit.contain,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final inStyle = style ?? LMChatIconStyle.basic();
    return Container(
      height: inStyle.boxSize ?? inStyle.size,
      width: inStyle.boxSize ?? inStyle.size,
      margin: inStyle.margin,
      padding: inStyle.boxPadding,
      decoration: BoxDecoration(
        color: inStyle.backgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(inStyle.boxBorderRadius ?? 0),
        ),
        border: Border.all(
          width: inStyle.boxBorder ?? 0.0,
          strokeAlign: BorderSide.strokeAlignOutside,
          color: inStyle.boxBorderColor ?? Colors.transparent,
        ),
      ),
      child: getIconWidget(inStyle),
    );
  }

  LMChatIcon copyWith({
    LMChatIconType? type,
    IconData? icon,
    String? assetPath,
    LMChatIconStyle? style,
  }) {
    return LMChatIcon(
      type: type ?? this.type,
      icon: icon ?? this.icon,
      assetPath: assetPath ?? this.assetPath,
      style: style ?? this.style,
    );
  }
}

class LMChatIconStyle {
  /// color of the icon, not applicable on [LMChatIconType.png]
  final Color? color;

  /// square size of the icon
  final double? size;

  /// square size of the box surrounding the icon
  final double? boxSize;

  /// weight of the border around the box
  final double? boxBorder;

  /// weight of the border around the box
  final Color? boxBorderColor;

  /// radius of the box around the icon
  final double? boxBorderRadius;

  /// padding around icon with respect to the box
  final EdgeInsets? boxPadding;

  /// margin around the box
  final EdgeInsets? margin;

  /// color of the box, or background color of icon
  final Color? backgroundColor;

  /// fit inside the box for icon
  final BoxFit? fit;

  const LMChatIconStyle({
    this.color,
    this.size,
    this.boxSize,
    this.boxBorder,
    this.boxBorderColor,
    this.boxBorderRadius,
    this.boxPadding,
    this.margin,
    this.backgroundColor,
    this.fit,
  });

  factory LMChatIconStyle.basic() {
    return const LMChatIconStyle(
      size: 24,
      boxPadding: EdgeInsets.zero,
      fit: BoxFit.contain,
    );
  }

  LMChatIconStyle copyWith({
    Color? color,
    double? size,
    double? boxSize,
    double? boxBorder,
    double? boxBorderRadius,
    Color? boxBorderColor,
    EdgeInsets? boxPadding,
    EdgeInsets? margin,
    Color? backgroundColor,
    BoxFit? fit,
  }) {
    return LMChatIconStyle(
      color: color ?? this.color,
      size: size ?? this.size,
      boxSize: boxSize ?? this.boxSize,
      boxBorder: boxBorder ?? this.boxBorder,
      boxBorderColor: boxBorderColor ?? this.boxBorderColor,
      boxBorderRadius: boxBorderRadius ?? this.boxBorderRadius,
      boxPadding: boxPadding ?? this.boxPadding,
      margin: margin ?? this.margin,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fit: fit ?? this.fit,
    );
  }
}
