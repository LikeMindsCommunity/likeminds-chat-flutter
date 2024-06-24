part of 'participants_bloc.dart';

/// [LMChatParticipantsEvent] is the base class for all the events related to participants of a chat room.
abstract class LMChatParticipantsEvent extends Equatable {
  /// [LMChatParticipantsEvent] constructor to create an instance of [LMChatParticipantsEvent].
  const LMChatParticipantsEvent();

  @override
  List<Object> get props => [];
}

/// [LMChatGetParticipantsEvent] is used to get the participants of a chat room.
class LMChatGetParticipantsEvent extends LMChatParticipantsEvent {
  /// [chatroomId] is the id of the chat room for which the participants are to be fetched.
  final int chatroomId;

  /// [page] is the page number of the participants to be fetched.
  final int page;

  /// [pageSize] is the number of participants to be fetched in a single page.
  final int pageSize;

  /// [search] is the search query to search the participants.
  final String? search;

  /// [isSecret] is a flag to indicate if the chat room is secret or not.
  final bool isSecret;

  /// [LMChatGetParticipantsEvent] constructor to create an instance of [LMChatGetParticipantsEvent].
  const LMChatGetParticipantsEvent({
    required this.chatroomId,
    required this.page,
    required this.pageSize,
    this.search,
    required this.isSecret,
  });
  @override
  List<Object> get props =>
      [chatroomId, page, pageSize, search ?? '', isSecret];
}
