import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// {@template lm_chat_menu}
/// The chat menu widget.
/// This widget is used to show the chat menu.
/// The [LMChatMenu] widget takes the following parameters:
/// - [menuItems]: The list of menu items.
/// - [child]: The child widget.
/// - [style]: The style of the menu.
/// {@endtemplate}

class LMChatMenu extends StatelessWidget {
  /// Creates a new [LMChatMenu] with the provided values.
  /// The [menuItems] parameter is required.
  /// The [child] parameter is required.
  /// The [style] parameter is optional.
  /// The [key] parameter is optional.
  const LMChatMenu({
    super.key,
    required this.menuItems,
    required this.child,
    this.style,
  });

  /// The list of menu items.
  final List<LMChatMenuItem> menuItems;

  /// The child widget.
  final Widget child;

  /// The style of the menu.
  final LMChatMenuStyle? style;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPressStart: (details) {
        _showMenu(context, details);
      },
      child: child,
    );
  }

  void _showMenu(BuildContext context, LongPressStartDetails details) {
    if (menuItems.isNotEmpty) {
      // finding the overlay to show the menu
      final RenderBox overlay =
          Overlay.of(context).context.findRenderObject() as RenderBox;
      // finding the position of the tap
      final RelativeRect position = RelativeRect.fromRect(
        Rect.fromPoints(
          details.globalPosition,
          details.globalPosition.translate(0, 0),
        ),
        overlay.localToGlobal(Offset.zero) & overlay.size,
      );
      // showing the menu
      showMenu(
        context: context,
        position: position,
        elevation: style?.elevation,
        shadowColor: style?.shadowColor,
        surfaceTintColor: style?.surfaceTintColor,
        semanticLabel: style?.semanticLabel,
        shape: style?.shape,
        color: style?.color,
        constraints: style?.constraints,
        clipBehavior: style?.clipBehavior ?? Clip.none,
        items: [
          for (LMChatMenuItem menuItem in menuItems)
            PopupMenuItem(
              onTap: () {
                menuItem.onTap();
              },
              padding: style?.itemPadding ?? EdgeInsets.zero,
              child: ListTile(
                leading: menuItem.leading,
                title: menuItem.title,
              ),
            ),
          // kVerticalPaddingSmall,
        ],
      );
    }
  }
}

/// {@template lm_chat_menu_style}
/// The style for the chat menu.
/// This class is used to style the chat menu.
/// The [LMChatMenuStyle] class takes the following parameters:
/// - [elevation]: The elevation of the menu.
/// - [shadowColor]: The shadow color of the menu.
/// - [surfaceTintColor]: The surface tint color of the menu.
/// - [semanticLabel]: The semantic label of the menu.
/// - [shape]: The shape of the menu.
/// - [color]: The color of the menu.
/// - [constraints]: The constraints of the menu.
/// - [clipBehavior]: The clip behavior of the menu.
/// - [itemPadding]: The padding of the menu item.
/// {@endtemplate}

class LMChatMenuStyle {
  /// The elevation of the menu.
  final double? elevation;

  /// The shadow color of the menu.
  final Color? shadowColor;

  /// The surface tint color of the menu.
  final Color? surfaceTintColor;

  /// The semantic label of the menu.
  final String? semanticLabel;

  /// The shape of the menu.
  final ShapeBorder? shape;

  /// The color of the menu.
  final Color? color;

  /// The constraints of the menu.
  final BoxConstraints? constraints;

  /// The clip behavior of the menu.
  final Clip? clipBehavior;

  /// The padding of the menu item.
  final EdgeInsets? itemPadding;

  /// Creates a new [LMChatMenuStyle] with the provided values.
  const LMChatMenuStyle({
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.semanticLabel,
    this.shape,
    this.color,
    this.constraints,
    this.clipBehavior,
    this.itemPadding,
  });

  /// Creates a copy of this [LMChatMenuStyle] but with the given fields replaced with the new values.
  /// If the new values are null, the old values are used.
  LMChatMenuStyle copyWith({
    double? elevation,
    Color? shadowColor,
    Color? surfaceTintColor,
    String? semanticLabel,
    ShapeBorder? shape,
    Color? color,
    BoxConstraints? constraints,
    Clip? clipBehavior,
    EdgeInsets? itemPadding,
  }) {
    return LMChatMenuStyle(
      elevation: elevation ?? this.elevation,
      shadowColor: shadowColor ?? this.shadowColor,
      surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
      semanticLabel: semanticLabel ?? this.semanticLabel,
      shape: shape ?? this.shape,
      color: color ?? this.color,
      constraints: constraints ?? this.constraints,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      itemPadding: itemPadding ?? this.itemPadding,
    );
  }

  /// A basic style for the chat menu.
  factory LMChatMenuStyle.basic({Color? onContainer}) => LMChatMenuStyle(
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.2),
        surfaceTintColor: onContainer ?? Colors.white,
        semanticLabel: 'Chat Menu',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: Colors.white,
        constraints: BoxConstraints(
          minWidth: 12.w,
          maxWidth: 60.w,
        ),
        clipBehavior: Clip.none,
        itemPadding: EdgeInsets.zero,
      );
}
