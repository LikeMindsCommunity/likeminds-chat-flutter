library likeminds_chat_flutter_core;

export 'src/views/views.dart';
export 'src/blocs/blocs.dart';
export 'src/core/core.dart';
export 'src/core/configurations/chat_config.dart';
export 'src/core/configurations/chat_builder.dart';
export 'src/core/configurations/widget_source.dart';
export 'src/utils/utils.dart';
export 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart'
    hide videoExtentions, photoExtentions, mediaExtentions;

const bool isDebug = bool.fromEnvironment('DEBUG');
