import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';
import 'package:shimmer/shimmer.dart';

class LMChatDocumentShimmer extends StatelessWidget {
  const LMChatDocumentShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius:
              BorderRadius.circular(LMChatDefaultTheme.kBorderRadiusMedium)),
      padding: const EdgeInsets.all(LMChatDefaultTheme.kPaddingLarge),
      child: Shimmer.fromColors(
        baseColor: Colors.black26,
        highlightColor: Colors.black12,
        child: Row(children: <Widget>[
          Container(
            height: 40,
            width: 35,
            color: Colors.white,
          ),
          LMChatDefaultTheme.kHorizontalPaddingLarge,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 8,
                width: 150,
                color: Colors.white,
              ),
              LMChatDefaultTheme.kVerticalPaddingMedium,
              Row(
                children: <Widget>[
                  Container(
                    height: 6,
                    width: 50,
                    color: Colors.white,
                  ),
                  LMChatDefaultTheme.kHorizontalPaddingXSmall,
                  const Text(
                    '·',
                    style: TextStyle(
                      fontSize: LMChatDefaultTheme.kFontSmall,
                      color: Colors.grey,
                    ),
                  ),
                  LMChatDefaultTheme.kHorizontalPaddingXSmall,
                  Container(
                    height: 6,
                    width: 50,
                    color: Colors.white,
                  ),
                ],
              )
            ],
          )
        ]),
      ),
    );
  }
}
