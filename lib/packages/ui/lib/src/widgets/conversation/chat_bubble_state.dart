part of 'chat_bubble.dart';

class LMChatStateBubble extends StatelessWidget {
  final String message;

  const LMChatStateBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          IntrinsicWidth(
            child: Container(
              constraints: BoxConstraints(maxWidth: 70.w),
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: LMChatDefaultTheme.whiteColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: LMChatText(
                message,
                style: const LMChatTextStyle(
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(
                    fontSize: 12,
                    color: Color.fromRGBO(100, 116, 139, 1),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
