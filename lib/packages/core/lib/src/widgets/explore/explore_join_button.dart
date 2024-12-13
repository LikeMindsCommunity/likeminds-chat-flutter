import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/src/utils/constants/assets.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

class LMChatJoinButton extends StatelessWidget {
  final VoidCallback onTap;
  final LMChatRoomViewData chatroom;

  const LMChatJoinButton({
    super.key,
    required this.onTap,
    required this.chatroom,
  });

  @override
  Widget build(BuildContext context) {
    bool isJoined = chatroom.followStatus!;
    return chatroom.isSecret != null && chatroom.isSecret!
        ? const SizedBox()
        : GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              isJoined
                  ? showDialog(
                      context: context,
                      builder: (context) => LMChatDialog(
                        style: LMChatDialogStyle(
                          backgroundColor: LMChatTheme.theme.container,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        title: LMChatText(
                          "Leave Chatroom?",
                          style: LMChatTextStyle(
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: LMChatTheme.theme.onContainer,
                            ),
                          ),
                        ),
                        content: LMChatText(
                          chatroom.isSecret != null && chatroom.isSecret!
                              ? 'Are you sure you want to leave this private group? To join back, you\'ll need to reach out to the admin'
                              : 'Are you sure you want to leave this group?',
                          style: LMChatTextStyle(
                            textStyle: TextStyle(
                              fontSize: 14,
                              color: LMChatTheme.theme.onContainer,
                            ),
                          ),
                        ),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 2.0),
                            child: LMChatText(
                              "CANCEL",
                              style: LMChatTextStyle(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: LMChatTheme.theme.onContainer,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: LMChatText(
                              "CONFIRM",
                              style: LMChatTextStyle(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: LMChatTheme.theme.primaryColor,
                                ),
                              ),
                              onTap: () {
                                onTap();
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : onTap();
            },
            child: AbsorbPointer(
              child: Container(
                decoration: BoxDecoration(
                  color: isJoined
                      ? LMChatTheme.theme.disabledColor
                      : LMChatTheme.theme.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      isJoined
                          ? LMChatIcon(
                              type: LMChatIconType.svg,
                              assetPath: exploreJoinnedIcon,
                              style: LMChatIconStyle(
                                size: 24,
                                color: LMChatTheme.theme.primaryColor,
                              ),
                            )
                          : LMChatIcon(
                              type: LMChatIconType.svg,
                              assetPath: exploreJoinIcon,
                              style: LMChatIconStyle(
                                size: 24,
                                color: LMChatTheme.theme.container,
                              ),
                            ),
                      const SizedBox(width: 6),
                      LMChatText(
                        isJoined ? "Joined" : "Join",
                        style: LMChatTextStyle.basic().copyWith(
                          textStyle: TextStyle(
                            color: !isJoined
                                ? LMChatTheme.theme.container
                                : LMChatTheme.theme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
