import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/enums.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';

/// This widget is used to display a text button
/// The [LMChatButton] can be customized by passing in the required parameters
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
    this.onLongPress,
    this.onLongPressStart,
    this.onLongPressEnd,
    this.onLongPressMoveUpdate,
    this.onVerticalDragUpdate,
    this.onHorizontalDragUpdate,
    this.gesturesEnabled = false,
  });

  /// Required parameter, defines whether the button is active or disabled
  final bool isActive;

  /// Controls whether gestures (long press, drags) are enabled
  final bool gesturesEnabled;

  /// style class to customise the look and feel of the button
  final LMChatButtonStyle? style;

  /// Text to be displayed in the button
  final LMChatText? text;

  /// Icon to be displayed in the button
  final LMChatIcon? icon;

  /// Action to perform after tapping on the button
  final VoidCallback? onTap;

  /// Action to perform after holding the button
  final VoidCallback? onLongPress;

  /// Text to be displayed in the button if the button is active
  final LMChatText? activeText;

  /// Action to perform after text in the button is tapped
  final VoidCallback? onTextTap;

  /// Action to perform after just starting holding the button
  final Function(LongPressStartDetails)? onLongPressStart;

  /// Action to perform after just ending holding the button
  final Function(LongPressEndDetails)? onLongPressEnd;

  /// Action to perform when there is a drag while holding the button
  final Function(LongPressMoveUpdateDetails)? onLongPressMoveUpdate;

  /// Action to perform when there is a vertical drag while holding the button
  final Function(DragUpdateDetails)? onVerticalDragUpdate;

  /// Action to perform when dragging horizontally
  final Function(DragUpdateDetails)? onHorizontalDragUpdate;

  @override
  State<LMChatButton> createState() => _LMButtonState();
}

class _LMButtonState extends State<LMChatButton>
    with SingleTickerProviderStateMixin {
  bool _active = false;
  bool _isLongPressed = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  Offset _dragOffset = Offset.zero;

  // Different max distances for horizontal and vertical drags
  static const double maxHorizontalDrag = 160.0;
  static const double maxVerticalDrag = 80.0;

  bool? _isHorizontalDrag;
  Offset? _dragStartOffset;

  @override
  void initState() {
    super.initState();
    _active = widget.isActive;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(_controller);
  }

  @override
  void didUpdateWidget(LMChatButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _active = widget.isActive;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inStyle = widget.style ?? LMChatButtonStyle.basic();
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: inStyle.scaleOnLongPress ?? 1.0)
            .animate(_controller);

    return GestureDetector(
      onTap: () {
        setState(() {
          _active = !_active;
        });
        widget.onTap?.call();
      },
      onLongPressStart: widget.gesturesEnabled
          ? (details) {
              setState(() {
                _isLongPressed = true;
                _dragOffset = Offset.zero;
                _dragStartOffset = details.globalPosition;
                _isHorizontalDrag = null;
              });
              _controller.forward();
              widget.onLongPressStart?.call(details);
            }
          : null,
      onLongPress: widget.gesturesEnabled ? widget.onLongPress : null,
      onLongPressMoveUpdate: widget.gesturesEnabled
          ? (details) {
              if (_isLongPressed) {
                if (_dragStartOffset == null) {
                  _dragStartOffset = details.globalPosition;
                  return;
                }

                // Determine drag direction if not yet determined
                if (_isHorizontalDrag == null) {
                  final dragDelta = details.globalPosition - _dragStartOffset!;
                  if (dragDelta.distance > 10) {
                    // Small threshold for intentional drag
                    _isHorizontalDrag = dragDelta.dx.abs() > dragDelta.dy.abs();
                    // Debug initial direction
                    debugPrint(
                        'Drag direction locked to: ${_isHorizontalDrag! ? 'horizontal' : 'vertical'}');
                  } else {
                    return;
                  }
                }

                final newOffset = details.offsetFromOrigin;
                double constrainedX = 0.0;
                double constrainedY = 0.0;

                // Apply different constraints based on direction
                if (_isHorizontalDrag!) {
                  constrainedX = newOffset.dx.clamp(-maxHorizontalDrag, 0.0);

                  // Add toast notifications at specific thresholds
                  if (constrainedX <= -50 && constrainedX > -51) {
                    debugPrint('Crossed cancel threshold');
                  } else if (constrainedX <= -150) {
                    debugPrint('Near maximum horizontal drag');
                    widget.onHorizontalDragUpdate?.call(
                      DragUpdateDetails(
                        globalPosition: details.globalPosition,
                        delta: Offset(constrainedX, 0),
                      ),
                    );
                  }
                } else {
                  constrainedY = newOffset.dy.clamp(-maxVerticalDrag, 0.0);

                  // Add toast notifications for vertical drag
                  if (constrainedY <= -50 && constrainedY > -51) {
                    debugPrint('Crossed lock threshold');
                  } else if (constrainedY <= -75) {
                    debugPrint('Near maximum vertical drag');
                    widget.onVerticalDragUpdate?.call(
                      DragUpdateDetails(
                        globalPosition: details.globalPosition,
                        delta: Offset(0, constrainedY),
                      ),
                    );
                  }
                }

                setState(() {
                  _dragOffset = Offset(constrainedX, constrainedY);
                });

                // // Call appropriate callbacks based on locked direction
                // if (_isHorizontalDrag!) {

                // } else {

                // }

                widget.onLongPressMoveUpdate?.call(details);
              }
            }
          : null,
      onLongPressEnd: widget.gesturesEnabled
          ? (details) {
              setState(() {
                _isLongPressed = false;
                _dragOffset = Offset.zero;
                _dragStartOffset = null;
                _isHorizontalDrag = null;
              });
              _controller.reverse();
              widget.onLongPressEnd?.call(details);
              debugPrint('Long press ended, drag reset');
            }
          : null,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: _dragOffset,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            ),
          );
        },
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

  /// Scale factor for the button when long pressed
  final double? scaleOnLongPress;

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
    this.scaleOnLongPress,
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
    double? scaleOnLongPress,
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
      scaleOnLongPress: scaleOnLongPress ?? this.scaleOnLongPress,
    );
  }
}
