import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';
import 'package:shimmer/shimmer.dart';

class LMChatUserTileShimmer extends StatelessWidget {
  const LMChatUserTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: 16.0,
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.black26,
        highlightColor: Colors.black12,
        child: Row(
          children: [
            const SizedBox(
              height: 50,
              width: 50,
              child: CircleAvatar(
                backgroundColor: Colors.white,
              ),
            ),
            LMChatDefaultTheme.kHorizontalPaddingXLarge,
            Container(
              height: 12,
              width: 150,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}