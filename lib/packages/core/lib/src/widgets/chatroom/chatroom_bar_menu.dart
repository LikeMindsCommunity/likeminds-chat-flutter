import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';

/// {@template lm_attachment_menu}
/// A widget that displays a menu of attachment options in the chatroom bar.
/// This menu is shown when the attachment button is tapped.
/// {@endtemplate}
class LMAttachmentMenu extends StatelessWidget {
  /// The list of menu items to display
  final List<LMAttachmentMenuItemData> items;

  /// The style configuration for the menu
  final LMAttachmentMenuStyle style;

  /// {@macro lm_attachment_menu}
  const LMAttachmentMenu({
    super.key,
    required this.items,
    this.style = const LMAttachmentMenuStyle(),
  });

  /// Creates a copy of this [LMAttachmentMenu] with the given fields replaced with new values.
  ///
  /// The [items] parameter sets a new list of menu items.
  /// The [style] parameter sets a new style configuration.
  ///
  /// Returns a new [LMAttachmentMenu] instance with the updated values.
  LMAttachmentMenu copyWith({
    List<LMAttachmentMenuItemData>? items,
    LMAttachmentMenuStyle? style,
  }) {
    return LMAttachmentMenu(
      items: items ?? this.items,
      style: style ?? this.style,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _defaultAttachmentMenu(context);
  }

  Widget _defaultAttachmentMenu(BuildContext context) {
    // Calculate grid layout
    final int itemCount = items.length;
    // Use 3 columns for both 3 items and 5 items cases
    final int columns = (itemCount == 3 || itemCount == 5) ? 3 : 2;
    final int rows = (itemCount / columns).ceil();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ClipRRect(
        borderRadius: style.borderRadius,
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: style.backgroundColor,
          child: Padding(
            padding: style.padding,
            child: Column(
              children: List.generate(rows, (rowIndex) {
                // Calculate items for this row
                final int startIndex = rowIndex * columns;
                final int endIndex = startIndex + columns > itemCount
                    ? itemCount
                    : startIndex + columns;
                final int itemsInRow = endIndex - startIndex;

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: rowIndex < rows - 1 ? 16 : 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ...List.generate(itemsInRow, (index) {
                        final item = items[startIndex + index];
                        return Expanded(
                          child: LMChatCore.config.chatRoomConfig.builder
                              .attachmentMenuItemBuilder(
                            context,
                            item,
                            LMAttachmentMenuItem(
                              item: item,
                              style: style.menuItemStyle,
                            ),
                          ),
                        );
                      }),
                      // Add spacers if needed to maintain grid alignment
                      if (itemsInRow < columns)
                        ...List.generate(
                          columns - itemsInRow,
                          (index) => const Spacer(),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

/// {@template lm_attachment_menu_item}
/// A widget that displays a single item in the attachment menu.
/// {@endtemplate}
class LMAttachmentMenuItem extends StatelessWidget {
  /// The menu item data
  final LMAttachmentMenuItemData item;

  /// The style configuration for the menu item
  final LMAttachmentMenuItemStyle style;

  /// {@macro lm_attachment_menu_item}
  const LMAttachmentMenuItem({
    super.key,
    required this.item,
    this.style = const LMAttachmentMenuItemStyle(),
  });

  /// Creates a copy of this [LMAttachmentMenuItem] with the given fields replaced with new values.
  ///
  /// The [item] parameter sets a new menu item data.
  /// The [style] parameter sets a new style configuration.
  ///
  /// Returns a new [LMAttachmentMenuItem] instance with the updated values.
  LMAttachmentMenuItem copyWith({
    LMAttachmentMenuItemData? item,
    LMAttachmentMenuItemStyle? style,
  }) {
    return LMAttachmentMenuItem(
      item: item ?? this.item,
      style: style ?? this.style,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _defaultMenuItem(context);
  }

  Widget _defaultMenuItem(BuildContext context) {
    return Column(
      children: [
        LMChatButton(
          onTap: item.onTap,
          icon: LMChatIcon(
            type: item.iconType ?? LMChatIconType.icon,
            icon: item.icon,
            assetPath: item.assetPath,
            style: LMChatIconStyle(
              color: style.iconColor,
              size: item.iconType == LMChatIconType.svg ? 38 : 30,
              boxSize: style.iconBoxSize,
              boxBorderRadius: item.iconType == LMChatIconType.svg ? 100 : 0,
              boxPadding: item.iconType == LMChatIconType.svg
                  ? const EdgeInsets.all(12)
                  : EdgeInsets.zero,
              backgroundColor: item.iconType == LMChatIconType.svg
                  ? style.backgroundColor
                  : null,
            ),
          ),
          style: LMChatButtonStyle(
            height: style.buttonHeight,
            width: style.buttonWidth,
            borderRadius: style.buttonBorderRadius,
            backgroundColor: style.backgroundColor,
          ),
        ),
        const SizedBox(height: 4),
        LMChatText(
          item.label,
          style: LMChatTextStyle(
            textStyle: style.labelTextStyle,
          ),
        ),
      ],
    );
  }
}

/// {@template lm_attachment_menu_item_data}
/// Data class for attachment menu items
/// {@endtemplate}
class LMAttachmentMenuItemData {
  /// The icon to display
  final IconData? icon;

  /// The label text to display
  final String label;

  /// The callback when item is tapped
  final VoidCallback onTap;

  /// The type of icon (material icon or svg)
  final LMChatIconType? iconType;

  /// The asset path for svg icons
  final String? assetPath;

  /// {@macro lm_attachment_menu_item_data}
  const LMAttachmentMenuItemData({
    this.icon,
    required this.label,
    required this.onTap,
    this.iconType,
    this.assetPath,
  });
}

/// {@template lm_attachment_menu_style}
/// Style configuration for the attachment menu
/// {@endtemplate}
class LMAttachmentMenuStyle {
  /// Background color of the menu
  final Color backgroundColor;

  /// Border radius of the menu
  final BorderRadius borderRadius;

  /// Padding around the menu content
  final EdgeInsets padding;

  /// Style for menu items
  final LMAttachmentMenuItemStyle menuItemStyle;

  /// {@macro lm_attachment_menu_style}
  const LMAttachmentMenuStyle({
    this.backgroundColor = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.padding = const EdgeInsets.symmetric(
      vertical: 16,
      horizontal: 48,
    ),
    this.menuItemStyle = const LMAttachmentMenuItemStyle(),
  });

  /// Creates a copy of this style with the given fields replaced with new values
  LMAttachmentMenuStyle copyWith({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    LMAttachmentMenuItemStyle? menuItemStyle,
  }) {
    return LMAttachmentMenuStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      menuItemStyle: menuItemStyle ?? this.menuItemStyle,
    );
  }
}

/// {@template lm_attachment_menu_item_style}
/// Style configuration for attachment menu items
/// {@endtemplate}
class LMAttachmentMenuItemStyle {
  /// Color of the icon
  final Color iconColor;

  /// Background color for both icon and button
  final Color backgroundColor;

  /// Size of the icon box
  final double iconBoxSize;

  /// Height of the button
  final double buttonHeight;

  /// Width of the button
  final double buttonWidth;

  /// Border radius of the button
  final double buttonBorderRadius;

  /// Text style for the label
  final TextStyle labelTextStyle;

  /// {@macro lm_attachment_menu_item_style}
  const LMAttachmentMenuItemStyle({
    this.iconColor = Colors.white,
    this.backgroundColor = Colors.blue,
    this.iconBoxSize = 48,
    this.buttonHeight = 48,
    this.buttonWidth = 48,
    this.buttonBorderRadius = 24,
    this.labelTextStyle = const TextStyle(
      fontSize: 12,
      color: Colors.black,
    ),
  });

  /// Creates a copy of this style with the given fields replaced with new values
  LMAttachmentMenuItemStyle copyWith({
    Color? iconColor,
    Color? backgroundColor,
    double? iconBoxSize,
    double? buttonHeight,
    double? buttonWidth,
    double? buttonBorderRadius,
    TextStyle? labelTextStyle,
  }) {
    return LMAttachmentMenuItemStyle(
      iconColor: iconColor ?? this.iconColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      iconBoxSize: iconBoxSize ?? this.iconBoxSize,
      buttonHeight: buttonHeight ?? this.buttonHeight,
      buttonWidth: buttonWidth ?? this.buttonWidth,
      buttonBorderRadius: buttonBorderRadius ?? this.buttonBorderRadius,
      labelTextStyle: labelTextStyle ?? this.labelTextStyle,
    );
  }
}
