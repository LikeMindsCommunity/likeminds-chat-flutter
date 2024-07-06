import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/moderation/report_tag_convertor.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:meta/meta.dart';

part 'moderation_event.dart';
part 'moderation_state.dart';
part 'handler/fetch_report_tag_event_handler.dart';
part 'handler/post_report_event_handler.dart';

/// {@template lm_chat_moderation_bloc}
/// A [Bloc] which manages moderation of chat
/// {@endtemplate}
class LMChatModerationBloc
    extends Bloc<LMChatModerationEvent, LMChatModerationState> {
  /// {@macro lm_chat_moderation_bloc}
  LMChatModerationBloc() : super(LMChatModerationInitialState()) {
    on<LMChatModerationFetchTagsEvent>(_fetchTagsEventHandler);
    on<LMChatModerationPostReportEvent>(_postReportEventHandler);
  }
}
