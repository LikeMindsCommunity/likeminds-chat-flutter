import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';

class LMChatFloatingActionButton extends StatelessWidget {
  final bool isCollapsed;
  final String? text;

  final VoidCallback? onTap;

  const LMChatFloatingActionButton({
    super.key,
    this.isCollapsed = false,
    this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      child: const Icon(Icons.add),
    );
  }
}

class LMChatFloatingActionButtonStyle {
  final Color? backgroundColor;

  final double? collapsedHeight;
  final double? collapsedWidth;

  final double? expandedHeight;
  final double? expandedWidth;

  final LMChatIcon? icon;

  final bool? showTextOnCollapsed;

  final bool? showTextOnExpanded;

  final Duration? animationDuration;

  final Curve? animationCurve;

  const LMChatFloatingActionButtonStyle({
    this.backgroundColor,
    this.icon,
    this.collapsedHeight,
    this.collapsedWidth,
    this.expandedHeight,
    this.expandedWidth,
    this.showTextOnCollapsed,
    this.showTextOnExpanded,
    this.animationDuration,
    this.animationCurve,
  });

  LMChatFloatingActionButtonStyle copyWith({
    Color? backgroundColor,
    LMChatIcon? icon,
    double? collapsedHeight,
    double? collapsedWidth,
    double? expandedHeight,
    double? expandedWidth,
    bool? showTextOnCollapsed,
    bool? showTextOnExpanded,
  }) {
    return LMChatFloatingActionButtonStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      icon: icon ?? this.icon,
      collapsedHeight: collapsedHeight ?? this.collapsedHeight,
      collapsedWidth: collapsedWidth ?? this.collapsedWidth,
      expandedHeight: expandedHeight ?? this.expandedHeight,
      expandedWidth: expandedWidth ?? this.expandedWidth,
      showTextOnCollapsed: showTextOnCollapsed ?? this.showTextOnCollapsed,
      showTextOnExpanded: showTextOnExpanded ?? this.showTextOnExpanded,
    );
  }
}
