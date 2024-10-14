import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/views/chatroom/configurations/builder.dart';
import 'package:likeminds_chat_flutter_core/src/views/chatroom/configurations/setting.dart';
import 'package:likeminds_chat_flutter_core/src/views/chatroom/configurations/style.dart';
import 'package:likeminds_chat_flutter_core/src/views/poll/configurations/builder.dart';
import 'package:likeminds_chat_flutter_core/src/views/poll/configurations/setting.dart';

// export all the configurations
export 'package:likeminds_chat_flutter_core/src/views/chatroom/configurations/builder.dart';
export 'package:likeminds_chat_flutter_core/src/views/chatroom/configurations/setting.dart';
export 'package:likeminds_chat_flutter_core/src/views/chatroom/configurations/style.dart';

/// {@template lm_chat_poll_config}
/// [LMChatPollConfig] is a class which is used to configure the chatroom
/// screen. It is used to customize the create poll screen.
/// {@endtemplate}
class LMChatPollConfig {
  /// {@macro lm_chat_poll_builder}
  final LMChatPollBuilderDelegate builder;

  /// {@macro lm_chat_create_poll_setting}
  final LMChatPollSetting setting;

  /// {@macro lm_chat_create_poll_style}
  final LMChatPollStyle style;

  /// {@macro lm_chat_create_poll_config}
  const LMChatPollConfig({
    this.builder = const LMChatPollBuilderDelegate(),
    this.setting = const LMChatPollSetting(),
    this.style = const LMChatPollStyle(),
  });
}
