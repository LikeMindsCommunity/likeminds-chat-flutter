import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';

/// {@template lm_chat_chip}
/// A widget which displays a chip.
/// {@endtemplate}
class LMChatChip extends StatelessWidget {
  /// {@macro lm_chat_chip}
  const LMChatChip({
    super.key,
    required this.label,
    this.onTap,
    this.style,
  });

  /// The callback when the chip is tapped.
  final VoidCallback? onTap;

  /// The label of the chip.
  final Widget label;

  /// The style of the chip.
  final LMChatChipStyle? style;

  /// Creates a copy of this [LMChatChip] but with the given fields replaced with the new values.
  /// If the new values are null, then the old values are used.
  LMChatChip copyWith({
    VoidCallback? onTap,
    Widget? label,
    LMChatChipStyle? style,
  }) {
    return LMChatChip(
      onTap: onTap ?? this.onTap,
      label: label ?? this.label,
      style: style ?? this.style,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: InkRipple.splashFactory,
      onTap: onTap,
      child: Chip(
        label: label,
        backgroundColor: style?.backgroundColor,
        shape: style?.shape,
        padding: style?.padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
        labelPadding: style?.labelPadding ?? EdgeInsets.zero,
        elevation: 0,
        side: style?.side,
      ),
    );
  }
}

/// {@template lm_chat_chip_style}
/// A class which describes the style for the [LMChatChip]
/// {@endtemplate}
class LMChatChipStyle {
  /// The background color of the chip.
  final Color? backgroundColor;

  /// The shape of the chip.
  final OutlinedBorder? shape;

  /// The padding of the chip.
  final EdgeInsets? padding;

  /// The margin of the chip.
  final EdgeInsets? margin;

  /// The label padding of the chip.
  final EdgeInsets? labelPadding;

  /// The elevation of the chip.
  final double? elevation;

  /// The Border of the chip.
  final BorderSide? side;

  /// {@macro lm_chat_chip_style}
  const LMChatChipStyle({
    this.backgroundColor,
    this.shape,
    this.padding,
    this.margin,
    this.labelPadding,
    this.elevation,
    this.side,
  });

  /// Creates a copy of this [LMChatChipStyle] but with the given fields replaced with the new values.
  /// If the new values are null, then the old values are used.
  LMChatChipStyle copyWith({
    Color? backgroundColor,
    OutlinedBorder? shape,
    EdgeInsets? padding,
    EdgeInsets? labelPadding,
    double? elevation,
    BorderSide? side,
  }) {
    return LMChatChipStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      shape: shape ?? this.shape,
      padding: padding ?? this.padding,
      labelPadding: labelPadding ?? this.labelPadding,
      elevation: elevation ?? this.elevation,
      side: side ?? this.side,
    );
  }

  /// Create a default [LMChatChipStyle]
  factory LMChatChipStyle.basic() {
    return LMChatChipStyle(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      labelPadding: EdgeInsets.zero,
      elevation: 0,
    );
  }
}
