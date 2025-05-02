import 'package:likeminds_chat_flutter_core/src/widgets/widgets.dart';

/// {@template lm_chat_home_style}
/// [LMNetworkingChatStyle] is a class which is used to style the LMNetworkingChatScreen
///  It is used to customize the LMNetworkingChatScreen.
/// {@endtemplate}
class LMNetworkingChatStyle {
  /// {@macro lm_chat_home_style}
  const LMNetworkingChatStyle({
    this.netwrokingChatListStyle,
  });

  final LMNetworkingChatListStyle Function(LMNetworkingChatListStyle)?
      netwrokingChatListStyle;
}
