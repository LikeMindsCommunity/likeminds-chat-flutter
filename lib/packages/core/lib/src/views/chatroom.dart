import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/blocs.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/observer.dart';
import 'package:likeminds_chat_flutter_core/src/utils/analytics/analytics.dart';
import 'package:likeminds_chat_flutter_core/src/utils/chatroom/chatroom_utils.dart';
import 'package:likeminds_chat_flutter_core/src/utils/conversation/conversation_utils.dart';
import 'package:likeminds_chat_flutter_core/src/utils/helpers/tagging_helper.dart';
import 'package:likeminds_chat_flutter_core/src/utils/preferences/preferences.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/chatroom/chatroom_bar.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/chatroom/chatroom_menu.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:overlay_support/overlay_support.dart';

class LMChatroomScreen extends StatefulWidget {
  final int chatroomId;

  const LMChatroomScreen({
    super.key,
    required this.chatroomId,
  });

  @override
  State<LMChatroomScreen> createState() => _LMChatroomScreenState();
}

class _LMChatroomScreenState extends State<LMChatroomScreen> {
  late ConversationBloc _conversationBloc;
  late ConversationActionBloc _convActionBloc;
  late LMChatroomBloc _chatroomBloc;
  late ChatroomActionBloc _chatroomActionBloc;

  late ChatRoom chatroom;
  User? user;
  List<ChatroomAction> actions = [];

  int currentTime = DateTime.now().millisecondsSinceEpoch;
  Map<String, List<LMChatMedia>> conversationAttachmentsMeta =
      <String, List<LMChatMedia>>{};
  Map<String, Conversation> conversationMeta = <String, Conversation>{};
  Map<String, List<LMChatMedia>> mediaFiles = <String, List<LMChatMedia>>{};
  Map<int, User?> userMeta = <int, User?>{};

  bool showScrollButton = false;
  int lastConversationId = 0;
  List<Conversation> selectedConversations = <Conversation>[];
  ValueNotifier rebuildConversationList = ValueNotifier(false);
  ValueNotifier rebuildChatBar = ValueNotifier(false);
  ValueNotifier showConversationActions = ValueNotifier(false);
  ValueNotifier<bool> rebuildChatTopic = ValueNotifier(true);
  bool showChatTopic = true;
  Conversation? localTopic;

  ScrollController scrollController = ScrollController();
  PagingController<int, Conversation> pagedListController =
      PagingController<int, Conversation>(firstPageKey: 1);

  int _page = 1;
  ModalRoute? _route;

  @override
  void initState() {
    super.initState();
    Bloc.observer = LMChatBlocObserver();
    _conversationBloc = ConversationBloc.instance;
    _chatroomBloc = LMChatroomBloc.instance;
    _convActionBloc = ConversationActionBloc.instance;
    _chatroomActionBloc = ChatroomActionBloc.instance;
    _chatroomBloc.add(LMChatInitChatroomEvent(
        (GetChatroomRequestBuilder()..chatroomId(widget.chatroomId)).build()));
    _addPaginationListener();
    scrollController.addListener(() {
      _showScrollToBottomButton();
      _handleChatTopic();
    });
    // chatActionBloc = BlocProvider.of<ChatActionBloc>(context);
    // conversationBloc = ConversationBloc();
    user = LMChatPreferences.instance.getUser();

    debugPrint("Chatroom id is ${widget.chatroomId}");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _chatroomActionBloc.add(
      MarkReadChatroomEvent(chatroomId: widget.chatroomId),
    );
    super.dispose();
  }

  _addPaginationListener() {
    pagedListController.addPageRequestListener(
      (pageKey) {
        _conversationBloc.add(
          LoadConversations(
            getConversationRequest: (GetConversationRequestBuilder()
                  ..chatroomId(widget.chatroomId)
                  ..page(pageKey)
                  ..pageSize(500)
                  ..isLocalDB(false)
                  ..minTimestamp(0)
                  ..maxTimestamp(currentTime))
                .build(),
          ),
        );
      },
    );
  }

  void _handleChatTopic() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!showChatTopic) {
        rebuildChatTopic.value = !rebuildChatTopic.value;
        showChatTopic = true;
      }
    } else {
      if (showChatTopic) {
        rebuildChatTopic.value = !rebuildChatTopic.value;
        showChatTopic = false;
      }
    }
  }

  void _scrollToBottom() {
    scrollController
        .animateTo(
      scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    )
        .then(
      (value) {
        rebuildChatTopic.value = !rebuildChatTopic.value;
        showChatTopic = true;
      },
    );
  }

  void _showScrollToBottomButton() {
    if (scrollController.position.pixels >
        scrollController.position.viewportDimension) {
      _showButton();
    }
    if (scrollController.position.pixels <
        scrollController.position.viewportDimension) {
      _hideButton();
    }
  }

  void _showButton() {
    setState(() {
      showScrollButton = true;
    });
  }

  void _hideButton() {
    setState(() {
      showScrollButton = false;
    });
  }

  void updatePagingControllers(ConversationState state) {
    if (state is ConversationLoaded) {
      _page++;

      if (state.getConversationResponse.conversationMeta != null &&
          state.getConversationResponse.conversationMeta!.isNotEmpty) {
        conversationMeta
            .addAll(state.getConversationResponse.conversationMeta!);
      }

      if (state.getConversationResponse.conversationAttachmentsMeta != null &&
          state.getConversationResponse.conversationAttachmentsMeta!
              .isNotEmpty) {
        Map<String, List<LMChatMedia>> getConversationAttachmentData = state
            .getConversationResponse.conversationAttachmentsMeta!
            .map((key, value) {
          return MapEntry(
            key,
            (value as List<dynamic>?)
                    ?.map((e) => LMChatMedia.fromJson(e))
                    .toList() ??
                [],
          );
        });
        conversationAttachmentsMeta.addAll(getConversationAttachmentData);
      }

      if (state.getConversationResponse.userMeta != null) {
        userMeta.addAll(state.getConversationResponse.userMeta!);
      }
      List<Conversation>? conversationData =
          state.getConversationResponse.conversationData;
      // filterOutStateMessage(conversationData!);
      conversationData = addTimeStampInConversationList(
          conversationData, chatroom.communityId!);
      if (state.getConversationResponse.conversationData == null ||
          state.getConversationResponse.conversationData!.isEmpty ||
          state.getConversationResponse.conversationData!.length < 500) {
        pagedListController.appendLastPage(conversationData ?? []);
      } else {
        pagedListController.appendPage(conversationData ?? [], _page);
      }
    }
    if (state is ConversationPosted) {
      addConversationToPagedList(
        state.postConversationResponse.conversation!,
      );
    } else if (state is LocalConversation) {
      addLocalConversationToPagedList(state.conversation);
    } else if (state is MultiMediaConversationLoading) {
      if (!userMeta.containsKey(user!.id)) {
        userMeta[user!.id] = user;
      }
      mediaFiles[state.postConversation.temporaryId!] = state.mediaFiles;

      List<Conversation> conversationList =
          pagedListController.itemList ?? <Conversation>[];

      conversationList.insert(0, state.postConversation);

      rebuildConversationList.value = !rebuildConversationList.value;
    } else if (state is MultiMediaConversationPosted) {
      // addMultiMediaConversation(
      //   state,
      // );
    } else if (state is ConversationError) {
      toast(state.message);
    }
    if (state is ConversationUpdated) {
      if (state.response.id != lastConversationId) {
        addConversationToPagedList(
          state.response,
        );
        lastConversationId = state.response.id;
      }
    }
  }

  // This function adds local conversation to the paging controller
  // and rebuilds the list to reflect UI changes
  void addLocalConversationToPagedList(Conversation conversation) {
    List<Conversation> conversationList =
        pagedListController.itemList ?? <Conversation>[];

    if (pagedListController.itemList != null &&
        conversation.replyId != null &&
        !conversationMeta.containsKey(conversation.replyId.toString())) {
      Conversation? replyConversation = pagedListController.itemList!
          .firstWhere((element) =>
              element.id ==
              (conversation.replyId ?? conversation.replyConversation));
      conversationMeta[conversation.replyId.toString()] = replyConversation;
    }
    conversationList.insert(0, conversation);
    if (conversationList.length >= 500) {
      conversationList.removeLast();
    }
    if (!userMeta.containsKey(user!.id)) {
      userMeta[user!.id] = user;
    }

    pagedListController.itemList = conversationList;
    rebuildConversationList.value = !rebuildConversationList.value;
    // pagedListController.refresh();
  }

  // void updateEditedConversation(Conversation editedConversation) {
  //   List<Conversation> conversationList =
  //       pagedListController.itemList ?? <Conversation>[];
  //   int index = conversationList
  //       .indexWhere((element) => element.id == editedConversation.id);
  //   if (index != -1) {
  //     conversationList[index] = editedConversation;
  //   }

  //   if (conversationMeta.isNotEmpty &&
  //       conversationMeta.containsKey(editedConversation.id.toString())) {
  //     conversationMeta[editedConversation.id.toString()] = editedConversation;
  //   }
  //   pagedListController.itemList = conversationList;
  //   // rebuildConversationList.value = !rebuildConversationList.value;
  // }

  void addConversationToPagedList(Conversation conversation) {
    List<Conversation> conversationList =
        pagedListController.itemList ?? <Conversation>[];

    int index = conversationList.indexWhere(
        (element) => element.temporaryId == conversation.temporaryId);
    if (pagedListController.itemList != null &&
        conversation.replyId != null &&
        !conversationMeta.containsKey(conversation.replyId.toString())) {
      Conversation? replyConversation = pagedListController.itemList!
          .firstWhere((element) =>
              element.id ==
              (conversation.replyId ?? conversation.replyConversation));
      conversationMeta[conversation.replyId.toString()] = replyConversation;
    }
    if (index != -1) {
      conversationList[index] = conversation;
    } else if (conversationList.isNotEmpty) {
      if (conversationList.first.date != conversation.date) {
        conversationList.insert(
          0,
          Conversation(
            isTimeStamp: true,
            id: 1,
            hasFiles: false,
            attachmentCount: 0,
            attachmentsUploaded: false,
            createdEpoch: conversation.createdEpoch,
            chatroomId: chatroom.id,
            date: conversation.date,
            memberId: conversation.memberId,
            userId: conversation.userId,
            temporaryId: conversation.temporaryId,
            answer: conversation.date ?? '',
            communityId: chatroom.communityId!,
            createdAt: conversation.createdAt,
            header: conversation.header,
          ),
        );
      }
      conversationList.insert(0, conversation);
      if (conversationList.length >= 500) {
        conversationList.removeLast();
      }
      if (!userMeta.containsKey(user!.id)) {
        userMeta[user!.id] = user;
      }
    }
    pagedListController.itemList = conversationList;
    rebuildConversationList.value = !rebuildConversationList.value;
  }

  // void addMultiMediaConversation(MultiMediaConversationPosted state) {
  //   if (!userMeta.containsKey(user!.id)) {
  //     userMeta[user!.id] = user;
  //   }
  //   if (!conversationAttachmentsMeta
  //       .containsKey(state.postConversationResponse.conversation!.id)) {
  //     List<LMChatMedia> putMediaAttachment = state.putMediaResponse;
  //     conversationAttachmentsMeta[
  //             '${state.postConversationResponse.conversation!.id}'] =
  //         putMediaAttachment;
  //   }
  //   List<Conversation> conversationList =
  //       pagedListController.itemList ?? <Conversation>[];

  //   conversationList.removeWhere((element) =>
  //       element.temporaryId ==
  //       state.postConversationResponse.conversation!.temporaryId);

  //   mediaFiles.remove(state.postConversationResponse.conversation!.temporaryId);

  //   conversationList.insert(
  //     0,
  //     Conversation(
  //       id: state.postConversationResponse.conversation!.id,
  //       hasFiles: true,
  //       attachmentCount: state.putMediaResponse.length,
  //       attachmentsUploaded: true,
  //       chatroomId: chatroom.id,
  //       state: state.postConversationResponse.conversation!.state,
  //       date: state.postConversationResponse.conversation!.date,
  //       memberId: state.postConversationResponse.conversation!.memberId,
  //       userId: state.postConversationResponse.conversation!.userId,
  //       temporaryId: state.postConversationResponse.conversation!.temporaryId,
  //       answer: state.postConversationResponse.conversation!.answer,
  //       communityId: chatroom.communityId!,
  //       createdAt: state.postConversationResponse.conversation!.createdAt,
  //       header: state.postConversationResponse.conversation!.header,
  //       ogTags: state.postConversationResponse.conversation!.ogTags,
  //     ),
  //   );

  //   if (conversationList.length >= 500) {
  //     conversationList.removeLast();
  //   }
  //   rebuildConversationList.value = !rebuildConversationList.value;
  // }

  // void updateDeletedConversation(DeleteConversationResponse response) {
  //   List<Conversation> conversationList =
  //       pagedListController.itemList ?? <Conversation>[];
  //   int index = conversationList.indexWhere(
  //       (element) => element.id == response.conversations!.first.id);
  //   if (index != -1) {
  //     conversationList[index].deletedByUserId = user!.id;
  //   }
  //   if (conversationMeta.isNotEmpty &&
  //       conversationMeta
  //           .containsKey(response.conversations!.first.id.toString())) {
  //     conversationMeta[response.conversations!.first.id.toString()]!
  //         .deletedByUserId = user!.id;
  //   }
  //   pagedListController.itemList = conversationList;
  //   scrollController.animateTo(
  //     scrollController.position.pixels + 10,
  //     duration: const Duration(milliseconds: 500),
  //     curve: Curves.easeOut,
  //   );
  //   rebuildConversationList.value = !rebuildConversationList.value;
  // }

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: LMChatTheme.theme.backgroundColor,
          floatingActionButton:
              showScrollButton ? _defaultScrollButton() : null,
          body: SafeArea(
            bottom: false,
            child: BlocConsumer<LMChatroomBloc, LMChatroomState>(
                bloc: _chatroomBloc,
                listener: (context, state) {
                  if (state is LMChatroomLoadedState) {
                    chatroom = state.getChatroomResponse.chatroom!;
                    lastConversationId =
                        state.getChatroomResponse.lastConversationId ?? 0;
                    _chatroomActionBloc
                        .add(MarkReadChatroomEvent(chatroomId: chatroom.id));
                    _conversationBloc.add(InitConversations(
                      chatroomId: chatroom.id,
                      conversationId: lastConversationId,
                    ));
                    LMAnalytics.get().track(
                      AnalyticsKeys.syncComplete,
                      {
                        'sync_complete': true,
                      },
                    );
                    LMAnalytics.get().track(AnalyticsKeys.chatroomOpened, {
                      'chatroom_id': chatroom.id,
                      'community_id': chatroom.communityId,
                      'chatroom_type': chatroom.type,
                      'source': 'home_feed',
                    });
                  }
                },
                builder: (context, state) {
                  // return const SkeletonChatList();
                  if (state is LMChatroomLoadingState) {
                    return const LMChatSkeletonChatPage();
                  }

                  if (state is LMChatroomLoadedState) {
                    final response = state.getChatroomResponse;
                    chatroom = response.chatroom!;
                    actions = response.chatroomActions!;

                    return Column(
                      children: [
                        SizedBox(child: _defaultAppBar(chatroom)),
                        Expanded(
                          child: ValueListenableBuilder(
                            valueListenable: rebuildConversationList,
                            builder: (context, _, __) {
                              return BlocConsumer<ConversationBloc,
                                  ConversationState>(
                                bloc: _conversationBloc,
                                listener: (context, state) {
                                  updatePagingControllers(state);
                                  if (state is ConversationPosted) {
                                    Map<String, String> userTags =
                                        LMChatTaggingHelper.decodeString(state
                                                .postConversationResponse
                                                .conversation
                                                ?.answer ??
                                            "");
                                    LMAnalytics.get().track(
                                      AnalyticsKeys.chatroomResponded,
                                      {
                                        "chatroom_type": chatroom.type,
                                        "community_id": chatroom.communityId,
                                        "chatroom_name": chatroom.header,
                                        "chatroom_last_conversation_type": state
                                                .postConversationResponse
                                                .conversation
                                                ?.attachments
                                                ?.first
                                                .type ??
                                            "text",
                                        "tagged_users": userTags.isNotEmpty,
                                        "count_tagged_users": userTags.length,
                                        "name_tagged_users": userTags.keys
                                            .map((e) => e.replaceFirst("@", ""))
                                            .toList(),
                                        "is_group_tag": false,
                                      },
                                    );
                                  }
                                  if (state is ConversationError) {
                                    LMAnalytics.get().track(
                                      AnalyticsKeys.messageSendingError,
                                      {
                                        "chatroom_id": chatroom.id,
                                        "chatroom_type": chatroom.type,
                                        "clicked_resend": false,
                                      },
                                    );
                                  }
                                  if (state is MultiMediaConversationError) {
                                    LMAnalytics.get().track(
                                      AnalyticsKeys.attachmentUploadedError,
                                      {
                                        "chatroom_id": chatroom.id,
                                        "chatroom_type": chatroom.type,
                                        "clicked_retry": false
                                      },
                                    );
                                  }
                                  if (state is MultiMediaConversationPosted) {
                                    LMAnalytics.get().track(
                                      AnalyticsKeys.attachmentUploaded,
                                      {
                                        "chatroom_id": chatroom.id,
                                        "chatroom_type": chatroom.type,
                                        "message_id": state
                                            .postConversationResponse
                                            .conversation
                                            ?.id,
                                        "type": mapMediaTypeToString(state
                                            .putMediaResponse.first.mediaType),
                                      },
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  return PagedListView(
                                    pagingController: pagedListController,
                                    scrollController: scrollController,
                                    physics: const ClampingScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 16,
                                    ),
                                    reverse: true,
                                    builderDelegate:
                                        PagedChildBuilderDelegate<Conversation>(
                                      noItemsFoundIndicatorBuilder: (context) =>
                                          const SizedBox(height: 10),
                                      firstPageProgressIndicatorBuilder:
                                          (context) =>
                                              const LMChatSkeletonChatList(),
                                      newPageProgressIndicatorBuilder:
                                          (context) => Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 1.h),
                                        child: const Column(
                                          children: [
                                            LMChatSkeletonChatBubble(
                                                isSent: true),
                                            LMChatSkeletonChatBubble(
                                                isSent: false),
                                            LMChatSkeletonChatBubble(
                                                isSent: true),
                                          ],
                                        ),
                                      ),
                                      animateTransitions: true,
                                      transitionDuration:
                                          const Duration(milliseconds: 500),
                                      itemBuilder: (context, item, index) {
                                        if (item.isTimeStamp != null &&
                                                item.isTimeStamp! ||
                                            item.state != 0 &&
                                                item.state != null) {
                                          return _defaultStateBubble(
                                            LMChatTaggingHelper
                                                .extractStateMessage(
                                                    item.answer),
                                          );
                                        }

                                        final replyAttachments = item.replyId !=
                                                null
                                            ? conversationAttachmentsMeta
                                                    .containsKey(
                                                        item.replyId.toString())
                                                ? conversationAttachmentsMeta[
                                                    item.replyId.toString()]
                                                : null
                                            : null;

                                        Conversation? replyConversation =
                                            conversationMeta[
                                                item.replyId.toString()];

                                        return item.userId == user!.id
                                            ? _defaultSentChatBubble(item)
                                            : _defaultReceivedChatBubble(item);
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        // const Spacer(),
                        LMChatroomBar(
                          chatroom: chatroom,
                          scrollToBottom: _scrollToBottom,
                        ),
                      ],
                    );
                  }

                  return const SizedBox();
                }),
          ),
        ));
  }

  // Widget _defConversationList() {
  //   }

  Widget _defaultStateBubble(String message) {
    return LMChatStateBubble(message: message);
  }

  Widget _defaultSentChatBubble(Conversation conversation) {
    return LMChatBubble(
      conversation: conversation,
      currentUser: LMChatPreferences.instance.getCurrentUser,
      conversationUser: conversation.member!,
    );
  }

  Widget _defaultReceivedChatBubble(Conversation conversation) {
    return LMChatBubble(
      conversation: conversation,
      currentUser: LMChatPreferences.instance.getCurrentUser,
      conversationUser: conversation.member!,
    );
  }

  Widget _defaultAppBar(ChatRoom chatroom) {
    return LMChatAppBar(
      style: LMChatAppBarStyle(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        backgroundColor: LMChatTheme.theme.container,
      ),
      banner: LMChatProfilePicture(
        imageUrl:
            chatroom.chatroomWithUser?.imageUrl ?? chatroom.chatroomImageUrl,
        fallbackText: chatroom.header,
        style: LMChatProfilePictureStyle(
          size: 42,
          backgroundColor: LMChatTheme.theme.secondaryColor,
        ),
      ),
      title: LMChatText(
        chatroom.chatroomWithUser?.name ?? chatroom.title,
        style: LMChatTextStyle(
          textStyle: TextStyle(
            color: LMChatTheme.theme.onContainer,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      trailing: [
        _defaultChatroomMenu(),
      ],
    );
  }

  Widget _defaultChatroomMenu() {
    return LMChatroomMenu(
      chatroom: chatroom,
      chatroomActions: actions,
    );
  }

  Widget _defaultScrollButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 72.0),
      child: LMChatButton(
        onTap: () {
          _scrollToBottom();
        },
        style: LMChatButtonStyle.basic().copyWith(
          height: 42,
          width: 42,
          borderRadius: 24,
          backgroundColor: LMChatTheme.theme.container,
          icon: LMChatIcon(
            type: LMChatIconType.icon,
            icon: Icons.keyboard_arrow_down,
            style: LMChatIconStyle(
              size: 24,
              boxSize: 30,
              boxPadding: 6,
              color: LMChatTheme.theme.onContainer,
            ),
          ),
        ),
      ),
    );
  }

  // Widget? getContent(Conversation conversation) {
  //   if (conversation.attachmentsUploaded == null ||
  //       !conversation.attachmentsUploaded!) {
  //     // If conversation has media but not uploaded yet
  //     // show local files
  //     Widget? mediaWidget;

  //     if (mediaFiles[conversation.temporaryId] == null ||
  //         mediaFiles[conversation.temporaryId]!.isEmpty) {
  //       // return expandableText;
  //       if (conversation.ogTags != null) {
  //         return LMLinkPreview(
  //             onTap: () {
  //               launchUrl(
  //                 Uri.parse(conversation.ogTags?['url'] ?? ''),
  //                 mode: LaunchMode.externalApplication,
  //               );
  //             },
  //             linkModel: MediaModel(
  //                 mediaType: LMMediaType.link,
  //                 ogTags: OgTags.fromEntity(
  //                     OgTagsEntity.fromJson(conversation.ogTags))));
  //       } else {
  //         return null;
  //       }
  //     }
  //     if (mediaFiles[conversation.temporaryId]!.first.mediaType ==
  //             MediaType.photo ||
  //         mediaFiles[conversation.temporaryId]!.first.mediaType ==
  //             MediaType.video) {
  //       mediaWidget =
  //           getImageFileMessage(context, mediaFiles[conversation.temporaryId]!);
  //     } else if (mediaFiles[conversation.temporaryId]!.first.mediaType ==
  //         MediaType.document) {
  //       mediaWidget =
  //           documentPreviewFactory(mediaFiles[conversation.temporaryId]!);
  //     } else if (mediaFiles[conversation.temporaryId]!.first.mediaType ==
  //         MediaType.link) {
  //       mediaWidget = LMLinkPreview(
  //           onTap: () {
  //             launchUrl(
  //               Uri.parse(
  //                   mediaFiles[conversation.temporaryId]!.first.ogTags?.url ??
  //                       ''),
  //               mode: LaunchMode.externalApplication,
  //             );
  //           },
  //           linkModel: MediaModel(
  //               mediaType: LMMediaType.link,
  //               ogTags: mediaFiles[conversation.temporaryId]!.first.ogTags));
  //     } else {
  //       mediaWidget = null;
  //     }
  //     return Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Stack(
  //           children: [
  //             mediaWidget ?? const SizedBox.shrink(),
  //             const Positioned(
  //               top: 0,
  //               bottom: 0,
  //               left: 0,
  //               right: 0,
  //               child: LMLoader(
  //                 primary: kWhiteColor,
  //               ),
  //             )
  //           ],
  //         ),
  //         conversation.answer.isEmpty
  //             ? const SizedBox.shrink()
  //             : kVerticalPaddingXSmall,
  //       ],
  //     );
  //   } else if (conversation.attachmentsUploaded != null ||
  //       conversation.attachmentsUploaded!) {
  //     // If conversation has media and uploaded
  //     // show uploaded files
  //     final conversationAttachments =
  //         conversationAttachmentsMeta.containsKey(conversation.id.toString())
  //             ? conversationAttachmentsMeta['${conversation.id}']
  //             : null;
  //     if (conversationAttachments == null) {
  //       return null;
  //     }

  //     Widget? mediaWidget;
  //     if (conversationAttachments.first.mediaType == MediaType.photo ||
  //         conversationAttachments.first.mediaType == MediaType.video) {
  //       mediaWidget = getImageMessage(
  //         context,
  //         conversationAttachments,
  //         chatroom!,
  //         conversation,
  //         userMeta,
  //       );
  //     } else if (conversationAttachments.first.mediaType ==
  //         MediaType.document) {
  //       mediaWidget = documentPreviewFactory(conversationAttachments);
  //     } else if (conversation.ogTags != null) {
  //       mediaWidget = LMLinkPreview(
  //           onTap: () {
  //             launchUrl(
  //               Uri.parse(conversation.ogTags?['url'] ?? ''),
  //               mode: LaunchMode.externalApplication,
  //             );
  //           },
  //           linkModel: MediaModel(
  //               mediaType: LMMediaType.link,
  //               ogTags: OgTags.fromEntity(
  //                   OgTagsEntity.fromJson(conversation.ogTags))));
  //     } else {
  //       mediaWidget = null;
  //     }
  //     return Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         mediaWidget ?? const SizedBox.shrink(),
  //         conversation.answer.isEmpty
  //             ? const SizedBox.shrink()
  //             : kVerticalPaddingXSmall,
  //       ],
  //     );
  //   }
  //   return null;
  // }
}
