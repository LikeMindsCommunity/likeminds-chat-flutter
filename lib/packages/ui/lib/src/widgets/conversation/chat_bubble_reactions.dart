import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/models/models.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';

class LMChatBubbleReactions extends StatefulWidget {
  final LMChatConversationViewData conversation;
  final LMChatUserViewData currentUser;
  final Map<int, LMChatUserViewData> userMeta;
  final List<LMChatReactionViewData>? reactions;
  final bool? isSent;
  final Function(String reaction)? onRemoveReaction;

  const LMChatBubbleReactions({
    super.key,
    this.isSent,
    this.onRemoveReaction,
    this.reactions,
    required this.userMeta,
    required this.conversation,
    required this.currentUser,
  });

  @override
  State<LMChatBubbleReactions> createState() => _LMChatBubbleReactionsState();
}

class _LMChatBubbleReactionsState extends State<LMChatBubbleReactions> {
  LMChatConversationViewData? conversation;
  List<LMChatReactionViewData> reactions = [];
  Map<String, List<LMChatReactionViewData>> mappedReactions = {};

  @override
  void initState() {
    super.initState();
    conversation = widget.conversation;
    reactions = widget.reactions ?? [];
    mappedReactions = convertListToMapReaction(reactions);
  }

  @override
  void didUpdateWidget(covariant LMChatBubbleReactions oldWidget) {
    conversation = widget.conversation;
    reactions = widget.reactions ?? [];
    mappedReactions = convertListToMapReaction(reactions);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    List<String> keys = mappedReactions.keys.toList();
    return ((conversation!.hasReactions ?? false) &&
            (widget.reactions != null && widget.reactions!.isNotEmpty))
        ? Container(
            padding: const EdgeInsets.only(top: 4),
            margin: const EdgeInsets.only(left: 8),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  elevation: 5,
                  useSafeArea: true,
                  builder: (context) => LMChatReactionBottomSheet(
                    mappedReactions: mappedReactions,
                    userMeta: widget.userMeta,
                    currentUser: widget.currentUser,
                    conversation: conversation!,
                    onRemoveReaction: widget.onRemoveReaction,
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  keys.length >= 2
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: LMChatTheme.theme.container,
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: Text(
                            '${keys[1]}${mappedReactions[keys[1]]!.length}',
                          ),
                        )
                      : const SizedBox(),
                  keys.length >= 3
                      ? Container(
                          margin: const EdgeInsets.only(left: 4.0),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: LMChatTheme.theme.container,
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: LMChatText(
                            '${keys[2]}${mappedReactions[keys[2]]!.length}',
                          ),
                        )
                      : const SizedBox(),
                  kHorizontalPaddingSmall,
                  reactions.length > 3
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: LMChatTheme.theme.container,
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: const Text('...'),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          )
        : const SizedBox();
  }

  Map<String, List<LMChatReactionViewData>> convertListToMapReaction(
      List<LMChatReactionViewData> reaction) {
    Map<String, List<LMChatReactionViewData>> mappedReactions = {};
    mappedReactions = {'All': reaction};
    for (var element in reaction) {
      if (mappedReactions.containsKey(element.reaction)) {
        mappedReactions[element.reaction]?.add(element);
      } else {
        mappedReactions[element.reaction] = [element];
      }
    }
    return mappedReactions;
  }
}
