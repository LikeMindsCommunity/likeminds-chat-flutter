import 'builder.dart';
import 'setting.dart';
import 'style.dart';

// export all the configurations
export 'setting.dart';
export 'style.dart';
export 'builder.dart';

/// {@template lm_member_list_config}
/// [LMChatMemberListConfig] is a class which is used to configure the member list
/// screen. It is used to customize the member list screen configuration.
/// {@endtemplate}
class LMChatMemberListConfig {
  /// {@macro lm_widget_builder_delegate}
  final LMChatMemberListBuilderDelegate builder;

  /// {@macro lm_member_list_style}
  final LMChatMemberListStyle style;

  /// {@macro lm_member_list_setting}
  final LMChatMemberListSetting setting;

  /// {@macro lm_member_list_config}
  const LMChatMemberListConfig({
    this.builder = const LMChatMemberListBuilderDelegate(),
    this.style = const LMChatMemberListStyle(),
    this.setting = const LMChatMemberListSetting(),
  });
}
