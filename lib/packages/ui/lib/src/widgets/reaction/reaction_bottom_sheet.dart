import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

///{@template lm_chat_reaction_bottom_sheet}
/// A widget that displays a bottom sheet for selecting reactions.
///
/// This bottom sheet shows the available reactions for a conversation and allows
/// the current user to remove their reactions.
///{@endtemplate}
class LMChatReactionBottomSheet extends StatefulWidget {
  /// A map of reactions mapped to their corresponding
  /// list of reaction view data. This can be null if no reactions are available.
  final Map<String, List<LMChatReactionViewData>>? mappedReactions;

  /// The user data of the current user interacting with the
  /// reactions.
  final LMChatUserViewData currentUser;

  /// A map containing metadata about users involved in the
  /// conversation. This can be null if no user metadata is available.
  final Map<int, LMChatUserViewData?>? userMeta;

  /// The conversation data to which the reactions belong.
  final LMChatConversationViewData conversation;

  /// A callback function that is called when a reaction
  /// is removed. It takes the reaction as a string parameter.
  final Function(String reaction)? onRemoveReaction;

  ///{@macro lm_chat_reaction_bottom_sheet}
  final LMChatReactionBottomSheetStyle? style; // Add style parameter

  const LMChatReactionBottomSheet({
    super.key,
    this.mappedReactions,
    required this.currentUser,
    required this.conversation,
    this.userMeta,
    this.onRemoveReaction,
    this.style, // Include style in constructor
  });

  LMChatReactionBottomSheet copyWith({
    Map<String, List<LMChatReactionViewData>>? mappedReactions,
    LMChatUserViewData? currentUser,
    Map<int, LMChatUserViewData?>? userMeta,
    LMChatConversationViewData? conversation,
    Function(String reaction)? onRemoveReaction,
    LMChatReactionBottomSheetStyle? style,
  }) {
    return LMChatReactionBottomSheet(
      key: key ?? key,
      mappedReactions: mappedReactions ?? this.mappedReactions,
      currentUser: currentUser ?? this.currentUser,
      conversation: conversation ?? this.conversation,
      userMeta: userMeta ?? this.userMeta,
      onRemoveReaction: onRemoveReaction ?? this.onRemoveReaction,
      style: style ?? this.style,
    );
  }

  @override
  State<LMChatReactionBottomSheet> createState() =>
      _LMChatReactionBottomSheetState();
}

class _LMChatReactionBottomSheetState extends State<LMChatReactionBottomSheet> {
  String selectedKey = 'All';
  Map<String, List<LMChatReactionViewData>>? mappedReactions;
  Map<int, LMChatUserViewData?>? userMeta;
  LMChatUserViewData? currentUser;
  LMChatConversationViewData? conversation;
  late LMChatReactionBottomSheetStyle style;

  // Set data for bottom sheet
  void initialiseBottomSheetData() {
    mappedReactions = widget.mappedReactions;
    userMeta = widget.userMeta;
    currentUser = widget.currentUser;
    conversation = widget.conversation;
    style = widget.style ?? LMChatTheme.theme.reactionBottomSheetStyle;
  }

  @override
  Widget build(BuildContext context) {
    initialiseBottomSheetData();
    return Container(
      clipBehavior: Clip.none,
      padding: style.padding ??
          const EdgeInsets.symmetric(horizontal: 18.0), // Use style padding
      height: style.height ?? 60.h, // Use style height
      decoration: BoxDecoration(
        color: style.backgroundColor ??
            LMChatTheme.theme.container, // Use style background color
        borderRadius: style.borderRadius ??
            const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ), // Use style border radius
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          kVerticalPaddingLarge,
          _buildTitle(), // Refactored title section
          kVerticalPaddingXLarge,
          _buildTabBar(), // Refactored tab bar section
          kVerticalPaddingLarge,
          _buildReactionList(), // Refactored reaction list section
        ],
      ),
    );
  }

  // New method to build the title
  Widget _buildTitle() {
    return LMChatText(
      'Reactions',
      style: style.titleStyle ??
          const LMChatTextStyle(
            textStyle: TextStyle(fontWeight: FontWeight.bold),
          ), // Use style title style
    );
  }

  // New method to build the tab bar
  Widget _buildTabBar() {
    return SizedBox(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: style.tabBarBorderColor ??
                      LMChatTheme.theme.disabledColor,
                  width: 1,
                ),
              ),
            ),
            width: 100.w - 40,
            height: 40,
            child: ListView.builder(
              itemCount: mappedReactions!.keys.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, reactionIndex) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedKey =
                        mappedReactions!.keys.elementAt(reactionIndex);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 5.0),
                  decoration: BoxDecoration(
                      border: selectedKey ==
                              mappedReactions!.keys.elementAt(reactionIndex)
                          ? Border(
                              bottom: BorderSide(
                                color: style.selectedTabColor ??
                                    LMChatTheme.theme
                                        .primaryColor, // Use style selected tab color
                                width: widget.style?.selectedTabBorderWidth ??
                                    1, // Use style selected tab border width
                              ),
                            )
                          : null),
                  child: LMChatText(
                    '${mappedReactions!.keys.elementAt(reactionIndex)} (${mappedReactions!.values.elementAt(reactionIndex).length})',
                    style: selectedKey ==
                            mappedReactions!.keys.elementAt(reactionIndex)
                        ? style.selectedTabTextStyle ??
                            LMChatTextStyle(
                              textStyle: TextStyle(
                                color: style.selectedTabColor ??
                                    LMChatTheme.theme.primaryColor,
                              ),
                            )
                        : style.tabTextStyle ??
                            const LMChatTextStyle(
                              textStyle: TextStyle(),
                            ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // New method to build the reaction list
  Widget _buildReactionList() {
    return Expanded(
      child: ListView.builder(
        itemCount: mappedReactions![selectedKey]!.length,
        itemBuilder: (context, itemIndex) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: LMChatUserTile(
            absorbTouch: false,
            style: style.userTileStyle,
            onTap: mappedReactions![selectedKey]![itemIndex].userId ==
                    currentUser!.id
                ? () => widget.onRemoveReaction?.call(
                      mappedReactions![selectedKey]![itemIndex].reaction,
                    )
                : () {},
            userViewData:
                userMeta![mappedReactions![selectedKey]![itemIndex].userId]!,
            trailing: LMChatText(
              mappedReactions![selectedKey]![itemIndex].reaction,
              style: style.reactionTextStyle ??
                  const LMChatTextStyle(
                    // Use style reaction text style
                    textStyle: TextStyle(
                      fontSize: 28,
                    ),
                  ),
            ),
            subtitle: mappedReactions![selectedKey]![itemIndex].userId ==
                    currentUser!.id
                ? LMChatText(
                    'Tap to remove',
                    style: style.removeReactionTextStyle ??
                        const LMChatTextStyle(
                          // Use style remove reaction text style
                          textStyle: TextStyle(
                            color: LMChatDefaultTheme.greyColor,
                          ),
                        ),
                  )
                : const SizedBox(),
          ),
        ),
      ),
    );
  }
}

/// A class that defines the style for the reaction bottom sheet.
///
/// This class contains properties that determine the appearance of the
/// reaction bottom sheet, including padding, height, background color,
/// border radius, and styles for various UI elements within the bottom sheet.
class LMChatReactionBottomSheetStyle {
  /// The padding applied to the entire bottom sheet.
  final EdgeInsets? padding;

  /// The height of the bottom sheet.
  final double? height;

  /// The background color of the bottom sheet.
  final Color? backgroundColor;

  /// The border radius of the bottom sheet.
  final BorderRadius? borderRadius;

  /// The style for the title text in the bottom sheet.
  final LMChatTextStyle? titleStyle;

  /// The height of the tab bar within the bottom sheet.
  final double? tabBarHeight;

  /// The border color of the tab bar.
  final Color? tabBarBorderColor;

  /// The border width of the tab bar.
  final double? tabBarBorderWidth;

  /// The width of the tab bar.
  final double? tabBarWidth;

  /// The padding applied to each tab item in the tab bar.
  final EdgeInsets? tabItemPadding;

  /// The background color of the selected tab.
  final Color? selectedTabColor;

  /// The border width of the selected tab.
  final double? selectedTabBorderWidth;

  /// The style for the text in the selected tab.
  final LMChatTextStyle? selectedTabTextStyle;

  /// The style for the text in the tab items.
  final LMChatTextStyle? tabTextStyle;

  /// The margin applied to the list items in the bottom sheet.
  final EdgeInsets? listItemMargin;

  /// The style for the user tiles in the bottom sheet.
  final LMChatTileStyle? userTileStyle;

  /// The style for the reaction text within the bottom sheet.
  final LMChatTextStyle? reactionTextStyle;

  /// The style for the text indicating the removal of a reaction.
  final LMChatTextStyle? removeReactionTextStyle;

  const LMChatReactionBottomSheetStyle({
    this.padding,
    this.height,
    this.backgroundColor,
    this.borderRadius,
    this.titleStyle,
    this.tabBarHeight,
    this.tabBarBorderColor,
    this.tabBarBorderWidth,
    this.tabBarWidth,
    this.tabItemPadding,
    this.selectedTabColor,
    this.selectedTabBorderWidth,
    this.selectedTabTextStyle,
    this.tabTextStyle,
    this.listItemMargin,
    this.userTileStyle,
    this.reactionTextStyle,
    this.removeReactionTextStyle,
  });

  /// Creates a basic style for the reaction bottom sheet with default values.
  factory LMChatReactionBottomSheetStyle.basic() {
    return const LMChatReactionBottomSheetStyle(
      padding: EdgeInsets.symmetric(horizontal: 18.0),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12.0),
        topRight: Radius.circular(12.0),
      ),
      tabBarHeight: 40,
      tabBarBorderWidth: 1,
      tabItemPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      selectedTabBorderWidth: 2,
      listItemMargin: EdgeInsets.only(bottom: 10),
      userTileStyle: LMChatTileStyle(verticalGap: 0, gap: 4),
    );
  }

  /// Creates a copy of the current style, allowing for modifications of specific properties.
  LMChatReactionBottomSheetStyle copyWith({
    EdgeInsets? padding,
    double? height,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    LMChatTextStyle? titleStyle,
    double? tabBarHeight,
    Color? tabBarBorderColor,
    double? tabBarBorderWidth,
    double? tabBarWidth,
    EdgeInsets? tabItemPadding,
    Color? selectedTabColor,
    double? selectedTabBorderWidth,
    LMChatTextStyle? selectedTabTextStyle,
    LMChatTextStyle? tabTextStyle,
    EdgeInsets? listItemMargin,
    LMChatTileStyle? userTileStyle,
    LMChatTextStyle? reactionTextStyle,
    LMChatTextStyle? removeReactionTextStyle,
  }) {
    return LMChatReactionBottomSheetStyle(
      padding: padding ?? this.padding,
      height: height ?? this.height,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      titleStyle: titleStyle ?? this.titleStyle,
      tabBarHeight: tabBarHeight ?? this.tabBarHeight,
      tabBarBorderColor: tabBarBorderColor ?? this.tabBarBorderColor,
      tabBarBorderWidth: tabBarBorderWidth ?? this.tabBarBorderWidth,
      tabBarWidth: tabBarWidth ?? this.tabBarWidth,
      tabItemPadding: tabItemPadding ?? this.tabItemPadding,
      selectedTabColor: selectedTabColor ?? this.selectedTabColor,
      selectedTabBorderWidth:
          selectedTabBorderWidth ?? this.selectedTabBorderWidth,
      selectedTabTextStyle: selectedTabTextStyle ?? this.selectedTabTextStyle,
      tabTextStyle: tabTextStyle ?? this.tabTextStyle,
      listItemMargin: listItemMargin ?? this.listItemMargin,
      userTileStyle: userTileStyle ?? this.userTileStyle,
      reactionTextStyle: reactionTextStyle ?? this.reactionTextStyle,
      removeReactionTextStyle:
          removeReactionTextStyle ?? this.removeReactionTextStyle,
    );
  }
}
