import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

class LMChatJoinButton extends StatelessWidget {
  final VoidCallback onTap;
  final LMChatRoomViewData chatroom;

  const LMChatJoinButton({
    Key? key,
    required this.onTap,
    required this.chatroom,
  }) : super(key: key);

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
                        title: const Text("Leave chatroom"),
                        content: Text(
                          chatroom.isSecret != null && chatroom.isSecret!
                              ? 'Are you sure you want to leave this private group? To join back, you\'ll need to reach out to the admin'
                              : 'Are you sure you want to leave this group?',
                        ),
                        // actionText: 'Confirm',
                        // onActionPressed: onTap,
                        actions: [
                          LMChatText(
                            'Cancel',
                            onTap: () {
                              Navigator.pop(context);
                            },
                            style: const LMChatTextStyle(
                              maxLines: 1,
                              textStyle: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          LMChatText(
                            'Confirm',
                            onTap: () {
                              onTap();
                              Navigator.pop(context);
                            },
                            style: const LMChatTextStyle(
                              maxLines: 1,
                              textStyle: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
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
                          ? Icon(
                              Icons.notifications_active_outlined,
                              size: 24,
                              color: LMChatTheme.theme.primaryColor,
                            )
                          : Icon(
                              Icons.notification_add_outlined,
                              size: 24,
                              color: LMChatTheme.theme.onPrimary,
                            ),
                      const SizedBox(width: 6),
                      LMChatText(
                        isJoined ? "Joined" : "Join",
                        style: LMChatTextStyle.basic().copyWith(
                          textStyle: TextStyle(
                            color: !isJoined
                                ? LMChatTheme.theme.onPrimary
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
