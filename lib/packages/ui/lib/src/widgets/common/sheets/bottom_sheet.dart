import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';

class LMChatBottomSheet extends StatefulWidget {
  final LMChatText? title;
  final List<Widget> children;
  final LMChatBottomSheetStyle? style;

  const LMChatBottomSheet({
    Key? key,
    required this.children,
    this.style,
    this.title,
  }) : super(key: key);

  @override
  State<LMChatBottomSheet> createState() => _LMBottomSheetState();

  LMChatBottomSheet copyWith({
    LMChatText? title,
    List<Widget>? children,
    LMChatBottomSheetStyle? style,
  }) {
    return LMChatBottomSheet(
      title: title ?? this.title,
      style: style ?? this.style,
      children: children ?? this.children,
    );
  }
}

class _LMBottomSheetState extends State<LMChatBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    LMChatThemeData theme = LMChatTheme.theme;
    return Container(
      width: screenSize.width,
      height: widget.style?.height,
      decoration: BoxDecoration(
        color: widget.style?.backgroundColor ?? theme.container,
        borderRadius: widget.style?.borderRadius,
        boxShadow: widget.style?.boxShadow,
      ),
      constraints: BoxConstraints(
        maxHeight: widget.style?.height ?? screenSize.height * 0.8,
        minHeight: screenSize.height * 0.2,
      ),
      margin: widget.style?.margin,
      padding:
          widget.style?.padding ?? const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          widget.style?.dragBar ??
              Container(
                width: 48,
                height: 8,
                decoration: ShapeDecoration(
                  color: widget.style?.dragBarColor ?? theme.disabledColor
                    ..withAlpha(200),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
          const SizedBox(height: 24),
          widget.title != null
              ? Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(bottom: 15),
                  child: widget.title)
              : const SizedBox.shrink(),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) => widget.children[index],
              itemCount: widget.children.length,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class LMChatBottomSheetStyle {
  final LMChatTextStyle? titleStyle;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final double? height;
  final double? elevation;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final List<BoxShadow>? boxShadow;
  final Widget? dragBar;
  final Color? dragBarColor;

  const LMChatBottomSheetStyle({
    this.titleStyle,
    this.backgroundColor,
    this.borderRadius,
    this.height,
    this.elevation,
    this.padding,
    this.margin,
    this.boxShadow,
    this.dragBar,
    this.dragBarColor,
  });

  LMChatBottomSheetStyle copyWith({
    Color? backgroundColor,
    BorderRadiusGeometry? borderRadius,
    double? height,
    double? elevation,
    EdgeInsets? padding,
    EdgeInsets? margin,
    List<BoxShadow>? boxShadow,
    Widget? dragBar,
    Color? dragBarColor,
    LMChatTextStyle? titleStyle,
  }) {
    return LMChatBottomSheetStyle(
      titleStyle: titleStyle ?? this.titleStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      height: height ?? this.height,
      elevation: elevation ?? this.elevation,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      boxShadow: boxShadow ?? this.boxShadow,
      dragBar: dragBar ?? this.dragBar,
      dragBarColor: dragBarColor ?? this.dragBarColor,
    );
  }
}
