import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';

/// [LMChatCustomPopUpMenu] is an extension on [CustomPopupMenu]
/// to add a copyWith method to update the properties of the menu
extension LMChatCustomPopUpMenu on CustomPopupMenu {
  /// copyWith method for CustomPopupMenu
  /// to update the properties of the menu
  /// with new values without changing the original menu
  CustomPopupMenu copyWith({
    Widget? child,
    Widget Function()? menuBuilder,
    PressType? pressType,
    CustomPopupMenuController? controller,
    Color arrowColor = const Color(0xFF4C4C4C),
    bool showArrow = true,
    Color barrierColor = Colors.black12,
    double arrowSize = 10.0,
    double horizontalMargin = 10.0,
    double verticalMargin = 10.0,
    PreferredPosition? position,
    void Function(bool)? menuOnChange,
    bool enablePassEvent = true,
  }) {
    return CustomPopupMenu(
      menuBuilder: menuBuilder ?? this.menuBuilder,
      pressType: pressType ?? this.pressType,
      controller: controller ?? this.controller,
      arrowColor: arrowColor,
      showArrow: showArrow,
      barrierColor: barrierColor,
      arrowSize: arrowSize,
      horizontalMargin: horizontalMargin,
      verticalMargin: verticalMargin,
      position: position ?? this.position,
      menuOnChange: menuOnChange ?? this.menuOnChange,
      enablePassEvent: enablePassEvent,
      child: child ?? this.child,
    );
  }
}
