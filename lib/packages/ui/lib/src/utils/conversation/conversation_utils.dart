import 'package:flutter/material.dart';

/// Returns the global position of the chat bubble widget.
///
/// Takes a [GlobalKey] as a parameter and returns the [Offset] of the widget's position.
/// If the widget is not found, it returns an offset of (0, 0).
Offset getPositionOfChatBubble(GlobalKey widgetKey) {
  RenderBox? renderBox =
      widgetKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) {
    return const Offset(0, 0);
  }

  final Offset offset = renderBox.localToGlobal(Offset.zero);
  return offset;
}

/// Returns the height of the widget associated with the given [GlobalKey].
///
/// If the widget is not found, it returns null.
double? getHeightOfWidget(GlobalKey widgetKey) {
  RenderBox? renderBox =
      widgetKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) {
    return null;
  }
  return renderBox.size.height;
}

/// Returns the width of the widget associated with the given [GlobalKey].
///
/// If the widget is not found, it returns null.
double? getWidthOfWidget(GlobalKey widgetKey) {
  RenderBox? renderBox =
      widgetKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) {
    return null;
  }
  return renderBox.size.width;
}
