part of "../participants_bloc.dart";

// get participants event handler for [LMChatParticipantsBloc]
// It fetches the participants of a chat room.
void _getParticipantsEventHandler(LMChatGetParticipantsEvent event,
    Emitter<LMChatParticipantsState> emit) async {
  if (event.search != null) {
    emit(const LMChatParticipantsSearchingState()); // Emit searching state
  } else {
    emit(const LMChatParticipantsLoadingState());
  }
  try {
    // create get participants request
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
    // check if response is successful
    // if successful, emit [LMChatParticipantsLoadedState] with participants
    // if unsuccessful, emit [LMChatParticipantsErrorState] with error message
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
          errorMessage:
              response.errorMessage ?? "Error in fetching participants",
        ),
      );
    }
  } catch (e) {
    emit(
      LMChatParticipantsErrorState(
        errorMessage: e.toString(),
      ),
    );
  }
}
