import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/constants/assets.dart';
import 'package:lottie/lottie.dart';

/// A screen that handles the initialization of an AI chatbot
/// and navigates to the appropriate chatroom once setup is complete.
class LMChatAIBotInitiationScreen extends StatefulWidget {
  /// Custom Lottie animation JSON asset path to show during initialization
  final String? animationToShow;

  /// Text to display during initialization
  final LMChatTextBuilder? previewText;

  /// Creates an AI chatbot initialization screen with optional custom animation and preview text
  const LMChatAIBotInitiationScreen({
    Key? key,
    this.animationToShow,
    this.previewText,
  }) : super(key: key);

  @override
  State<LMChatAIBotInitiationScreen> createState() =>
      _LMChatAIBotInitiationScreenState();
}

class _LMChatAIBotInitiationScreenState
    extends State<LMChatAIBotInitiationScreen> with TickerProviderStateMixin {
  final LMChatClient _chatClient = LMChatCore.client;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _initializeChatbot();
  }

  Future<void> _initializeChatbot() async {
    try {
      final response = await _chatClient.getAIChatbots(
        (GetAIChatbotsRequestBuilder()
              ..page(1)
              ..pageSize(10))
            .build(),
      );

      if (!response.success) {
        _handleError(response.errorMessage);
        return;
      }

      if (response.data?.users.isEmpty ?? true) {
        _handleError('No chatbots available');
        return;
      }

      final chatbot = response.data!.users[0];
      final chatbotUUID = chatbot.sdkClientInfo!.uuid;

      final dmStatusResponse = await _chatClient.checkDMStatus(
        (CheckDMStatusRequestBuilder()
              ..reqFrom('member_profile')
              ..uuid(chatbotUUID!))
            .build(),
      );

      if (!dmStatusResponse.success) {
        _handleError(dmStatusResponse.errorMessage);
        return;
      }

      final cta = dmStatusResponse.data?.cta;
      final ctaURL = Uri.parse(cta ?? '');
      final chatroomId = ctaURL.queryParameters['chatroom_id'];

      if (chatroomId != null) {
        await _handleExistingChatroom(int.parse(chatroomId));
      } else {
        await _createNewChatroom(chatbotUUID);
      }
    } catch (e) {
      _handleError('An error occurred: $e');
    }
  }

  Future<void> _handleExistingChatroom(int chatroomId) async {
    await _saveChatroomId(chatroomId);
    _navigateToChatroom(chatroomId);
  }

  Future<void> _createNewChatroom(String chatbotUUID) async {
    final response = await _chatClient.createDMChatroom(
      (CreateDMChatroomRequestBuilder()..uuid(chatbotUUID)).build(),
    );

    if (!response.success) {
      _handleError(response.errorMessage);
      return;
    }

    final chatroomId = response.data?.chatRoom?.id;

    if (chatroomId != null) {
      await _saveChatroomId(chatroomId);
      _navigateToChatroom(chatroomId);
    } else {
      _handleError('Failed to create chatroom');
    }
  }

  Future<void> _saveChatroomId(int chatroomId) async {
    await LMChatLocalPreference.instance
        .storeChatroomIdWithAIChatbot(chatroomId);
  }

  void _navigateToChatroom(int chatroomId) {
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => LMChatroomScreen(chatroomId: chatroomId),
    //   ),
    // );
  }

  void _handleError(String? message) {
    _stopAnimation();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? 'An error occurred')),
    );
    Navigator.pop(context);
  }

  void _stopAnimation() {
    _animationController.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LMChatTheme.theme.container,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Lottie.asset(
                widget.animationToShow ?? aiChatbotLoadingAnimation,
              ),
            ),
            widget.previewText?.call(
                  context,
                  const LMChatText(
                    "Setting up AI Chatbot...",
                  ),
                ) ??
                const LMChatText(
                  "Setting up AI Chatbot...",
                ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
