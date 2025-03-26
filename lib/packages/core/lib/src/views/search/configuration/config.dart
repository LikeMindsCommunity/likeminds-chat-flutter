import 'package:likeminds_chat_flutter_core/src/views/search/configuration/builder.dart';
import 'package:likeminds_chat_flutter_core/src/views/search/configuration/setting.dart';
import 'package:likeminds_chat_flutter_core/src/views/search/configuration/style.dart';

// export all the configurations
export 'package:likeminds_chat_flutter_core/src/views/search/configuration/builder.dart';
export 'package:likeminds_chat_flutter_core/src/views/search/configuration/setting.dart';
export 'package:likeminds_chat_flutter_core/src/views/search/configuration/style.dart';

/// {@template lm_search_config}
/// [LMSearchConversationConfig] is a class used to configure the search screen.
/// It provides options to customize the behavior, appearance, and structure
/// of the search screen.
/// {@endtemplate}
class LMSearchConversationConfig {
  /// {@macro lm_search_config}
  final LMSearchBuilderDelegate builder;

  /// {@macro lm_search_config}
  final LMSearchSetting setting;

  /// {@macro lm_search_config}
  final LMSearchStyle style;

  /// {@macro lm_search_config}
  const LMSearchConversationConfig({
    this.builder = const LMSearchBuilderDelegate(),
    this.setting = const LMSearchSetting(),
    this.style = const LMSearchStyle(),
  });
}
