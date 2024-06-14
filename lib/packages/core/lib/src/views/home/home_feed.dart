import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/blocs.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/home/home_bloc.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/observer.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/chatroom/chatroom_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/conversation/conversation_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/user/user_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/utils/chatroom/chatroom_utils.dart';
import 'package:likeminds_chat_flutter_core/src/utils/media/media_helper.dart';
import 'package:likeminds_chat_flutter_core/src/utils/preferences/preferences.dart';
import 'package:likeminds_chat_flutter_core/src/utils/realtime/realtime.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_core/src/views/views.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class LMChatHomeScreen extends StatefulWidget {
  final LMChatroomType chatroomType;

  final LMChatHomeAppBarBuilder? appbarBuilder;
  final LMChatroomTileBuilder? chatroomTileBuilder;
  final LMChatContextWidgetBuilder? loadingPageWidget;
  final LMChatContextWidgetBuilder? loadingListWidget;

  const LMChatHomeScreen({
    super.key,
    required this.chatroomType,
    this.appbarBuilder,
    this.chatroomTileBuilder,
    this.loadingListWidget,
    this.loadingPageWidget,
  });

  @override
  State<LMChatHomeScreen> createState() => _LMChatHomeScreenState();
}

class _LMChatHomeScreenState extends State<LMChatHomeScreen> {
  List<int>? chatroomTypes;
  int currentTime = DateTime.now().millisecondsSinceEpoch;
  User? user;
  LMChatHomeBloc homeBloc = LMChatHomeBloc.instance;
  ValueNotifier<bool> rebuildPagedList = ValueNotifier(false);
  PagingController<int, LMChatTile> homeFeedPagingController =
      PagingController(firstPageKey: 1);

  int _pageKey = 1;

  @override
  void initState() {
    Bloc.observer = LMChatBlocObserver();
    user = LMChatPreferences.instance.getCurrentUser;
    homeFeedPagingController.itemList?.clear();
    chatroomTypes = getChatroomTypes(widget.chatroomType);
    _addPaginationListener();
    super.initState();
  }

  @override
  void dispose() {
    homeFeedPagingController.itemList?.clear();
    homeBloc.close();
    super.dispose();
  }

  @override
  void didUpdateWidget(LMChatHomeScreen oldWidget) {
    user = LMChatPreferences.instance.getCurrentUser;
    homeFeedPagingController.itemList?.clear();
    chatroomTypes = getChatroomTypes(widget.chatroomType);
    _addPaginationListener();
    super.didUpdateWidget(oldWidget);
  }

  _addPaginationListener() {
    homeFeedPagingController.addPageRequestListener(
      (pageKey) {
        homeBloc.add(
          LMChatInitHomeEvent(
            request: (GetHomeFeedRequestBuilder()
                  ..page(pageKey)
                  ..pageSize(pageSize)
                  ..minTimestamp(0)
                  ..maxTimestamp(currentTime)
                  ..chatroomTypes(chatroomTypes ?? [0, 7]))
                .build(),
          ),
        );
      },
    );
  }

  updatePagingControllers(LMChatHomeState state) {
    if (state is LMChatHomeLoaded) {
      List<LMChatTile> chatItems = getChats(context, state.response);
      _pageKey++;
      homeFeedPagingController.itemList?.clear();
      homeFeedPagingController.nextPageKey = _pageKey;
      if (state.response.chatroomsData == null ||
          state.response.chatroomsData!.isEmpty ||
          state.response.chatroomsData!.length < pageSize) {
        homeFeedPagingController.appendLastPage(chatItems);
      } else {
        homeFeedPagingController.appendPage(chatItems, _pageKey);
      }
    } else if (state is LMChatUpdateHomeFeed) {
      List<LMChatTile> chatItems = getChats(context, state.response);
      _pageKey = 2;
      homeFeedPagingController.itemList?.clear();
      homeFeedPagingController.nextPageKey = _pageKey;
      if (state.response.chatroomsData == null ||
          state.response.chatroomsData!.isEmpty ||
          state.response.chatroomsData!.length < pageSize) {
        homeFeedPagingController.appendLastPage(chatItems);
      } else {
        homeFeedPagingController.appendPage(chatItems, _pageKey);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            debugPrint("Floating action button pressed");
            final LMChatCache cache = (LMChatCacheBuilder()
                  ..key("kAccessToken")
                  ..value("accessToken"))
                .build();

            final localPref =
                LMChatCore.instance.lmChatClient.insertOrUpdateCache(cache);
            debugPrint("Local pref while saving: $localPref");
            final cacheValue =
                LMChatCore.instance.lmChatClient.getCache("kAccessToken");
            debugPrint("Cache value: ${cacheValue.data?.value}");

          },
          child: const Icon(
            Icons.add,
          ),
        ),
        backgroundColor: LMChatTheme.theme.backgroundColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              widget.appbarBuilder?.call(
                    user!.toUserViewData(),
                    _defaultAppBar(),
                  ) ??
                  _defaultAppBar(),
              Expanded(
                child: Container(
                  color: LMChatTheme.theme.container,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: BlocConsumer<LMChatHomeBloc, LMChatHomeState>(
                      bloc: homeBloc,
                      listener: (context, state) {
                        updatePagingControllers(state);
                      },
                      buildWhen: (previous, current) {
                        if (previous is LMChatHomeLoaded &&
                            current is LMChatHomeLoading) {
                          return false;
                        } else if (previous is LMChatUpdateHomeFeed &&
                            current is LMChatHomeLoading) {
                          return false;
                        }
                        return true;
                      },
                      builder: (context, state) {
                        if (state is LMChatHomeError) {
                          return Center(
                            child: Text(state.message),
                          );
                        }
                        return _defaultChatroomList();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LMChatAppBar _defaultAppBar() {
    return LMChatAppBar(
      style: LMChatAppBarStyle(
        height: 72,
        showBackButton: false,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        backgroundColor: LMChatTheme.theme.container,
      ),
      title: LMChatText(
        "Direct Messages",
        style: LMChatTextStyle(
          textStyle: TextStyle(
            color: LMChatTheme.theme.onContainer,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      trailing: [
        LMChatProfilePicture(
          fallbackText: user!.name,
          imageUrl: user?.imageUrl,
          style: const LMChatProfilePictureStyle(
            size: 42,
          ),
        ),
      ],
    );
  }

  Widget _defaultChatroomList() {
    return ValueListenableBuilder(
        valueListenable: rebuildPagedList,
        builder: (context, _, __) {
          return PagedListView<int, LMChatTile>(
            pagingController: homeFeedPagingController,
            padding: EdgeInsets.zero,
            physics: const ClampingScrollPhysics(),
            builderDelegate: PagedChildBuilderDelegate<LMChatTile>(
              firstPageProgressIndicatorBuilder: (context) =>
                  widget.loadingPageWidget?.call(context) ??
                  const LMChatSkeletonChatroomList(),
              noItemsFoundIndicatorBuilder: (context) => const SizedBox(),
              itemBuilder: (context, item, index) {
                return item;
              },
            ),
          );
        });
  }

  LMChatTile _defaultChatroomTile(
    LMChatRoomViewData chatroom,
    LMChatConversationViewData conversation,
    User chatroomWithUser,
    User chatroomUser,
    User conversationUser,
    List<LMChatMedia> attachmentMeta,
  ) {
    bool whichUser = user != null && user!.id != chatroomWithUser.id;
    String message = getChatroomPreviewMessage(
      conversation,
      conversationUser.toUserViewData(),
      chatroomUser.toUserViewData(),
      chatroomWithUser.toUserViewData(),
    );
    return LMChatTile(
      style: LMChatTileStyle.basic()
          .copyWith(backgroundColor: LMChatTheme.theme.container),
      onTap: () {
        LMChatRealtime.instance.chatroomId = chatroom.id;
        final route = MaterialPageRoute(
          builder: (context) {
            return LMChatroomScreen(
              chatroomId: chatroom.id,
            );
          },
        );
        Navigator.of(context).push(route).whenComplete(
              () => homeBloc.add(LMChatUpdateHomeEvent()),
            );
      },
      leading: LMChatProfilePicture(
        fallbackText: whichUser ? chatroomWithUser.name : chatroomUser.name,
        imageUrl: whichUser ? chatroomWithUser.imageUrl : chatroomUser.imageUrl,
        style: const LMChatProfilePictureStyle(size: 48),
      ),
      title: LMChatText(
        whichUser ? chatroomWithUser.name : chatroomUser.name,
        style: LMChatTextStyle(
          maxLines: 1,
          textStyle: TextStyle(
            fontSize: 16,
            color: LMChatTheme.theme.onContainer,
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      subtitle: ((conversation.hasFiles ?? false) &&
              conversation.deletedByUserId == null)
          ? getChatItemAttachmentTile(
              attachmentMeta,
              conversation.toConversation(),
            )
          : LMChatText(
              conversation.state != 0
                  ? LMChatTaggingHelper.extractStateMessage(message)
                  : message,
              style: LMChatTextStyle(
                maxLines: 1,
                textStyle: TextStyle(
                  fontSize: 14,
                  color: LMChatTheme.theme.onContainer,
                  fontWeight: FontWeight.w400,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          chatroom.muteStatus != null && chatroom.muteStatus!
              ? const LMChatIcon(
                  type: LMChatIconType.icon,
                  icon: Icons.volume_off_outlined,
                )
              : const SizedBox.shrink(),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              LMChatText(
                getTime(conversation.createdEpoch!.toString()),
                style: LMChatTextStyle(
                  textStyle: TextStyle(
                    fontSize: 12,
                    color: LMChatTheme.theme.onContainer,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Visibility(
                visible: chatroom.unseenCount! > 0,
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: 24,
                    maxHeight: 24,
                  ),
                  width: 24,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(14)),
                    color: LMChatTheme.theme.primaryColor,
                  ),
                  child: Center(
                    child: LMChatText(
                      chatroom.unseenCount! > 99
                          ? "99+"
                          : chatroom.unseenCount.toString(),
                      style: LMChatTextStyle(
                        textStyle: TextStyle(
                          fontSize: 12,
                          color: LMChatTheme.theme.onPrimary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<LMChatTile> getChats(
    BuildContext context,
    GetHomeFeedResponse response,
  ) {
    List<LMChatTile> chats = [];
    final List<LMChatRoomViewData> chatrooms =
        response.chatroomsData?.map((e) => e.toChatRoomViewData()).toList() ??
            [];
    final Map<String, Conversation> lastConversations =
        response.conversationMeta ?? {};
    final Map<int, User> userMeta = response.userMeta ?? {};
    final Map<dynamic, dynamic>? attachmentDynamic =
        response.conversationAttachmentsMeta;

    for (int i = 0; i < chatrooms.length; i++) {
      final Conversation conversation =
          lastConversations[chatrooms[i].lastConversationId.toString()]!;
      final User chatroomUser = userMeta[chatrooms[i].userId]!;
      final User chatroomWithUser = userMeta[chatrooms[i].chatroomWithUserId]!;
      final User conversationUser =
          userMeta[conversation.member?.id ?? conversation.userId]!;
      final List<dynamic>? attachment =
          attachmentDynamic?[conversation.id.toString()];

      final List<LMChatMedia> attachmentMeta =
          attachment?.map((e) => LMChatMedia.fromJson(e)).toList() ?? [];

      chats.add(
        widget.chatroomTileBuilder?.call(
              chatrooms[i],
              _defaultChatroomTile(
                chatrooms[i],
                conversation.toConversationViewData(),
                chatroomWithUser,
                chatroomUser,
                conversationUser,
                attachmentMeta,
              ),
            ) ??
            _defaultChatroomTile(
              chatrooms[i],
              conversation.toConversationViewData(),
              chatroomWithUser,
              chatroomUser,
              conversationUser,
              attachmentMeta,
            ),
      );
    }

    return chats;
  }

  String getTime(String time) {
    final int time0 = int.tryParse(time) ?? 0;
    final DateTime now = DateTime.now();
    final DateTime messageTime = DateTime.fromMillisecondsSinceEpoch(time0);
    final Duration difference = now.difference(messageTime);
    if (difference.inDays > 0 || now.day != messageTime.day) {
      return DateFormat('dd/MM/yyyy').format(messageTime);
    }
    return DateFormat('kk:mm').format(messageTime);
  }
}

Widget getShimmer() => Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade300,
      period: const Duration(seconds: 2),
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 12,
        ),
        child: Container(
          height: 16,
          width: 72,
          color: LMChatDefaultTheme.whiteColor,
        ),
      ),
    );
