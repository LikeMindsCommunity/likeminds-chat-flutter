// part of 'chatroom.dart';


//  void updatePagingControllers(ConversationState state, Map<String, List<LMChatMedia>> conversationAttachmentsMeta,
//   Map<String, Conversation> conversationMeta) {
//     if (state is ConversationLoaded) {
//       _page++;

//       if (state.getConversationResponse.conversationMeta != null &&
//           state.getConversationResponse.conversationMeta!.isNotEmpty) {
//         conversationMeta
//             .addAll(state.getConversationResponse.conversationMeta!);
//       }

//       if (state.getConversationResponse.conversationAttachmentsMeta != null &&
//           state.getConversationResponse.conversationAttachmentsMeta!
//               .isNotEmpty) {
//         Map<String, List<LMChatMedia>> getConversationAttachmentData = state
//             .getConversationResponse.conversationAttachmentsMeta!
//             .map((key, value) {
//           return MapEntry(
//             key,
//             (value as List<dynamic>?)
//                     ?.map((e) => LMChatMedia.fromJson(e))
//                     .toList() ??
//                 [],
//           );
//         });
//         conversationAttachmentsMeta.addAll(getConversationAttachmentData);
//       }

//       if (state.getConversationResponse.userMeta != null) {
//         userMeta.addAll(state.getConversationResponse.userMeta!);
//       }
//       List<Conversation>? conversationData =
//           state.getConversationResponse.conversationData;
//       // filterOutStateMessage(conversationData!);
//       conversationData = addTimeStampInConversationList(
//           conversationData, chatroom.communityId!);
//       if (state.getConversationResponse.conversationData == null ||
//           state.getConversationResponse.conversationData!.isEmpty ||
//           state.getConversationResponse.conversationData!.length < 500) {
//         pagedListController.appendLastPage(conversationData ?? []);
//       } else {
//         pagedListController.appendPage(conversationData ?? [], _page);
//       }
//     }
//     if (state is ConversationPosted) {
//       addConversationToPagedList(
//         state.postConversationResponse.conversation!,
//       );
//     } else if (state is LocalConversation) {
//       addLocalConversationToPagedList(state.conversation);
//     } else if (state is MultiMediaConversationLoading) {
//       if (!userMeta.containsKey(user!.id)) {
//         userMeta[user!.id] = user;
//       }
//       mediaFiles[state.postConversation.temporaryId!] = state.mediaFiles;

//       List<Conversation> conversationList =
//           pagedListController.itemList ?? <Conversation>[];

//       conversationList.insert(0, state.postConversation);

//       rebuildConversationList.value = !rebuildConversationList.value;
//     } else if (state is MultiMediaConversationPosted) {
//       addMultiMediaConversation(
//         state,
//       );
//     } else if (state is ConversationError) {
//       toast(state.message);
//     }
//     if (state is ConversationUpdated) {
//       if (state.response.id != lastConversationId) {
//         addConversationToPagedList(
//           state.response,
//         );
//         lastConversationId = state.response.id;
//       }
//     }
//   }

//   // This function adds local conversation to the paging controller
//   // and rebuilds the list to reflect UI changes
//   void addLocalConversationToPagedList(Conversation conversation) {
//     List<Conversation> conversationList =
//         pagedListController.itemList ?? <Conversation>[];

//     if (pagedListController.itemList != null &&
//         conversation.replyId != null &&
//         !conversationMeta.containsKey(conversation.replyId.toString())) {
//       Conversation? replyConversation = pagedListController.itemList!
//           .firstWhere((element) =>
//               element.id ==
//               (conversation.replyId ?? conversation.replyConversation));
//       conversationMeta[conversation.replyId.toString()] = replyConversation;
//     }
//     conversationList.insert(0, conversation);
//     if (conversationList.length >= 500) {
//       conversationList.removeLast();
//     }
//     if (!userMeta.containsKey(user!.id)) {
//       userMeta[user!.id] = user;
//     }

//     pagedListController.itemList = conversationList;
//     rebuildConversationList.value = !rebuildConversationList.value;
//   }

//   void updateEditedConversation(Conversation editedConversation) {
//     List<Conversation> conversationList =
//         pagedListController.itemList ?? <Conversation>[];
//     int index = conversationList
//         .indexWhere((element) => element.id == editedConversation.id);
//     if (index != -1) {
//       conversationList[index] = editedConversation;
//     }

//     if (conversationMeta.isNotEmpty &&
//         conversationMeta.containsKey(editedConversation.id.toString())) {
//       conversationMeta[editedConversation.id.toString()] = editedConversation;
//     }
//     pagedListController.itemList = conversationList;
//     rebuildConversationList.value = !rebuildConversationList.value;
//   }

//   void addConversationToPagedList(Conversation conversation) {
//     List<Conversation> conversationList =
//         pagedListController.itemList ?? <Conversation>[];

//     int index = conversationList.indexWhere(
//         (element) => element.temporaryId == conversation.temporaryId);
//     if (pagedListController.itemList != null &&
//         conversation.replyId != null &&
//         !conversationMeta.containsKey(conversation.replyId.toString())) {
//       Conversation? replyConversation = pagedListController.itemList!
//           .firstWhere((element) =>
//               element.id ==
//               (conversation.replyId ?? conversation.replyConversation));
//       conversationMeta[conversation.replyId.toString()] = replyConversation;
//     }
//     if (index != -1) {
//       conversationList[index] = conversation;
//     } else if (conversationList.isNotEmpty) {
//       if (conversationList.first.date != conversation.date) {
//         conversationList.insert(
//           0,
//           Conversation(
//             isTimeStamp: true,
//             id: 1,
//             hasFiles: false,
//             attachmentCount: 0,
//             attachmentsUploaded: false,
//             createdEpoch: conversation.createdEpoch,
//             chatroomId: chatroom.id,
//             date: conversation.date,
//             memberId: conversation.memberId,
//             userId: conversation.userId,
//             temporaryId: conversation.temporaryId,
//             answer: conversation.date ?? '',
//             communityId: chatroom.communityId!,
//             createdAt: conversation.createdAt,
//             header: conversation.header,
//           ),
//         );
//       }
//       conversationList.insert(0, conversation);
//       if (conversationList.length >= 500) {
//         conversationList.removeLast();
//       }
//       if (!userMeta.containsKey(user!.id)) {
//         userMeta[user!.id] = user;
//       }
//     }
//     pagedListController.itemList = conversationList;
//     rebuildConversationList.value = !rebuildConversationList.value;
//   }

//   void addMultiMediaConversation(MultiMediaConversationPosted state) {
//     if (!userMeta.containsKey(user!.id)) {
//       userMeta[user!.id] = user;
//     }
//     if (!conversationAttachmentsMeta
//         .containsKey(state.postConversationResponse.conversation!.id)) {
//       List<LMChatMedia> putMediaAttachment = state.putMediaResponse;
//       conversationAttachmentsMeta[
//               '${state.postConversationResponse.conversation!.id}'] =
//           putMediaAttachment;
//     }
//     List<Conversation> conversationList =
//         pagedListController.itemList ?? <Conversation>[];

//     conversationList.removeWhere((element) =>
//         element.temporaryId ==
//         state.postConversationResponse.conversation!.temporaryId);

//     mediaFiles.remove(state.postConversationResponse.conversation!.temporaryId);

//     conversationList.insert(
//       0,
//       Conversation(
//         id: state.postConversationResponse.conversation!.id,
//         hasFiles: true,
//         attachmentCount: state.putMediaResponse.length,
//         attachmentsUploaded: true,
//         chatroomId: chatroom.id,
//         state: state.postConversationResponse.conversation!.state,
//         date: state.postConversationResponse.conversation!.date,
//         memberId: state.postConversationResponse.conversation!.memberId,
//         userId: state.postConversationResponse.conversation!.userId,
//         temporaryId: state.postConversationResponse.conversation!.temporaryId,
//         answer: state.postConversationResponse.conversation!.answer,
//         communityId: chatroom.communityId!,
//         createdAt: state.postConversationResponse.conversation!.createdAt,
//         header: state.postConversationResponse.conversation!.header,
//         ogTags: state.postConversationResponse.conversation!.ogTags,
//       ),
//     );

//     if (conversationList.length >= 500) {
//       conversationList.removeLast();
//     }
//     rebuildConversationList.value = !rebuildConversationList.value;
//   }

//   void updateDeletedConversation(DeleteConversationResponse response) {
//     List<Conversation> conversationList =
//         pagedListController.itemList ?? <Conversation>[];
//     int index = conversationList.indexWhere(
//         (element) => element.id == response.conversations!.first.id);
//     if (index != -1) {
//       conversationList[index].deletedByUserId = user!.id;
//     }
//     if (conversationMeta.isNotEmpty &&
//         conversationMeta
//             .containsKey(response.conversations!.first.id.toString())) {
//       conversationMeta[response.conversations!.first.id.toString()]!
//           .deletedByUserId = user!.id;
//     }
//     pagedListController.itemList = conversationList;
//     scrollController.animateTo(
//       scrollController.position.pixels + 10,
//       duration: const Duration(milliseconds: 500),
//       curve: Curves.easeOut,
//     );
//     rebuildConversationList.value = !rebuildConversationList.value;
//   }
