// import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/views/poll/configurations/create_poll_builder.dart';
import 'package:likeminds_chat_flutter_core/src/views/poll/configurations/poll_result_builder.dart';
import 'package:likeminds_chat_flutter_core/src/views/poll/configurations/setting.dart';
import 'package:likeminds_chat_flutter_core/src/views/poll/configurations/style.dart';


// export all the configurations
export 'package:likeminds_chat_flutter_core/src/views/poll/configurations/create_poll_builder.dart';
export 'package:likeminds_chat_flutter_core/src/views/poll/configurations/poll_result_builder.dart';
export 'package:likeminds_chat_flutter_core/src/views/poll/configurations/setting.dart';
export 'package:likeminds_chat_flutter_core/src/views/poll/configurations/style.dart';

/// {@template lm_chat_poll_config}
/// [LMChatPollConfig] is a class which is used to configure the chatroom
/// screen. It is used to customize the create poll screen.
/// {@endtemplate}
class LMChatPollConfig {
  /// {@macro lm_chat_poll_builder}
  final LMChatPollResultBuilderDelegate pollResultBuilder;

  /// {@macro lm_chat_create_poll_builder}
  final LMChatCreatePollBuilderDelegate createPollBuilder;

  /// {@macro lm_chat_create_poll_setting}
  final LMChatPollSetting setting;

  /// {@macro lm_chat_create_poll_style}
  final LMChatCreatePollStyle style;

  /// {@macro lm_chat_create_poll_config}
  const LMChatPollConfig({
    this.pollResultBuilder = const LMChatPollResultBuilderDelegate(),
    this.createPollBuilder = const LMChatCreatePollBuilderDelegate(),
    this.setting = const LMChatPollSetting(),
    this.style = const LMChatCreatePollStyle(),
  });
}
