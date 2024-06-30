import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/blocs.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/observer.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/convertors.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:overlay_support/overlay_support.dart';

class LMChatDMConversationList extends StatefulWidget {
  final int chatroomId;

  final ScrollController? scrollController;

  final List<int>? selectedConversations;

  final ValueNotifier<bool>? appBarNotifier;

  final PagingController<int, Conversation>? listController;

  /// Creates a new instance of LMChatConversationList
  const LMChatDMConversationList({
    super.key,
    required this.chatroomId,
    this.scrollController,
    this.selectedConversations,
    this.appBarNotifier,
    this.listController,
  });

  @override
  State<LMChatDMConversationList> createState() =>
      _LMChatDMConversationListState();
}

class _LMChatDMConversationListState extends State<LMChatDMConversationList> {
  late LMChatConversationBloc _conversationBloc;
  late LMChatConversationActionBloc _convActionBloc;

  late User user;
  int _page = 1;
  int lastConversationId = 0;

  ValueNotifier showConversationActions = ValueNotifier(false);
  ValueNotifier rebuildConversationList = ValueNotifier(false);
  late ValueNotifier<bool> rebuildAppBar;

  Map<String, Conversation> conversationMeta = <String, Conversation>{};
  Map<int, User?> userMeta = <int, User?>{};
  List<int> _selectedIds = [];

  late ScrollController scrollController;
  late PagingController<int, Conversation> pagedListController =
      PagingController<int, Conversation>(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    Bloc.observer = LMChatBlocObserver();
    user = LMChatLocalPreference.instance.getUser();
    _conversationBloc = LMChatConversationBloc.instance;
    _convActionBloc = LMChatConversationActionBloc.instance;
    _selectedIds = widget.selectedConversations ?? [];
    rebuildAppBar = widget.appBarNotifier ?? ValueNotifier(false);
    scrollController = widget.scrollController ?? ScrollController();
    pagedListController = widget.listController ??
        PagingController<int, Conversation>(firstPageKey: 1);
    _addPaginationListener();
  }

  @override
  void didUpdateWidget(covariant LMChatDMConversationList oldWidget) {
    super.didUpdateWidget(oldWidget);
    Bloc.observer = LMChatBlocObserver();
    user = LMChatLocalPreference.instance.getUser();
    _conversationBloc = LMChatConversationBloc.instance;
    _convActionBloc = LMChatConversationActionBloc.instance;
    _selectedIds = widget.selectedConversations ?? [];
    rebuildAppBar = widget.appBarNotifier ?? ValueNotifier(false);
    scrollController = widget.scrollController ?? ScrollController();
    pagedListController = widget.listController ??
        PagingController<int, Conversation>(firstPageKey: 1);
    _addPaginationListener();
  }

  @override
  void dispose() {
    _convActionBloc.close();
    _conversationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LMChatConversationBloc, LMChatConversationState>(
        bloc: _conversationBloc,
        listener: (context, state) {
          updatePagingControllers(state);
          if (state is ConversationPosted) {
            Map<String, String> userTags = LMChatTaggingHelper.decodeString(
                state.postConversationResponse.conversation?.answer ?? "");
            // LMAnalytics.get().track(
            //   AnalyticsKeys.chatroomResponded,
            //   {
            //     "chatroom_type": chatroom.type,
            //     "community_id": chatroom.communityId,
            //     "chatroom_name": chatroom.header,
            //     "chatroom_last_conversation_type": state
            //             .postConversationResponse
            //             .conversation
            //             ?.attachments
            //             ?.first
            //             .type ??
            //         "text",
            //     "tagged_users": userTags.isNotEmpty,
            //     "count_tagged_users": userTags.length,
            //     "name_tagged_users":
            //         userTags.keys.map((e) => e.replaceFirst("@", "")).toList(),
            //     "is_group_tag": false,
            //   },
            // );
          }
          if (state is ConversationError) {
            // LMAnalytics.get().track(
            //   AnalyticsKeys.messageSendingError,
            //   {
            //     "chatroom_id": chatroom.id,
            //     "chatroom_type": chatroom.type,
            //     "clicked_resend": false,
            //   },
            // );
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
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 2.w,
                ),
                reverse: true,
                builderDelegate: PagedChildBuilderDelegate<Conversation>(
                  noItemsFoundIndicatorBuilder: (context) => const Center(
                    child: LMChatText('No chats found!'),
                  ),
                  firstPageProgressIndicatorBuilder: (context) =>
                      const LMChatSkeletonChatList(),
                  animateTransitions: true,
                  transitionDuration: const Duration(milliseconds: 500),
                  itemBuilder: (context, item, index) {
                    if (item.isTimeStamp != null && item.isTimeStamp! ||
                        item.state != 0 && item.state != null) {
                      return _defaultStateBubble(
                        item.state == 1
                            ? LMChatTaggingHelper.extractFirstDMStateMessage(
                                item.toConversationViewData(),
                                user.toUserViewData(),
                              )
                            : LMChatTaggingHelper.extractStateMessage(
                                item.answer,
                              ),
                      );
                    }
                    return item.userId == user.id
                        ? _defaultSentChatBubble(item)
                        : _defaultReceivedChatBubble(item);
                  },
                ),
              );
            },
          );
        });
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
      style: LMChatBubbleStyle.basic().copyWith(showHeader: false),
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
      style: LMChatBubbleStyle.basic().copyWith(showHeader: false),
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

  _addPaginationListener() {
    pagedListController.addPageRequestListener(
      (pageKey) {
        int currentTime = DateTime.now().millisecondsSinceEpoch;
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

  void updatePagingControllers(LMChatConversationState state) {
    if (state is ConversationLoaded) {
      _page++;

      if (state.getConversationResponse.conversationMeta != null &&
          state.getConversationResponse.conversationMeta!.isNotEmpty) {
        conversationMeta
            .addAll(state.getConversationResponse.conversationMeta!);
      }
      if (state.getConversationResponse.userMeta != null) {
        userMeta.addAll(state.getConversationResponse.userMeta!);
      }
      List<Conversation>? conversationData =
          state.getConversationResponse.conversationData;
      // filterOutStateMessage(conversationData!);
      conversationData = addTimeStampInConversationList(conversationData,
          LMChatLocalPreference.instance.getCommunityData()!.id);
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
    if (!userMeta.containsKey(user.id)) {
      userMeta[user.id] = user;
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
            chatroomId: widget.chatroomId,
            date: conversation.date,
            memberId: conversation.memberId,
            userId: conversation.userId,
            temporaryId: conversation.temporaryId,
            answer: conversation.date ?? '',
            communityId: LMChatLocalPreference.instance.getCommunityData()!.id,
            createdAt: conversation.createdAt,
            header: conversation.header,
          ),
        );
      }
      conversationList.insert(0, conversation);
      if (conversationList.length >= 500) {
        conversationList.removeLast();
      }
      if (!userMeta.containsKey(user.id)) {
        userMeta[user.id] = user;
      }
    }
    pagedListController.itemList = conversationList;
    rebuildConversationList.value = !rebuildConversationList.value;
  }
}
