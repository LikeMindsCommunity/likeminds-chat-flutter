import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';

class LMChatReactionBar extends StatelessWidget {
  const LMChatReactionBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            width: 90.w,
            height: 50,
            child: getListOfReactions(
              onTap: (String reaction) async {
                if (reaction == 'Add') {
                } else {}
              },
            ),
          ),
        ],
      ),
    );
  }
}

const List<String> reactionEmojis = ['♥️', '😂', '😮', '😢', '😡', '👍'];

Widget getListOfReactions({required Function onTap}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: reactionEmojis
            .map((e) => GestureDetector(
                  onTap: () => onTap(e),
                  child: LMChatText(e, style: const LMChatTextStyle()),
                ))
            .toList() +
        [
          GestureDetector(
            onTap: () => onTap('Add'),
            child: const LMChatIcon(
              type: LMChatIconType.icon,
              icon: Icons.add_reaction_outlined,
              style: LMChatIconStyle(
                size: 24,
              ),
            ),
          )
        ],
  );
}
