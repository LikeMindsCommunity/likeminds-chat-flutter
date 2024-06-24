part of "../participants_bloc.dart";

// get participants event handler for [LMChatParticipantsBloc]
// It fetches the participants of a chat room.
void _getParticipantsEventHandler(LMChatGetParticipantsEvent event,
    Emitter<LMChatParticipantsState> emit) async {
  emit(const LMChatParticipantsLoadingState());
  try {
    final GetParticipantsRequest getParticipantsRequest =
        (GetParticipantsRequestBuilder()
              ..chatroomId(event.chatroomId)
              ..page(event.page)
              ..pageSize(event.pageSize)
              ..search(event.search)
              ..isSecret(event.isSecret))
            .build();
    final LMResponse<GetParticipantsResponse> response =
        await LMChatCore.client.getParticipants(
      getParticipantsRequest,
    );
    if (response.success) {
      GetParticipantsResponse getParticipantsResponse = response.data!;
      List<LMChatUserViewData> participants =
          getParticipantsResponse.participants
                  ?.map(
                    (participant) => participant.toUserViewData(),
                  )
                  .toList() ??
              [];

      emit(
        LMChatParticipantsLoadedState(
          participants: participants,
          page: event.page,
        ),
      );
    } else {
      emit(
        LMChatParticipantsErrorState(
         errorMessage:  response.errorMessage ?? "Error in fetching participants",
        ),
      );
    }
  } catch (e) {
    emit(
      LMChatParticipantsErrorState(
       errorMessage:  e.toString(),
      ),
    );
  }
}
