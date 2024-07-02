import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';

class LMChatJoinButton extends StatelessWidget {
  final Function() onTap;
  final ChatRoom chatroom;

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
            onTap: () {
              isJoined
                  ? showDialog(
                      context: context,
                      builder: (context) => LMChatDialog(
                        title: const Text("Leave chatroom"),
                        content: Text(chatroom.isSecret != null &&
                                chatroom.isSecret!
                            ? 'Are you sure you want to leave this private group? To join back, you\'ll need to reach out to the admin'
                            : 'Are you sure you want to leave this group?'),
                        // actionText: 'Confirm',
                        // onActionPressed: onTap,
                      ),
                    )
                  : onTap();
            },
            child: Container(
              decoration: BoxDecoration(
                color: isJoined ? null : Colors.black,
                border: isJoined
                    ? Border.all(color: Colors.black, width: 1.2)
                    : null,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Row(
                  children: [
                    isJoined
                        // ? SvgPicture.asset(
                        //     kAssetNotificationCheckIcon,
                        //     height: 26,
                        //     color: isJoined
                        //         ? LMBranding.instance.headerColor
                        //         : kWhiteColor,
                        //   )
                        ? Icon(Icons.notifications)
                        : Icon(
                            Icons.notification_add,
                            size: 24,
                            color: Colors.red,
                            // color: isJoined
                            //     ? LMBranding.instance.headerColor
                            //     : kWhiteColor,
                          ),
                    const SizedBox(width: 6),
                    Text(
                      isJoined ? "Joined" : "Join",
                      // style: GoogleFonts.roboto(
                      //   fontSize: 11.sp,
                      //   fontWeight: FontWeight.w600,
                      //   color: isJoined
                      //       ? LMBranding.instance.headerColor
                      //       : kWhiteColor,
                      // ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
