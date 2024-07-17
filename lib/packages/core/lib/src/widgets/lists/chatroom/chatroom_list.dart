import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/constants/assets.dart';
import 'package:likeminds_chat_flutter_core/src/utils/realtime/realtime.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// {@template lm_chat_home_feed_list}
/// A widget that represents a List of Group Chatrooms on home
/// Talks to an instance of LMChatHomeFeedBloc, and updates accordingly
/// Allows for customizations to change the look and feel.
/// {@endtemplate}
class LMChatHomeFeedList extends StatefulWidget {
  /// {@macro lm_chat_home_feed_list}
  const LMChatHomeFeedList({
    super.key,
  });

  @override
  State<LMChatHomeFeedList> createState() => _LMChatHomeFeedListState();
}

class _LMChatHomeFeedListState extends State<LMChatHomeFeedList>
    with AutomaticKeepAliveClientMixin<LMChatHomeFeedList> {
  // Widget level track of page key for pagination
  int _page = 1;

  // BLoC needed for list's state management
  late LMChatHomeFeedBloc feedBloc;

  // ValueNotifier to rebuild the list based on an update
  ValueNotifier<bool> rebuildFeedList = ValueNotifier(false);

  // Paging controller to handle pagination, and list updation
  late PagingController<int, LMChatRoomViewData> homeFeedPagingController;

  final LMChatHomeBuilderDelegate _screenBuilder =
      LMChatCore.config.homeConfig.builder;
  final LMChatHomeFeedListStyle? _style =
      LMChatCore.config.homeConfig.style.homeFeedListStyle?.call(
    LMChatHomeFeedListStyle.basic(),
  );

  @override
  void initState() {
    super.initState();
    feedBloc = LMChatHomeFeedBloc.instance;
    homeFeedPagingController = PagingController(firstPageKey: 1);
    _addPaginationListener();
  }

  @override
  void didUpdateWidget(covariant LMChatHomeFeedList oldWidget) {
    super.didUpdateWidget(oldWidget);
    feedBloc = LMChatHomeFeedBloc.instance;
    homeFeedPagingController = PagingController(firstPageKey: 1);
    _addPaginationListener();
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
    return Scaffold(
      backgroundColor: _style?.backgroundColor ?? LMChatTheme.theme.scaffold,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _screenBuilder.homeFeedExploreTileBuilder(
              context,
              _defaultExploreTile(),
            ),
            Expanded(
              child: BlocListener<LMChatHomeFeedBloc, LMChatHomeFeedState>(
                bloc: feedBloc,
                listener: (_, state) {
                  _updatePagingControllers(state);
                },
                child: ValueListenableBuilder(
                    valueListenable: rebuildFeedList,
                    builder: (context, _, __) {
                      return PagedListView<int, LMChatRoomViewData>(
                        pagingController: homeFeedPagingController,
                        padding: _style?.padding ??
                            const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 4,
                            ),
                        physics: const ClampingScrollPhysics(),
                        builderDelegate:
                            PagedChildBuilderDelegate<LMChatRoomViewData>(
                          firstPageErrorIndicatorBuilder: (context) =>
                              _screenBuilder
                                  .homeFeedFirstPageErrorIndicatorBuilder(
                            context,
                            _defaultErrorView(),
                          ),
                          newPageErrorIndicatorBuilder: (context) =>
                              _screenBuilder
                                  .homeFeedNewPageErrorIndicatorBuilder(
                            context,
                            _defaultErrorView(),
                          ),
                          firstPageProgressIndicatorBuilder: (context) =>
                              _screenBuilder
                                  .homeFeedFirstPageProgressIndicatorBuilder(
                            context,
                            const LMChatSkeletonChatroomList(),
                          ),
                          newPageProgressIndicatorBuilder: (context) =>
                              _screenBuilder
                                  .homeFeedNewPageProgressIndicatorBuilder(
                            context,
                            const LMChatLoader(),
                          ),
                          noItemsFoundIndicatorBuilder: (context) =>
                              _screenBuilder
                                  .homeFeedNoItemsFoundIndicatorBuilder(
                            context,
                            _defaultEmptyView(),
                          ),
                          noMoreItemsIndicatorBuilder: (context) =>
                              _screenBuilder
                                  .homeFeedNoMoreItemsIndicatorBuilder(
                            context,
                            const SizedBox(),
                          ),
                          itemBuilder: (context, item, index) {
                            return _screenBuilder.homeFeedTileBuilder(
                              context,
                              item,
                              _defaultHomeChatRoomTile(item),
                            );
                          },
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LMChatTile _defaultExploreTile() {
    return LMChatTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LMChatExplorePage(),
          ),
        ).then((val) {
          feedBloc.add(LMChatRefreshHomeFeedEvent());
        });
      },
      style: LMChatTileStyle.basic().copyWith(
        margin: EdgeInsets.only(
          top: 3.h,
          bottom: 1.h,
        ),
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        height: 4.h,
      ),
      leading: LMChatIcon(
        type: LMChatIconType.svg,
        assetPath: exploreIcon,
        style: LMChatIconStyle(
          color: LMChatTheme.theme.primaryColor,
          size: 28,
          boxSize: 32,
        ),
      ),
      title: Padding(
        padding: EdgeInsets.only(
          left: 4.w,
          right: 4,
        ),
        child: LMChatText(
          'Explore Chatrooms',
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
      ),
      trailing: FutureBuilder(
        future: LMChatCore.client.getExploreTabCount(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            if (snapshot.data!.success) {
              GetExploreTabCountResponse response = snapshot.data!.data!;
              return _screenBuilder.homeFeedExploreChipBuilder(
                context,
                _defExploreChip(response),
              );
            } else {
              const SizedBox();
            }
          }
          return const SizedBox();
        },
      ),
    );
  }

  LMChatChip _defExploreChip(GetExploreTabCountResponse response) {
    return LMChatChip(
      style: LMChatChipStyle.basic().copyWith(
        backgroundColor: LMChatTheme.theme.primaryColor,
        padding: EdgeInsets.symmetric(
          horizontal: 2.w,
        ),
        side: BorderSide.none,
      ),
      label: LMChatText(
        response.unseenChannelCount == null || response.unseenChannelCount == 0
            ? '${response.totalChannelCount} Chatrooms'
            : '${response.unseenChannelCount} NEW',
        style: LMChatTextStyle(
          textStyle: TextStyle(
            color: LMChatTheme.theme.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  _addPaginationListener() {
    homeFeedPagingController.addPageRequestListener(
      (pageKey) {
        feedBloc.add(LMChatFetchHomeFeedEvent(page: pageKey));
      },
    );
  }

  _updatePagingControllers(LMChatHomeFeedState state) {
    if (state is LMChatHomeFeedError) {
      homeFeedPagingController.error = state.errorMessage;
      return;
    }
    if (state is LMChatHomeFeedLoaded) {
      _page++;
      homeFeedPagingController.itemList?.clear();
      homeFeedPagingController.nextPageKey = _page;
      if (state.chatrooms.isEmpty || state.chatrooms.length < 50) {
        homeFeedPagingController.appendLastPage(state.chatrooms);
      } else {
        homeFeedPagingController.appendPage(state.chatrooms, _page);
      }
    } else if (state is LMChatHomeFeedUpdated) {
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
          'Oops! No chatrooms found.',
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

  Widget _defaultErrorView() {
    return Container();
  }

  LMChatTile _defaultHomeChatRoomTile(LMChatRoomViewData chatroom) {
    String message = getHomeChatroomPreviewMessage(chatroom.lastConversation!);
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
        Navigator.of(context).push(route).whenComplete(
              () => feedBloc.add(LMChatRefreshHomeFeedEvent()),
            );
      },
      leading: LMChatProfilePicture(
        fallbackText: chatroom.header,
        imageUrl: chatroom.chatroomImageUrl,
        style: _style?.profilePictureStyle ??
            const LMChatProfilePictureStyle(size: 48),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LMChatText(
            chatroom.header,
            style: const LMChatTextStyle(
              maxLines: 1,
              textStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 2),
          if (chatroom.isSecret == true)
            _screenBuilder.homeFeedSecretChatroomIconBuilder(
              _defSecretChatroomIcon(),
            ),
        ],
      ),
      subtitle: LMChatText(
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
        mainAxisSize: MainAxisSize.min,
        children: [
          chatroom.muteStatus != null && chatroom.muteStatus!
              ? _screenBuilder.homeFeedMuteIconBuilder(
                  _defMuteIcon(),
                )
              : const SizedBox.shrink(),
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
                child: LMChatText(
                  chatroom.unseenCount! > 99
                      ? "99+"
                      : chatroom.unseenCount.toString(),
                  style: LMChatTextStyle(
                    maxLines: 1,
                    backgroundColor: LMChatTheme.theme.primaryColor,
                    borderRadius: 24,
                    padding: const EdgeInsets.only(
                      left: 7,
                      right: 7,
                      top: 2,
                      bottom: 2,
                    ),
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: LMChatTheme.theme.onPrimary,
                      fontWeight: FontWeight.w500,
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

  LMChatIcon _defSecretChatroomIcon() {
    return const LMChatIcon(
      type: LMChatIconType.svg,
      assetPath: secretLockIcon,
      style: LMChatIconStyle(
        size: 20,
      ),
    );
  }

  LMChatIcon _defMuteIcon() {
    return LMChatIcon(
      type: LMChatIconType.icon,
      icon: Icons.volume_off_outlined,
      style: LMChatIconStyle(
        backgroundColor: LMChatTheme.theme.scaffold,
        boxSize: 36,
        boxPadding: const EdgeInsets.only(
          left: 6,
          right: 4,
        ),
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

/// {@template lm_chat_home_feed_list_style}
/// A style object to customize the look and feel of the home feed list
/// {@endtemplate}
class LMChatHomeFeedListStyle {
  /// [backgroundColor] is the background color of the list
  final Color? backgroundColor;

  /// [padding] is the padding of the list
  final EdgeInsets? padding;

  /// [profilePictureStyle] is the style of the profile picture
  final LMChatProfilePictureStyle? profilePictureStyle;

  static final LMChatThemeData _themeData = LMChatTheme.theme;

  /// {@macro lm_chat_home_feed_list_style}
  const LMChatHomeFeedListStyle({
    this.backgroundColor,
    this.padding,
    this.profilePictureStyle,
  });

  /// Default style for the home feed list
  factory LMChatHomeFeedListStyle.basic() {
    return LMChatHomeFeedListStyle(
      backgroundColor: _themeData.scaffold,
      padding: const EdgeInsets.all(0),
      profilePictureStyle: const LMChatProfilePictureStyle(size: 48),
    );
  }

  /// Creates a copy of this [LMChatHomeFeedListStyle] but with the given fields replaced with the new values.
  /// If the fields are null, the original values are retained.
  LMChatHomeFeedListStyle copyWith({
    Color? backgroundColor,
    EdgeInsets? padding,
    LMChatProfilePictureStyle? profilePictureStyle,
  }) {
    return LMChatHomeFeedListStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      padding: padding ?? this.padding,
      profilePictureStyle: profilePictureStyle ?? this.profilePictureStyle,
    );
  }
}
