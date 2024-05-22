// part of 'chatroom.dart';

// late LMChatConversationBloc _conversationBloc;
// late LMChatConversationActionBloc _convActionBloc;
// late LMChatroomBloc _chatroomBloc;
// late ChatroomActionBloc _chatroomActionBloc;

// late ChatRoom chatroom;
// User? user;
// List<ChatroomAction> actions = [];

// int currentTime = DateTime.now().millisecondsSinceEpoch;
// Map<String, List<LMChatMedia>> conversationAttachmentsMeta =
//     <String, List<LMChatMedia>>{};
// Map<String, Conversation> conversationMeta = <String, Conversation>{};
// Map<String, List<LMChatMedia>> mediaFiles = <String, List<LMChatMedia>>{};
// Map<int, User?> userMeta = <int, User?>{};

// bool showScrollButton = false;
// int lastConversationId = 0;
// int _page = 1;
// List<Conversation> selectedConversations = <Conversation>[];
// ValueNotifier rebuildConversationList = ValueNotifier(false);
// ValueNotifier rebuildChatBar = ValueNotifier(false);
// ValueNotifier showConversationActions = ValueNotifier(false);
// ValueNotifier<bool> rebuildChatTopic = ValueNotifier(true);
// bool showChatTopic = true;
// Conversation? localTopic;

// ScrollController scrollController = ScrollController();

// PagingController<int, Conversation> pagedListController =
//     PagingController<int, Conversation>(firstPageKey: 1);

// void conversationStateListener(BuildContext context, ConversationState state) {
//   updatePagingControllers(state);
//   if (state is ConversationPosted) {
//     Map<String, String> userTags = LMChatTaggingHelper.decodeString(
//         state.postConversationResponse.conversation?.answer ?? "");
//     LMAnalytics.get().track(
//       AnalyticsKeys.chatroomResponded,
//       {
//         "chatroom_type": chatroom.type,
//         "community_id": chatroom.communityId,
//         "chatroom_name": chatroom.header,
//         "chatroom_last_conversation_type": state.postConversationResponse
//                 .conversation?.attachments?.first.type ??
//             "text",
//         "tagged_users": userTags.isNotEmpty,
//         "count_tagged_users": userTags.length,
//         "name_tagged_users":
//             userTags.keys.map((e) => e.replaceFirst("@", "")).toList(),
//         "is_group_tag": false,
//       },
//     );
//   }
//   if (state is ConversationError) {
//     LMAnalytics.get().track(
//       AnalyticsKeys.messageSendingError,
//       {
//         "chatroom_id": chatroom.id,
//         "chatroom_type": chatroom.type,
//         "clicked_resend": false,
//       },
//     );
//   }
//   if (state is MultiMediaConversationError) {
//     LMAnalytics.get().track(
//       AnalyticsKeys.attachmentUploadedError,
//       {
//         "chatroom_id": chatroom.id,
//         "chatroom_type": chatroom.type,
//         "clicked_retry": false
//       },
//     );
//   }
//   if (state is MultiMediaConversationPosted) {
//     LMAnalytics.get().track(
//       AnalyticsKeys.attachmentUploaded,
//       {
//         "chatroom_id": chatroom.id,
//         "chatroom_type": chatroom.type,
//         "message_id": state.postConversationResponse.conversation?.id,
//         "type": mapMediaTypeToString(state.putMediaResponse.first.mediaType),
//       },
//     );
//   }
// }

// void updatePagingControllers(ConversationState state) {
//   if (state is ConversationLoaded) {
//     _page++;
//     if (state.getConversationResponse.conversationMeta != null &&
//         state.getConversationResponse.conversationMeta!.isNotEmpty) {
//       conversationMeta.addAll(state.getConversationResponse.conversationMeta!);
//     }

//     if (state.getConversationResponse.conversationAttachmentsMeta != null &&
//         state.getConversationResponse.conversationAttachmentsMeta!.isNotEmpty) {
//       Map<String, List<LMChatMedia>> getConversationAttachmentData = state
//           .getConversationResponse.conversationAttachmentsMeta!
//           .map((key, value) {
//         return MapEntry(
//           key,
//           (value as List<dynamic>?)
//                   ?.map((e) => LMChatMedia.fromJson(e))
//                   .toList() ??
//               [],
//         );
//       });
//       conversationAttachmentsMeta.addAll(getConversationAttachmentData);
//     }

//     if (state.getConversationResponse.userMeta != null) {
//       userMeta.addAll(state.getConversationResponse.userMeta!);
//     }
//     List<Conversation>? conversationData =
//         state.getConversationResponse.conversationData;
//     // filterOutStateMessage(conversationData!);
//     conversationData =
//         addTimeStampInConversationList(conversationData, chatroom.communityId!);
//     if (state.getConversationResponse.conversationData == null ||
//         state.getConversationResponse.conversationData!.isEmpty ||
//         state.getConversationResponse.conversationData!.length < 500) {
//       pagedListController.appendLastPage(conversationData ?? []);
//     } else {
//       pagedListController.appendPage(conversationData ?? [], _page);
//     }
//   }
//   if (state is ConversationPosted) {
//     addConversationToPagedList(
//       state.postConversationResponse.conversation!,
//     );
//   } else if (state is LocalConversation) {
//     addLocalConversationToPagedList(state.conversation);
//   } else if (state is ConversationError) {
//     toast(state.message);
//   }
//   if (state is ConversationUpdated) {
//     if (state.response.id != lastConversationId) {
//       addConversationToPagedList(
//         state.response,
//       );
//       lastConversationId = state.response.id;
//     }
//   }
// }

// // This function adds local conversation to the paging controller
// // and rebuilds the list to reflect UI changes
// void addLocalConversationToPagedList(Conversation conversation) {
//   List<Conversation> conversationList =
//       pagedListController.itemList ?? <Conversation>[];

//   if (pagedListController.itemList != null &&
//       conversation.replyId != null &&
//       !conversationMeta.containsKey(conversation.replyId.toString())) {
//     Conversation? replyConversation = pagedListController.itemList!.firstWhere(
//         (element) =>
//             element.id ==
//             (conversation.replyId ?? conversation.replyConversation));
//     conversationMeta[conversation.replyId.toString()] = replyConversation;
//   }
//   conversationList.insert(0, conversation);
//   if (conversationList.length >= 500) {
//     conversationList.removeLast();
//   }
//   if (!userMeta.containsKey(user!.id)) {
//     userMeta[user!.id] = user;
//   }

//   pagedListController.itemList = conversationList;
//   rebuildConversationList.value = !rebuildConversationList.value;
//   // pagedListController.refresh();
// }

// void addConversationToPagedList(Conversation conversation) {
//   List<Conversation> conversationList =
//       pagedListController.itemList ?? <Conversation>[];

//   int index = conversationList
//       .indexWhere((element) => element.temporaryId == conversation.temporaryId);
//   if (pagedListController.itemList != null &&
//       conversation.replyId != null &&
//       !conversationMeta.containsKey(conversation.replyId.toString())) {
//     Conversation? replyConversation = pagedListController.itemList!.firstWhere(
//         (element) =>
//             element.id ==
//             (conversation.replyId ?? conversation.replyConversation));
//     conversationMeta[conversation.replyId.toString()] = replyConversation;
//   }
//   if (index != -1) {
//     conversationList[index] = conversation;
//   } else if (conversationList.isNotEmpty) {
//     if (conversationList.first.date != conversation.date) {
//       conversationList.insert(
//         0,
//         Conversation(
//           isTimeStamp: true,
//           id: 1,
//           hasFiles: false,
//           attachmentCount: 0,
//           attachmentsUploaded: false,
//           createdEpoch: conversation.createdEpoch,
//           chatroomId: chatroom.id,
//           date: conversation.date,
//           memberId: conversation.memberId,
//           userId: conversation.userId,
//           temporaryId: conversation.temporaryId,
//           answer: conversation.date ?? '',
//           communityId: chatroom.communityId!,
//           createdAt: conversation.createdAt,
//           header: conversation.header,
//         ),
//       );
//     }
//     conversationList.insert(0, conversation);
//     if (conversationList.length >= 500) {
//       conversationList.removeLast();
//     }
//     if (!userMeta.containsKey(user!.id)) {
//       userMeta[user!.id] = user;
//     }
//   }
//   pagedListController.itemList = conversationList;
//   rebuildConversationList.value = !rebuildConversationList.value;
// }

// _addPaginationListener(int chatroomId) {
//   pagedListController.addPageRequestListener(
//     (pageKey) {
//       _conversationBloc.add(
//         LoadConversations(
//           getConversationRequest: (GetConversationRequestBuilder()
//                 ..chatroomId(chatroomId)
//                 ..page(pageKey)
//                 ..pageSize(500)
//                 ..isLocalDB(false)
//                 ..minTimestamp(0)
//                 ..maxTimestamp(currentTime))
//               .build(),
//         ),
//       );
//     },
//   );
// }

// void _handleChatTopic() {
//   if (scrollController.position.userScrollDirection ==
//       ScrollDirection.forward) {
//     if (!showChatTopic) {
//       rebuildChatTopic.value = !rebuildChatTopic.value;
//       showChatTopic = true;
//     }
//   } else {
//     if (showChatTopic) {
//       rebuildChatTopic.value = !rebuildChatTopic.value;
//       showChatTopic = false;
//     }
//   }
// }

// void _scrollToBottom() {
//   scrollController
//       .animateTo(
//     scrollController.position.minScrollExtent,
//     duration: const Duration(milliseconds: 500),
//     curve: Curves.easeInOut,
//   )
//       .then(
//     (value) {
//       rebuildChatTopic.value = !rebuildChatTopic.value;
//       showChatTopic = true;
//     },
//   );
// }

// void _showScrollToBottomButton() {
//   if (scrollController.position.pixels >
//       scrollController.position.viewportDimension) {
//     _showButton();
//   }
//   if (scrollController.position.pixels <
//       scrollController.position.viewportDimension) {
//     _hideButton();
//   }
// }

// void _showButton() {}

// void _hideButton() {}

// isTimeStamp(Conversation item) =>
//     item.isTimeStamp != null && item.isTimeStamp! ||
//     item.state != 0 && item.state != null;
