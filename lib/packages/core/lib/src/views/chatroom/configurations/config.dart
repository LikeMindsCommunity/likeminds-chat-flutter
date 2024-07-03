import 'package:likeminds_chat_flutter_core/src/views/chatroom/configurations/builder.dart';
import 'package:likeminds_chat_flutter_core/src/views/chatroom/configurations/setting.dart';
import 'package:likeminds_chat_flutter_core/src/views/chatroom/configurations/style.dart';

// export all the configurations
export 'package:likeminds_chat_flutter_core/src/views/chatroom/configurations/builder.dart';
export 'package:likeminds_chat_flutter_core/src/views/chatroom/configurations/setting.dart';
export 'package:likeminds_chat_flutter_core/src/views/chatroom/configurations/style.dart';


/// {@template lm_chatroom_config}
/// [LMChatRoomConfig] is a class which is used to configure the chatroom
/// screen. It is used to customize the chatroom screen.
/// {@endtemplate}
class LMChatRoomConfig {
  /// {@macro lm_chatroom_config}
  final LMChatRoomBuilderDelegate builder;

  /// {@macro lm_chatroom_config}
  final LMChatRoomSetting setting;

  /// {@macro lm_chatroom_config}
  final LMChatRoomStyle style;

  /// {@macro lm_chatroom_config}
  const LMChatRoomConfig({
    this.builder = const LMChatRoomBuilderDelegate(),
    this.setting = const LMChatRoomSetting(),
    this.style = const LMChatRoomStyle(),
  });
}
