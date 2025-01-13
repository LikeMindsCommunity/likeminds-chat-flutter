// ignore_for_file: unused_import

import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/convertors.dart';
import 'package:likeminds_chat_flutter_core/src/utils/constants/assets.dart';
import 'package:likeminds_chat_flutter_core/src/utils/media/audio_handler.dart';
import 'package:likeminds_chat_flutter_core/src/views/poll/poll_handler.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:intl/intl.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class LMChatConversationList extends StatefulWidget {
  final int chatroomId;

  final List<int>? selectedConversations;

  final ValueNotifier<bool>? appBarNotifier;

  final LMDualSidePaginationController<LMChatConversationViewData>?
      paginatedListController;

  /// Creates a new instance of LMChatConversationList
  const LMChatConversationList({
    super.key,
    required this.chatroomId,
    this.selectedConversations,
    this.appBarNotifier,
    this.paginatedListController,
  });

  @override
  State<LMChatConversationList> createState() => _LMChatConversationListState();
}

class _LMChatConversationListState extends State<LMChatConversationList> {
  late LMChatConversationBloc _conversationBloc;
  late LMChatConversationActionBloc _convActionBloc;

  late User user;
  int _topPage = 1;
  int _bottomPage = 1;
  final int _pageSize = 200;
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
  final LMChatThemeData theme = LMChatTheme.theme;
  int? replyId;

  @override
  void initState() {
    super.initState();
    user = LMChatLocalPreference.instance.getUser();
    _conversationBloc = LMChatConversationBloc.instance;
    _convActionBloc = LMChatConversationActionBloc.instance;
    _selectedIds = widget.selectedConversations ?? [];
    rebuildAppBar = widget.appBarNotifier ?? ValueNotifier(false);
    // setting the reply conversation to null
    // to avoid any previous reply conversation
    LMChatConversationBloc.replyConversation = null;
  }

  @override
  void didUpdateWidget(covariant LMChatConversationList oldWidget) {
    super.didUpdateWidget(oldWidget);
    user = LMChatLocalPreference.instance.getUser();
    _conversationBloc = LMChatConversationBloc.instance;
    _convActionBloc = LMChatConversationActionBloc.instance;
    _selectedIds = widget.selectedConversations ?? [];
    rebuildAppBar = widget.appBarNotifier ?? ValueNotifier(false);
  }

  @override
  void dispose() {
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
              _updateEditedConversation(state.conversationViewData);
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
        )
      ],
      child: ValueListenableBuilder(
        valueListenable: rebuildConversationList,
        builder: (context, value, child) {
          return LMDualSidePagedList<LMChatConversationViewData>(
            paginationType: LMChatConversationBloc.replyConversation == null
                ? LMPaginationType.top
                : LMPaginationType.both,
            initialPage: 1,
            onPaginationTriggered: _onPaginationTriggered,
            paginationController: pagedListController,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            reverse: true,
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
            noItemsFoundIndicatorBuilder: (context) {
              return _defaultEmptyView();
            },
            itemBuilder: (context, item, index) {
              if (item.isTimeStamp != null && item.isTimeStamp! ||
                  item.state != 0 && item.state != 10 && item.state != null) {
                final stateMessage =
                    LMChatTaggingHelper.extractStateMessage(item.answer);
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
    LMChatConversationViewData? replyConversation =
        LMChatConversationBloc.replyConversation;
    _conversationBloc.add(
      LMChatFetchConversationsEvent(
        minTimestamp: replyConversation == null
            ? null
            : direction == LMPaginationDirection.bottom
                ? replyConversation!.createdEpoch
                : null,
        maxTimestamp: replyConversation == null
            ? null
            : direction == LMPaginationDirection.top
                ? replyConversation!.createdEpoch
                : null,
        chatroomId: widget.chatroomId,
        page: pageKey,
        pageSize: _pageSize,
        direction: direction,
        lastConversationId: lastConversationId,
        replyId: replyId,
        orderBy: direction == LMPaginationDirection.bottom
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
      poll: _defPoll(conversation),
      userMeta: userMeta.map((id, user) {
        return MapEntry(id, user!.toUserViewData());
      }),
      audioHandler: LMChatCoreAudioHandler.instance,
      onTagTap: (tag) {},
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
      style: LMChatBubbleStyle.basic().copyWith(
        showHeader: false,
      ),
      isSelected: _selectedIds.contains(conversation.id) ||
          _animateToChatId == conversation.id,
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
    );
  }

  LMChatPoll _defPoll(LMChatConversationViewData conversation) {
    ValueNotifier<bool> rebuildPoll = ValueNotifier(false);
    final List<int> selectedOptions = [];
    bool isVoteEditing = false;

    return LMChatPoll(
      style: theme.pollStyle,
      rebuildPollWidget: rebuildPoll,
      pollData: conversation,
      selectedOption: selectedOptions,
      onEditVote: (pollData) {
        isVoteEditing = true;
        selectedOptions.clear();
        pollData.poll?.forEach((element) {
          if ((element.isSelected ?? false)) {
            selectedOptions.add(element.id!);
          }
        });
        rebuildPoll.value = !rebuildPoll.value;
      },
      onSubmit: (options) {
        submitVote(
          context,
          conversation,
          options,
          {},
          conversation.copyWith(),
          widget.chatroomId,
        );
      },
      onOptionSelect: (option) {
        // if poll has ended, then do not allow to vote
        if (LMChatPollUtils.hasPollEnded(
            conversation.expiryTime, conversation.noPollExpiry)) {
          return;
        }
        // if poll is submitted and not editing votes, then do not allow to vote
        if (LMChatPollUtils.isPollSubmitted(conversation.poll ?? []) &&
            !isVoteEditing) {
          return;
        }
        // if multiple select is enabled, then add the option to the selected options
        // else submit the vote
        if (LMChatPollUtils.isMultiChoicePoll(
            conversation.multipleSelectNo, conversation.multipleSelectState)) {
          if (selectedOptions.contains(option.id)) {
            selectedOptions.remove(option.id);
          } else {
            if (option.id != null) {
              selectedOptions.add(option.id!);
            }
          }
          rebuildPoll.value = !rebuildPoll.value;
        } else {
          submitVote(
            context,
            conversation,
            [option],
            {},
            conversation.copyWith(),
            widget.chatroomId,
          );
        }
      },
      onAddOptionSubmit: (optionText) async {
        await addOption(
          context,
          conversation,
          optionText,
          user.toUserViewData(),
          rebuildPoll,
          LMChatWidgetSource.chatroom,
        );
        rebuildConversationList.value = !rebuildConversationList.value;
      },
      onVoteClick: (option) {
        onVoteTextTap(
          context,
          conversation,
          LMChatWidgetSource.chatroom,
          option: option,
        );
      },
      onAnswerTextTap: () {
        onVoteTextTap(
          context,
          conversation,
          LMChatWidgetSource.chatroom,
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
      poll: _defPoll(conversation),
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
      style: LMChatBubbleStyle.basic(),
      avatar: LMChatProfilePicture(
        fallbackText: conversation.member!.name,
        imageUrl: conversation.member!.imageUrl,
        style: const LMChatProfilePictureStyle(
          size: 39,
          boxShape: BoxShape.circle,
        ),
      ),
      avatarBuilder: (context, avatar) {
        if (conversation.conversationViewType ==
            LMChatConversationViewType.bottom) {
          return const SizedBox(
            width: 39,
          );
        }
        return avatar;
      },
      isSelected: _selectedIds.contains(conversation.id) ||
          _animateToChatId == conversation.id,
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

  Future<void> updatePagingControllers(LMChatConversationState state) async {
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
      List<LMChatConversationViewData>? conversationData =
          state.getConversationResponse.conversationData?.map((e) {
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
      }).toList();

      if (state.direction == LMPaginationDirection.bottom) {
        conversationData = conversationData?.reversed.toList();
      }
      if (state.page == 1) {
        conversationData =
            groupConversationsAndAddDates(conversationData ?? []);
      } else {
        conversationData = updatePaginationConversationsViewType(
            pagedListController.itemList, conversationData ?? []);
      }
      if (state.getConversationResponse.conversationData == null ||
          state.getConversationResponse.conversationData!.isEmpty ||
          state.getConversationResponse.conversationData!.length < _pageSize) {
        if (state.direction == LMPaginationDirection.top) {
          _bottomPage++;
          pagedListController.appendLastPageToEnd(conversationData);
        } else {
          _topPage++;
          pagedListController
              .appendFirstPageToStart(conversationData.reversed.toList());
        }
      } else {
        if (state.direction == LMPaginationDirection.top) {
          _bottomPage++;
          pagedListController.appendPageToEnd(conversationData, _bottomPage);
        } else {
          _topPage++;
          pagedListController.appendPageToStart(
              conversationData.toList(), _topPage);
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

      // Add reply conversation object if exists
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

  // This function adds local conversation to the paging controller
  // and rebuilds the list to reflect UI changes
  void addLocalConversationToPagedList(
      LMChatConversationViewData conversation) {
    LMChatConversationViewData? result;
    List<LMChatConversationViewData> conversationList =
        pagedListController.itemList;

    // Handle reply conversation logic
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

    // Check if we need to add a timestamp message
    if (conversationList.isNotEmpty &&
        conversationList.first.date != conversation.date) {
      // Add timestamp message before the new conversation
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

    // check if the new conversation is by the same user as last conversation
    // if yes, then add the conversation to the same group by assigning view type - bottom
    if (conversationList.isNotEmpty &&
        conversationList.first.memberId == conversation.memberId) {
      result = result.copyWith(
          conversationViewType: LMChatConversationViewType.bottom);
    }

    // Add the actual conversation
    conversationList.insert(0, result);
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
        pagedListController.itemList;

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
    // check if the new conversation is by the same user as last conversation
    // if yes, then add the conversation to the same group by assigning view type - bottom
    if (conversationList.isNotEmpty &&
        conversationList.first.memberId == conversation.memberId) {
      result = result.copyWith(
          conversationViewType: LMChatConversationViewType.bottom);
    }
    if (index != -1) {
      conversationList[index] = result;
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
      // add the actual conversation
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
        pagedListController.itemList;

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
      duration: const Duration(milliseconds: 10),
      curve: Curves.easeOut,
    );
    rebuildConversationList.value = !rebuildConversationList.value;
  }

  void _updateEditedConversation(
      LMChatConversationViewData editedConversation) {
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
        LMChatConversationBloc.replyConversation =
            replyConversationsVewData.first;
      }

      // fetch 100 conversations from the bottom of the list
      final GetConversationRequestBuilder bottomToReplyConversationBuilder =
          GetConversationRequestBuilder()
            ..chatroomId(chatroomId)
            ..page(1)
            ..pageSize(_pageSize)
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
            ..pageSize(_pageSize)
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
      // update conversation view type
      allConversations = groupConversationsAndAddDates(allConversations);
      // add the new conversation to pagedList
      pagedListController.addAll(allConversations);
      // reset the pages
      _topPage = 2;
      _bottomPage = 2;
      // set last page reached to true in case of no more data
      if (bottomConversationsVewData.length < _pageSize) {
        pagedListController.isLastPageToTopReached = true;
      }
      if (topConversationsViewData.length < _pageSize) {
        pagedListController.isLastPageToBottomReached = true;
      }
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
  }

  Future<void> _highLightConversation(int replyId) async {
    // highlight the reply message
    // set replyId to [_animateToChatId] flag
    // used to detect if we have to show a selection animation
    // with the help of AnimatedContainer in [LMChatBubble]
    _animateToChatId = replyId;
    rebuildConversationList.value = !rebuildConversationList.value;
    // it is essential for showing an animation with better visibility
    await Future.delayed(const Duration(milliseconds: 1500));
    // again setting [_animateToChatId] to null for removing selection state
    _animateToChatId = null;
    rebuildConversationList.value = !rebuildConversationList.value;
  }
}
