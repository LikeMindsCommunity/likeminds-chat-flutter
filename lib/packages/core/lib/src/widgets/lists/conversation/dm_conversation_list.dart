import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/observer.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/convertors.dart';
import 'package:likeminds_chat_flutter_core/src/utils/constants/assets.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:overlay_support/overlay_support.dart';

class LMChatDMConversationList extends StatefulWidget {
  final int chatroomId;

  final ScrollController? scrollController;

  final List<int>? selectedConversations;

  final ValueNotifier<bool>? appBarNotifier;

  final PagingController<int, LMChatConversationViewData>? listController;

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
  Map<String, List<LMChatAttachmentViewData>> conversationAttachmentsMeta =
      <String, List<LMChatAttachmentViewData>>{};
  Map<String, List<LMChatReactionViewData>> conversationReactionsMeta =
      <String, List<LMChatReactionViewData>>{};
  Map<int, User?> userMeta = <int, User?>{};
  List<int> _selectedIds = [];

  late ScrollController scrollController;
  final LMChatroomBuilderDelegate _screenBuilder =
      LMChatCore.config.chatRoomConfig.builder;

  late PagingController<int, LMChatConversationViewData> pagedListController =
      PagingController<int, LMChatConversationViewData>(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    user = LMChatLocalPreference.instance.getUser();
    _conversationBloc = LMChatConversationBloc.instance;
    _convActionBloc = LMChatConversationActionBloc.instance;
    _selectedIds = widget.selectedConversations ?? [];
    rebuildAppBar = widget.appBarNotifier ?? ValueNotifier(false);
    scrollController = widget.scrollController ?? ScrollController();
    pagedListController = widget.listController ??
        PagingController<int, LMChatConversationViewData>(firstPageKey: 1);
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
        PagingController<int, LMChatConversationViewData>(firstPageKey: 1);
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
    return MultiBlocListener(
      listeners: [
        BlocListener<LMChatConversationActionBloc,
            LMChatConversationActionState>(
          bloc: _convActionBloc,
          listener: (context, state) {
            if (state is LMChatConversationDelete) {
              _updateDeletedConversation(state.conversations.first);
            }
            if (state is LMChatConversationEdited) {
              updateEditedConversation(state.conversationViewData);
            }
            if (state is LMChatPutReactionState ||
                state is LMChatPutReactionError ||
                state is LMChatDeleteReactionState ||
                state is LMChatDeleteReactionError) {
              _updateReactions(state);
            }
          },
        ),
        BlocListener<LMChatConversationBloc, LMChatConversationState>(
          bloc: _conversationBloc,
          listener: (context, state) {
            updatePagingControllers(state);
          },
        ),
      ],
      child: ValueListenableBuilder(
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
                PagedChildBuilderDelegate<LMChatConversationViewData>(
              animateTransitions: true,
              transitionDuration: const Duration(milliseconds: 500),
              noItemsFoundIndicatorBuilder: (context) =>
                  _screenBuilder.noItemInListWidgetBuilder(
                context,
                _defaultEmptyView(),
              ),
              firstPageProgressIndicatorBuilder: (context) =>
                  _screenBuilder.loadingListWidgetBuilder(
                context,
                const LMChatSkeletonChatList(),
              ),
              newPageProgressIndicatorBuilder: (context) =>
                  _screenBuilder.paginatedLoadingWidgetBuilder(
                context,
                const LMChatLoader(),
              ),
              itemBuilder: (context, item, index) {
                if (item.isTimeStamp != null && item.isTimeStamp! ||
                    item.state != 0 && item.state != null) {
                  final stateMessage = item.state == 1
                      ? LMChatTaggingHelper.extractFirstDMStateMessage(
                          item,
                          user.toUserViewData(),
                        )
                      : LMChatTaggingHelper.extractStateMessage(item.answer);
                  return _screenBuilder.stateBubbleBuilder(
                    context,
                    stateMessage,
                    _defaultStateBubble(stateMessage),
                  );
                }
                return item.memberId == user.id
                    ? _screenBuilder.sentChatBubbleBuilder(
                        context, item, _defaultSentChatBubble(item))
                    : _screenBuilder.receivedChatBubbleBuilder(
                        context, item, _defaultReceivedChatBubble(item));
              },
            ),
          );
        },
      ),
    );
  }

  LMChatStateBubble _defaultStateBubble(String message) {
    return LMChatStateBubble(
      message: message,
      style: LMChatTheme.theme.stateBubbleStyle.copyWith(
        messageStyle: LMChatTextStyle.basic().copyWith(
          maxLines: 2,
          textStyle: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  LMChatBubble _defaultSentChatBubble(LMChatConversationViewData conversation) {
    return LMChatBubble(
      conversation: conversation,
      attachments:
          conversationAttachmentsMeta[conversation.temporaryId.toString()] ??
              conversationAttachmentsMeta[conversation.id.toString()],
      currentUser: LMChatLocalPreference.instance.getUser().toUserViewData(),
      conversationUser: conversation.member!,
      userMeta: userMeta.map((id, user) {
        return MapEntry(id, user!.toUserViewData());
      }),
      reactions:
          conversationReactionsMeta[conversation.temporaryId.toString()] ??
              conversationReactionsMeta[conversation.id.toString()],
      onReaction: (r) {
        onReaction(r, conversation.id);
        setState(() {});
      },
      onRemoveReaction: (r) {
        onRemoveReaction(r, conversation.id);
        setState(() {});
      },
      onTagTap: (tag) {},
      onReply: (conversation) {
        _convActionBloc.add(
          LMChatReplyConversationEvent(
            chatroomId: widget.chatroomId,
            conversationId: conversation.id,
            replyConversation: conversation,
            attachments: conversationAttachmentsMeta[
                    conversation.temporaryId.toString()] ??
                conversationAttachmentsMeta[conversation.id.toString()],
          ),
        );
      },
      isSent: true,
      isDM: true,
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

  LMChatBubble _defaultReceivedChatBubble(
      LMChatConversationViewData conversation) {
    return LMChatBubble(
      conversation: conversation,
      attachments: conversationAttachmentsMeta[conversation.id.toString()],
      currentUser: LMChatLocalPreference.instance.getUser().toUserViewData(),
      conversationUser: conversation.member!,
      userMeta: userMeta.map((id, user) {
        return MapEntry(id, user!.toUserViewData());
      }),
      reactions:
          conversationReactionsMeta[conversation.temporaryId.toString()] ??
              conversationReactionsMeta[conversation.id.toString()],
      onReaction: (r) {
        onReaction(r, conversation.id);
        setState(() {});
      },
      onRemoveReaction: (r) {
        onRemoveReaction(r, conversation.id);
        setState(() {});
      },
      onTagTap: (tag) {},
      onReply: (conversation) {
        _convActionBloc.add(
          LMChatReplyConversationEvent(
            chatroomId: widget.chatroomId,
            conversationId: conversation.id,
            replyConversation: conversation,
            attachments:
                conversationAttachmentsMeta[conversation.id.toString()],
          ),
        );
      },
      isSent: false,
      isDM: true,
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

  Widget _defaultEmptyView() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const LMChatIcon(
          type: LMChatIconType.png,
          assetPath: emptyViewImage,
          style: LMChatIconStyle(
            size: 100,
          ),
        ),
        const SizedBox(height: 12),
        LMChatText(
          'Oops! No conversations found.',
          style: LMChatTextStyle(
            maxLines: 1,
            textStyle: TextStyle(
              color: LMChatTheme.theme.inActiveColor,
            ),
          ),
        )
      ],
    ));
  }

  _addPaginationListener() {
    pagedListController.addPageRequestListener(
      (pageKey) {
        _conversationBloc.add(
          LMChatFetchConversationsEvent(
            chatroomId: widget.chatroomId,
            page: pageKey,
            pageSize: 500,
          ),
        );
      },
    );
  }

  void updatePagingControllers(LMChatConversationState state) {
    if (state is LMChatConversationLoadedState) {
      _page++;

      if (state.getConversationResponse.conversationMeta != null &&
          state.getConversationResponse.conversationMeta!.isNotEmpty) {
        conversationMeta
            .addAll(state.getConversationResponse.conversationMeta!);
      }
      if (state.getConversationResponse.conversationAttachmentsMeta != null &&
          state.getConversationResponse.conversationAttachmentsMeta!
              .isNotEmpty) {
        Map<String, List<LMChatAttachmentViewData>>
            getConversationAttachmentData = state
                .getConversationResponse.conversationAttachmentsMeta!
                .map((key, value) {
          return MapEntry(
            key,
            (value as List<Attachment>?)
                    ?.map((e) => e.toAttachmentViewData())
                    .toList() ??
                [],
          );
        });
        conversationAttachmentsMeta.addAll(getConversationAttachmentData);
      }
      if (state.getConversationResponse.conversationReactionMeta != null &&
          state.getConversationResponse.conversationReactionMeta!.isNotEmpty) {
        Map<String, List<LMChatReactionViewData>> getConversationReactionsData =
            state.getConversationResponse.conversationReactionMeta!
                .map((key, value) {
          return MapEntry(
            key,
            (value as List<Reaction>?)
                    ?.map((e) => e.toReactionViewData())
                    .toList() ??
                [],
          );
        });
        conversationReactionsMeta.addAll(getConversationReactionsData);
      }
      if (state.getConversationResponse.userMeta != null) {
        userMeta.addAll(state.getConversationResponse.userMeta!);
      }
      List<LMChatConversationViewData>? conversationData = state
              .getConversationResponse.conversationData
              ?.map((e) => e.toConversationViewData())
              .toList() ??
          [];
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
    if (state is LMChatConversationPostedState) {
      addConversationToPagedList(
        state.conversationViewData,
      );
    } else if (state is LMChatLocalConversationState) {
      addLocalConversationToPagedList(state.conversationViewData);
    } else if (state is LMChatConversationErrorState) {
      toast(state.message);
    }
    if (state is LMChatMultiMediaConversationLoadingState) {
      LMChatConversationViewData conv =
          state.postConversation.toConversationViewData();

      conv = conv.copyWith(
          replyConversationObject: conversationMeta[conv.replyId.toString()]
              ?.toConversationViewData());

      if (!userMeta.containsKey(user.id)) {
        userMeta[user.id] = user;
      }
      conversationAttachmentsMeta[conv.temporaryId!] =
          state.mediaFiles.map((e) => e.toAttachmentViewData()).toList();

      addLocalConversationToPagedList(conv);
    }
    if (state is LMChatMultiMediaConversationPostedState) {
      final conv = state.postConversationResponse.conversation;

      conversationAttachmentsMeta[conv!.id.toString()] =
          state.putMediaResponse.map((e) => e.toAttachmentViewData()).toList();

      addConversationToPagedList(
        state.postConversationResponse.conversation!.toConversationViewData(),
      );
    }
    if (state is LMChatConversationUpdatedState) {
      if (state.conversationViewData.id != lastConversationId) {
        conversationAttachmentsMeta.addAll(state.attachments);
        addConversationToPagedList(
          state.conversationViewData,
        );
        lastConversationId = state.conversationViewData.id;
      }
    }
  }

  void addLocalConversationToPagedList(
      LMChatConversationViewData conversation) {
    LMChatConversationViewData? result;
    List<LMChatConversationViewData> conversationList =
        pagedListController.itemList ?? <LMChatConversationViewData>[];

    if (pagedListController.itemList != null &&
        conversation.replyId != null &&
        !conversationMeta.containsKey(conversation.replyId.toString())) {
      LMChatConversationViewData? replyConversation =
          pagedListController.itemList!.firstWhere((element) =>
              element.id ==
              (conversation.replyId ?? conversation.replyConversation));
      conversationMeta[conversation.replyId.toString()] =
          replyConversation.toConversation();

      result =
          conversation.copyWith(replyConversationObject: replyConversation);
    }
    conversationList.insert(0, result ?? conversation);
    if (conversationList.length >= 500) {
      conversationList.removeLast();
    }
    if (!userMeta.containsKey(user.id)) {
      userMeta[user.id] = user;
    }

    pagedListController.itemList = conversationList;
    rebuildConversationList.value = !rebuildConversationList.value;
  }

  void addConversationToPagedList(LMChatConversationViewData conversation) {
    LMChatConversationViewData? result;
    List<LMChatConversationViewData> conversationList =
        pagedListController.itemList ?? <LMChatConversationViewData>[];

    int index = conversationList.indexWhere(
        (element) => element.temporaryId == conversation.temporaryId);
    if (pagedListController.itemList != null &&
        (conversation.replyId != null ||
            conversation.replyConversation != null) &&
        !conversationMeta.containsKey(conversation.replyId.toString())) {
      LMChatConversationViewData? replyConversation =
          pagedListController.itemList!.firstWhere((element) =>
              element.id ==
              (conversation.replyId ?? conversation.replyConversation));
      conversationMeta[conversation.replyId.toString()] =
          replyConversation.toConversation();

      result =
          conversation.copyWith(replyConversationObject: replyConversation);
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
            temporaryId: conversation.temporaryId,
            answer: conversation.date ?? '',
            communityId: LMChatLocalPreference.instance.getCommunityData()!.id,
            createdAt: conversation.createdAt,
            header: conversation.header,
          ).toConversationViewData(),
        );
      }
      conversationList.insert(0, result ?? conversation);
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

  void _updateDeletedConversation(LMChatConversationViewData conversation) {
    List<LMChatConversationViewData> conversationList =
        pagedListController.itemList ?? <LMChatConversationViewData>[];
    int index =
        conversationList.indexWhere((element) => element.id == conversation.id);
    if (index != -1) {
      conversationList[index] = conversationList[index].copyWith(
        deletedByUserId: user.id,
      );
    }
    if (conversationMeta.isNotEmpty &&
        conversationMeta.containsKey(conversation.id.toString())) {
      conversationMeta[conversation.id..toString()]!.deletedByUserId = user.id;
    }
    pagedListController.itemList = conversationList;
    scrollController.animateTo(
      scrollController.position.pixels + 10,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
    rebuildConversationList.value = !rebuildConversationList.value;
  }

  void updateEditedConversation(LMChatConversationViewData editedConversation) {
    List<LMChatConversationViewData> conversationList =
        pagedListController.itemList ?? <LMChatConversationViewData>[];
    int index = conversationList
        .indexWhere((element) => element.id == editedConversation.id);
    if (index != -1) {
      conversationList[index] = editedConversation;
    }

    if (conversationMeta.isNotEmpty &&
        conversationMeta.containsKey(editedConversation.id.toString())) {
      conversationMeta[editedConversation.id.toString()] =
          editedConversation.toConversation();
    }
    pagedListController.itemList = conversationList;
    rebuildConversationList.value = !rebuildConversationList.value;
  }

  onReaction(
    String reaction,
    int conversationId,
  ) {
    if (reaction == 'Add') {
      LMChatroomActionBloc.instance.add(
        LMChatShowEmojiKeyboardEvent(
          conversationId: conversationId,
        ),
      );
    } else {
      /// TODO: Check for follow status of chatroom
      // if (!chatroom.followStatus!) {
      //   Future<LMResponse> response = locator<LikeMindsService>()
      //       .followChatroom((FollowChatroomRequestBuilder()
      //             ..chatroomId(chatroom.id)
      //             ..memberId(loggedinUser.id)
      //             ..value(true))
      //           .build())
      //     ..then((value) {
      //       if (value.success) {
      //         toast("Chatroom joined");
      //       }
      //     });
      _convActionBloc.add(LMChatPutReaction(
        conversationId: conversationId,
        reaction: reaction,
      ));
      _selectedIds.remove(conversationId);
      rebuildAppBar.value = !rebuildAppBar.value;
    }
  }

  onRemoveReaction(String reaction, int conversationId) {
    _convActionBloc.add(LMChatDeleteReaction(
      conversationId: conversationId,
      reaction: reaction,
    ));
    Navigator.pop(context);
  }

  void _updateReactions(LMChatConversationActionState state) {
    if (state is LMChatPutReactionState) {
      LMChatReactionViewData addedReaction = Reaction(
        chatroomId: widget.chatroomId,
        conversationId: state.conversationId,
        reaction: state.reaction,
        userId: user.id,
      ).toReactionViewData();
      if (!userMeta.containsKey(user.id)) {
        userMeta[user.id] = user;
      }
      _addReaction(addedReaction, state.conversationId);
    }
    if (state is LMChatPutReactionError) {
      toast(state.errorMessage);
      LMChatReactionViewData addedReaction = Reaction(
        chatroomId: widget.chatroomId,
        conversationId: state.conversationId,
        reaction: state.reaction,
        userId: user.id,
      ).toReactionViewData();
      _removeReaction(addedReaction);
    }
    if (state is LMChatDeleteReactionState) {
      LMChatReactionViewData deletedReaction = Reaction(
        chatroomId: widget.chatroomId,
        conversationId: state.conversationId,
        reaction: state.reaction,
        userId: user.id,
      ).toReactionViewData();
      _removeReaction(deletedReaction);
    }
    if (state is LMChatDeleteReactionError) {
      toast(state.errorMessage);
      LMChatReactionViewData deletedReaction = Reaction(
        chatroomId: widget.chatroomId,
        conversationId: state.conversationId,
        reaction: state.reaction,
        userId: user.id,
      ).toReactionViewData();
      _addReaction(deletedReaction, state.conversationId);
    }
  }

  void _addReaction(LMChatReactionViewData reaction, int conversationId) {
    String conversationIdStr = conversationId.toString();
    if (conversationReactionsMeta.containsKey(conversationIdStr)) {
      final existingReactions = conversationReactionsMeta[conversationIdStr]!;
      final existingReactionIndex =
          existingReactions.indexWhere((r) => r.userId == reaction.userId);
      if (existingReactionIndex != -1) {
        existingReactions[existingReactionIndex] =
            reaction; // Update existing reaction
      } else {
        existingReactions.add(reaction); // Add new reaction
      }
    } else {
      conversationReactionsMeta[conversationIdStr] = [reaction];
    }
    List<LMChatConversationViewData> conversationList =
        pagedListController.itemList ?? <LMChatConversationViewData>[];
    int index =
        conversationList.indexWhere((element) => element.id == conversationId);
    if (index != -1) {
      conversationList[index] =
          conversationList[index].copyWith(hasReactions: true);
    }
    rebuildConversationList.value = !rebuildConversationList.value;
  }

  void _removeReaction(LMChatReactionViewData reaction) {
    String conversationIdStr = reaction.conversationId.toString();
    if (conversationReactionsMeta.containsKey(conversationIdStr)) {
      final existingReactions = conversationReactionsMeta[conversationIdStr]!;
      final existingReactionIndex =
          existingReactions.indexWhere((r) => r.userId == reaction.userId);
      if (existingReactionIndex != -1) {
        existingReactions
            .removeAt(existingReactionIndex); // Remove existing reaction
      }
    }
    List<LMChatConversationViewData> conversationList =
        pagedListController.itemList ?? <LMChatConversationViewData>[];
    int index = conversationList
        .indexWhere((element) => element.id == reaction.conversationId);
    if (index != -1) {
      conversationList[index] = conversationList[index].copyWith(
          hasReactions:
              conversationReactionsMeta[conversationIdStr]!.isNotEmpty);
    }
    rebuildConversationList.value = !rebuildConversationList.value;
  }
}
