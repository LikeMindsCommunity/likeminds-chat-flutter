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
      padding: EdgeInsets.all(
        inStyle.boxPadding?.abs() ?? 0,
      ),
      decoration: BoxDecoration(
        color: inStyle.backgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(inStyle.boxBorderRadius ?? 0),
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

  /// radius of the box around the icon
  final double? boxBorderRadius;

  /// padding around icon with respect to the box
  final double? boxPadding;

  /// color of the box, or background color of icon
  final Color? backgroundColor;

  /// fit inside the box for icon
  final BoxFit? fit;

  const LMChatIconStyle({
    this.color,
    this.size,
    this.boxSize,
    this.boxBorder,
    this.boxBorderRadius,
    this.boxPadding,
    this.backgroundColor,
    this.fit,
  });

  factory LMChatIconStyle.basic() {
    return const LMChatIconStyle(
      size: 24,
      boxPadding: 0,
      fit: BoxFit.contain,
    );
  }

  LMChatIconStyle copyWith({
    Color? color,
    double? size,
    double? boxSize,
    double? boxBorder,
    double? boxBorderRadius,
    double? boxPadding,
    Color? backgroundColor,
    BoxFit? fit,
  }) {
    return LMChatIconStyle(
      color: color ?? this.color,
      size: size ?? this.size,
      boxSize: boxSize ?? this.boxSize,
      boxBorder: boxBorder ?? this.boxBorder,
      boxBorderRadius: boxBorderRadius ?? this.boxBorderRadius,
      boxPadding: boxPadding ?? this.boxPadding,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fit: fit ?? this.fit,
    );
  }
}
