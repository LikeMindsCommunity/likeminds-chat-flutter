import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/blocs.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/home/home_bloc.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/observer.dart';
import 'package:likeminds_chat_flutter_core/src/utils/constants/enums.dart';
import 'package:likeminds_chat_flutter_core/src/utils/chatroom/chatroom_utils.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/helpers/tagging_helper.dart';
import 'package:likeminds_chat_flutter_core/src/utils/media/media_helper.dart';
import 'package:likeminds_chat_flutter_core/src/utils/preferences/preferences.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_core/src/views/views.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/shimmers/chatroom_skeleton.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class LMChatHomeScreen extends StatefulWidget {
  final LMChatroomType chatroomType;
  final LMChatHomeAppBarBuilder? appbarBuilder;
  final LMChatroomTileBuilder? chatroomTileBuilder;

  const LMChatHomeScreen({
    super.key,
    required this.chatroomType,
    this.appbarBuilder,
    this.chatroomTileBuilder,
  });

  @override
  State<LMChatHomeScreen> createState() => _LMChatHomeScreenState();
}

class _LMChatHomeScreenState extends State<LMChatHomeScreen> {
  List<int>? chatroomTypes;
  int currentTime = DateTime.now().millisecondsSinceEpoch;
  final int pageSize = 20;
  User? user;
  LMChatHomeBloc? homeBloc;
  ValueNotifier<bool> rebuildPagedList = ValueNotifier(false);
  PagingController<int, LMChatTile> homeFeedPagingController =
      PagingController(firstPageKey: 1);

  int _pageKey = 1;

  @override
  void initState() {
    super.initState();
    Bloc.observer = LMChatBlocObserver();
    user = LMChatPreferences.instance.getCurrentUser;
    homeFeedPagingController.itemList?.clear();
    chatroomTypes = getChatroomTypes(widget.chatroomType);
    homeBloc = LMChatHomeBloc.instance
      ..add(LMChatInitHomeEvent(
          request: (GetHomeFeedRequestBuilder()
                ..page(1)
                ..pageSize(pageSize)
                ..minTimestamp(0)
                ..maxTimestamp(currentTime)
                ..chatroomTypes(chatroomTypes ?? [0, 7]))
              .build()));
    _addPaginationListener();
  }

  _addPaginationListener() {
    homeFeedPagingController.addPageRequestListener(
      (pageKey) {
        homeBloc!.add(
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
      homeFeedPagingController.itemList = chatItems;
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: LMChatTheme.theme.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              widget.appbarBuilder?.call(
                    user!,
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
                        if (state is LMChatHomeLoading) {
                          return const LMChatSkeletonChatList();
                        } else if (state is LMChatHomeError) {
                          return Center(
                            child: Text(state.message),
                          );
                        } else if (state is LMChatHomeLoaded ||
                            state is LMChatUpdateHomeFeed ||
                            state is LMChatUpdatedHomeFeed) {
                          return _defaultChatroomList();
                        }
                        return const SizedBox();
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
          debugPrint("Chatroom List rebuilt");
          return PagedListView<int, LMChatTile>(
            pagingController: homeFeedPagingController,
            padding: EdgeInsets.zero,
            physics: const ClampingScrollPhysics(),
            builderDelegate: PagedChildBuilderDelegate<LMChatTile>(
              newPageProgressIndicatorBuilder: (_) => const SizedBox(),
              noItemsFoundIndicatorBuilder: (context) => const SizedBox(),
              itemBuilder: (context, item, index) {
                return item;
              },
            ),
          );
        });
  }

  LMChatTile _defaultChatroomTile(
    ChatRoom chatroom,
    Conversation conversation,
    User chatroomWithUser,
    User chatroomUser,
    User conversationUser,
    List<LMChatMedia> attachmentMeta,
  ) {
    String message = conversation.deletedByUserId == null
        ? '${conversationUser.id == chatroomWithUser.id ? 'You: ' : ''}${conversation.state != 0 ? LMChatTaggingHelper.extractStateMessage(
            conversation.answer,
          ) : LMChatTaggingHelper.convertRouteToTag(
            conversation.answer,
            withTilde: false,
          )}'
        : getDeletedText(conversation, user!);
    return LMChatTile(
      onTap: () {
        // LMChatRealtime.instance.chatroomId = chatrooms[i].id;
        final route = MaterialPageRoute(
          builder: (context) {
            return LMChatroomScreen(
              chatroomId: chatroom.id,
            );
          },
        );
        Navigator.of(context).push(route);
      },
      leading: LMChatProfilePicture(
        fallbackText: user != null && user!.id != chatroomWithUser.id
            ? chatroomWithUser.name
            : chatroomUser.name,
        imageUrl: user != null && user!.id != chatroomWithUser.id
            ? chatroomWithUser.imageUrl
            : chatroomUser.imageUrl,
        style: const LMChatProfilePictureStyle(size: 48),
      ),
      title: LMChatText(
        user != null && user!.id != chatroomWithUser.id
            ? chatroomWithUser.name
            : chatroomUser.name,
        style: const LMChatTextStyle(
          maxLines: 1,
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      subtitle: ((conversation.hasFiles ?? false) &&
              conversation.deletedByUserId == null)
          ? getChatItemAttachmentTile(
              attachmentMeta,
              conversation,
            )
          : LMChatText(
              conversation.state != 0
                  ? LMChatTaggingHelper.extractStateMessage(message)
                  : message,
              style: const LMChatTextStyle(
                maxLines: 1,
                textStyle: TextStyle(
                  fontSize: 14,
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
                style: const LMChatTextStyle(
                  textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Visibility(
                visible: chatroom.unseenCount! > 0,
                child: Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    color: LMChatTheme.theme.primaryColor,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 4,
                  ),
                  child: Center(
                    child: LMChatText(
                      chatroom.unseenCount! > 99
                          ? "99+"
                          : chatroom.unseenCount.toString(),
                      style: const LMChatTextStyle(
                        textStyle: TextStyle(
                          color: LMChatDefaultTheme.whiteColor,
                          fontSize: 12,
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
    final List<ChatRoom> chatrooms = response.chatroomsData ?? [];
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

      chats.add(widget.chatroomTileBuilder?.call(
              chatrooms[i],
              _defaultChatroomTile(
                chatrooms[i],
                conversation,
                chatroomWithUser,
                chatroomUser,
                conversationUser,
                attachmentMeta,
              )) ??
          _defaultChatroomTile(
            chatrooms[i],
            conversation,
            chatroomWithUser,
            chatroomUser,
            conversationUser,
            attachmentMeta,
          ));
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
