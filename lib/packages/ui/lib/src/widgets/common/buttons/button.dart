import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';
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
    this.icon,
    this.onHold,
  });

  /// Required parameter, defines whether the button is active or disabled
  final bool isActive;

  /// style class to customise the look and feel of the button
  final LMChatButtonStyle? style;

  /// Text to be displayed in the button
  final LMChatText? text;

  /// Icon to be displayed in the button
  final LMChatIcon? icon;

  /// Action to perform after tapping on the button
  final VoidCallback? onTap;

  /// Action to perform after holding the button
  final VoidCallback? onHold;

  /// Text to be displayed in the button if the button is active
  final LMChatText? activeText;

  final VoidCallback? onTextTap;

  @override
  State<LMChatButton> createState() => _LMButtonState();

  LMChatButton copyWith({
    bool? isActive,
    LMChatButtonStyle? style,
    LMChatText? text,
    LMChatIcon? icon,
    Function()? onTap,
    LMChatText? activeText,
    VoidCallback? onTextTap,
  }) {
    return LMChatButton(
      isActive: isActive ?? this.isActive,
      style: style ?? this.style,
      text: text ?? this.text,
      icon: icon ?? this.icon,
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
        widget.onTap?.call();
      },
      onLongPress: widget.onHold,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: inStyle.height,
        width: inStyle.width,
        margin: inStyle.margin,
        padding: inStyle.padding ?? EdgeInsets.zero,
        decoration: BoxDecoration(
          color: inStyle.backgroundColor ?? LMChatTheme.theme.backgroundColor,
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
                    ? (inStyle.activeIcon ?? inStyle.icon ?? widget.icon) ??
                        const SizedBox.shrink()
                    : inStyle.icon ?? widget.icon ?? const SizedBox.shrink()
                : const SizedBox.shrink(),
            GestureDetector(
              onTap: inStyle.showText ? widget.onTextTap : null,
              behavior: HitTestBehavior.translucent,
              child: Row(
                children: [
                  inStyle.placement == LMChatIconButtonPlacement.start
                      ? (widget.icon != null ||
                              inStyle.icon != null ||
                              inStyle.activeIcon != null)
                          ? SizedBox(
                              width: inStyle.spacing ?? 0,
                            )
                          : const SizedBox.shrink()
                      : const SizedBox.shrink(),
                  inStyle.showText
                      ? Container(
                          padding: inStyle.textPadding,
                          child: _active
                              ? widget.activeText ??
                                  widget.text ??
                                  const SizedBox.shrink()
                              : widget.text ?? const SizedBox.shrink(),
                        )
                      : const SizedBox.shrink(),
                  inStyle.placement == LMChatIconButtonPlacement.end
                      ? (widget.icon != null ||
                              inStyle.icon != null ||
                              inStyle.activeIcon != null)
                          ? SizedBox(width: inStyle.spacing ?? 0)
                          : const SizedBox.shrink()
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            inStyle.placement == LMChatIconButtonPlacement.end
                ? _active
                    ? inStyle.activeIcon ??
                        widget.icon ??
                        inStyle.icon ??
                        const SizedBox.shrink()
                    : widget.icon ?? inStyle.icon ?? const SizedBox.shrink()
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

/// {@template lm_chat_button_style}
/// [LMChatButtonStyle] is used to style the [LMChatButton]
/// {@endtemplate}
class LMChatButtonStyle {
  /// padding of the button, defaults to zero
  final EdgeInsets? padding;

  /// margin of the button, defaults to zero
  final EdgeInsets? margin;

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

  /// space between the text and icon
  final double? spacing;

  /// whether to show the text in the button
  final bool showText;

  /// Icon to be displayed in the button
  final LMChatIcon? icon;

  /// Icon to be displayed in the button if the button is active
  final LMChatIcon? activeIcon;

  /// padding for the text
  final EdgeInsets? textPadding;

  /// {@macro lm_chat_button_style}
  const LMChatButtonStyle({
    this.padding,
    this.margin,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.height,
    this.width,
    this.placement = LMChatIconButtonPlacement.start,
    this.spacing,
    this.mainAxisAlignment,
    this.showText = true,
    this.icon,
    this.activeIcon,
    this.textPadding,
  });

  /// Basic style factory constructor; used as default style
  factory LMChatButtonStyle.basic() {
    return const LMChatButtonStyle(
      padding: EdgeInsets.all(4),
      backgroundColor: Colors.transparent,
      borderRadius: 8,
      height: 28,
      spacing: 4,
      textPadding: EdgeInsets.zero,
    );
  }

  /// CopyWith method to create a new instance of [LMChatButtonStyle] with the updated values
  LMChatButtonStyle copyWith({
    EdgeInsets? padding,
    EdgeInsets? margin,
    Color? backgroundColor,
    Border? border,
    double? borderRadius,
    double? height,
    double? width,
    LMChatIconButtonPlacement? placement,
    MainAxisAlignment? mainAxisAlignment,
    double? spacing,
    bool? showText,
    LMChatIcon? icon,
    LMChatIcon? activeIcon,
    EdgeInsets? textPadding,
  }) {
    return LMChatButtonStyle(
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      border: border ?? this.border,
      borderRadius: borderRadius ?? this.borderRadius,
      height: height ?? this.height,
      width: width ?? this.width,
      placement: placement ?? this.placement,
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      spacing: spacing ?? this.spacing,
      showText: showText ?? this.showText,
      icon: icon ?? this.icon,
      activeIcon: activeIcon ?? this.activeIcon,
      textPadding: textPadding ?? this.textPadding,
    );
  }
}
