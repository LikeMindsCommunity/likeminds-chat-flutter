import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';
import 'package:shimmer/shimmer.dart';

class LMChatMediaShimmerWidget extends StatelessWidget {
  final bool isPP;
  final double? height;
  final double? width;
  final LMChatMediaShimmerStyle? style;

  const LMChatMediaShimmerWidget(
      {Key? key, this.isPP = false, this.height, this.width, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Shimmer.fromColors(
      baseColor: style?.baseColor ?? Colors.grey.shade100,
      highlightColor: style?.highlightColor ?? Colors.grey.shade200,
      period: const Duration(seconds: 2),
      direction: ShimmerDirection.ltr,
      child: isPP
          ? const CircleAvatar(backgroundColor: Colors.white)
          : Container(
              color: Colors.white,
              width: width ?? screenWidth * 0.55,
              height: height ?? screenWidth * 0.55,
            ),
    );
  }
}

class LMChatMediaShimmerStyle {
  final Color? baseColor;
  final Color? highlightColor;

  LMChatMediaShimmerStyle({
    this.baseColor,
    this.highlightColor,
  });
}
