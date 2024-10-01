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
