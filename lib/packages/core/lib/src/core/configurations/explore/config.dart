import 'package:likeminds_chat_flutter_core/src/core/configurations/explore/builder.dart';
import 'package:likeminds_chat_flutter_core/src/core/configurations/explore/setting.dart';
import 'package:likeminds_chat_flutter_core/src/core/configurations/explore/style.dart';

// export all the configurations
export 'package:likeminds_chat_flutter_core/src/core/configurations/explore/builder.dart';
export 'package:likeminds_chat_flutter_core/src/core/configurations/explore/setting.dart';
export 'package:likeminds_chat_flutter_core/src/core/configurations/explore/style.dart';

/// {@template lm_chat_explore_config}
/// [LMChatExploreConfig] is a class which is used to configure the explore
/// screen. It is used to customize the explore screen.
/// {@endtemplate}
class LMChatExploreConfig {
  /// {@macro lm_chat_explore_config}
  final LMChatExploreBuilderDelegate builder;

  /// {@macro lm_chat_explore_config}
  final LMChatExploreSetting setting;

  /// {@macro lm_chat_explore_config}
  final LMChatExploreStyle style;

  /// {@macro lm_chat_explore_config}
  const LMChatExploreConfig({
    this.builder = const LMChatExploreBuilderDelegate(),
    this.setting = const LMChatExploreSetting(),
    this.style = const LMChatExploreStyle(),
  });
}
