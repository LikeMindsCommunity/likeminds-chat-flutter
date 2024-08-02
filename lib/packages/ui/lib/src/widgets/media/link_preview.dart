import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/models/models.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

/// {@template lm_chat_link_preview}
/// A widget to display a link preview in a chatroom.
/// The [LMChatLinkPreview] can be customized by passing in the required parameters
/// and can be used in a chatroom.
/// {@endtemplate}
class LMChatLinkPreview extends StatelessWidget {
  /// {@macro lm_chat_link_preview}
  const LMChatLinkPreview({
    super.key,
    required this.ogTags,
    this.onTap,
  });

  final LMChatOGTagsViewData ogTags;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GestureDetector(
        onTap: () {
          if (onTap != null) {
            onTap!();
          } else if (ogTags.url != null && ogTags.url!.isNotEmpty) {
            launchUrl(Uri.parse(ogTags.url!));
          }
        },
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0x1a9b9b9b),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(ogTags.imageUrl != null && ogTags.imageUrl!.isNotEmpty)
              LMChatImage(
                imageUrl: ogTags.imageUrl,
                style: const LMChatImageStyle(
                    height: 190,
                    width: 225,
                    boxFit: BoxFit.fill,
                    errorWidget: LMChatIcon(
                      type: LMChatIconType.icon,
                      icon: Icons.link,
                      style: LMChatIconStyle(
                        size: 32,
                      ),
                    )),
              ),
              if(ogTags.title != null && ogTags.title!.isNotEmpty)
              LMChatText(
                ogTags.title ?? "",
                style: const LMChatTextStyle(
                  padding: EdgeInsets.only(
                    top: 8,
                    bottom: 4,
                    left: 8,
                    right: 8,
                  ),
                  textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
              ),
              if(ogTags.description != null && ogTags.description!.isNotEmpty)
              LMChatText(
                ogTags.description ?? "",
                style: const LMChatTextStyle(
                  padding: EdgeInsets.only(
                    top: 4,
                    bottom: 16,
                    left: 8,
                    right: 8,
                  ),
                  textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
