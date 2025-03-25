part of 'search_conversation_bloc.dart';

@immutable

/// Abstract class [LMChatSearchConversationEvent] is used to define the events for the search conversation bloc.
sealed class LMChatSearchConversationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// [LMChatGetSearchConversationEvent] is an event to get the search conversation.
/// It extends [LMChatSearchConversationEvent] and uses [LMChatGetSearchConversationEvent].
class LMChatGetSearchConversationEvent extends LMChatSearchConversationEvent {
  /// [chatroomId] is the id of the chat room for which the conversation are to be fetched.
  final int chatroomId;

  /// [page] is the page number of the Conversation to be fetched.
  final int page;

  /// [pageSize] is the number of Conversation to be fetched in a single page.
  final int pageSize;

  /// [search] is the search query to search the Conversation.
  final String? search;

  ///[followStatus] is the status of the follow
  final bool followStatus;

  /// [LMChatGetSearchConversationEvent] constructor to create an instance of [LMChatGetConversationEvent].
  LMChatGetSearchConversationEvent({
    required this.chatroomId,
    required this.page,
    required this.pageSize,
    this.search,
    required this.followStatus,
  });
  @override
  List<Object> get props => [
        chatroomId,
        page,
        pageSize,
        search ?? '',
        followStatus,
      ];
}
