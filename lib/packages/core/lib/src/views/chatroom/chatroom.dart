import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/blocs.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/observer.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/chatroom/chatroom_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/conversation/conversation_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/extension/list_extension.dart';
import 'package:likeminds_chat_flutter_core/src/utils/member_rights/member_rights.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_core/src/views/report/report.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/chatroom/chatroom_bar.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/chatroom/chatroom_menu.dart';
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

  ScrollController scrollController = ScrollController();
  PagingController<int, LMChatConversationViewData> pagedListController =
      PagingController<int, LMChatConversationViewData>(firstPageKey: 1);

  final List<int> _selectedIds = <int>[];
  final LMChatroomBuilderDelegate _screenBuilder =
      LMChatCore.config.chatRoomConfig.builder;

  bool isAnyMessageSelected() {
    return _selectedIds.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    Bloc.observer = LMChatBlocObserver();
    currentUser = LMChatLocalPreference.instance.getUser();
    _chatroomActionBloc = LMChatroomActionBloc.instance;
    _convActionBloc = LMChatConversationActionBloc.instance;
    _chatroomBloc = LMChatroomBloc.instance
      ..add(LMChatFetchChatroomEvent(chatroomId: widget.chatroomId));
    scrollController.addListener(() {
      _showScrollToBottomButton();
      _handleChatTopic();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ScreenSize.init(context);
  }

  @override
  void dispose() {
    _chatroomActionBloc.add(MarkReadChatroomEvent(
      chatroomId: widget.chatroomId,
    ));
    _chatroomBloc.close();
    _convActionBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                chatroom = state.chatroom;
                lastConversationId = state.lastConversationId;
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
                    _screenBuilder.appBarBuilder.call(
                      context,
                      chatroom.toChatRoomViewData(),
                      _defaultAppBar(
                        chatroom,
                        chatroomState.participantCount,
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
                    LMChatroomBar(
                      chatroom: chatroom.toChatRoomViewData(),
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

  Widget _chatroomList() {
    return chatroom.type != 10
        ? LMChatConversationList(
            chatroomId: widget.chatroomId,
            appBarNotifier: rebuildAppBar,
            selectedConversations: _selectedIds,
            scrollController: scrollController,
            listController: pagedListController,
          )
        : LMChatDMConversationList(
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
      style: const LMChatAppBarStyle(
        height: 72,
        padding: EdgeInsets.symmetric(horizontal: 18),
      ),
      banner: ValueListenableBuilder(
        valueListenable: rebuildAppBar,
        builder: (context, _, __) {
          return isAnyMessageSelected()
              ? const SizedBox.shrink()
              : LMChatProfilePicture(
                  imageUrl: chatUser?.imageUrl ?? chatroom.chatroomImageUrl,
                  fallbackText: chatroom.header,
                  style: LMChatProfilePictureStyle(
                    size: 42,
                    backgroundColor: LMChatTheme.theme.primaryColor,
                  ),
                );
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
                  : _defaultChatroomMenu();
            }),
      ],
    );
  }

  List<Widget> _defaultSelectedChatroomMenu() {
    final LMChatConversationViewData? conversationViewData = pagedListController
        .value.itemList
        ?.firstWhere((element) => element.id == _selectedIds.first);

    bool haveDeletePermission = conversationViewData != null &&
        LMChatMemberRightUtil.checkDeletePermissions(conversationViewData);
    bool haveEditPermission =
        LMChatMemberRightUtil.checkEditPermissions(conversationViewData!);
    return [
      // Reply button
      if (_selectedIds.length == 1)
        LMChatButton(
          onTap: () {
            // add reply event
            _convActionBloc.add(
              LMChatReplyConversationEvent(
                conversationId: conversationViewData.id,
                chatroomId: widget.chatroomId,
                replyConversation: conversationViewData,
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
        ),
      const SizedBox(width: 8),
      // Copy button
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
      const SizedBox(width: 8),
      // Edit button
      if (haveEditPermission && _selectedIds.length == 1)
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
      // pop up menu button for report
      if (_selectedIds.length == 1 &&
          LMChatMemberRightUtil.isReportAllowed(conversationViewData))
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
                  _selectedIds.clear();
                  rebuildAppBar.value = !rebuildAppBar.value;
                  rebuildConversationList.value =
                      !rebuildConversationList.value;
                  context.push(
                    LMChatReportScreen(
                      entityId: conversationViewData.id.toString(),
                      entityCreatorId:
                          conversationViewData.member!.id.toString(),
                      entityType: 3,
                    ),
                  );
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
