import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// {@template chatroom_setting}
/// [LMChatroomSetting] is a class which is used to configure the chatroom
/// screen. It is used to customize the chatroom screen.
/// {@endtemplate}
class LMChatroomSetting {
  /// The selection type for the chatroom
  final LMChatSelectionType? selectionType;

  /// {@macro chatroom_setting}
  const LMChatroomSetting({this.selectionType = LMChatSelectionType.appbar});
}
