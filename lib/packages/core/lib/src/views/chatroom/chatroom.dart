import 'dart:io';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/blocs.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/observer.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/chatroom/chatroom_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/member_rights/member_rights.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_core/src/views/chatroom/configurations/config.dart';
import 'package:likeminds_chat_flutter_core/src/views/report/report.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/widgets.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:overlay_support/overlay_support.dart';

/// {@template chatroom_screen}
/// Chatroom screen is the main screen where the user can chat with other users.
/// It has a chatroom list, chatroom bar, and chatroom menu.
///  {@endtemplate}
class LMChatroomScreen extends StatefulWidget {
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

  ScrollController scrollController = ScrollController();
  PagingController<int, LMChatConversationViewData> pagedListController =
      PagingController<int, LMChatConversationViewData>(firstPageKey: 1);

  final List<int> _selectedIds = <int>[];
  final LMChatroomBuilderDelegate _screenBuilder =
      LMChatCore.config.chatRoomConfig.builder;
  final CustomPopupMenuController _menuController = CustomPopupMenuController();
  final MemberStateResponse? getMemberState =
      LMChatLocalPreference.instance.getMemberRights();

  bool isAnyMessageSelected() {
    return _selectedIds.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    Bloc.observer = LMChatBlocObserver();
    currentUser = LMChatLocalPreference.instance.getUser();
    _chatroomBloc = LMChatroomBloc.instance
      ..add(LMChatFetchChatroomEvent(chatroomId: widget.chatroomId));
    _chatroomActionBloc = LMChatroomActionBloc.instance;
    _conversationBloc = LMChatConversationBloc.instance;
    _convActionBloc = LMChatConversationActionBloc.instance;
    scrollController.addListener(() {
      _showScrollToBottomButton();
    });
  }

  @override
  void didUpdateWidget(LMChatroomScreen old) {
    super.didUpdateWidget(old);
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
    super.didChangeDependencies();
    ScreenSize.init(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deactivate() {
    _chatroomBloc.close();
    _convActionBloc.close();
    _chatroomActionBloc.close();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return _screenBuilder.scaffold(
      backgroundColor: LMChatTheme.theme.backgroundColor,
      floatingActionButton: ValueListenableBuilder(
        valueListenable: rebuildFloatingButton,
        builder: (context, _, __) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: Platform.isIOS ? 48.0 : 72.0,
              right: Platform.isIOS ? 2 : 6,
            ),
            child: showScrollButton
                ? _screenBuilder.floatingActionButton(_defaultScrollButton())
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
              _conversationBloc.add(LMChatInitialiseConversationsEvent(
                chatroomId: chatroom.id,
                conversationId: lastConversationId,
              ));
              _chatroomActionBloc.add(MarkReadChatroomEvent(
                chatroomId: chatroom.id,
              ));
              LMAnalytics.get().track(
                AnalyticsKeys.syncComplete,
                {'sync_complete': true},
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
                    ),
                  ),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: rebuildConversationList,
                      builder: (context, value, child) {
                        return _chatroomList();
                      },
                    ),
                  ),
                  _screenBuilder.chatBarBuilder(
                    context,
                    LMChatroomBar(
                      chatroom: chatroom.toChatRoomViewData(),
                      scrollToBottom: _scrollToBottom,
                    ),
                  ),
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
      scrollController: scrollController,
      listController: pagedListController,
    );
  }

  LMChatConversationList _defaultConvList() {
    return LMChatConversationList(
      chatroomId: widget.chatroomId,
      appBarNotifier: rebuildAppBar,
      selectedConversations: _selectedIds,
      scrollController: scrollController,
      listController: pagedListController,
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
        padding: const EdgeInsets.symmetric(horizontal: 18),
        gap: 3.w,
      ),
      leading: LMChatButton(
        onTap: () {
          if (_selectedIds.isNotEmpty) {
            _selectedIds.clear();
            rebuildAppBar.value = !rebuildAppBar.value;
            rebuildConversationList.value = !rebuildConversationList.value;
          } else {
            Navigator.of(context).pop();
            _chatroomActionBloc.add(
              MarkReadChatroomEvent(
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
              color: LMChatTheme.theme.onPrimary,
              size: 20,
              boxSize: 28,
            ),
          ),
          backgroundColor: LMChatTheme.theme.primaryColor,
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
                      fallbackText: chatroom.header,
                      style: LMChatProfilePictureStyle(
                        size: 42,
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
      trailing: [
        ValueListenableBuilder(
            valueListenable: rebuildAppBar,
            builder: (context, _, __) {
              return isAnyMessageSelected()
                  ? Row(
                      children: _defaultSelectedChatroomMenu(),
                    )
                  : _screenBuilder.chatroomMenu(
                      context,
                      actions,
                      _defaultChatroomMenu(),
                    );
            }),
      ],
    );
  }

  List<Widget> _defaultSelectedChatroomMenu() {
    final LMChatConversationViewData? conversationViewData = pagedListController
        .value.itemList
        ?.firstWhere((element) => element.id == _selectedIds.first);

    bool haveDeletePermission = conversationViewData != null &&
        LMChatMemberRightUtil.checkDeletePermissions(conversationViewData) &&
        chatroom.chatRequestState != 2;
    bool haveEditPermission =
        LMChatMemberRightUtil.checkEditPermissions(conversationViewData!) &&
            chatroom.chatRequestState != 2;
    return [
      // Reply button
      if (_selectedIds.length == 1 && _isRespondingAllowed()) ...[
        const SizedBox(width: 8),
        _screenBuilder.replyButton(
            context,
            conversationViewData,
            LMChatButton(
              onTap: () {
                // add reply event
                _convActionBloc.add(
                  LMChatReplyConversationEvent(
                    conversationId: conversationViewData.id,
                    chatroomId: widget.chatroomId,
                    replyConversation: conversationViewData,
                    attachments: conversationViewData.attachments,
                  ),
                );
                _selectedIds.clear();
                rebuildAppBar.value = !rebuildAppBar.value;
                rebuildConversationList.value = !rebuildConversationList.value;
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
            )),
      ],
      // Copy button
      ...[
        const SizedBox(width: 8),
        _screenBuilder.copyButton(
          context,
          pagedListController.value.itemList
                  ?.where(
                      (conversation) => _selectedIds.contains(conversation.id))
                  .toList() ??
              [],
          LMChatButton(
            onTap: () {
              // Store the answer in the clipboard
              // and show a toast message
              // if _selectedIds is more than 1, then copy answer with
              // [date and time] conversation user name : answer format
              bool isMultiple = _selectedIds.length > 1;
              String copiedMessage = "";
              if (isMultiple) {
                for (int id in _selectedIds) {
                  LMChatConversationViewData conversation = pagedListController
                      .value.itemList!
                      .firstWhere((element) => element.id == id);
                  copiedMessage +=
                      "[${conversation.date}] ${conversation.member!.name} : ${conversation.answer}\n";
                }
              } else {
                copiedMessage = conversationViewData.answer;
              }
              Clipboard.setData(
                ClipboardData(text: copiedMessage),
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
        ),
      ],
      // Edit button
      if (haveEditPermission && _selectedIds.length == 1) ...[
        const SizedBox(width: 8),
        _screenBuilder.editButton(
          context,
          conversationViewData,
          LMChatButton(
            onTap: () {
              _selectedIds.clear();
              _convActionBloc.add(
                LMChatEditingConversationEvent(
                  conversationId: conversationViewData.id,
                  chatroomId: widget.chatroomId,
                  editConversation: conversationViewData,
                ),
              );
              rebuildAppBar.value = !rebuildAppBar.value;
              rebuildConversationList.value = !rebuildConversationList.value;
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
      ],
      // Delete button
      if (haveDeletePermission && _selectedIds.length == 1) ...[
        const SizedBox(width: 8),
        _screenBuilder.deleteButton(
          context,
          conversationViewData,
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
                          rebuildConversationList.value =
                              !rebuildConversationList.value;
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
          ),
        ),
      ],
      // pop up menu button for report
      if (_selectedIds.length == 1 &&
          LMChatMemberRightUtil.isReportAllowed(conversationViewData) &&
          chatroom.chatRequestState != 2) ...[
        const SizedBox(width: 8),
        _screenBuilder.moreOptionButton(
          context,
          _moreAction,
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
                    _moreAction(conversationViewData);
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
      ]
    ];
  }

  void _moreAction(LMChatConversationViewData conversationViewData) {
    _selectedIds.clear();
    rebuildAppBar.value = !rebuildAppBar.value;
    rebuildConversationList.value = !rebuildConversationList.value;
    context.push(
      LMChatReportScreen(
        entityId: conversationViewData.id.toString(),
        entityCreatorId: conversationViewData.member!.id.toString(),
        entityType: 3,
      ),
    );
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
            boxPadding: const EdgeInsets.all(2),
            color: LMChatTheme.theme.onContainer,
          ),
        ),
      ),
    );
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
}
