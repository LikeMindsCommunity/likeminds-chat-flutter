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
    this.child,
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

  /// child widget to the button
  /// if the button has a child, the text and icon will be ignored
  /// and the child will be displayed in the button
  final Widget? child;

  @override
  State<LMChatButton> createState() => _LMButtonState();

  /// CopyWith method to create a new instance of [LMChatButton] with the updated values
  /// This method is used to update the values of the [LMChatButton] widget
  /// by creating a new instance of the widget with the updated values
  LMChatButton copyWith({
    Key? key,
    LMChatText? text,
    VoidCallback? onTap,
    LMChatText? activeText,
    bool? isActive,
    LMChatButtonStyle? style,
    VoidCallback? onTextTap,
    LMChatIcon? icon,
    VoidCallback? onLongPress,
    Function(LongPressStartDetails)? onLongPressStart,
    Function(LongPressEndDetails)? onLongPressEnd,
    Function(LongPressMoveUpdateDetails)? onLongPressMoveUpdate,
    Function(DragUpdateDetails)? onVerticalDragUpdate,
    Function(DragUpdateDetails)? onHorizontalDragUpdate,
    bool? gesturesEnabled,
    Widget? child,
  }) {
    return LMChatButton(
      key: key ?? this.key,
      text: text ?? this.text,
      onTap: onTap ?? this.onTap,
      activeText: activeText ?? this.activeText,
      isActive: isActive ?? this.isActive,
      style: style ?? this.style,
      onTextTap: onTextTap ?? this.onTextTap,
      icon: icon ?? this.icon,
      onLongPress: onLongPress ?? this.onLongPress,
      onLongPressStart: onLongPressStart ?? this.onLongPressStart,
      onLongPressEnd: onLongPressEnd ?? this.onLongPressEnd,
      onLongPressMoveUpdate:
          onLongPressMoveUpdate ?? this.onLongPressMoveUpdate,
      onVerticalDragUpdate: onVerticalDragUpdate ?? this.onVerticalDragUpdate,
      onHorizontalDragUpdate:
          onHorizontalDragUpdate ?? this.onHorizontalDragUpdate,
      gesturesEnabled: gesturesEnabled ?? this.gesturesEnabled,
      child: child ?? this.child,
    );
  }
}

class _LMButtonState extends State<LMChatButton>
    with SingleTickerProviderStateMixin {
  bool _active = false;
  bool _isLongPressed = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  Offset _dragOffset = Offset.zero;

  bool? _isHorizontalDrag;
  Offset? _dragStartOffset;

  @override
  void initState() {
    super.initState();
    _active = widget.isActive;
    final inStyle = widget.style ?? LMChatButtonStyle.basic();
    _controller = AnimationController(
      duration: inStyle.animationDuration,
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
                final inStyle = widget.style ?? LMChatButtonStyle.basic();

                if (_dragStartOffset == null) {
                  _dragStartOffset = details.globalPosition;
                  return;
                }

                // Determine drag direction if not yet determined
                if (_isHorizontalDrag == null) {
                  final dragDelta = details.globalPosition - _dragStartOffset!;
                  if (dragDelta.distance > inStyle.dragDirectionThreshold) {
                    _isHorizontalDrag = dragDelta.dx.abs() > dragDelta.dy.abs();
                  } else {
                    return;
                  }
                }

                final newOffset = details.offsetFromOrigin;
                double constrainedX = 0.0;
                double constrainedY = 0.0;

                if (_isHorizontalDrag!) {
                  constrainedX =
                      newOffset.dx.clamp(-inStyle.maxHorizontalDrag, 0.0);

                  if (constrainedX <= -inStyle.horizontalCancelThreshold &&
                      constrainedX > -(inStyle.horizontalCancelThreshold + 1)) {
                    debugPrint('Crossed cancel threshold');
                  } else if (constrainedX <= -inStyle.maxHorizontalDrag) {
                    debugPrint('Near maximum horizontal drag');
                    widget.onHorizontalDragUpdate?.call(
                      DragUpdateDetails(
                        globalPosition: details.globalPosition,
                        delta: Offset(constrainedX, 0),
                      ),
                    );
                  }
                } else {
                  constrainedY =
                      newOffset.dy.clamp(-inStyle.maxVerticalDrag, 0.0);

                  if (constrainedY <= -inStyle.verticalLockThreshold &&
                      constrainedY > -(inStyle.verticalLockThreshold + 1)) {
                    debugPrint('Crossed lock threshold');
                  } else if (constrainedY <= -inStyle.maxVerticalDrag) {
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
          child: widget.child ??
              Flex(
                direction: inStyle.direction ?? Axis.horizontal,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment:
                    inStyle.mainAxisAlignment ?? MainAxisAlignment.center,
                children: [
                  inStyle.placement == LMChatIconButtonPlacement.start
                      ? _active
                          ? (inStyle.activeIcon ??
                                  inStyle.icon ??
                                  widget.icon) ??
                              const SizedBox.shrink()
                          : inStyle.icon ??
                              widget.icon ??
                              const SizedBox.shrink()
                      : const SizedBox.shrink(),
                  GestureDetector(
                    onTap: inStyle.showText ? widget.onTextTap : null,
                    behavior: HitTestBehavior.translucent,
                    child: Flex(
                      direction: Axis.horizontal,
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
                          : widget.icon ??
                              inStyle.icon ??
                              const SizedBox.shrink()
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

  /// Duration for the scale animation
  final Duration animationDuration;

  /// Maximum horizontal drag distance allowed
  final double maxHorizontalDrag;

  /// Maximum vertical drag distance allowed
  final double maxVerticalDrag;

  /// Minimum drag distance to determine drag direction
  final double dragDirectionThreshold;

  /// Threshold for horizontal cancel action
  final double horizontalCancelThreshold;

  /// Threshold for vertical lock action
  final double verticalLockThreshold;

  /// Direction of the icon and text
  final Axis? direction;

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
    this.animationDuration = const Duration(milliseconds: 200),
    this.maxHorizontalDrag = 160.0,
    this.maxVerticalDrag = 80.0,
    this.dragDirectionThreshold = 10.0,
    this.horizontalCancelThreshold = 50.0,
    this.verticalLockThreshold = 50.0,
    this.direction,
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
      animationDuration: Duration(milliseconds: 200),
      maxHorizontalDrag: 160.0,
      maxVerticalDrag: 80.0,
      dragDirectionThreshold: 10.0,
      horizontalCancelThreshold: 50.0,
      verticalLockThreshold: 50.0,
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
    Duration? animationDuration,
    double? maxHorizontalDrag,
    double? maxVerticalDrag,
    double? dragDirectionThreshold,
    double? horizontalCancelThreshold,
    double? verticalLockThreshold,
    Axis? direction,
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
      animationDuration: animationDuration ?? this.animationDuration,
      maxHorizontalDrag: maxHorizontalDrag ?? this.maxHorizontalDrag,
      maxVerticalDrag: maxVerticalDrag ?? this.maxVerticalDrag,
      dragDirectionThreshold:
          dragDirectionThreshold ?? this.dragDirectionThreshold,
      horizontalCancelThreshold:
          horizontalCancelThreshold ?? this.horizontalCancelThreshold,
      verticalLockThreshold:
          verticalLockThreshold ?? this.verticalLockThreshold,
      direction: direction ?? this.direction,
    );
  }
}
