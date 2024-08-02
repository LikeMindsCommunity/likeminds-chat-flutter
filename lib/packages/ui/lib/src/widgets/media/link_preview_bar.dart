import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/models/models.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';

/// {@template chat_link_preview_bar}
/// A widget to display a link preview bar on top of the chat bar textfield.
///
/// The [LMChatLinkPreviewBar] can be customized by passing in the required parameters
/// and can be used in a chatroom.
/// {@endtemplate}
class LMChatLinkPreviewBar extends StatelessWidget {
  /// {@macro chat_link_preview_bar}
  const LMChatLinkPreviewBar({
    super.key,
    required this.ogTags,
    this.onCanceled,
  });

  /// The [LMChatOGTagsViewData] to be displayed in the link preview bar.
  final LMChatOGTagsViewData ogTags;

  /// The onCanceled function of the link preview bar.
  final VoidCallback? onCanceled;

  @override
  Widget build(BuildContext context) {
    final themeData = LMChatTheme.theme;
    return Container(
      width: 80.w,
      decoration: BoxDecoration(
        color: themeData.container,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LMChatImage(
              imageUrl: ogTags.imageUrl,
              style: const LMChatImageStyle(
                height: 80,
                width: 80,
                boxFit: BoxFit.fill,
                margin: EdgeInsets.symmetric(horizontal: 6),
                errorWidget: LMChatIcon(
                  type: LMChatIconType.icon,
                  icon: Icons.link,
                  style: LMChatIconStyle(
                    size: 32,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LMChatText(
                    ogTags.title ?? "",
                    style: LMChatTextStyle(
                      padding: EdgeInsets.symmetric(horizontal: 1.w),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  LMChatText(
                    ogTags.description ?? "",
                    style: LMChatTextStyle(
                      padding: EdgeInsets.symmetric(horizontal: 1.w),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  LMChatText(
                    ogTags.url ?? "",
                    style: LMChatTextStyle(
                      padding: EdgeInsets.symmetric(horizontal: 1.w),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            LMChatButton(
              onTap: onCanceled,
              icon: const LMChatIcon(
                type: LMChatIconType.icon,
                icon: Icons.close,
                style: LMChatIconStyle(
                  size: 20,
                ),
              ),
              style: const LMChatButtonStyle(
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.all(6),
                borderRadius: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
