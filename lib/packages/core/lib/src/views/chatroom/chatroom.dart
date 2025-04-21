import 'dart:io';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/blocs.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/observer.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/chatroom/chatroom_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/media/audio_handler.dart';
import 'package:likeminds_chat_flutter_core/src/utils/member_rights/member_rights.dart';
import 'package:likeminds_chat_flutter_core/src/utils/realtime/realtime.dart';
import 'package:likeminds_chat_flutter_core/src/utils/conversation/conversation_action_helper.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_core/src/views/chatroom/configurations/config.dart';
import 'package:likeminds_chat_flutter_core/src/views/views.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/widgets.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

/// {@template chatroom_screen}
/// Chatroom screen is the main screen where the user can chat with other users.
/// It has a chatroom list, chatroom bar, and chatroom menu.
///  {@endtemplate}
class LMChatroomScreen extends StatefulWidget {
  static const routeName = '/chatroom';

  /// [chatroomId] is the id of the chatroom.
  final int chatroomId;

  /// {@macro chatroom_screen}
  const LMChatroomScreen({
    super.key,
    required this.chatroomId,
  });

  @override
  State<LMChatroomScreen> createState() => _LMChatroomScreenState();
}

class _LMChatroomScreenState extends State<LMChatroomScreen> {
  late LMChatroomBloc _chatroomBloc;
  late LMChatroomActionBloc _chatroomActionBloc;
  late LMChatConversationBloc _conversationBloc;
  late LMChatConversationActionBloc _convActionBloc;
  late LMChatConversationActionHelper _conversationActionHelper;

  late ChatRoom chatroom;
  late User currentUser;
  List<ChatroomAction> actions = [];
  Conversation? localTopic;

  int lastConversationId = 0;
  bool showChatTopic = true;
  bool showScrollButton = false;

  ValueNotifier<bool> rebuildConversationList = ValueNotifier(false);
  ValueNotifier<bool> rebuildChatBar = ValueNotifier(false);
  ValueNotifier<bool> rebuildChatTopic = ValueNotifier(true);
  ValueNotifier<bool> rebuildAppBar = ValueNotifier(false);
  ValueNotifier<bool> rebuildFloatingButton = ValueNotifier(false);

  final ScrollController scrollController = ScrollController();
  final ListController listController = ListController();
  late LMDualSidePaginationController<LMChatConversationViewData>
      pagedListController = LMDualSidePaginationController(
    listController: listController,
    scrollController: scrollController,
  );

  final List<int> _selectedIds = <int>[];
  final LMChatroomBuilderDelegate _screenBuilder =
      LMChatCore.config.chatRoomConfig.builder;
  final LMChatroomSetting _chatroomSetting =
      LMChatCore.config.chatRoomConfig.setting;
  final CustomPopupMenuController _menuController = CustomPopupMenuController();
  final MemberStateResponse? getMemberState =
      LMChatLocalPreference.instance.getMemberRights();
  final _webConfiguration = LMChatCore.config.webConfiguration;

  bool isAnyMessageSelected() {
    return _selectedIds.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    LMChatRealtime.instance.chatroomId = widget.chatroomId;
    Bloc.observer = LMChatBlocObserver();
    currentUser = LMChatLocalPreference.instance.getUser();
    _chatroomBloc = LMChatroomBloc.instance
      ..add(LMChatFetchChatroomEvent(chatroomId: widget.chatroomId));
    _chatroomActionBloc = LMChatroomActionBloc.instance;
    _conversationBloc = LMChatConversationBloc.instance;
    _convActionBloc = LMChatConversationActionBloc.instance;
    _conversationActionHelper = LMChatConversationActionHelper(
      selectionType:
          _chatroomSetting.selectionType ?? LMChatSelectionType.appbar,
      selectedIds: _selectedIds,
      onResetSelection: _resetSelection,
      convActionBloc: _convActionBloc,
      chatroomId: widget.chatroomId,
      conversations: pagedListController.itemList,
      chatRequestState: 0, //TODO: update proper chat request state
    );
    scrollController.addListener(() {
      _showScrollToBottomButton();
    });
  }

  @override
  void didUpdateWidget(LMChatroomScreen old) {
    super.didUpdateWidget(old);
    LMChatRealtime.instance.chatroomId = widget.chatroomId;
    Bloc.observer = LMChatBlocObserver();
    currentUser = LMChatLocalPreference.instance.getUser();
    _chatroomBloc = LMChatroomBloc.instance;
    _chatroomActionBloc = LMChatroomActionBloc.instance;
    _conversationBloc = LMChatConversationBloc.instance;
    _convActionBloc = LMChatConversationActionBloc.instance;
    scrollController.addListener(() {
      _showScrollToBottomButton();
    });
  }

  @override
  void didChangeDependencies() {
    LMChatRealtime.instance.chatroomId = widget.chatroomId;
    _chatroomBloc = LMChatroomBloc.instance;
    _chatroomActionBloc = LMChatroomActionBloc.instance;
    _conversationBloc = LMChatConversationBloc.instance;
    _convActionBloc = LMChatConversationActionBloc.instance;
    ScreenSize.init(context,
        setWidth: kIsWeb ? _webConfiguration.maxWidth : null);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    LMChatRealtime.instance.chatroomId = null;
    _chatroomBloc.close();
    _convActionBloc.close();
    _conversationBloc.close();
    _chatroomActionBloc.close();
    scrollController.removeListener(
        _showScrollToBottomButton); // Good practice to remove listeners
    scrollController.dispose(); // Dispose controllers owned by this state
    _menuController.dispose(); // Dispose controllers owned by this state
    // Dispose ValueNotifiers if they are exclusively used by this screen instance
    rebuildConversationList.dispose();
    rebuildChatBar.dispose();
    rebuildChatTopic.dispose();
    rebuildAppBar.dispose();
    rebuildFloatingButton.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: _webConfiguration.maxWidth,
        ),
        child: ValueListenableBuilder(
            valueListenable: LMChatTheme.themeNotifier,
            builder: (context, _, child) {
              return _screenBuilder.scaffold(
                resizeToAvoidBottomInset: true,
                onPopInvoked: (p) {
                  _chatroomActionBloc.add(LMChatMarkReadChatroomEvent(
                    chatroomId: chatroom.id,
                  ));
                  if (LMChatCoreAudioHandler.instance.player.isPlaying ||
                      LMChatCoreAudioHandler.instance.recorder.isRecording) {
                    LMChatCoreAudioHandler.instance.stopAudio();
                    LMChatCoreAudioHandler.instance.stopRecording();
                  }
                },
                backgroundColor: LMChatTheme.theme.backgroundColor,
                floatingActionButton: ValueListenableBuilder(
                  valueListenable: rebuildFloatingButton,
                  builder: (context, _, __) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: kIsWeb
                            ? 64.0
                            : Platform.isIOS
                                ? 64.0
                                : 96.0,
                        right: kIsWeb
                            ? 2.0
                            : Platform.isIOS
                                ? 2
                                : 4,
                      ),
                      child: showScrollButton
                          ? _screenBuilder
                              .floatingActionButton(_defaultScrollButton())
                          : null,
                    );
                  },
                ),
                body: SafeArea(
                  bottom: false,
                  child: BlocConsumer<LMChatroomBloc, LMChatroomState>(
                    bloc: _chatroomBloc,
                    listener: (context, state) {
                      if (state is LMChatroomLoadedState) {
                        chatroom = state.chatroom;
                        lastConversationId = state.lastConversationId;
                        _conversationBloc
                            .add(LMChatInitialiseConversationsEvent(
                          chatroomId: chatroom.id,
                          conversationId: lastConversationId,
                        ));
                        _chatroomActionBloc.add(LMChatMarkReadChatroomEvent(
                          chatroomId: chatroom.id,
                        ));
                        LMChatAnalyticsBloc.instance.add(
                          const LMChatFireAnalyticsEvent(
                            eventName: LMChatAnalyticsKeys.syncComplete,
                            eventProperties: {'sync_complete': true},
                          ),
                        );
                        LMChatAnalyticsBloc.instance.add(
                          LMChatFireAnalyticsEvent(
                            eventName: LMChatAnalyticsKeys.chatroomOpened,
                            eventProperties: {
                              'chatroom_id': chatroom.id,
                              'community_id': chatroom.communityId,
                              'chatroom_type': chatroom.type,
                              'source': 'home_feed',
                            },
                          ),
                        );
                        updateChatBotChatroom();
                      }
                    },
                    builder: (chatroomContext, chatroomState) {
                      if (chatroomState is LMChatroomLoadedState) {
                        chatroom = chatroomState.chatroom;
                        actions = chatroomState.actions;
                        return Column(
                          children: [
                            BlocListener<LMChatConversationActionBloc,
                                LMChatConversationActionState>(
                              bloc: _convActionBloc,
                              listener: (context, state) {
                                if (state is LMChatRefreshBarState) {
                                  chatroom = state.chatroom.toChatRoom();
                                }
                              },
                              child: _screenBuilder.appBarBuilder.call(
                                context,
                                chatroom.toChatRoomViewData(),
                                _defaultAppBar(
                                  chatroom,
                                  chatroomState.participantCount,
                                ),
                                chatroomState.participantCount,
                              ),
                            ),
                            Expanded(
                              child: Listener(
                                behavior: HitTestBehavior.opaque,
                                onPointerDown: (_) {
                                  if (FocusScope.of(context).hasFocus) {
                                    FocusScope.of(context).unfocus();
                                  }
                                },
                                child: ValueListenableBuilder(
                                  valueListenable: rebuildConversationList,
                                  builder: (context, value, child) {
                                    return _chatroomList();
                                  },
                                ),
                              ),
                            ),
                            BlocBuilder(
                                bloc: _chatroomActionBloc,
                                builder: (context, state) {
                                  if (state is LMChatShowEmojiKeyboardState) {
                                    return SafeArea(
                                      child: LMChatReactionKeyboard(
                                        onEmojiSelected: (reaction) {
                                          LMChatAnalyticsBloc.instance.add(
                                            LMChatFireAnalyticsEvent(
                                              eventName: LMChatAnalyticsKeys
                                                  .reactionAdded,
                                              eventProperties: {
                                                'reaction': reaction,
                                                'from': 'keyboard',
                                                'message_id':
                                                    state.conversationId,
                                                'chatroom_id': chatroom.id,
                                              },
                                            ),
                                          );
                                          _convActionBloc.add(
                                            LMChatPutReaction(
                                              conversationId:
                                                  state.conversationId,
                                              reaction: reaction,
                                            ),
                                          );
                                          _chatroomActionBloc.add(
                                            LMChatHideEmojiKeyboardEvent(),
                                          );
                                        },
                                      ),
                                    );
                                  }
                                  return _screenBuilder.chatBarBuilder(
                                    context,
                                    LMChatroomBar(
                                      chatroom: chatroom.toChatRoomViewData(),
                                      scrollToBottom: _scrollToBottom,
                                      enableTagging: chatroom.type != 10,
                                    ),
                                  );
                                }),
                            if (isOtherUserAIChatbot(
                                chatroom.toChatRoomViewData()))
                              LMChatText(
                                "AI may make mistakes",
                                style: LMChatTextStyle(
                                  padding: const EdgeInsets.only(
                                    bottom: 10,
                                    top: 6,
                                  ),
                                  textStyle: TextStyle(
                                    color: LMChatTheme.theme.onContainer
                                        .withOpacity(0.6),
                                  ),
                                ),
                              )
                          ],
                        );
                      }
                      return _screenBuilder.loadingPageWidgetBuilder(
                        context,
                        const LMChatSkeletonChatPage(),
                      );
                    },
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget _chatroomList() {
    return chatroom.type != 10
        ? _screenBuilder.conversationList(
            chatroom.id,
            _defaultConvList(),
          )
        : _screenBuilder.dmConversationList(
            chatroom.id,
            _defaultDMConvList(),
          );
  }

  LMChatDMConversationList _defaultDMConvList() {
    return LMChatDMConversationList(
      chatroomId: widget.chatroomId,
      appBarNotifier: rebuildAppBar,
      selectedConversations: _selectedIds,
      isOtherUserAIChatbot: isOtherUserAIChatbot(
        chatroom.toChatRoomViewData(),
      ),
      conversationHelper: _conversationActionHelper,
      paginatedListController: pagedListController,
    );
  }

  LMChatConversationList _defaultConvList() {
    return LMChatConversationList(
      chatroomId: widget.chatroomId,
      appBarNotifier: rebuildAppBar,
      selectedConversations: _selectedIds,
      paginatedListController: pagedListController,
      conversationHelper: _conversationActionHelper,
    );
  }

  LMChatAppBar _defaultAppBar(
    ChatRoom chatroom,
    int participants,
  ) {
    User? chatUser;
    if (chatroom.type! == 10) {
      chatUser = currentUser.id == chatroom.chatroomWithUser!.id
          ? chatroom.member!
          : chatroom.chatroomWithUser!;
    }
    return LMChatAppBar(
      style: LMChatAppBarStyle(
        height: 72,
        gap: 2.6.w,
        backgroundColor: LMChatTheme.theme.container,
        padding: const EdgeInsets.symmetric(horizontal: 18),
      ),
      leading: LMChatButton(
        onTap: () {
          if (_selectedIds.isNotEmpty) {
            _selectedIds.clear();
            rebuildAppBar.value = !rebuildAppBar.value;
            rebuildConversationList.value = !rebuildConversationList.value;
          } else {
            LMChatCoreAudioHandler.instance.stopAudio();
            LMChatCoreAudioHandler.instance.stopRecording();
            Navigator.of(context).pop();
            _chatroomActionBloc.add(
              LMChatMarkReadChatroomEvent(
                chatroomId: widget.chatroomId,
              ),
            );
          }
        },
        style: LMChatButtonStyle(
          height: 28,
          width: 28,
          borderRadius: 6,
          padding: EdgeInsets.zero,
          icon: LMChatIcon(
            type: LMChatIconType.icon,
            icon: Icons.arrow_back,
            style: LMChatIconStyle(
              color: LMChatTheme.theme.onContainer,
              size: 24,
              boxSize: 28,
            ),
          ),
          backgroundColor: LMChatTheme.theme.container,
        ),
      ),
      banner: ValueListenableBuilder(
        valueListenable: rebuildAppBar,
        builder: (context, _, __) {
          return isAnyMessageSelected()
              ? const SizedBox.shrink()
              : chatroom.type! == 10
                  ? LMChatProfilePicture(
                      imageUrl: chatUser?.imageUrl ?? chatroom.chatroomImageUrl,
                      fallbackText: chatUser?.name ?? chatroom.header,
                      style: LMChatProfilePictureStyle(
                        size: 36,
                        backgroundColor: LMChatTheme.theme.primaryColor,
                      ),
                    )
                  : const SizedBox.shrink();
        },
      ),
      title: ValueListenableBuilder(
        valueListenable: rebuildAppBar,
        builder: (context, _, __) {
          return LMChatText(
            isAnyMessageSelected()
                ? _selectedIds.length.toString()
                : chatUser?.name ?? chatroom.header,
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
        },
      ),
      subtitle: chatroom.type != 10
          ? ValueListenableBuilder(
              valueListenable: rebuildAppBar,
              builder: (context, _, __) {
                return isAnyMessageSelected()
                    ? const SizedBox.shrink()
                    : LMChatText(
                        "${participants.toString()} participants",
                        style: const LMChatTextStyle(
                          textStyle: TextStyle(
                            color: LMChatDefaultTheme.greyColor,
                          ),
                        ),
                      );
              },
            )
          : const SizedBox.shrink(),
      trailing: isOtherUserAIChatbot(chatroom.toChatRoomViewData())
          ? []
          : [
              ValueListenableBuilder(
                valueListenable: rebuildAppBar,
                builder: (context, _, __) {
                  return (isAnyMessageSelected() &&
                              _chatroomSetting.selectionType ==
                                  LMChatSelectionType.appbar) ||
                          (isAnyMessageSelected() && _selectedIds.length > 1)
                      ? Row(
                          children: _defaultSelectedChatroomMenu(),
                        )
                      : Row(
                          children: [
                            _screenBuilder.searchButtomBuilder(
                              context,
                              chatroom.toChatRoomViewData(),
                              _defaultSearchButton(),
                            ),
                            _screenBuilder.chatroomMenu(
                              context,
                              actions,
                              _defaultChatroomMenu(),
                            ),
                          ],
                        );
                },
              ),
            ],
    );
  }

  LMChatButton _defaultSearchButton() {
    return LMChatButton(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LMChatSearchConversationScreen(
                chatRoomId: chatroom.id,
              ),
            ));
      },
      style: LMChatButtonStyle(
        height: 28,
        width: 28,
        borderRadius: 6,
        padding: EdgeInsets.zero,
        icon: LMChatIcon(
          type: LMChatIconType.icon,
          icon: Icons.search,
          style: LMChatIconStyle(
            color: LMChatTheme.theme.onContainer,
            size: 24,
            boxSize: 28,
          ),
        ),
        backgroundColor: LMChatTheme.theme.container,
      ),
    );
  }

  List<Widget> _defaultSelectedChatroomMenu() {
    final LMChatConversationViewData conversationViewData = pagedListController
        .itemList
        .firstWhere((element) => element.id == _selectedIds.first);
    final bool haveDeletePermission =
        LMChatMemberRightUtil.checkDeletePermissions(conversationViewData) &&
            chatroom.chatRequestState != 2;
    final bool haveEditPermission =
        LMChatMemberRightUtil.checkEditPermissions(conversationViewData) &&
            chatroom.chatRequestState != 2;
    final bool isVoiceNote = conversationViewData.attachments
            ?.any((attachment) => attachment.type == 'voice_note') ??
        false;

    final List<Widget> menuWidgets = [];

    // Reply option
    if (_selectedIds.length == 1 && _isRespondingAllowed()) {
      menuWidgets.addAll(_buildReplyOption(conversationViewData));
    }

    // Copy option - Only show if not a voice note
    if (!isVoiceNote) {
      menuWidgets.addAll(_buildCopyOption(conversationViewData));
    }

    // Edit option - Only show if not a voice note
    if (haveEditPermission && _selectedIds.length == 1 && !isVoiceNote) {
      menuWidgets.addAll(_buildEditOption(conversationViewData));
    }

    // Delete option
    if (haveDeletePermission) {
      menuWidgets.addAll(_buildDeleteOption(conversationViewData));
    }

    // Report option
    if (_selectedIds.length == 1 &&
        LMChatMemberRightUtil.isReportAllowed(conversationViewData) &&
        chatroom.chatRequestState != 2) {
      menuWidgets.addAll(_buildReportOption(conversationViewData));
    }

    return menuWidgets;
  }

  void _resetSelection() {
    _selectedIds.clear();
    rebuildAppBar.value = !rebuildAppBar.value;
    rebuildConversationList.value = !rebuildConversationList.value;
  }

  List<Widget> _buildReplyOption(
      LMChatConversationViewData conversationViewData) {
    return [
      const SizedBox(width: 8),
      _screenBuilder.replyButton(
        context,
        conversationViewData,
        LMChatButton(
          onTap: () {
            _conversationActionHelper.onReply(conversationViewData);
          },
          style: LMChatButtonStyle.basic().copyWith(
            icon: LMChatIcon(
              type: LMChatIconType.icon,
              icon: Icons.reply,
              style: LMChatIconStyle(
                color: LMChatTheme.theme.primaryColor,
              ),
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildCopyOption(
      LMChatConversationViewData conversationViewData) {
    return [
      const SizedBox(width: 8),
      _screenBuilder.copyButton(
        context,
        pagedListController.itemList
            .where((c) => _selectedIds.contains(c.id))
            .toList(),
        LMChatButton(
          onTap: () {
            _conversationActionHelper.onCopy(
              pagedListController.itemList
                  .where((c) => _selectedIds.contains(c.id))
                  .toList(),
            );
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
      ),
    ];
  }

  List<Widget> _buildEditOption(
      LMChatConversationViewData conversationViewData) {
    return [
      const SizedBox(width: 8),
      _screenBuilder.editButton(
        context,
        conversationViewData,
        LMChatButton(
          onTap: () {
            _conversationActionHelper.onEdit(conversationViewData);
          },
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
      ),
    ];
  }

  List<Widget> _buildDeleteOption(
      LMChatConversationViewData conversationViewData) {
    return [
      const SizedBox(width: 8),
      _screenBuilder.deleteButton(
        context,
        conversationViewData,
        LMChatButton(
          onTap: () {
            _conversationActionHelper.onDelete(context, [..._selectedIds]);
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
        ),
      ),
    ];
  }

  List<Widget> _buildReportOption(
      LMChatConversationViewData conversationViewData) {
    return [
      const SizedBox(width: 8),
      _screenBuilder.moreOptionButton(
        context,
        (conversation) =>
            _conversationActionHelper.onReport(conversation, context),
        CustomPopupMenu(
          pressType: PressType.singleClick,
          showArrow: false,
          controller: CustomPopupMenuController(),
          enablePassEvent: false,
          menuBuilder: () => ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60.w,
              color: LMChatTheme.theme.container,
              child: LMChatText(
                "Report Message",
                onTap: () {
                  _conversationActionHelper.onReport(
                      conversationViewData, context);
                },
                style: LMChatTextStyle(
                  maxLines: 1,
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: 2.h,
                  ),
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: LMChatTheme.theme.primaryColor,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
          child: LMChatIcon(
            type: LMChatIconType.icon,
            icon: Icons.more_vert_rounded,
            style: LMChatIconStyle(
              size: 28,
              color: LMChatTheme.theme.primaryColor,
            ),
          ),
        ),
      ),
    ];
  }

  LMChatroomMenu _defaultChatroomMenu() {
    return LMChatroomMenu(
      chatroom: chatroom,
      controller: _menuController,
      chatroomActions: actions,
    );
  }

  LMChatButton _defaultScrollButton() {
    return LMChatButton(
      onTap: () {
        _scrollToBottom(false);
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
            boxPadding: const EdgeInsets.all(2),
            color: LMChatTheme.theme.onContainer,
          ),
        ),
      ),
    );
  }

  void _scrollToBottom(bool isPostingNewConversation) {
    if (LMChatConversationBloc.replyConversation != null) {
      if (!isPostingNewConversation) {
        _conversationBloc.add(LMChatFetchConversationsEvent(
          chatroomId: widget.chatroomId,
          page: 1,
          pageSize: 200,
          direction: LMPaginationDirection.top,
          lastConversationId: lastConversationId,
          reInitialize: true,
        ));
      }
      LMChatConversationBloc.instance.stream.listen((state) async {
        if (state is LMChatConversationPostedState) {
          _conversationBloc.add(LMChatFetchConversationsEvent(
            chatroomId: widget.chatroomId,
            page: 1,
            pageSize: 200,
            direction: LMPaginationDirection.top,
            lastConversationId: lastConversationId,
            reInitialize: true,
          ));
          _scrollToBottom(isPostingNewConversation);
        }
        if (state is LMChatConversationLoadedState) {
          if (state.reInitialize) {
            LMChatConversationBloc.replyConversation = null;
            _scrollToBottom(isPostingNewConversation);
          }
        }
      });
    } else {
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
  }

  void _showScrollToBottomButton() {
    if (scrollController.position.pixels >
        scrollController.position.viewportDimension) {
      showScrollButton = true;
      rebuildFloatingButton.value = !rebuildFloatingButton.value;
    }
    if (scrollController.position.pixels <
        scrollController.position.viewportDimension) {
      showScrollButton = false;
      rebuildFloatingButton.value = !rebuildFloatingButton.value;
    }
  }

  bool _isRespondingAllowed() {
    if (getMemberState?.member?.state != 1 && chatroom.type == 7) {
      return false;
    } else if (!LMChatMemberRightUtil.checkRespondRights(getMemberState)) {
      return false;
    } else if (chatroom.chatRequestState == 2) {
      return false;
    } else {
      return true;
    }
  }

  void updateChatBotChatroom() {
    if (isOtherUserAIChatbot(chatroom.toChatRoomViewData()) &&
        widget.chatroomId !=
            LMChatLocalPreference.instance.getChatroomIdWithAIChatbot()) {
      LMChatLocalPreference.instance
          .storeChatroomIdWithAIChatbot(widget.chatroomId);
    }
  }
}
