import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/enums.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';

// This widget is used to display a text button
// The [LMChatButton] can be customized by passing in the required parameters
class LMChatButton extends StatefulWidget {
  const LMChatButton({
    super.key,
    this.text,
    required this.onTap,
    this.activeText,
    this.isActive = false,
    this.style,
    this.onTextTap,
  });

  /// Required parameter, defines whether the button is active or disabled
  final bool isActive;

  /// style class to customise the look and feel of the button
  final LMChatButtonStyle? style;

  /// Text to be displayed in the button
  final LMChatText? text;

  /// Action to perform after tapping on the button
  final Function() onTap;

  /// Text to be displayed in the button if the button is active
  final LMChatText? activeText;

  final VoidCallback? onTextTap;

  @override
  State<LMChatButton> createState() => _LMButtonState();

  LMChatButton copyWith({
    bool? isActive,
    LMChatButtonStyle? style,
    LMChatText? text,
    Function()? onTap,
    LMChatText? activeText,
    VoidCallback? onTextTap,
  }) {
    return LMChatButton(
      isActive: isActive ?? this.isActive,
      style: style ?? this.style,
      text: text ?? this.text,
      onTap: onTap ?? this.onTap,
      activeText: activeText ?? this.activeText,
      onTextTap: onTextTap ?? this.onTextTap,
    );
  }
}

class _LMButtonState extends State<LMChatButton> {
  bool _active = false;

  @override
  void initState() {
    _active = widget.isActive;
    super.initState();
  }

  @override
  void didUpdateWidget(LMChatButton oldWidget) {
    _active = widget.isActive;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final inStyle = widget.style ?? LMChatButtonStyle.basic();
    return GestureDetector(
      onTap: () {
        setState(() {
          _active = !_active;
        });
        widget.onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: inStyle.height,
        width: inStyle.width,
        padding: inStyle.padding ?? EdgeInsets.zero,
        decoration: BoxDecoration(
          color: inStyle.backgroundColor,
          borderRadius: BorderRadius.circular(inStyle.borderRadius ?? 0),
          border: inStyle.border,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
              inStyle.mainAxisAlignment ?? MainAxisAlignment.center,
          children: [
            inStyle.placement == LMChatIconButtonPlacement.start
                ? _active
                    ? (inStyle.activeIcon ?? inStyle.icon) ??
                        const SizedBox.shrink()
                    : inStyle.icon ?? const SizedBox.shrink()
                : const SizedBox.shrink(),
            GestureDetector(
              onTap: inStyle.showText ? widget.onTextTap : null,
              behavior: HitTestBehavior.translucent,
              child: Row(
                children: [
                  inStyle.placement == LMChatIconButtonPlacement.start
                      ? (inStyle.icon != null || inStyle.activeIcon != null)
                          ? SizedBox(width: inStyle.margin ?? 0)
                          : const SizedBox.shrink()
                      : const SizedBox.shrink(),
                  inStyle.showText
                      ? Container(
                          padding: inStyle.textPadding,
                          child: _active
                              ? widget.activeText ??
                                  widget.text ??
                                  const SizedBox.shrink()
                              : widget.text ?? const SizedBox.shrink())
                      : const SizedBox.shrink(),
                  inStyle.placement == LMChatIconButtonPlacement.end
                      ? (inStyle.icon != null || inStyle.activeIcon != null)
                          ? SizedBox(width: inStyle.margin ?? 0)
                          : const SizedBox.shrink()
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            inStyle.placement == LMChatIconButtonPlacement.end
                ? _active
                    ? inStyle.activeIcon ??
                        inStyle.icon ??
                        const SizedBox.shrink()
                    : inStyle.icon ?? const SizedBox.shrink()
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class LMChatButtonStyle {
  /// padding of the button, defaults to zero
  final EdgeInsets? padding;

  /// background color of the button, defaults to transparent
  final Color? backgroundColor;

  /// border radius of the button container
  final double? borderRadius;

  /// height of the button
  final double? height;

  /// width of the button
  final double? width;

  /// border of the button
  final Border? border;

  /// placement of the icon in the button
  final LMChatIconButtonPlacement placement;

  /// axis alignment for setting button's icon and text spacing
  final MainAxisAlignment? mainAxisAlignment;

  /// margin between the text and icon
  final double? margin;

  final bool showText;

  /// Icon to be displayed in the button
  final LMChatIcon? icon;

  /// Icon to be displayed in the button if the button is active
  final LMChatIcon? activeIcon;

  final EdgeInsets? textPadding;

  const LMChatButtonStyle({
    this.padding,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.height,
    this.width,
    this.placement = LMChatIconButtonPlacement.start,
    this.margin,
    this.mainAxisAlignment,
    this.showText = true,
    this.icon,
    this.activeIcon,
    this.textPadding,
  });

  factory LMChatButtonStyle.basic() {
    return const LMChatButtonStyle(
      padding: EdgeInsets.all(4),
      backgroundColor: Colors.transparent,
      borderRadius: 8,
      height: 28,
      margin: 4,
      textPadding: EdgeInsets.zero,
    );
  }

  LMChatButtonStyle copyWith({
    EdgeInsets? padding,
    Color? backgroundColor,
    Border? border,
    double? borderRadius,
    double? height,
    double? width,
    LMChatIconButtonPlacement? placement,
    MainAxisAlignment? mainAxisAlignment,
    double? margin,
    bool? showText,
    LMChatIcon? icon,
    LMChatIcon? activeIcon,
    EdgeInsets? textPadding,
  }) {
    return LMChatButtonStyle(
      padding: padding ?? this.padding,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      border: border ?? this.border,
      borderRadius: borderRadius ?? this.borderRadius,
      height: height ?? this.height,
      width: width ?? this.width,
      placement: placement ?? this.placement,
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      margin: margin ?? this.margin,
      showText: showText ?? this.showText,
      icon: icon ?? this.icon,
      activeIcon: activeIcon ?? this.activeIcon,
      textPadding: textPadding ?? this.textPadding,
    );
  }
}
