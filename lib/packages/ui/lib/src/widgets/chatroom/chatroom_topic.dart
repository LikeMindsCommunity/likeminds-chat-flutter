import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/models/models.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/constants/constants.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';

class LMChatRoomTopic extends StatelessWidget {
  const LMChatRoomTopic({
    super.key,
    required this.conversation,
    required this.onTap,
    this.leading,
    this.trailing,
    this.title,
    this.subTitle,
    this.date,
    this.backGroundColor,
  });

  final LMChatConversationViewData conversation;
  final VoidCallback onTap;
  final Widget? leading;
  final Widget? trailing;
  final LMChatText? title;
  final LMChatText? subTitle;
  final LMChatText? date;
  final Color? backGroundColor;

  Widget generateIcon(LMChatConversationViewData conversation) {
    Widget? icon;
    if (conversation.attachments == null) {
      if (conversation.ogTags != null) icon = const Icon(Icons.link);
    } else {
      switch (conversation.attachments!.first.type) {
        case kAttachmentTypeImage:
          icon = const Icon(Icons.image);
          break;
        case kAttachmentTypeVideo:
          icon = const Icon(Icons.videocam);
          break;
        case kAttachmentTypePDF:
          icon = const Icon(Icons.insert_drive_file_outlined);
          break;
      }
    }
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          kHorizontalPaddingXSmall,
          icon,
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  String generateSubtext(LMChatConversationViewData conversation) {
    if (conversation.answer.isNotEmpty) {
      return conversation.answer;
    }

    String subText = "";
    if (conversation.attachments != null) {
      switch (conversation.attachments!.first.type) {
        case kAttachmentTypeImage:
          subText = "Photo";
          break;
        case kAttachmentTypeVideo:
          subText = "Video";
          break;
        case kAttachmentTypePDF:
          subText = conversation.attachments!.first.name ?? "Document";
          break;
      }
    }
    return subText;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: backGroundColor ?? LMChatTheme.theme.backgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(children: [
            leading != null
                ? leading!
                : LMChatProfilePicture(
                    fallbackText: conversation.member != null
                        ? conversation.member!.name
                        : "Chatroom topic",
                    imageUrl: conversation.member?.imageUrl,
                    style: const LMChatProfilePictureStyle(
                      size: 36,
                    ),
                  ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        title != null
                            ? title!
                            : LMChatText(
                                conversation.member != null
                                    ? conversation.member!.name
                                    : "Chatroom topic",
                                style: LMChatTextStyle(
                                  textStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: LMChatTheme.theme.onContainer,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                        kHorizontalPaddingXSmall,
                        date == null
                            ? Text.rich(
                                TextSpan(children: [
                                  const WidgetSpan(
                                      child: Center(
                                    child: LMChatText(
                                      "\u2022 ",
                                      style: LMChatTextStyle(
                                        textStyle: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  )),
                                  WidgetSpan(
                                    child: LMChatText(
                                      "${conversation.date}",
                                      style: const LMChatTextStyle(
                                        textStyle: TextStyle(
                                          color: LMChatDefaultTheme.greyColor,
                                          // fontSize: 16
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                              )
                            : date!,
                      ],
                    ),
                    subTitle != null
                        ? subTitle!
                        : Text.rich(
                            TextSpan(
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                              children: [
                                TextSpan(
                                  text: generateSubtext(conversation),
                                )
                              ],
                            ),
                            maxLines: 1,
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                  ],
                ),
              ),
            ),
            // trailing != null
            //     ? trailing!
            //     : (((conversation.ogTags != null) ||
            //                 ((conversation.attachments != null &&
            //                         conversation.attachments!.isNotEmpty)) &&
            //                     (conversation.attachments!.first.type !=
            //                         kAttachmentTypePDF)) &&
            //             (conversation.ogTags != null &&
            //                 conversation.ogTags?['image'] != null))
            //         ? Align(
            //             alignment: Alignment.centerRight,
            //             child: LMChatImage(
            //               imageFile:
            //                   conversation.attachments?.first.attachmentFile,
            //               imageUrl:
            //                   conversation.attachments?.first.thumbnailUrl ??
            //                       conversation.attachments?.first.url ??
            //                       conversation.ogTags?['image'],
            //               width: 65,
            //               height: 65,
            //             ),
            //           )
            //         : const SizedBox.shrink()
          ]),
        ),
      ),
    );
  }
}
