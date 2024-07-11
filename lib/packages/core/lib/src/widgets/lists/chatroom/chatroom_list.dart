import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/blocs.dart';
import 'package:likeminds_chat_flutter_core/src/utils/chatroom/chatroom_utils.dart';
import 'package:likeminds_chat_flutter_core/src/utils/realtime/realtime.dart';
import 'package:likeminds_chat_flutter_core/src/views/views.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// {@template lm_chat_home_feed_list}
/// A widget that represents a List of Group Chatrooms on home
/// Talks to an instance of LMChatHomeFeedBloc, and updates accordingly
/// Allows for customizations to change the look and feel.
/// {@endtemplate}
class LMChatHomeFeedList extends StatefulWidget {
  /// [chatroomTileBuilder] is a builder function to render a chatroom tile
  final LMChatroomTileBuilder? chatroomTileBuilder;

  /// [LMChatHomeFeedListStyle] is a style object to customize the look and feel
  final LMChatHomeFeedListStyle? style;

  /// [firstPageErrorIndicatorBuilder] is a builder function to render an error indicator on first page
  final LMContextWidgetBuilder? firstPageErrorIndicatorBuilder;

  /// [newPageErrorIndicatorBuilder] is a builder function to render an error indicator on new page
  final LMContextWidgetBuilder? newPageErrorIndicatorBuilder;

  /// [firstPageProgressIndicatorBuilder] is a builder function to render a progress indicator on first page
  final LMContextWidgetBuilder? firstPageProgressIndicatorBuilder;

  /// [newPageProgressIndicatorBuilder] is a builder function to render a progress indicator on new page
  final LMContextWidgetBuilder? newPageProgressIndicatorBuilder;

  /// [noItemsFoundIndicatorBuilder] is a builder function to render a no items found indicator
  final LMContextWidgetBuilder? noItemsFoundIndicatorBuilder;

  /// [noMoreItemsIndicatorBuilder] is a builder function to render a no more items indicator
  final LMContextWidgetBuilder? noMoreItemsIndicatorBuilder;

  /// {@macro lm_chat_home_feed_list}
  const LMChatHomeFeedList({
    super.key,
    this.style,
    this.chatroomTileBuilder,
    this.firstPageErrorIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
    this.firstPageProgressIndicatorBuilder,
    this.newPageProgressIndicatorBuilder,
    this.noItemsFoundIndicatorBuilder,
    this.noMoreItemsIndicatorBuilder,
  });

  /// Creates a copy of this [LMChatHomeFeedList] but with the given fields replaced with the new values.
  LMChatHomeFeedList copyWith({
    LMChatroomTileBuilder? chatroomTileBuilder,
    LMChatHomeFeedListStyle? style,
    LMContextWidgetBuilder? firstPageErrorIndicatorBuilder,
    LMContextWidgetBuilder? newPageErrorIndicatorBuilder,
    LMContextWidgetBuilder? firstPageProgressIndicatorBuilder,
    LMContextWidgetBuilder? newPageProgressIndicatorBuilder,
    LMContextWidgetBuilder? noItemsFoundIndicatorBuilder,
    LMContextWidgetBuilder? noMoreItemsIndicatorBuilder,
  }) {
    return LMChatHomeFeedList(
      chatroomTileBuilder: chatroomTileBuilder ?? this.chatroomTileBuilder,
      style: style ?? this.style,
      firstPageErrorIndicatorBuilder:
          firstPageErrorIndicatorBuilder ?? this.firstPageErrorIndicatorBuilder,
      newPageErrorIndicatorBuilder:
          newPageErrorIndicatorBuilder ?? this.newPageErrorIndicatorBuilder,
      firstPageProgressIndicatorBuilder: firstPageProgressIndicatorBuilder ??
          this.firstPageProgressIndicatorBuilder,
      newPageProgressIndicatorBuilder: newPageProgressIndicatorBuilder ??
          this.newPageProgressIndicatorBuilder,
      noItemsFoundIndicatorBuilder:
          noItemsFoundIndicatorBuilder ?? this.noItemsFoundIndicatorBuilder,
      noMoreItemsIndicatorBuilder:
          noMoreItemsIndicatorBuilder ?? this.noMoreItemsIndicatorBuilder,
    );
  }

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
      backgroundColor:
          widget.style?.backgroundColor ?? LMChatTheme.theme.scaffold,
      body: SafeArea(
        top: false,
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  physics: const ClampingScrollPhysics(),
                  builderDelegate:
                      PagedChildBuilderDelegate<LMChatRoomViewData>(
                    firstPageErrorIndicatorBuilder:
                        widget.firstPageErrorIndicatorBuilder ??
                            (context) => _defaultErrorView(),
                    newPageErrorIndicatorBuilder:
                        widget.newPageErrorIndicatorBuilder ??
                            (context) => _defaultErrorView(),
                    firstPageProgressIndicatorBuilder:
                        widget.firstPageProgressIndicatorBuilder ??
                            (context) => const LMChatSkeletonChatroomList(),
                    newPageProgressIndicatorBuilder:
                        widget.newPageProgressIndicatorBuilder ??
                            (context) => const LMChatSkeletonChatroomList(),
                    noItemsFoundIndicatorBuilder:
                        widget.noItemsFoundIndicatorBuilder,
                    noMoreItemsIndicatorBuilder:
                        widget.noMoreItemsIndicatorBuilder,
                    itemBuilder: (context, item, index) {
                      return widget.chatroomTileBuilder
                              ?.call(item, _defaultHomeChatRoomTile(item)) ??
                          _defaultHomeChatRoomTile(item);
                    },
                  ),
                );
              }),
        ),
      ),
    );
  }

  _addPaginationListener() {
    homeFeedPagingController.addPageRequestListener(
      (pageKey) {
        feedBloc.add(
          LMChatFetchHomeFeedEvent(
            page: pageKey,
          ),
        );
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
        style: const LMChatProfilePictureStyle(size: 48),
      ),
      title: LMChatText(
        chatroom.header,
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

  /// {@macro lm_chat_home_feed_list_style}
  const LMChatHomeFeedListStyle({
    this.backgroundColor,
    this.padding,
  });
}
