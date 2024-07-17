import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/common/icon/icon.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/common/text/text.dart';

/// A class representing the style properties for a custom popup menu.
class LMChatCustomPopupMenuStyle {
  /// The background color of the popup menu.
  Color? backgroundColor;

  /// Text style for the popup menu.
  LMChatTextStyle? textStyle;

  /// Icon style for the popup menu.
  LMChatIconStyle? iconStyle;

  /// The foreground color of the menu box.
  Color? menuBoxForegroundColor;

  /// The height of the menu box.
  double? menuBoxHeight;

  /// The width of the menu box.
  double? menuBoxWidth;

  /// The padding of the menu box.
  EdgeInsets? menuBoxPadding;

  /// The margin of the menu box.
  EdgeInsets? menuBoxMargin;

  /// The decoration of the menu box.
  BoxDecoration? menuBoxDecoration;

  /// Text style for the popup menu.
  TextStyle? menuTextStyle;

  /// Creates a new instance of [LMChatCustomPopupMenuStyle].
  LMChatCustomPopupMenuStyle({
    this.backgroundColor,
    this.textStyle,
    this.iconStyle,
    this.menuBoxForegroundColor,
    this.menuBoxHeight,
    this.menuBoxWidth,
    this.menuBoxPadding,
    this.menuBoxMargin,
    this.menuBoxDecoration,
    this.menuTextStyle,
  });

  /// Creates a copy of this [LMChatCustomPopupMenuStyle] but with the given fields replaced with the new values.
  /// If the new values are null, the old values are used.

  LMChatCustomPopupMenuStyle copyWith({
    Color? backgroundColor,
    LMChatTextStyle? textStyle,
    LMChatIconStyle? iconStyle,
    Color? menuBoxForegroundColor,
    double? menuBoxHeight,
    double? menuBoxWidth,
    EdgeInsets? menuBoxPadding,
    EdgeInsets? menuBoxMargin,
    BoxDecoration? menuBoxDecoration,
    TextStyle? menuTextStyle,
  }) {
    return LMChatCustomPopupMenuStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textStyle: textStyle ?? this.textStyle,
      iconStyle: iconStyle ?? this.iconStyle,
      menuBoxForegroundColor:
          menuBoxForegroundColor ?? this.menuBoxForegroundColor,
      menuBoxHeight: menuBoxHeight ?? this.menuBoxHeight,
      menuBoxWidth: menuBoxWidth ?? this.menuBoxWidth,
      menuBoxPadding: menuBoxPadding ?? this.menuBoxPadding,
      menuBoxMargin: menuBoxMargin ?? this.menuBoxMargin,
      menuBoxDecoration: menuBoxDecoration ?? this.menuBoxDecoration,
      menuTextStyle: menuTextStyle ?? this.menuTextStyle,
    );
  }

  /// Merges this [LMChatCustomPopupMenuStyle] with another [LMChatCustomPopupMenuStyle].
  LMChatCustomPopupMenuStyle merge(LMChatCustomPopupMenuStyle? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      textStyle: other.textStyle ?? textStyle,
      iconStyle: other.iconStyle ?? iconStyle,
      menuBoxForegroundColor:
          other.menuBoxForegroundColor ?? menuBoxForegroundColor,
      menuBoxHeight: other.menuBoxHeight ?? menuBoxHeight,
      menuBoxWidth: other.menuBoxWidth ?? menuBoxWidth,
      menuBoxPadding: other.menuBoxPadding ?? menuBoxPadding,
      menuBoxMargin: other.menuBoxMargin ?? menuBoxMargin,
      menuBoxDecoration: other.menuBoxDecoration ?? menuBoxDecoration,
      menuTextStyle: other.menuTextStyle ?? menuTextStyle,
    );
  }
}
