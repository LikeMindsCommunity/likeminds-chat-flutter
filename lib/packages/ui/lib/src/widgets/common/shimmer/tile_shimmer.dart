import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';
import 'package:shimmer/shimmer.dart';

class LMChatTileShimmer extends StatelessWidget {
  const LMChatTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 16.0,
        bottom: 4.0,
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.4),
        highlightColor: Colors.grey.withOpacity(0.1),
        child: Row(
          children: [
            LMChatDefaultTheme.kHorizontalPaddingXLarge,
            Container(
              height: 24,
              width: 180,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
