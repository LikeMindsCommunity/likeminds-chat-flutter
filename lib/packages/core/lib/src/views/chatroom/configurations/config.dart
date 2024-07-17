import 'package:likeminds_chat_flutter_core/src/views/chatroom/configurations/builder.dart';
import 'package:likeminds_chat_flutter_core/src/views/chatroom/configurations/setting.dart';
import 'package:likeminds_chat_flutter_core/src/views/chatroom/configurations/style.dart';

// export all the configurations
export 'package:likeminds_chat_flutter_core/src/views/chatroom/configurations/builder.dart';
export 'package:likeminds_chat_flutter_core/src/views/chatroom/configurations/setting.dart';
export 'package:likeminds_chat_flutter_core/src/views/chatroom/configurations/style.dart';


/// {@template lm_chatroom_config}
/// [LMChatroomConfig] is a class which is used to configure the chatroom
/// screen. It is used to customize the chatroom screen.
/// {@endtemplate}
class LMChatroomConfig {
  /// {@macro lm_chatroom_config}
  final LMChatroomBuilderDelegate builder;

  /// {@macro lm_chatroom_config}
  final LMChatroomSetting setting;

  /// {@macro lm_chatroom_config}
  final LMChatroomStyle style;

  /// {@macro lm_chatroom_config}
  const LMChatroomConfig({
    this.builder = const LMChatroomBuilderDelegate(),
    this.setting = const LMChatroomSetting(),
    this.style = const LMChatroomStyle(),
  });
}
