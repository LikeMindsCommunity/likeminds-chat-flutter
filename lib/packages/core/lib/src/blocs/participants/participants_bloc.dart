import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';

part 'participants_event.dart';
part 'participants_state.dart';

class LMChatParticipantsBloc
    extends Bloc<LMChatParticipantsEvent, LMChatParticipantsState> {
  static LMChatParticipantsBloc? _instance;
  static LMChatParticipantsBloc get instance =>
      _instance ??= LMChatParticipantsBloc._();
  LMChatParticipantsBloc._() : super(const LMChatParticipantsInitial()) {
    on<LMChatGetParticipantsEvent>((event, emit) async {
      if (event.getParticipantsRequest.page == 1) {
        emit(
          const LMChatParticipantsLoading(),
        );
      } else {
        emit(
          const LMChatParticipantsPaginationLoading(),
        );
      }
      try {
        final LMResponse<GetParticipantsResponse> response =
            await LMChatCore.client.getParticipants(
          event.getParticipantsRequest,
        );
        if (response.success) {
          GetParticipantsResponse getParticipantsResponse = response.data!;
          if (getParticipantsResponse.success) {
            emit(
              LMChatParticipantsLoaded(
                getParticipantsResponse: getParticipantsResponse,
              ),
            );
          } else {
            debugPrint(getParticipantsResponse.errorMessage);
            emit(
              LMChatParticipantsError(
                getParticipantsResponse.errorMessage!,
              ),
            );
          }
        } else {
          debugPrint(response.errorMessage);
          emit(
            LMChatParticipantsError(
              response.errorMessage!,
            ),
          );
        }
      } catch (e) {
        debugPrint(e.toString());
        emit(
          const LMChatParticipantsError(
            'An error occurred',
          ),
        );
      }
    });
  }
}
