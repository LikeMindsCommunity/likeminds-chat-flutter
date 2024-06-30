import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/blocs.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/observer.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/chatroom/chatroom_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/chatroom/chatroom_bar.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/chatroom/chatroom_menu.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/lists/conversation/conversation_list.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

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

  @override
  void initState() {
    super.initState();
    Bloc.observer = LMChatBlocObserver();
    _chatroomBloc = LMChatroomBloc.instance;
    _chatroomActionBloc = LMChatroomActionBloc.instance;
    _chatroomBloc.add(LMChatFetchChatroomEvent(chatroomId: widget.chatroomId));
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
                chatroom = state.chatroom;
                lastConversationId = state.lastConversationId;
                _chatroomActionBloc
                    .add(MarkReadChatroomEvent(chatroomId: chatroom.id));
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
                    widget.appbarbuilder?.call(
                          chatroom.toChatRoomViewData(),
                          _defaultAppBar(chatroom),
                        ) ??
                        _defaultAppBar(chatroom),
                    Expanded(
                      child:
                          LMChatConversationList(chatroomId: widget.chatroomId),
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
      banner: LMChatProfilePicture(
        imageUrl: chatUser.imageUrl ?? chatroom.chatroomImageUrl,
        fallbackText: chatroom.header,
        style: LMChatProfilePictureStyle(
          size: 42,
          backgroundColor: LMChatTheme.theme.secondaryColor,
        ),
      ),
      title: LMChatText(
        chatUser.name ?? chatroom.title,
        style: LMChatTextStyle(
          maxLines: 1,
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.ellipsis,
            color: LMChatTheme.theme.onContainer,
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
