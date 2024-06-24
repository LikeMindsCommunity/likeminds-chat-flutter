import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

class LMChatUserTile extends StatelessWidget {
  final LMChatUserViewData user;

  const LMChatUserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (user.sdkClientInfo != null) {
          // todo: user profile callback
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        height: 8.h,
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LMChatProfilePicture(
              fallbackText: user.name,
              imageUrl: user.imageUrl,
              style: const LMChatProfilePictureStyle(
                size: 48,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                user.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
