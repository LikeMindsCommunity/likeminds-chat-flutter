import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/constants/assets.dart';
import 'package:likeminds_chat_flutter_core/src/utils/realtime/realtime.dart';
import 'package:likeminds_chat_flutter_core/src/views/member_list/member_list.dart';
import 'package:likeminds_chat_flutter_core/src/views/networking_chat/configurations/builder.dart';

/// {@template lm_chat_dm_feed_list}
/// A widget that represents a List of DM Chatrooms
/// Talks to an instance of LMChatDMFeedBloc, and updates accordingly
/// Allows for customizations to change the look and feel.
/// {@endtemplate}
class LMNetworkingChatScreen extends StatefulWidget {
  /// {@macro lm_chat_dm_feed_list}
  const LMNetworkingChatScreen({
    super.key,
  });

  /// Creates a copy of this [LMNetworkingChatScreen] but with the given fields replaced with the new values.
  LMNetworkingChatScreen copyWith() {
    return const LMNetworkingChatScreen();
  }

  @override
  State<LMNetworkingChatScreen> createState() => _LMNetworkingChatScreenState();
}

class _LMNetworkingChatScreenState extends State<LMNetworkingChatScreen>
    with AutomaticKeepAliveClientMixin<LMNetworkingChatScreen> {
  // Widget level track of page key for pagination
  int _page = 1;

  // BLoC needed for list's state management
  late LMChatDMFeedBloc feedBloc;

  // ValueNotifier to rebuild the list based on an update
  ValueNotifier<bool> rebuildFeedList = ValueNotifier(false);

  // Paging controller to handle pagination, and list updation
  late PagingController<int, LMChatRoomViewData> homeFeedPagingController;

  final LMNetworkingChatBuilderDelegate _screenBuilder =
      LMChatCore.config.networkingChatConfig.builder;

  /// [_style] is a style object to customize the look and feel of the list
  final LMNetworkingChatListStyle _style = LMChatCore
          .config.networkingChatConfig.style.netwrokingChatListStyle
          ?.call(
        LMNetworkingChatListStyle.basic(),
      ) ??
      LMNetworkingChatListStyle.basic();

  final ValueNotifier<bool> _showDMFab = ValueNotifier(false);
  int? _showList;

  void _checkDMStatus() async {
    final checkDMStatusRequest =
        (CheckDMStatusRequestBuilder()..reqFrom("dm_feed_v2")).build();
    final checkDMStatusResponse = await LMChatCore.client.checkDMStatus(
      checkDMStatusRequest,
    );
    _showDMFab.value = checkDMStatusResponse.data?.showDm ?? false;
    final cta = checkDMStatusResponse.data?.cta;
    if (cta != null) {
      Uri uri = Uri.parse(cta);
      Map<String, String> queryParams = uri.queryParameters;
      _showList = int.tryParse(queryParams['show_list'] ?? '');
    }
  }

  @override
  void initState() {
    feedBloc = LMChatDMFeedBloc.instance;
    homeFeedPagingController = PagingController(firstPageKey: 1);
    _checkDMStatus();
    _addPaginationListener();
    LMChatAnalyticsBloc.instance.add(
      const LMChatFireAnalyticsEvent(
        eventName: LMChatAnalyticsKeys.dmScreenOpened,
        eventProperties: {'source': 'home_feed'},
      ),
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant LMNetworkingChatScreen oldWidget) {
    feedBloc = LMChatDMFeedBloc.instance;
    homeFeedPagingController = PagingController(firstPageKey: 1);
    _addPaginationListener();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    feedBloc.close();
    homeFeedPagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ValueListenableBuilder(
        valueListenable: LMChatTheme.themeNotifier,
        builder: (context, _, __) {
          return _screenBuilder.scaffold(
            floatingActionButton: ValueListenableBuilder(
              valueListenable: _showDMFab,
              builder: (context, value, child) {
                return value
                    ? _screenBuilder.floatingActionNewMessageButton(
                        context, _floatingActionButton())
                    : const SizedBox();
              },
            ),
            backgroundColor:
                _style.backgroundColor ?? LMChatTheme.theme.scaffold,
            body: SafeArea(
              top: false,
              child: BlocListener<LMChatDMFeedBloc, LMChatDMFeedState>(
                bloc: feedBloc,
                listener: (_, state) {
                  _updatePagingControllers(state);
                },
                child: ValueListenableBuilder(
                    valueListenable: rebuildFeedList,
                    builder: (context, _, __) {
                      return PagedListView<int, LMChatRoomViewData>(
                        pagingController: homeFeedPagingController,
                        padding: _style.padding ??
                            const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 4,
                            ),
                        physics: const ClampingScrollPhysics(),
                        builderDelegate:
                            PagedChildBuilderDelegate<LMChatRoomViewData>(
                          itemBuilder: (context, chatroom, index) {
                            return _screenBuilder.userTileBuilder(
                              context,
                              chatroom,
                              _defaultDMChatRoomTile(chatroom),
                            );
                          },
                          firstPageErrorIndicatorBuilder: (context) =>
                              _screenBuilder.firstPageErrorIndicatorBuilder(
                            context,
                            _defaultErrorView(),
                          ),
                          newPageErrorIndicatorBuilder: (context) =>
                              _screenBuilder.newPageErrorIndicatorBuilder(
                            context,
                            _defaultErrorView(),
                          ),
                          firstPageProgressIndicatorBuilder: (context) =>
                              _screenBuilder.firstPageProgressIndicatorBuilder(
                            context,
                            const LMChatSkeletonChatroomList(),
                          ),
                          newPageProgressIndicatorBuilder: (context) =>
                              _screenBuilder.newPageProgressIndicatorBuilder(
                            context,
                            const LMChatLoader(),
                          ),
                          noItemsFoundIndicatorBuilder: (context) =>
                              _screenBuilder.noItemsFoundIndicatorBuilder(
                            context,
                            _defaultEmptyView(),
                          ),
                          noMoreItemsIndicatorBuilder: (context) =>
                              _screenBuilder.noMoreItemsIndicatorBuilder(
                            context,
                            const SizedBox(),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          );
        });
  }

  _addPaginationListener() {
    homeFeedPagingController.addPageRequestListener(
      (pageKey) {
        feedBloc.add(
          LMChatFetchDMFeedEvent(
            page: pageKey,
          ),
        );
      },
    );
  }

  _updatePagingControllers(LMChatDMFeedState state) {
    if (state is LMChatDMFeedLoaded) {
      _page++;
      homeFeedPagingController.itemList?.clear();
      homeFeedPagingController.nextPageKey = _page;
      if (state.chatrooms.isEmpty || state.chatrooms.length < 50) {
        homeFeedPagingController.appendLastPage(state.chatrooms);
      } else {
        homeFeedPagingController.appendPage(state.chatrooms, _page);
      }
    } else if (state is LMChatDMFeedUpdated) {
      _page = 2;
      homeFeedPagingController.itemList?.clear();
      homeFeedPagingController.nextPageKey = _page;
      if (state.chatrooms.isEmpty || state.chatrooms.length < 50) {
        homeFeedPagingController.appendLastPage(state.chatrooms);
      } else {
        homeFeedPagingController.appendPage(state.chatrooms, _page);
      }
    }
  }

  Widget _defaultErrorView() {
    return Container();
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
          'Oops! No direct messages.',
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

  LMChatTile _defaultDMChatRoomTile(LMChatRoomViewData chatroom) {
    final user = LMChatLocalPreference.instance.getUser();
    bool whichUser = user.id != chatroom.chatroomWithUserId;
    final chatroomUser =
        whichUser ? chatroom.chatroomWithUser! : chatroom.member!;
    String message = getDMChatroomPreviewMessage(
      chatroom.lastConversation!,
      chatroom.lastConversation!.member!,
      chatroom.member!,
      chatroom.chatroomWithUser!,
    );
    return LMChatTile(
      style: LMChatTileStyle.basic().copyWith(
        backgroundColor: LMChatTheme.theme.scaffold,
      ),
      onTap: () {
        LMChatRealtime.instance.chatroomId = chatroom.id;
        final route = MaterialPageRoute(
          builder: (context) {
            return LMChatroomScreen(
              chatroomId: chatroom.id,
            );
          },
        );
        Navigator.of(context).push(route).then(
              (val) => feedBloc.add(LMChatRefreshDMFeedEvent()),
            );
      },
      leading: LMChatProfilePicture(
        fallbackText: chatroomUser.name,
        imageUrl: chatroomUser.imageUrl,
        style: _style.profilePictureStyle ??
            LMChatProfilePictureStyle.basic().copyWith(size: 48),
      ),
      title: LMChatText(
        chatroomUser.name,
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
      subtitle: ((chatroom.lastConversation?.attachmentsUploaded ?? false) &&
              chatroom.lastConversation?.deletedByUserId == null)
          ? getChatItemAttachmentTile(
              message, chatroom.attachments, chatroom.lastConversation!)
          : LMChatText(
              chatroom.lastConversation!.state != 0
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
              ? _screenBuilder.muteIconBuilder(
                  _defMuteButton(),
                )
              : const SizedBox.shrink(),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              LMChatText(
                getTime(chatroom.lastConversation!.createdEpoch!.toString()),
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
                      style: _style.unreadCountTextStyle,
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

  LMChatButton _floatingActionButton() {
    return LMChatButton(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LMChatMemberList(
              showList: _showList,
            ),
          ),
        );
      },
      text: const LMChatText('NEW MESSAGE',
          style: LMChatTextStyle(
            textStyle: TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          )),
      style: LMChatButtonStyle(
        spacing: 8,
        icon: const LMChatIcon(
          type: LMChatIconType.svg,
          assetPath: kNetworkingChatIcon,
          style: LMChatIconStyle(
            color: Colors.white,
            size: 30,
          ),
        ),
        backgroundColor: LMChatTheme.theme.primaryColor,
        width: 173,
        height: 48,
        borderRadius: 40,
      ),
    );
  }

  LMChatIcon _defMuteButton() {
    return const LMChatIcon(
      type: LMChatIconType.icon,
      icon: Icons.volume_off_outlined,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

/// {@template lm_chat_dm_feed_list_style}
/// A style object to customize the look and feel of the DM Feed List
/// {@endtemplate}
class LMNetworkingChatListStyle {
  /// [backgroundColor] is the background color of the list
  final Color? backgroundColor;

  /// [padding] is the padding of the list
  final EdgeInsets? padding;

  /// [profilePictureStyle] is the style of the profile picture
  final LMChatProfilePictureStyle? profilePictureStyle;

  /// [unreadCountTextStyle] is the style of the unread count text
  final LMChatTextStyle? unreadCountTextStyle;

  static final LMChatThemeData _themeData = LMChatTheme.theme;

  /// {@macro lm_chat_dm_feed_list_style}
  const LMNetworkingChatListStyle({
    this.backgroundColor,
    this.padding,
    this.profilePictureStyle,
    this.unreadCountTextStyle,
  });

  /// {@macro lm_chat_dm_feed_list_style}
  factory LMNetworkingChatListStyle.basic() {
    return LMNetworkingChatListStyle(
      backgroundColor: _themeData.scaffold,
      padding: const EdgeInsets.only(
        left: 4,
        right: 8,
      ),
      profilePictureStyle: LMChatProfilePictureStyle.basic().copyWith(size: 48),
      unreadCountTextStyle: LMChatTextStyle(
        padding: const EdgeInsets.only(
          left: 7,
          right: 7,
          top: 2,
          bottom: 2,
        ),
        textStyle: TextStyle(
          fontSize: 12,
          color: LMChatTheme.theme.onPrimary,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  /// Creates a copy of this [LMNetworkingChatListStyle] but with the given fields replaced with the new values.
  /// If the new values are null, the old values are retained.
  LMNetworkingChatListStyle copyWith({
    Color? backgroundColor,
    EdgeInsets? padding,
    LMChatProfilePictureStyle? profilePictureStyle,
    LMChatTextStyle? unreadCountTextStyle,
  }) {
    return LMNetworkingChatListStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      padding: padding ?? this.padding,
      profilePictureStyle: profilePictureStyle ?? this.profilePictureStyle,
      unreadCountTextStyle: unreadCountTextStyle ?? this.unreadCountTextStyle,
    );
  }
}
