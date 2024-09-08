import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

/// {@template lm_chat_document_shimmer}
/// A shhimmer loading widget that is shown while document tile is loading
/// {@endtemplate}
class LMChatDocumentShimmer extends StatelessWidget {
  ///{@macro lm_chat_document_shimmer}
  const LMChatDocumentShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      width: 60.w,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          border: Border.all(color: LMChatDefaultTheme.greyColor, width: 1),
          borderRadius: BorderRadius.circular(kBorderRadiusMedium)),
      padding: const EdgeInsets.all(kPaddingLarge),
      child: Shimmer.fromColors(
        baseColor: Colors.black26,
        highlightColor: Colors.black12,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 10.w,
              width: 10.w,
              color: LMChatTheme.theme.container,
            ),
            kHorizontalPaddingLarge,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 8,
                  width: 30.w,
                  color: LMChatTheme.theme.container,
                ),
                kVerticalPaddingMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 6,
                      width: 10.w,
                      color: LMChatTheme.theme.container,
                    ),
                    kHorizontalPaddingXSmall,
                    Text(
                      '·',
                      style: TextStyle(
                        fontSize: kFontSmall,
                        color: LMChatTheme.theme.disabledColor,
                      ),
                    ),
                    kHorizontalPaddingXSmall,
                    Container(
                      height: 6,
                      width: 10.w,
                      color: LMChatTheme.theme.container,
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
