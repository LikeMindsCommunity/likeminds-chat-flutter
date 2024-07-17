import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// [LMChatTabBar] is an extension on [TabBar]
/// to add a copyWith method to update the properties of the TabBar
extension LMChatTabBar on TabBar {
  /// copyWith method for TabBar
  TabBar copyWith({
    Key? key,
    List<Widget>? tabs,
    TabController? controller,
    bool isScrollable = false,
    EdgeInsetsGeometry? padding,
    Color? indicatorColor,
    bool? automaticIndicatorColorAdjustment,
    double? indicatorWeight,
    EdgeInsetsGeometry? indicatorPadding,
    Decoration? indicator,
    TabBarIndicatorSize? indicatorSize,
    Color? dividerColor,
    double? dividerHeight,
    Color? labelColor,
    TextStyle? labelStyle,
    EdgeInsetsGeometry? labelPadding,
    Color? unselectedLabelColor,
    TextStyle? unselectedLabelStyle,
    DragStartBehavior? dragStartBehavior,
    MaterialStateProperty<Color?>? overlayColor,
    MouseCursor? mouseCursor,
    bool? enableFeedback,
    void Function(int)? onTap,
    ScrollPhysics? physics,
    InteractiveInkFeatureFactory? splashFactory,
    BorderRadius? splashBorderRadius,
    TabAlignment? tabAlignment,
  }) {
    return TabBar(
      key: key ?? this.key,
      tabs: tabs ?? this.tabs,
      controller: controller ?? this.controller,
      isScrollable: isScrollable,
      padding: padding ?? this.padding,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      automaticIndicatorColorAdjustment: automaticIndicatorColorAdjustment ??
          this.automaticIndicatorColorAdjustment,
      indicatorWeight: indicatorWeight ?? this.indicatorWeight,
      indicatorPadding: indicatorPadding ?? this.indicatorPadding,
      indicator: indicator ?? this.indicator,
      indicatorSize: indicatorSize ?? this.indicatorSize,
      dividerColor: dividerColor ?? this.dividerColor,
      dividerHeight: dividerHeight ?? this.dividerHeight,
      labelColor: labelColor ?? this.labelColor,
      labelStyle: labelStyle ?? this.labelStyle,
      labelPadding: labelPadding ?? this.labelPadding,
      unselectedLabelColor: unselectedLabelColor ?? this.unselectedLabelColor,
      unselectedLabelStyle: unselectedLabelStyle ?? this.unselectedLabelStyle,
      dragStartBehavior: dragStartBehavior ?? this.dragStartBehavior,
      overlayColor: overlayColor ?? this.overlayColor,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      enableFeedback: enableFeedback ?? this.enableFeedback,
      onTap: onTap ?? this.onTap,
      physics: physics ?? this.physics,
      splashFactory: splashFactory ?? this.splashFactory,
      splashBorderRadius: splashBorderRadius ?? this.splashBorderRadius,
      tabAlignment: tabAlignment ?? this.tabAlignment,
    );
  }
}
