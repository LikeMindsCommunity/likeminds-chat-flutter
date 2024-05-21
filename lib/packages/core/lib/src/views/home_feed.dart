import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/blocs.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/home/home_bloc.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/observer.dart';
import 'package:likeminds_chat_flutter_core/src/utils/constants/enums.dart';
import 'package:likeminds_chat_flutter_core/src/utils/chatroom/chatroom_utils.dart';
import 'package:likeminds_chat_flutter_core/src/utils/helpers/tagging_helper.dart';
import 'package:likeminds_chat_flutter_core/src/utils/media/media_helper.dart';
import 'package:likeminds_chat_flutter_core/src/utils/preferences/preferences.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_core/src/views/views.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/shimmers/chatroom_skeleton.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class LMChatHomeScreen extends StatefulWidget {
  final LMChatroomType chatroomType;
  const LMChatHomeScreen({
    super.key,
    required this.chatroomType,
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
    return Scaffold(
      backgroundColor: LMChatDefaultTheme.whiteColor,
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: SafeArea(
                bottom: false,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        LMChatText(
                          "Direct Messages",
                          style: LMChatTextStyle(
                            textStyle: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color: LMChatDefaultTheme.blackColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                    // const Spacer(),
                    LMChatProfilePicture(
                      fallbackText: user!.name,
                      imageUrl: user?.imageUrl,
                      style: const LMChatProfilePictureStyle(
                        size: 36,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(),
          Expanded(
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
                    return SafeArea(
                      top: false,
                      child: ValueListenableBuilder(
                          valueListenable: rebuildPagedList,
                          builder: (context, _, __) {
                            return PagedListView<int, LMChatTile>(
                              pagingController: homeFeedPagingController,
                              padding: EdgeInsets.zero,
                              physics: const ClampingScrollPhysics(),
                              builderDelegate:
                                  PagedChildBuilderDelegate<LMChatTile>(
                                newPageProgressIndicatorBuilder: (_) =>
                                    const SizedBox(),
                                noItemsFoundIndicatorBuilder: (context) =>
                                    const SizedBox(),
                                itemBuilder: (context, item, index) {
                                  return item;
                                },
                              ),
                            );
                          }),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
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
      final User chatroomWithUser = userMeta[chatrooms[i].chatroomWithUserId]!;
      final User conversationUser =
          userMeta[conversation.member?.id ?? conversation.userId]!;
      final List<dynamic>? attachment =
          attachmentDynamic?[conversation.id.toString()];

      final List<LMChatMedia>? attachmentMeta =
          attachment?.map((e) => LMChatMedia.fromJson(e)).toList();
      String message = conversation.deletedByUserId == null
          ? '${conversationUser.id == chatroomWithUser.id ? 'You: ' : ''}${conversation.state != 0 ? LMChatTaggingHelper.extractStateMessage(
              conversation.answer,
            ) : LMChatTaggingHelper.convertRouteToTag(
              conversation.answer,
              withTilde: false,
            )}'
          : getDeletedText(conversation, user!);
      chats.add(
        LMChatTile(
          onTap: () {
            // LMChatRealtime.instance.chatroomId = chatrooms[i].id;
            final route = MaterialPageRoute(
              builder: (context) {
                return LMChatroomScreen(
                  chatroomId: chatrooms[i].id,
                );
              },
            );
            Navigator.of(context)
                .push(route)
                .whenComplete(() => homeBloc?.add(LMChatUpdateHomeEvent(
                    request: (GetHomeFeedRequestBuilder()
                          ..page(1)
                          ..pageSize(pageSize)
                          ..minTimestamp(0)
                          ..maxTimestamp(currentTime)
                          ..chatroomTypes(chatroomTypes ?? [0, 7]))
                        .build())));
          },
          leading: LMChatProfilePicture(
            // fallbackText: chatrooms[i].header,
            // imageUrl: chatrooms[i].chatroomImageUrl,
            fallbackText: chatroomWithUser.name,
            imageUrl: chatroomWithUser.imageUrl,
            style: const LMChatProfilePictureStyle(size: 48),
          ),
          title: LMChatText(
            chatroomWithUser.name,
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
                  attachmentMeta ?? <LMChatMedia>[], conversation)
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
              chatrooms[i].muteStatus != null && chatrooms[i].muteStatus!
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
                    visible: chatrooms[i].unseenCount! > 0,
                    child: Center(
                      child: Container(
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(14)),
                          color: LMChatTheme.theme.primaryColor,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: LMChatText(
                          chatrooms[i].unseenCount! > 99
                              ? "99+"
                              : chatrooms[i].unseenCount.toString(),
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

          // user: userMeta[conversation.member?.id ?? conversation.userId],
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

  // String getAttachmentText(AttachmentMeta? attachmentMeta, ) {
  //   if (attachmentMeta != null &&
  //       attachmentMeta?.first.mediaType == MediaType.document) {
  //     return "${conversation!.attachmentCount} ${conversation!.attachmentCount! > 1 ? "Documents" : "Document"}";
  //   } else if (attachmentMeta != null &&
  //       attachmentMeta?.first.mediaType == MediaType.video) {
  //     return "${conversation!.attachmentCount} ${conversation!.attachmentCount! > 1 ? "Videos" : "Video"}";
  //   } else {
  //     return "${conversation!.attachmentCount} ${conversation!.attachmentCount! > 1 ? "Images" : "Image"}";
  //   }
  // }

  // IconData getAttachmentIcon() {
  //   if (attachmentMeta != null &&
  //       attachmentMeta?.first.mediaType == MediaType.document) {
  //     return Icons.insert_drive_file;
  //   } else if (attachmentMeta != null &&
  //       attachmentMeta?.first.mediaType == MediaType.video) {
  //     return Icons.video_camera_back;
  //   }
  //   return Icons.camera_alt;
  // }
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
