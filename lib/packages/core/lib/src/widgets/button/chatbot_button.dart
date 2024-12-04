import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/views/chatbot/init_chatbot.dart';

/// A class that holds the configuration properties for the LMChatAIButton.
/// These properties are used to authenticate and initialize the AI chatbot.
class LMChatAIButtonProps {
  /// The API key used for authentication when not using token-based security.
  /// Required when using the non-token based authentication method.
  final String? apiKey;

  /// The unique identifier for the user.
  /// Required when using the non-token based authentication method.
  final String? uuid;

  /// The display name of the user.
  /// Required when using the non-token based authentication method.
  final String? userName;

  /// The URL of the user's profile image.
  /// Optional parameter for user profile customization.
  final String? imageUrl;

  /// Indicates whether the user is a guest user.
  /// Optional parameter, defaults to false if not provided.
  final bool? isGuest;

  /// The access token for token-based security authentication.
  /// Required when using the token-based authentication method.
  final String? accessToken;

  /// The refresh token for token-based security authentication.
  /// Required when using the token-based authentication method.
  final String? refreshToken;

  /// Creates a new instance of [LMChatAIButtonProps].
  ///
  /// Use either [apiKey], [uuid], and [userName] for non-token based authentication,
  /// or [accessToken] and [refreshToken] for token-based authentication.
  const LMChatAIButtonProps({
    this.apiKey,
    this.uuid,
    this.userName,
    this.imageUrl,
    this.isGuest,
    this.accessToken,
    this.refreshToken,
  });

  /// Checks if the props are empty.
  bool isEmpty() {
    return (apiKey == null || apiKey!.isEmpty) &&
        (uuid == null || uuid!.isEmpty) &&
        (userName == null || userName!.isEmpty) &&
        (imageUrl == null || imageUrl!.isEmpty) &&
        isGuest == null;
  }
}

/// Style class for customizing the appearance of [LMChatAIButton]
class LMChatAIButtonStyle {
  /// The text to be displayed on the button.
  /// Defaults to 'AI Bot' if not provided.
  final String? text;

  /// The size of the button text in logical pixels.
  /// Defaults to 14 if not provided.
  final double? textSize;

  /// The color of the button text.
  /// Defaults to white (0xFFFFFFFF) if not provided.
  final Color? textColor;

  /// The background color of the button.
  /// Defaults to dark blue (0xFF020D42) if not provided.
  final Color? backgroundColor;

  /// The border radius of the button in logical pixels.
  /// Defaults to 28 if not provided.
  final double? borderRadius;

  /// The icon to be displayed on the button.
  /// If not provided, defaults to Icons.android.
  final IconData? icon;

  /// The placement of the icon relative to the text (start or end).
  /// Defaults to LMChatIconButtonPlacement.start.
  final LMChatIconButtonPlacement iconPlacement;

  const LMChatAIButtonStyle({
    this.text,
    this.textSize,
    this.textColor,
    this.backgroundColor,
    this.borderRadius,
    this.icon,
    this.iconPlacement = LMChatIconButtonPlacement.start,
  });

  /// Basic style factory constructor; used as default style
  factory LMChatAIButtonStyle.basic() {
    return const LMChatAIButtonStyle(
      text: 'AI Bot',
      textSize: 14,
      textColor: Color(0xFFFFFFFF),
      backgroundColor: Color(0xFF020D42),
      borderRadius: 28,
      iconPlacement: LMChatIconButtonPlacement.start,
    );
  }

  /// Creates a copy of this style with the given fields replaced with new values
  LMChatAIButtonStyle copyWith({
    String? text,
    double? textSize,
    Color? textColor,
    Color? backgroundColor,
    double? borderRadius,
    IconData? icon,
    LMChatIconButtonPlacement? iconPlacement,
  }) {
    return LMChatAIButtonStyle(
      text: text ?? this.text,
      textSize: textSize ?? this.textSize,
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      icon: icon ?? this.icon,
      iconPlacement: iconPlacement ?? this.iconPlacement,
    );
  }
}

/// A button widget that provides direct access to AI chatroom functionality.
///
/// This widget can be configured to use either token-based or API key-based authentication
/// through the [props] parameter.
class LMChatAIButton extends StatelessWidget {
  /// The text widget of the button
  final LMChatText? text;

  /// The icon widget of the button
  final LMChatIcon? icon;

  /// Style configuration for the button's appearance
  final LMChatAIButtonStyle? style;

  /// Configuration properties for the AI chatbot initialization.
  /// Contains authentication and user information.
  final LMChatAIButtonProps? props;

  /// Callback function that is called when the button is tapped.
  final VoidCallback? onTap;

  /// Callback function that is called when the button is long-pressed.
  final VoidCallback? onLongPress;

  const LMChatAIButton({
    super.key,
    this.text,
    this.icon,
    this.style,
    this.props,
    this.onTap,
    this.onLongPress,
  });

  /// Initializes the AI chatbot with token-based security.
  ///
  /// This method handles the authentication process using [accessToken] and [refreshToken],
  /// and navigates to the appropriate screen based on the chatroom state.
  ///
  /// Parameters:
  /// - [accessToken]: The access token for authentication
  /// - [refreshToken]: The refresh token for authentication
  /// - [context]: The build context for navigation
  ///
  /// Shows error message if the initialization fails.
  Future<void> startAIChatbotWithSecurity(
      String accessToken, String refreshToken, BuildContext context) async {
    final response = await LMChatCore.instance.showChatWithoutApiKey(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    if (response.success) {
      final chatroomId =
          LMChatLocalPreference.instance.getChatroomIdWithAIChatbot();
      if (chatroomId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LMChatroomScreen(chatroomId: chatroomId)),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const LMChatAIBotInitiationScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.errorMessage ?? 'An error occurred')),
      );
    }
  }

  /// Initializes the AI chatbot without token-based security.
  ///
  /// This method handles the authentication process using API key and user information,
  /// and navigates to the appropriate screen based on the chatroom state.
  ///
  /// Parameters:
  /// - [apiKey]: The API key for authentication
  /// - [uuid]: The unique identifier of the user
  /// - [userName]: The display name of the user
  /// - [imageUrl]: Optional URL for the user's profile image
  /// - [isGuest]: Whether the user is a guest
  /// - [context]: The build context for navigation
  ///
  /// Shows error message if the initialization fails.
  Future<void> startAIChatbotWithoutSecurity(
      String apiKey,
      String uuid,
      String userName,
      String? imageUrl,
      bool isGuest,
      BuildContext context) async {
    final response = await LMChatCore.instance.showChatWithApiKey(
      apiKey: apiKey,
      uuid: uuid,
      userName: userName,
      imageUrl: imageUrl,
      isGuest: isGuest,
    );

    if (response.success) {
      final chatroomId =
          LMChatLocalPreference.instance.getChatroomIdWithAIChatbot();
      if (chatroomId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LMChatroomScreen(chatroomId: chatroomId)),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const LMChatAIBotInitiationScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.errorMessage ?? 'An error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final inStyle = style ?? LMChatAIButtonStyle.basic();

    return LMChatButton(
      onTap: () async {
        onTap?.call();

        if (props != null) {
          if (props!.accessToken != null && props!.refreshToken != null) {
            // Start with API Key Security
            await startAIChatbotWithSecurity(
              props!.accessToken!,
              props!.refreshToken!,
              context,
            );
          } else if (props!.apiKey != null &&
              props!.uuid != null &&
              props!.userName != null) {
            // Start without API Key Security
            await startAIChatbotWithoutSecurity(
              props!.apiKey!,
              props!.uuid!,
              props!.userName!,
              props!.imageUrl,
              props!.isGuest ?? false,
              context,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    LMChatText('Invalid or insufficient credentials provided'),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: LMChatText('No credentials provided'),
            ),
          );
        }
      },
      onLongPress: onLongPress,
      text: text ??
          LMChatText(
            inStyle.text ?? 'AI Bot',
            style: LMChatTextStyle(
              textStyle: TextStyle(
                color: inStyle.textColor,
                fontSize: inStyle.textSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      icon: icon ??
          LMChatIcon(
            type:
                inStyle.icon == null ? LMChatIconType.svg : LMChatIconType.icon,
            icon: inStyle.icon,
            assetPath: kChatbotIcon,
            style: LMChatIconStyle(
              color: inStyle.textColor,
            ),
          ),
      style: LMChatButtonStyle(
        backgroundColor: inStyle.backgroundColor,
        borderRadius: inStyle.borderRadius,
        spacing: 6,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        placement: inStyle.iconPlacement,
      ),
    );
  }
}
