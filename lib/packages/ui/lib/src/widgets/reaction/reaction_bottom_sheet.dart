import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

class LMChatReactionBottomSheet extends StatefulWidget {
  final Map<String, List<LMChatReactionViewData>>? mappedReactions;
  final LMChatUserViewData currentUser;
  final Map<int, LMChatUserViewData?>? userMeta;
  final LMChatConversationViewData conversation;
  final Function(String reaction)? onRemoveReaction;

  const LMChatReactionBottomSheet({
    Key? key,
    this.mappedReactions,
    required this.currentUser,
    required this.conversation,
    this.userMeta,
    this.onRemoveReaction,
  }) : super(key: key);

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

  // Set data for bottom sheet
  void initialiseBottomSheetData() {
    mappedReactions = widget.mappedReactions;
    userMeta = widget.userMeta;
    currentUser = widget.currentUser;
    conversation = widget.conversation;
  }

  @override
  Widget build(BuildContext context) {
    initialiseBottomSheetData();
    return Container(
      clipBehavior: Clip.none,
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      height: 60.h,
      decoration: BoxDecoration(
        color: LMChatTheme.theme.container,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          kVerticalPaddingLarge,
          const Text(
            'Reactions',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          kVerticalPaddingXLarge,
          SizedBox(
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: LMChatDefaultTheme.greyColor.withOpacity(0.2),
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
                                    mappedReactions!.keys
                                        .elementAt(reactionIndex)
                                ? Border(
                                    bottom: BorderSide(
                                      color: LMChatTheme.theme.primaryColor,
                                      width: 1,
                                    ),
                                  )
                                : null),
                        child: Text(
                          '${mappedReactions!.keys.elementAt(reactionIndex)} (${mappedReactions!.values.elementAt(reactionIndex).length})',
                          style: selectedKey ==
                                  mappedReactions!.keys.elementAt(reactionIndex)
                              ? TextStyle(color: LMChatTheme.theme.primaryColor)
                              : const TextStyle(),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          kVerticalPaddingLarge,
          Expanded(
            child: ListView.builder(
              itemCount: mappedReactions![selectedKey]!.length,
              itemBuilder: (context, itemIndex) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: LMChatUserTile(
                  absorbTouch: false,
                  onTap: mappedReactions![selectedKey]![itemIndex].userId ==
                          currentUser!.id
                      ? () => widget.onRemoveReaction?.call(
                            mappedReactions![selectedKey]![itemIndex].reaction,
                          )
                      : () {},
                  userViewData: userMeta![
                      mappedReactions![selectedKey]![itemIndex].userId]!,
                  trailing: Text(
                    mappedReactions![selectedKey]![itemIndex].reaction,
                    // style: LMTheme.bold.copyWith(fontSize: 20.sp),
                  ),
                  subtitle: mappedReactions![selectedKey]![itemIndex].userId ==
                          currentUser!.id
                      ? const LMChatText(
                          'Tap to remove',
                          style: LMChatTextStyle(
                            textStyle: TextStyle(
                              color: LMChatDefaultTheme.greyColor,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LMChatReactionBottomSheetStyle {
  final EdgeInsets? padding;
  final double? height;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final TextStyle? titleStyle;
  final double? tabBarHeight;
  final Color? tabBarBorderColor;
  final double? tabBarBorderWidth;
  final double? tabBarWidth;
  final EdgeInsets? tabItemPadding;
  final Color? selectedTabColor;
  final double? selectedTabBorderWidth;
  final TextStyle? selectedTabTextStyle;
  final TextStyle? tabTextStyle;
  final EdgeInsets? listItemMargin;
  final LMChatTileStyle? userTileStyle;
  final TextStyle? reactionTextStyle;
  final TextStyle? removeReactionTextStyle;

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

  factory LMChatReactionBottomSheetStyle.basic() {
    return const LMChatReactionBottomSheetStyle(
      padding: EdgeInsets.symmetric(horizontal: 18.0),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12.0),
        topRight: Radius.circular(12.0),
      ),
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      tabBarHeight: 40,
      tabBarBorderWidth: 1,
      tabItemPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      selectedTabBorderWidth: 2,
      tabTextStyle: TextStyle(),
      listItemMargin: EdgeInsets.only(bottom: 10),
      userTileStyle: LMChatTileStyle(verticalGap: 0, gap: 4),
      reactionTextStyle: TextStyle(fontSize: 20),
      removeReactionTextStyle: TextStyle(
        color: LMChatDefaultTheme.greyColor,
      ),
    );
  }

  LMChatReactionBottomSheetStyle copyWith({
    EdgeInsets? padding,
    double? height,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    TextStyle? titleStyle,
    double? tabBarHeight,
    Color? tabBarBorderColor,
    double? tabBarBorderWidth,
    double? tabBarWidth,
    EdgeInsets? tabItemPadding,
    Color? selectedTabColor,
    double? selectedTabBorderWidth,
    TextStyle? selectedTabTextStyle,
    TextStyle? tabTextStyle,
    EdgeInsets? listItemMargin,
    LMChatTileStyle? userTileStyle,
    TextStyle? reactionTextStyle,
    TextStyle? removeReactionTextStyle,
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
