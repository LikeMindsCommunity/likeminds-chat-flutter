import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

/// [LMChatSkeletonChatPage] is a skeleton screen for the chat page.
class LMChatSkeletonChatPage extends StatelessWidget {
  const LMChatSkeletonChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        color: LMChatTheme.theme.backgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const LMChatSkeletonAppBar(),
            const SizedBox(height: 18),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(),
                child: Container(
                  color: LMChatTheme.theme.backgroundColor,
                  child: const LMChatSkeletonChatList(),
                ),
              ),
            ),
            // const Spacer(),
            const LMChatSkeletonChatBar(),
          ],
        ),
      ),
    );
  }
}

class LMChatSkeletonAppBar extends StatelessWidget {
  const LMChatSkeletonAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LMChatTheme.theme.container,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LMChatSkeletonAnimation(
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: LMChatTheme.theme.onContainer.withOpacity(0.5),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            LMChatSkeletonAnimation(
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: LMChatTheme.theme.onContainer.withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LMChatSkeletonAnimation(
                    child: Container(
                      width: 140,
                      height: 16,
                      decoration: BoxDecoration(
                        color: LMChatTheme.theme.onContainer.withOpacity(0.5),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  LMChatDefaultTheme.kVerticalPaddingSmall,
                  LMChatSkeletonAnimation(
                    child: Container(
                      width: 100,
                      height: 12,
                      decoration: BoxDecoration(
                        color: LMChatTheme.theme.onContainer.withOpacity(0.5),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // LMChatDefaultTheme.kHorizontalPaddingMedium,
          ],
        ),
      ),
    );
  }
}

class LMChatSkeletonChatBar extends StatelessWidget {
  const LMChatSkeletonChatBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      color: LMChatTheme.theme.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: LMChatSkeletonAnimation(
                child: Container(
                  width: size.width * 0.9,
                  height: size.height * 0.06,
                  decoration: BoxDecoration(
                    color: LMChatTheme.theme.onContainer.withOpacity(0.5),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            LMChatDefaultTheme.kHorizontalPaddingMedium,
            LMChatSkeletonAnimation(
              child: Container(
                width: size.height * 0.06,
                height: size.height * 0.06,
                decoration: BoxDecoration(
                  color: LMChatTheme.theme.onContainer.withOpacity(0.5),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LMChatSkeletonChatList extends StatelessWidget {
  const LMChatSkeletonChatList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> list = List.generate(
      10,
      (index) => LMChatSkeletonChatBubble(isSent: index % 3 == 0),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        children: list,
      ),
    );
  }
}

class LMChatSkeletonChatroomList extends StatelessWidget {
  const LMChatSkeletonChatroomList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> list = List.generate(
      6,
      (index) => const LMChatSkeletonChatroom(),
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.01,
      ),
      child: Column(
        children: list,
      ),
    );
  }
}

class LMChatSkeletonChatroom extends StatelessWidget {
  const LMChatSkeletonChatroom({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      color: LMChatTheme.theme.container,
      child: Padding(
        padding: EdgeInsets.only(
          left: 18,
          right: 18,
          bottom: size.height * 0.04,
        ),
        child: Row(
          children: [
            LMChatSkeletonAnimation(
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: LMChatTheme.theme.onContainer.withOpacity(0.5),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(21),
                  ),
                ),
              ),
            ),
            LMChatDefaultTheme.kHorizontalPaddingMedium,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LMChatSkeletonAnimation(
                    child: Container(
                      width: size.width * 0.6,
                      height: 14,
                      decoration: BoxDecoration(
                        color: LMChatTheme.theme.onContainer.withOpacity(0.5),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(6),
                        ),
                      ),
                    ),
                  ),
                  LMChatDefaultTheme.kVerticalPaddingSmall,
                  LMChatSkeletonAnimation(
                    child: Container(
                      width: size.width * 0.4,
                      height: 10,
                      decoration: BoxDecoration(
                        color: LMChatTheme.theme.onContainer.withOpacity(0.5),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LMChatSkeletonChatBubble extends StatelessWidget {
  final bool isSent;
  const LMChatSkeletonChatBubble({
    super.key,
    required this.isSent,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.01,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isSent)
                const Spacer()
              else
                LMChatSkeletonAnimation(
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: LMChatTheme.theme.onContainer.withOpacity(0.5),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                  ),
                ),
              LMChatDefaultTheme.kHorizontalPaddingMedium,
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: LMChatTheme.theme.container.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: size.width * 0.6,
                    maxHeight: size.height * 0.045,
                    minHeight: size.height * 0.045,
                  ),
                  alignment: Alignment.center,
                  child: LMChatSkeletonAnimation(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: LMChatTheme.theme.container.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              LMChatDefaultTheme.kHorizontalPaddingMedium,
              if (isSent)
                LMChatSkeletonAnimation(
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: LMChatTheme.theme.onContainer.withOpacity(0.5),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                  ),
                )
              else
                const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}

class LMChatSkeletonAnimation extends StatelessWidget {
  final Widget child;
  final Duration? duration;
  final Curve? curve;

  const LMChatSkeletonAnimation({
    super.key,
    required this.child,
    this.duration,
    this.curve,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.grey.shade300,
      period: const Duration(seconds: 1),
      direction: ShimmerDirection.ltr,
      child: child,
    );
  }
}
