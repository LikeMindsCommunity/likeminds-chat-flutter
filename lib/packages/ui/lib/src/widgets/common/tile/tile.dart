import 'package:flutter/material.dart';

class LMChatTile extends StatelessWidget {
  const LMChatTile({
    super.key,
    this.onTap,
    this.style,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.absorbTouch,
  });

  final VoidCallback? onTap;
  final LMChatTileStyle? style;

  final bool? absorbTouch;

  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    // Either pick the passed style or the default style
    final inStyle = style ?? LMChatTileStyle.basic();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AbsorbPointer(
        absorbing: absorbTouch ?? true,
        child: Container(
          height: inStyle.height,
          width: inStyle.width,
          decoration: BoxDecoration(
            color: inStyle.backgroundColor,
            border: inStyle.border,
            borderRadius: BorderRadius.all(
              Radius.circular(inStyle.borderRadius ?? 0),
            ),
          ),
          margin: inStyle.margin ?? const EdgeInsets.all(0),
          padding: inStyle.padding ?? const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment:
                inStyle.mainAxisAlignment ?? MainAxisAlignment.start,
            crossAxisAlignment:
                inStyle.crossAxisAlignment ?? CrossAxisAlignment.center,
            children: [
              leading ??
                  Container(
                    height: 48,
                    width: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
              SizedBox(width: inStyle.gap * 3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title ??
                        Container(
                          height: 14,
                          width: 120,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                          ),
                        ),
                    SizedBox(height: inStyle.gap),
                    subtitle ?? const SizedBox(),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              trailing ?? const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  /// `copyWith` method to update the properties of the tile
  /// with new values without changing the original tile
  LMChatTile copyWith({
    Function()? onTap,
    LMChatTileStyle? style,
    Widget? leading,
    Widget? title,
    Widget? subtitle,
    Widget? trailing,
  }) {
    return LMChatTile(
      onTap: onTap ?? this.onTap,
      style: style ?? this.style,
      leading: leading ?? this.leading,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      trailing: trailing ?? this.trailing,
    );
  }
}

class LMChatTileStyle {
  /// background color of the tile, defaults to transparent
  final Color? backgroundColor;

  /// border around the tile
  final Border? border;

  /// border radius of the tile, visible when bgColor is passed
  final double? borderRadius;

  /// main axis alignment for the row inside the tile
  final MainAxisAlignment? mainAxisAlignment;

  /// cross axis alignment for the row inside the tile
  final CrossAxisAlignment? crossAxisAlignment;

  /// padding from exterior bounds (borders)
  final EdgeInsets? padding;

  /// margin around the tile
  final EdgeInsets? margin;

  /// height of the tile
  final double? height;

  /// width of the tile
  final double? width;

  /// gap between the tiles
  final double gap;

  const LMChatTileStyle({
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.padding,
    this.margin,
    this.height,
    this.width,
    required this.gap,
  });

  LMChatTileStyle copyWith({
    Color? backgroundColor,
    Border? border,
    double? borderRadius,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? height,
    double? width,
    double? gap,
  }) {
    return LMChatTileStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      border: border ?? this.border,
      borderRadius: borderRadius ?? this.borderRadius,
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      height: height ?? this.height,
      width: width ?? this.width,
      gap: gap ?? this.gap,
    );
  }

  factory LMChatTileStyle.basic() {
    return const LMChatTileStyle(
      backgroundColor: Colors.transparent,
      borderRadius: 0,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      padding: EdgeInsets.all(12),
      width: double.infinity,
      gap: 4,
    );
  }
}
