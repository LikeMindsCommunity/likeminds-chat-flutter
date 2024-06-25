import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/blocs.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/observer.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/chatroom/chatroom_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/conversation/conversation_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/user/user_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/utils/analytics/analytics.dart';
import 'package:likeminds_chat_flutter_core/src/utils/conversation/conversation_utils.dart';
import 'package:likeminds_chat_flutter_core/src/utils/extension/list_extension.dart';
import 'package:likeminds_chat_flutter_core/src/utils/member_rights/member_rights.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/chatroom/chatroom_bar.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/chatroom/chatroom_menu.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:overlay_support/overlay_support.dart';

class LMChatroomScreen extends StatefulWidget {
  final int chatroomId;

  final LMChatroomAppBarBuilder? appbarbuilder;
  final LMChatBubbleBuilder? chatBubbleBuilder;
  final LMChatStateBubbleBuilder? stateBubbleBuilder;
  final LMChatContextWidgetBuilder? loadingPageWidget;
  final LMChatContextWidgetBuilder? loadingListWidget;
  final LMChatContextWidgetBuilder? paginatedLoadingWidget;
  final LMChatroomChatBarBuilder? chatBarBuilder;

  const LMChatroomScreen({
    super.key,
    required this.chatroomId,
    this.appbarbuilder,
    this.chatBarBuilder,
    this.chatBubbleBuilder,
    this.stateBubbleBuilder,
    this.loadingListWidget,
    this.loadingPageWidget,
    this.paginatedLoadingWidget,
  });

  @override
  State<LMChatroomScreen> createState() => _LMChatroomScreenState();
}

class _LMChatroomScreenState extends State<LMChatroomScreen> {
  late LMChatConversationBloc _conversationBloc;
  late LMChatConversationActionBloc _convActionBloc;
  late LMChatroomBloc _chatroomBloc;
  late LMChatroomActionBloc _chatroomActionBloc;

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
  final List<int> _selectedIds = <int>[];
  ValueNotifier<bool> rebuildAppBar = ValueNotifier(false);

  bool isAnyMessageSelected() {
    return _selectedIds.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    Bloc.observer = LMChatBlocObserver();
    _conversationBloc = LMChatConversationBloc.instance;
    _chatroomBloc = LMChatroomBloc.instance;
    _convActionBloc = LMChatConversationActionBloc.instance;
    _chatroomActionBloc = LMChatroomActionBloc.instance;
    _chatroomBloc.add(LMChatInitChatroomEvent(
        (GetChatroomRequestBuilder()..chatroomId(widget.chatroomId)).build()));
    _addPaginationListener();
    scrollController.addListener(() {
      _showScrollToBottomButton();
      _handleChatTopic();
    });
    // chatActionBloc = BlocProvider.of<ChatActionBloc>(context);
    // conversationBloc = ConversationBloc();
    user = LMChatLocalPreference.instance.getUser();

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

  void updatePagingControllers(LMChatConversationState state) {
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
          state.getConversationResponse.conversationData!.length > 500) {
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
  }

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

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: LMChatTheme.theme.backgroundColor,
        floatingActionButton: showScrollButton ? _defaultScrollButton() : null,
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
            builder: (chatroomContext, chatroomState) {
              if (chatroomState is LMChatroomLoadedState) {
                final response = chatroomState.getChatroomResponse;
                chatroom = response.chatroom!;
                actions = response.chatroomActions!;
                return Column(
                  children: [
                    widget.appbarbuilder?.call(
                          chatroom.toChatRoomViewData(),
                          _defaultAppBar(chatroom),
                        ) ??
                        _defaultAppBar(chatroom),
                    Expanded(
                      child: BlocConsumer<LMChatConversationBloc,
                              LMChatConversationState>(
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
                                  "message_id": state.postConversationResponse
                                      .conversation?.id,
                                  "type": mapMediaTypeToString(
                                      state.putMediaResponse.first.mediaType),
                                },
                              );
                            }
                          },
                          builder: (context, state) {
                            return ValueListenableBuilder(
                              valueListenable: rebuildConversationList,
                              builder: (context, value, child) {
                                return PagedListView(
                                  pagingController: pagedListController,
                                  scrollController: scrollController,
                                  physics: const ClampingScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  reverse: true,
                                  builderDelegate:
                                      PagedChildBuilderDelegate<Conversation>(
                                    noItemsFoundIndicatorBuilder: (context) =>
                                        const Center(
                                      child: LMChatText('No chats found!'),
                                    ),
                                    firstPageProgressIndicatorBuilder:
                                        (context) =>
                                            const LMChatSkeletonChatList(),
                                    animateTransitions: true,
                                    transitionDuration:
                                        const Duration(milliseconds: 500),
                                    itemBuilder: (context, item, index) {
                                      if (item.isTimeStamp != null &&
                                              item.isTimeStamp! ||
                                          item.state != 0 &&
                                              item.state != null) {
                                        return _defaultStateBubble(
                                          item.state == 1
                                              ? LMChatTaggingHelper
                                                  .extractFirstDMStateMessage(
                                                  item.toConversationViewData(),
                                                  user!.toUserViewData(),
                                                )
                                              : LMChatTaggingHelper
                                                  .extractStateMessage(
                                                  item.answer,
                                                ),
                                        );
                                      }
                                      return item.userId == user!.id
                                          ? _defaultSentChatBubble(item)
                                          : _defaultReceivedChatBubble(item);
                                    },
                                  ),
                                );
                              },
                            );
                          }),
                    ),
                    LMChatroomBar(
                      chatroom: chatroom,
                      scrollToBottom: _scrollToBottom,
                    ),
                  ],
                );
              }
              return const LMChatSkeletonChatPage();
            },
          ),
        ),
      ),
    );
  }

  Widget _defaultStateBubble(String message) {
    return LMChatStateBubble(message: message);
  }

  Widget _defaultSentChatBubble(Conversation conversation) {
    return LMChatBubble(
      conversation: conversation.toConversationViewData(),
      currentUser: LMChatLocalPreference.instance.getUser().toUserViewData(),
      conversationUser: conversation.member!.toUserViewData(),
      onTagTap: (tag) {},
      isSent: true,
      isSelected: _selectedIds.contains(conversation.id),
      onLongPress: (value, state) {
        if (value) {
          _selectedIds.add(conversation.id);
        } else {
          _selectedIds.remove(conversation.id.toString());
        }
        rebuildAppBar.value = !rebuildAppBar.value;
        state.setState(() {});
      },
      isSelectableOnTap: () {
        return _selectedIds.isNotEmpty;
      },
      onTap: (value, state) {
        if (value) {
          _selectedIds.add(conversation.id);
        } else {
          _selectedIds.remove(conversation.id);
        }
        rebuildAppBar.value = !rebuildAppBar.value;
        state.setState(() {});
      },
    );
  }

  Widget _defaultReceivedChatBubble(Conversation conversation) {
    return LMChatBubble(
      conversation: conversation.toConversationViewData(),
      currentUser: LMChatLocalPreference.instance.getUser().toUserViewData(),
      conversationUser: conversation.member!.toUserViewData(),
      onTagTap: (tag) {},
      isSent: false,
      isSelected: _selectedIds.contains(conversation.id),
      onLongPress: (value, state) {
        if (value) {
          _selectedIds.add(conversation.id);
        } else {
          _selectedIds.remove(conversation.id.toString());
        }
        rebuildAppBar.value = !rebuildAppBar.value;
        state.setState(() {});
      },
      isSelectableOnTap: () {
        return _selectedIds.isNotEmpty;
      },
      onTap: (value, state) {
        if (value) {
          _selectedIds.add(conversation.id);
        } else {
          _selectedIds.remove(conversation.id);
        }
        rebuildAppBar.value = !rebuildAppBar.value;
        state.setState(() {});
      },
    );
  }

  LMChatAppBar _defaultAppBar(ChatRoom chatroom) {
    final dynamic chatUser;
    chatUser = user!.id == chatroom.chatroomWithUser!.id
        ? chatroom.member!
        : chatroom.chatroomWithUser!;
    return LMChatAppBar(
      style: LMChatAppBarStyle(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        backgroundColor: LMChatTheme.theme.container,
      ),
      banner: ValueListenableBuilder(
          valueListenable: rebuildAppBar,
          builder: (context, _, __) {
            return isAnyMessageSelected()
                ? const SizedBox.shrink()
                : LMChatProfilePicture(
                    imageUrl: chatUser.imageUrl ?? chatroom.chatroomImageUrl,
                    fallbackText: chatroom.header,
                    style: LMChatProfilePictureStyle(
                      size: 42,
                      backgroundColor: LMChatTheme.theme.secondaryColor,
                    ),
                  );
          }),
      title: ValueListenableBuilder(
          valueListenable: rebuildAppBar,
          builder: (context, _, __) {
            return LMChatText(
              isAnyMessageSelected()
                  ? _selectedIds.length.toString()
                  : chatUser.name ?? chatroom.title,
              style: LMChatTextStyle(
                maxLines: 1,
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                  color: LMChatTheme.theme.onContainer,
                ),
              ),
            );
          }),
      trailing: [
        ValueListenableBuilder(
            valueListenable: rebuildAppBar,
            builder: (context, _, __) {
              return isAnyMessageSelected()
                  ? Row(
                      children: _defaultSelectedChatroomMenu(),
                    )
                  : _defaultChatroomMenu();
            }),
      ],
    );
  }

  List<Widget> _defaultSelectedChatroomMenu() {
    final LMChatConversationViewData? conversationViewData = pagedListController
        .value.itemList
        ?.firstWhere((element) => element.id == _selectedIds.first)
        .toConversationViewData();

    bool haveDeletePermission = conversationViewData != null &&
        LMChatMemberRightUtil.checkDeletePermissions(conversationViewData);
    bool haveEditPermission =
        LMChatMemberRightUtil.checkEditPermissions(conversationViewData!);
    return [
      // Copy button
      LMChatButton(
        onTap: () {
          // Store the answer in the clipboard
          // and show a toast message
          Clipboard.setData(
            ClipboardData(text: conversationViewData.answer),
          ).then((data) {
            toast("Copied to clipboard");
            _selectedIds.clear();
            rebuildAppBar.value = !rebuildAppBar.value;
            rebuildConversationList.value = !rebuildConversationList.value;
          });
        },
        style: LMChatButtonStyle.basic().copyWith(
          icon: LMChatIcon(
            type: LMChatIconType.icon,
            icon: Icons.copy,
            style: LMChatIconStyle(
              color: LMChatTheme.theme.primaryColor,
            ),
          ),
        ),
      ),
      const SizedBox(width: 8),
      // Edit button
      if (haveEditPermission && _selectedIds.length == 1)
        LMChatButton(
          onTap: () {},
          style: LMChatButtonStyle.basic().copyWith(
            icon: LMChatIcon(
              type: LMChatIconType.icon,
              icon: Icons.edit,
              style: LMChatIconStyle(
                color: LMChatTheme.theme.primaryColor,
              ),
            ),
          ),
        ),
      const SizedBox(width: 8),
      // Delete button
      if (haveDeletePermission && _selectedIds.length == 1)
        LMChatButton(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return LMChatDialog(
                  style: LMChatDialogStyle(
                    backgroundColor: LMChatTheme.theme.container,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  title: LMChatText(
                    "Delete Message?",
                    style: LMChatTextStyle(
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: LMChatTheme.theme.onContainer,
                      ),
                    ),
                  ),
                  content: const LMChatText(
                    "Are you sure you want to delete this message? This action cannot be reversed.",
                    style: LMChatTextStyle(),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 2.0),
                      child: LMChatText(
                        "CANCEL",
                        style: LMChatTextStyle(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: LMChatTheme.theme.onContainer,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: LMChatText("DELETE",
                          style: LMChatTextStyle(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: LMChatTheme.theme.primaryColor,
                            ),
                          ), onTap: () {
                        _convActionBloc.add(
                          LMChatDeleteConversationEvent(
                            conversationIds: _selectedIds.copy(),
                            reason: "Delete",
                          ),
                        );
                        _selectedIds.clear();
                        rebuildAppBar.value = !rebuildAppBar.value;
                        Navigator.of(context).pop();
                      }),
                    ),
                  ],
                );
              },
            );
          },
          style: LMChatButtonStyle.basic().copyWith(
            icon: LMChatIcon(
              type: LMChatIconType.icon,
              icon: Icons.delete,
              style: LMChatIconStyle(
                color: LMChatTheme.theme.primaryColor,
              ),
            ),
          ),
        )
    ];
  }

  Widget _defaultChatroomMenu() {
    return LMChatroomMenu(
      chatroom: chatroom,
      chatroomActions: actions,
    );
  }

  Widget _defaultScrollButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 96.0),
      child: LMChatButton(
        onTap: () {
          _scrollToBottom();
        },
        style: LMChatButtonStyle.basic().copyWith(
          height: 42,
          width: 42,
          borderRadius: 24,
          border: Border.all(
            color: LMChatTheme.theme.onContainer.withOpacity(0.2),
          ),
          backgroundColor: LMChatTheme.theme.container,
          icon: LMChatIcon(
            type: LMChatIconType.icon,
            icon: Icons.keyboard_arrow_down,
            style: LMChatIconStyle(
              size: 28,
              boxSize: 28,
              boxPadding: 2,
              color: LMChatTheme.theme.onContainer,
            ),
          ),
        ),
      ),
    );
  }
}
