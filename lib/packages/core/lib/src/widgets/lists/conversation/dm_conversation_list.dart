import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/observer.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/convertors.dart';
import 'package:likeminds_chat_flutter_core/src/utils/constants/assets.dart';
import 'package:likeminds_chat_flutter_core/src/utils/media/audio_handler.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:intl/intl.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class LMChatDMConversationList extends StatefulWidget {
  final int chatroomId;

  final List<int>? selectedConversations;

  final ValueNotifier<bool>? appBarNotifier;

  final bool? isOtherUserAIChatbot;

  final LMDualSidePaginationController<LMChatConversationViewData>?
      paginatedListController;

  /// Creates a new instance of LMChatConversationList
  const LMChatDMConversationList({
    super.key,
    required this.chatroomId,
    this.selectedConversations,
    this.appBarNotifier,
    this.paginatedListController,
    this.isOtherUserAIChatbot,
  });

  @override
  State<LMChatDMConversationList> createState() =>
      _LMChatDMConversationListState();
}

class _LMChatDMConversationListState extends State<LMChatDMConversationList> {
  late LMChatConversationBloc _conversationBloc;
  late LMChatConversationActionBloc _convActionBloc;

  late User user;
  int _topPage = 1;
  int _bottomPage = 1;
  final int _pageSize = 200;
  int lastConversationId = 0;
  bool isOtherUserChatbot = false;

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
  int? replyId;
  LMChatConversationViewData? replyConversation;
  int? _animateToChatId;

  late ScrollController scrollController;
  final LMChatroomBuilderDelegate _screenBuilder =
      LMChatCore.config.chatRoomConfig.builder;

  late LMDualSidePaginationController<LMChatConversationViewData>
      pagedListController = widget.paginatedListController ??
          LMDualSidePaginationController(
            listController: ListController(),
            scrollController: ScrollController(),
          );

  @override
  void initState() {
    super.initState();
    user = LMChatLocalPreference.instance.getUser();
    _conversationBloc = LMChatConversationBloc.instance;
    _convActionBloc = LMChatConversationActionBloc.instance;
    _selectedIds = widget.selectedConversations ?? [];
    rebuildAppBar = widget.appBarNotifier ?? ValueNotifier(false);
    isOtherUserChatbot = widget.isOtherUserAIChatbot ??
        widget.chatroomId ==
            LMChatLocalPreference.instance.getChatroomIdWithAIChatbot();
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
              for (LMChatConversationViewData conversation
                  in state.conversations) {
                _updateDeletedConversation(conversation);
              }
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
          return LMDualSidePagedList(
            paginationType: replyConversation == null
                ? PaginationType.bottom
                : PaginationType.both,
            initialPage: 1,
            onPaginationTriggered: _onPaginationTriggered,
            paginationController: pagedListController,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            reverse: true,
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
              if (item.id == -1) {
                return _getChatBotShimmer();
              }
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
          );
        },
      ),
    );
  }

  Future<void> _onPaginationTriggered(pageKey, direction, conversation) async {
    _conversationBloc.add(
      LMChatFetchConversationsEvent(
        minTimestamp: replyConversation == null
            ? null
            : direction == PaginationDirection.top
                ? replyConversation!.createdEpoch
                : null,
        maxTimestamp: replyConversation == null
            ? null
            : direction == PaginationDirection.bottom
                ? replyConversation!.createdEpoch
                : null,
        chatroomId: widget.chatroomId,
        page: pageKey,
        pageSize: _pageSize,
        direction: direction,
        lastConversationId: lastConversationId,
        replyId: replyId,
        orderBy: direction == PaginationDirection.top
            ? OrderBy.ascending
            : OrderBy.descending,
      ),
    );
  }

  LMChatStateBubble _defaultStateBubble(String message) {
    return LMChatStateBubble(
      message: message,
      style: LMChatTheme.theme.stateBubbleStyle.copyWith(
        backgroundColor: const Color(0xffacb7c0),
        messageStyle: LMChatTextStyle.basic().copyWith(
          maxLines: 2,
          textStyle: TextStyle(
            fontSize: 12,
            color: LMChatTheme.theme.container,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  LMChatBubble _defaultSentChatBubble(LMChatConversationViewData conversation) {
    return LMChatBubble(
      onReplyTap: () {
        _onReplyTap(conversation, pagedListController, widget.chatroomId);
      },
      conversation: conversation,
      attachments:
          conversationAttachmentsMeta[conversation.temporaryId.toString()] ??
              conversationAttachmentsMeta[conversation.id.toString()],
      currentUser: LMChatLocalPreference.instance.getUser().toUserViewData(),
      conversationUser: conversation.member!,
      userMeta: userMeta.map((id, user) {
        return MapEntry(id, user!.toUserViewData());
      }),
      audioHandler: LMChatCoreAudioHandler.instance,
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
      replyBuilder: (reply, oldWidget) {
        String message = getGIFText(reply);
        return oldWidget.copyWith(
          subtitle: ((reply.attachmentsUploaded ?? false) &&
                  reply.deletedByUserId == null)
              ? getChatItemAttachmentTile(message,
                  conversationAttachmentsMeta[reply.id.toString()] ?? [], reply)
              : LMChatText(
                  reply.state != 0
                      ? LMChatTaggingHelper.extractStateMessage(message)
                      : LMChatTaggingHelper.convertRouteToTag(
                            message,
                            withTilde: false,
                          ) ??
                          "Replying to Conversation",
                  style: LMChatTextStyle(
                    maxLines: 1,
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: LMChatTheme.theme.onContainer,
                      fontWeight: FontWeight.w400,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
        );
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
      isSelected: _selectedIds.contains(conversation.id) ||
          _animateToChatId == conversation.id,
      style: LMChatBubbleStyle.basic().copyWith(showHeader: false),
      onLongPress: (value, state) {
        if (value) {
          _selectedIds.add(conversation.id);
        } else {
          _selectedIds.remove(conversation.id);
        }
        rebuildAppBar.value = !rebuildAppBar.value;
        state.setState(() {});
        LMChatAnalyticsBloc.instance.add(
          LMChatFireAnalyticsEvent(
            eventName: LMChatAnalyticsKeys.messageSelected,
            eventProperties: {
              'type': 'text',
              'chatroom_id': widget.chatroomId,
            },
          ),
        );
        LMChatAnalyticsBloc.instance.add(
          LMChatFireAnalyticsEvent(
            eventName: LMChatAnalyticsKeys.emoticonTrayOpened,
            eventProperties: {
              'from': 'long press',
              'message_id': conversation.id,
              'chatroom_id': widget.chatroomId,
            },
          ),
        );
      },
      isSelectableOnTap: () {
        return _selectedIds.isNotEmpty;
      },
      onReactionsTap: () {
        LMChatAnalyticsBloc.instance.add(
          LMChatFireAnalyticsEvent(
            eventName: LMChatAnalyticsKeys.reactionListOpened,
            eventProperties: {
              'message_id': conversation.id,
              'chatroom_id': widget.chatroomId,
            },
          ),
        );
      },
      onTap: (value, state) {
        if (value) {
          _selectedIds.add(conversation.id);
          LMChatAnalyticsBloc.instance.add(
            LMChatFireAnalyticsEvent(
              eventName: LMChatAnalyticsKeys.messageSelected,
              eventProperties: {
                'type': 'text',
                'chatroom_id': widget.chatroomId,
              },
            ),
          );
        } else {
          _selectedIds.remove(conversation.id);
        }
        rebuildAppBar.value = !rebuildAppBar.value;
        state.setState(() {});
      },
      onMediaTap: () {
        LMChatMediaHandler.instance.addPickedMedia(
            conversationAttachmentsMeta[conversation.id.toString()]);
        LMChatCoreAudioHandler.instance.stopAudio();
        LMChatCoreAudioHandler.instance.stopRecording();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LMChatMediaPreviewScreen(
              conversation: conversation,
            ),
          ),
        );
      },
    );
  }

  LMChatBubble _defaultReceivedChatBubble(
      LMChatConversationViewData conversation) {
    return LMChatBubble(
      onReplyTap: () {
        _onReplyTap(conversation, pagedListController, widget.chatroomId);
      },
      conversation: conversation,
      attachments: conversationAttachmentsMeta[conversation.id.toString()],
      currentUser: LMChatLocalPreference.instance.getUser().toUserViewData(),
      conversationUser: conversation.member!,
      userMeta: userMeta.map((id, user) {
        return MapEntry(id, user!.toUserViewData());
      }),
      audioHandler: LMChatCoreAudioHandler.instance,
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
      replyBuilder: (reply, oldWidget) {
        String message = getGIFText(reply);
        return oldWidget.copyWith(
          subtitle: ((reply.attachmentsUploaded ?? false) &&
                  reply.deletedByUserId == null)
              ? getChatItemAttachmentTile(message,
                  conversationAttachmentsMeta[reply.id.toString()] ?? [], reply)
              : LMChatText(
                  reply.state != 0
                      ? LMChatTaggingHelper.extractStateMessage(message)
                      : LMChatTaggingHelper.convertRouteToTag(
                            message,
                            withTilde: false,
                          ) ??
                          "Replying to Conversation",
                  style: LMChatTextStyle(
                    maxLines: 1,
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: LMChatTheme.theme.onContainer,
                      fontWeight: FontWeight.w400,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
        );
      },
      isSent: false,
      isDM: true,
      avatar: isOtherUserChatbot
          ? LMChatProfilePicture(
              fallbackText: conversation.member!.name,
              imageUrl: conversation.member!.imageUrl,
              style: const LMChatProfilePictureStyle(
                size: 39,
                boxShape: BoxShape.circle,
              ),
            )
          : null,
      style: LMChatBubbleStyle.basic().copyWith(showHeader: false),
      isSelected: _selectedIds.contains(conversation.id) ||
          _animateToChatId == conversation.id,
      onReactionsTap: () {
        LMChatAnalyticsBloc.instance.add(
          LMChatFireAnalyticsEvent(
            eventName: LMChatAnalyticsKeys.reactionListOpened,
            eventProperties: {
              'message_id': conversation.id,
              'chatroom_id': widget.chatroomId,
            },
          ),
        );
      },
      onLongPress: (value, state) {
        if (value) {
          _selectedIds.add(conversation.id);
        } else {
          _selectedIds.remove(conversation.id);
        }
        rebuildAppBar.value = !rebuildAppBar.value;
        state.setState(() {});
        LMChatAnalyticsBloc.instance.add(
          LMChatFireAnalyticsEvent(
            eventName: LMChatAnalyticsKeys.messageSelected,
            eventProperties: {
              'type': 'text',
              'chatroom_id': widget.chatroomId,
            },
          ),
        );
        LMChatAnalyticsBloc.instance.add(
          LMChatFireAnalyticsEvent(
            eventName: LMChatAnalyticsKeys.emoticonTrayOpened,
            eventProperties: {
              'from': 'long press',
              'message_id': conversation.id,
              'chatroom_id': widget.chatroomId,
            },
          ),
        );
      },
      isSelectableOnTap: () {
        return _selectedIds.isNotEmpty;
      },
      onTap: (value, state) {
        if (value) {
          _selectedIds.add(conversation.id);
          LMChatAnalyticsBloc.instance.add(
            LMChatFireAnalyticsEvent(
              eventName: LMChatAnalyticsKeys.messageSelected,
              eventProperties: {
                'type': 'text',
                'chatroom_id': widget.chatroomId,
              },
            ),
          );
        } else {
          _selectedIds.remove(conversation.id);
        }
        rebuildAppBar.value = !rebuildAppBar.value;
        state.setState(() {});
      },
      onMediaTap: () {
        LMChatMediaHandler.instance.addPickedMedia(
            conversationAttachmentsMeta[conversation.id.toString()]);
        LMChatCoreAudioHandler.instance.stopAudio();
        LMChatCoreAudioHandler.instance.stopRecording();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LMChatMediaPreviewScreen(
              conversation: conversation,
            ),
          ),
        );
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

  Widget _getChatBotShimmer() {
    return const Padding(
      padding: EdgeInsets.only(left: 12.0),
      child: LMChatSkeletonChatBubble(
        isSent: false,
      ),
    );
  }

  LMChatConversationViewData _getChatBotShimmerConversation() {
    return (LMChatConversationViewDataBuilder()
          ..id(-1)
          ..answer('invisible')
          ..createdAt(DateFormat('dd MMM yyyy').format(DateTime.now())))
        .build();
  }

  void updatePagingControllers(LMChatConversationState state) {
    if (state is LMChatConversationLoadedState) {
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
              ?.map((e) {
            final conv = e.toConversationViewData(
              conversationPollsMeta:
                  state.getConversationResponse.conversationPollsMeta,
              userMeta: state.getConversationResponse.userMeta,
            );
            // Add attachments to the conversation object explicitly
            if (conversationAttachmentsMeta.containsKey(conv.id.toString())) {
              return conv.copyWith(
                attachments: conversationAttachmentsMeta[conv.id.toString()],
              );
            }
            return conv;
          }).toList() ??
          [];
      conversationData = addTimeStampInConversationList(conversationData,
          LMChatLocalPreference.instance.getCommunityData()!.id);
      if (state.getConversationResponse.conversationData == null ||
          state.getConversationResponse.conversationData!.isEmpty ||
          state.getConversationResponse.conversationData!.length > _pageSize) {
        if (state.direction == PaginationDirection.bottom) {
          _bottomPage++;
          pagedListController.appendLastPageToEnd(conversationData ?? []);
        } else {
          _topPage++;
          pagedListController.appendFirstPageToStart(
              conversationData?.reversed.toList() ?? []);
        }
      } else {
        if (state.direction == PaginationDirection.bottom) {
          _bottomPage++;
          pagedListController.appendPageToEnd(
              conversationData ?? [], _bottomPage);
        } else {
          _topPage++;
          pagedListController.appendPageToStart(
              conversationData?.reversed.toList() ?? [], _topPage);
        }
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
      if (state.conversationViewData.id != lastConversationId ||
          state.shouldUpdate) {
        conversationAttachmentsMeta.addAll(state.attachments);
        addConversationToPagedList(
          state.conversationViewData,
        );
        lastConversationId = state.conversationViewData.id;
        LMChatroomActionBloc.instance.add(
          LMChatMarkReadChatroomEvent(
            chatroomId: widget.chatroomId,
          ),
        );
      }
    }
  }

  void addLocalConversationToPagedList(
      LMChatConversationViewData conversation) {
    LMChatConversationViewData? result;
    List<LMChatConversationViewData> conversationList =
        pagedListController.itemList ?? <LMChatConversationViewData>[];

    if (conversation.replyId != null &&
        !conversationMeta.containsKey(conversation.replyId.toString())) {
      LMChatConversationViewData? replyConversation =
          pagedListController.itemList.firstWhere((element) =>
              element.id ==
              (conversation.replyId ?? conversation.replyConversation));
      conversationMeta[conversation.replyId.toString()] =
          replyConversation.toConversation();

      result = conversation.copyWith(
        replyConversationObject: replyConversation,
        attachments: conversationAttachmentsMeta[conversation.temporaryId] ??
            conversationAttachmentsMeta[conversation.id.toString()],
      );
    } else {
      result = conversation.copyWith(
        attachments: conversationAttachmentsMeta[conversation.temporaryId] ??
            conversationAttachmentsMeta[conversation.id.toString()],
      );
    }

    if (conversationList.isNotEmpty &&
        conversationList.first.date != conversation.date &&
        conversationList.first.id != -1) {
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
          answer: DateFormat('dd MMM yyyy').format(
              DateTime.fromMillisecondsSinceEpoch(
                  conversation.createdEpoch ?? 0)),
          communityId: LMChatLocalPreference.instance.getCommunityData()!.id,
          createdAt: conversation.createdAt,
          header: conversation.header,
        ).toConversationViewData(),
      );
    }

    conversationList.insert(0, result);
    if (isOtherUserChatbot) {
      conversationList.removeWhere((element) => element.id == -1);
      conversationList.insert(0, _getChatBotShimmerConversation());
    }
    if (conversationList.length >= _pageSize) {
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

    bool isSelf = conversation.memberId == user.id;
    if (conversationList.first.id == -1 && !isSelf && isOtherUserChatbot) {
      conversationList.removeAt(0);
    }

    int index = conversationList.indexWhere((element) {
      if (conversation.temporaryId == null || element.temporaryId == null) {
        return element.id == conversation.id;
      }
      return element.temporaryId == conversation.temporaryId;
    });
    if ((conversation.replyId != null ||
            conversation.replyConversation != null) &&
        !conversationMeta.containsKey(conversation.replyId.toString())) {
      LMChatConversationViewData? replyConversation =
          pagedListController.itemList.firstWhere((element) =>
              element.id ==
              (conversation.replyId ?? conversation.replyConversation));
      conversationMeta[conversation.replyId.toString()] =
          replyConversation.toConversation();

      result = conversation.copyWith(
        replyConversationObject: replyConversation,
        attachments: conversationAttachmentsMeta[conversation.temporaryId] ??
            conversationAttachmentsMeta[conversation.id.toString()],
      );
    } else {
      result = conversation.copyWith(
        attachments: conversationAttachmentsMeta[conversation.temporaryId] ??
            conversationAttachmentsMeta[conversation.id.toString()],
      );
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
            answer: DateFormat('dd MMM yyyy').format(
                DateTime.fromMillisecondsSinceEpoch(
                    conversation.createdEpoch ?? 0)),
            communityId: LMChatLocalPreference.instance.getCommunityData()!.id,
            createdAt: conversation.createdAt,
            header: conversation.header,
          ).toConversationViewData(),
        );
      }
      conversationList.insert(0, result);
      if (conversationList.length >= _pageSize) {
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

    // Update the deleted conversation
    int index =
        conversationList.indexWhere((element) => element.id == conversation.id);
    if (index != -1) {
      conversationList[index] = conversationList[index].copyWith(
        deletedByUserId: user.id,
      );
    }

    // Update conversations replying to the deleted conversation
    for (int i = 0; i < conversationList.length; i++) {
      if (conversationList[i].replyId == conversation.id ||
          conversationList[i].replyConversation == conversation.id) {
        conversationList[i] = conversationList[i].copyWith(
          replyConversationObject: conversation.copyWith(
            deletedByUserId: user.id,
          ),
        );
      }
    }

    if (conversationMeta.isNotEmpty &&
        conversationMeta.containsKey(conversation.id.toString())) {
      conversationMeta[conversation.id.toString()]!.deletedByUserId = user.id;
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
        pagedListController.itemList;
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
      LMChatAnalyticsBloc.instance.add(
        LMChatFireAnalyticsEvent(
          eventName: LMChatAnalyticsKeys.reactionAdded,
          eventProperties: {
            'reaction': reaction,
            'from': 'long_press',
            'message_id': conversationId,
            'chatroom_id': widget.chatroomId,
          },
        ),
      );
      _convActionBloc.add(LMChatPutReaction(
        conversationId: conversationId,
        reaction: reaction,
      ));
      _selectedIds.remove(conversationId);
      rebuildAppBar.value = !rebuildAppBar.value;
    }
  }

  onRemoveReaction(String reaction, int conversationId) {
    LMChatAnalyticsBloc.instance.add(
      LMChatFireAnalyticsEvent(
        eventName: LMChatAnalyticsKeys.reactionRemoved,
        eventProperties: {
          'message_id': conversationId,
          'chatroom_id': widget.chatroomId,
        },
      ),
    );
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
        pagedListController.itemList;
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
        pagedListController.itemList;
    int index = conversationList
        .indexWhere((element) => element.id == reaction.conversationId);
    if (index != -1) {
      conversationList[index] = conversationList[index].copyWith(
          hasReactions:
              conversationReactionsMeta[conversationIdStr]!.isNotEmpty);
    }
    rebuildConversationList.value = !rebuildConversationList.value;
  }

  void _onReplyTap(
    LMChatConversationViewData conversation,
    LMDualSidePaginationController pagedListController,
    int chatroomId,
  ) async {
    // find index of the conversation in the list
    final int? replyId = conversation.replyId ??
        conversation.replyConversation ??
        conversation.replyConversationObject?.id;
    // if not able to find replyId in conversation return
    if (replyId == null) {
      return;
    }
    // find index of reply in conversation list
    int index = pagedListController.itemList
        .indexWhere((element) => element.id == replyId);
    if (index != -1) {
      // scroll and highlight the conversation
      _scrollToConversation(index, replyId, pagedListController);
    } else {
      // handle if index is -1
      // clear page list and fetch the conversation
      // with the reply id
      pagedListController.clear();
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      // fetch reply conversation
      final GetConversationRequestBuilder replyConversationBuilder =
          GetConversationRequestBuilder()
            ..chatroomId(chatroomId)
            ..page(1)
            ..pageSize(1)
            ..isLocalDB(false)
            ..minTimestamp(0)
            ..maxTimestamp(currentTime)
            ..conversationId(replyId);

      // [Data Layer] function call
      final replyConversationResponse = await LMChatCore.client
          .getConversation(replyConversationBuilder.build());

      // convert [Conversation] list to [LMChatConversationViewData] list
      final replyConversationsVewData =
          replyConversationResponse.data!.conversationData!.map((e) {
        return e.toConversationViewData(
          conversationPollsMeta:
              replyConversationResponse.data!.conversationPollsMeta,
          userMeta: replyConversationResponse.data!.userMeta,
        );
      }).toList();

      // assign replyViewData to Global replyConversation
      if (replyConversationsVewData.isNotEmpty) {
        replyConversation = replyConversationsVewData.first;
      }

      // fetch 100 conversations from the bottom of the list
      final GetConversationRequestBuilder bottomToReplyConversationBuilder =
          GetConversationRequestBuilder()
            ..chatroomId(chatroomId)
            ..page(1)
            ..pageSize(100)
            ..isLocalDB(false)
            ..minTimestamp(replyConversationsVewData.first.createdEpoch!)
            ..maxTimestamp(currentTime)
            ..orderBy(OrderBy.ascending);

      // [Data Layer] function call
      final bottomToReplyResponse = await LMChatCore.client
          .getConversation(bottomToReplyConversationBuilder.build());

      // convert [Conversation] list to [LMChatConversationViewData] list
      final bottomConversationsVewData =
          bottomToReplyResponse.data!.conversationData!.map((e) {
        return e.toConversationViewData(
          conversationPollsMeta:
              bottomToReplyResponse.data!.conversationPollsMeta,
          userMeta: bottomToReplyResponse.data!.userMeta,
        );
      }).toList();

      // fetch 100 conversations from the top of the list
      final GetConversationRequestBuilder topToReplyConversationBuilder =
          GetConversationRequestBuilder()
            ..chatroomId(chatroomId)
            ..page(1)
            ..pageSize(100)
            ..isLocalDB(true)
            ..minTimestamp(0)
            ..maxTimestamp(replyConversationsVewData.first.createdEpoch!);

      // [Data Layer] function call
      final topToReplyResponse = await LMChatCore.client
          .getConversation(topToReplyConversationBuilder.build());

      // convert [Conversation] list to [LMChatConversationViewData] list
      final topConversationsViewData =
          topToReplyResponse.data!.conversationData!.map((e) {
        return e.toConversationViewData(
          conversationPollsMeta: topToReplyResponse.data!.conversationPollsMeta,
          userMeta: topToReplyResponse.data!.userMeta,
        );
      }).toList();

      // add all the conversations to the list
      List<LMChatConversationViewData> allConversations = [];

      // add bottom conversation in reversed order
      allConversations.addAll(bottomConversationsVewData.reversed);
      // add top conversation
      allConversations.addAll(topConversationsViewData);
      // add the new conversation to pagedList
      pagedListController.addAll(allConversations);
      // reset the pages
      _topPage = 2;
      _bottomPage = 2;
      rebuildConversationList.value = !rebuildConversationList.value;
      // find index of the conversation in the list and scroll to it
      int index = pagedListController.itemList
          .indexWhere((element) => element.id == replyId);
      if (index != -1) {
        // scroll and highlight the conversation
        _scrollToConversation(index, replyId, pagedListController);
      }
    }
  }

  void _scrollToConversation(int index, int replyId,
      LMDualSidePaginationController pagedListController) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      pagedListController.listController.animateToItem(
        index: index,
        scrollController: pagedListController.scrollController,
        alignment: 0.5,
        duration: (estimatedDuration) {
          return const Duration(milliseconds: 200);
        },
        curve: (estimatedDuration) {
          return Curves.easeInOut;
        },
      );
      // highlight the reply message
      _highLightConversation(replyId);
    });
  }

  Future<void> _highLightConversation(int replyId) async {
    // highlight the reply message
    // set replyId to [_animateToChatId] flag
    // used to detect if we have to show a selection animation
    // with the help of AnimatedContainer in [LMChatBubble]
    _animateToChatId = replyId;
    rebuildConversationList.value = !rebuildConversationList.value;
    // it is essential for showing an animation with better visibility
    await Future.delayed(const Duration(milliseconds: 1000));
    // again setting [_animateToChatId] to null for removing selection state
    _animateToChatId = null;
    rebuildConversationList.value = !rebuildConversationList.value;
  }
}
