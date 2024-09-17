// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';

import 'package:likeminds_chat_flutter_core/src/blocs/explore/bloc/explore_bloc.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/chatroom/chatroom_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/constants/assets.dart';
import 'package:likeminds_chat_flutter_core/src/utils/realtime/realtime.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/widgets.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// {@template lm_chat_explore_page}
/// A screen to show the Explore Feed of LMChat
///
/// Creates a new instance for [LMChatExplorePage]
///
/// Gives access to customizations through instance builder variables
///
/// To configure the page, use [LMChatExplorePageConfig]
/// {@endtemplate}
class LMChatExplorePage extends StatefulWidget {
  /// {@macro lm_chat_explore_page}
  const LMChatExplorePage({super.key});

  @override
  State<LMChatExplorePage> createState() => _LMChatExplorePageState();
}

class _LMChatExplorePageState extends State<LMChatExplorePage> {
  final LMChatExploreBloc exploreBloc = LMChatExploreBloc.instance;
  LMChatSpace _space = LMChatSpace.newest;

  ValueNotifier<bool> rebuildPin = ValueNotifier(false);
  ValueNotifier<bool> rebuildLMChatSpace = ValueNotifier(false);
  final CustomPopupMenuController _controller = CustomPopupMenuController();
  PagingController<int, ChatRoom> exploreFeedPagingController =
      PagingController<int, ChatRoom>(firstPageKey: 1);
  final _screenBuilder = LMChatCore.config.exploreConfig.builder;

  int pinnedChatroomCount = 0;
  int _page = 1;
  bool pinnedChatroom = false;
  final LMChatCustomPopupMenuStyle _defMenuStyle = LMChatCustomPopupMenuStyle(
    textStyle: const LMChatTextStyle(
      maxLines: 1,
      textStyle: TextStyle(
        fontSize: 16,
      ),
    ),
    iconStyle: const LMChatIconStyle(
      size: 28,
    ),
    menuBoxWidth: 52.w,
    menuBoxDecoration: BoxDecoration(
      color: LMChatTheme.theme.container,
      borderRadius: BorderRadius.circular(10),
    ),
  );

  LMChatCustomPopupMenuStyle _popUpMenuStyle() =>
      LMChatCore.config.exploreConfig.style.popUpMenuStyle?.call(
        _defMenuStyle,
      ) ??
      _defMenuStyle;

  @override
  void initState() {
    super.initState();
    _addPaginationListener();
  }

  @override
  void dispose() {
    exploreBloc.close();
    exploreFeedPagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _screenBuilder.scaffold(
      backgroundColor: LMChatTheme.theme.scaffold,
      appBar: _screenBuilder.appBarBuilder(context, _defaultExploreAppBar()),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: _defaultExploreBody(),
      ),
    );
  }

  Column _defaultExploreBody() {
    return Column(
      children: [
        kVerticalPaddingSmall,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _screenBuilder.exploreMenuBuilder(
                context,
                _shortNewest,
                _shortRecentlyActive,
                _shortMostParticipants,
                _shortMostMessages,
                _defaultExploreMenu(),
              ),
              const Spacer(),
              _defaultExplorePinButton(),
            ],
          ),
        ),
        kVerticalPaddingXLarge,
        Expanded(
          child: _defaultExploreBlocConsumer(),
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  BlocConsumer<LMChatExploreBloc, LMChatExploreState>
      _defaultExploreBlocConsumer() {
    return BlocConsumer<LMChatExploreBloc, LMChatExploreState>(
      bloc: exploreBloc,
      listener: (context, state) {
        _updatePagingController(state);
      },
      builder: (context, state) {
        return _defaultExploreFeedList();
      },
    );
  }

  LMChatAppBar _defaultExploreAppBar() {
    return LMChatAppBar(
      style: LMChatTheme.theme.appBarStyle.copyWith(
        height: 72,
        gap: 4.w,
        padding: EdgeInsets.all(4.w),
      ),
      title: LMChatText(
        'Explore Chatrooms',
        style: LMChatTextStyle(
          textStyle: TextStyle(
            color: LMChatTheme.theme.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  CustomPopupMenu _defaultExploreMenu() {
    return CustomPopupMenu(
      pressType: PressType.singleClick,
      controller: _controller,
      showArrow: false,
      menuBuilder: () => _defaultExploreMenuBox(),
      child: ValueListenableBuilder(
          valueListenable: rebuildLMChatSpace,
          builder: (context, _, __) {
            return Container(
              color: _popUpMenuStyle().backgroundColor,
              child: Row(
                children: [
                  LMChatText(
                    getStateSpace(_space),
                    style: _popUpMenuStyle().textStyle,
                  ),
                  const SizedBox(width: 8),
                  LMChatIcon(
                    type: LMChatIconType.icon,
                    icon: Icons.arrow_downward,
                    style: _popUpMenuStyle().iconStyle,
                  ),
                ],
              ),
            );
          }),
    );
  }

  Container _defaultExploreMenuBox() {
    return Container(
      width: _popUpMenuStyle().menuBoxWidth ?? 52.w,
      height: _popUpMenuStyle().menuBoxHeight,
      decoration: _popUpMenuStyle().menuBoxDecoration ??
          BoxDecoration(
            color: LMChatTheme.theme.container,
            borderRadius: BorderRadius.circular(10),
          ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              "Newest",
              style: _popUpMenuStyle().menuTextStyle,
            ),
            onTap: _shortNewest,
          ),
          ListTile(
            title: Text(
              "Recently Active",
              style: _popUpMenuStyle().menuTextStyle,
            ),
            onTap: _shortRecentlyActive,
          ),
          ListTile(
            title: Text(
              "Most Participants",
              style: _popUpMenuStyle().menuTextStyle,
            ),
            onTap: _shortMostParticipants,
          ),
          ListTile(
            title: Text(
              "Most Messages",
              style: _popUpMenuStyle().menuTextStyle,
            ),
            onTap: _shortMostMessages,
          ),
        ],
      ),
    );
  }

  void _shortMostMessages() {
    _controller.hideMenu();
    _space = LMChatSpace.mostMessages;
    rebuildLMChatSpace.value = !rebuildLMChatSpace.value;
    _refreshExploreFeed();
  }

  void _shortMostParticipants() {
    _controller.hideMenu();
    _space = LMChatSpace.mostParticipants;
    rebuildLMChatSpace.value = !rebuildLMChatSpace.value;
    _refreshExploreFeed();
  }

  void _shortRecentlyActive() {
    _controller.hideMenu();
    _space = LMChatSpace.active;
    rebuildLMChatSpace.value = !rebuildLMChatSpace.value;
    _refreshExploreFeed();
  }

  void _shortNewest() {
    _controller.hideMenu();
    _space = LMChatSpace.newest;
    rebuildLMChatSpace.value = !rebuildLMChatSpace.value;
    _refreshExploreFeed();
  }

  PagedListView<int, ChatRoom> _defaultExploreFeedList() {
    return PagedListView(
      pagingController: exploreFeedPagingController,
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      builderDelegate: PagedChildBuilderDelegate<ChatRoom>(
        noItemsFoundIndicatorBuilder: (context) => _defaultEmptyView(),
        newPageProgressIndicatorBuilder: (context) => const LMChatLoader(),
        firstPageProgressIndicatorBuilder: (context) => const LMChatLoader(),
        itemBuilder: (context, item, index) =>
            _screenBuilder.exploreTileBuilder(
          context,
          item.toChatRoomViewData(),
          _defaultExploreTile(item, context),
        ),
      ),
    );
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

  LMChatExploreTile _defaultExploreTile(ChatRoom item, BuildContext context) {
    return LMChatExploreTile(
      style: LMChatTheme.theme.chatTileStyle.copyWith(
        gap: 6,
        padding: EdgeInsets.symmetric(
          horizontal: 4.w,
          vertical: 1.h,
        ),
      ),
      chatroom: item.toChatRoomViewData(),
      onTap: () {
        LMChatRealtime.instance.chatroomId = item.id;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LMChatroomScreen(
              chatroomId: item.id,
            ),
          ),
        ).then((d) {
          _refreshExploreFeed();
        });
        _markRead(item.id);
      },
    );
  }

  Widget _defaultExplorePinButton() {
    return ValueListenableBuilder(
      valueListenable: rebuildPin,
      builder: (context, _, __) {
        return pinnedChatroomCount <= 3
            ? const SizedBox()
            : pinnedChatroom
                ? _screenBuilder.pinnedButtonBuilder(
                    context,
                    _defaultPinnedButton(),
                  )
                : _screenBuilder.pinButtonBuilder(
                    context,
                    _defaultPinButton(),
                  );
      },
    );
  }

  LMChatButton _defaultPinButton() {
    return LMChatButton(
      onTap: () {
        pinnedChatroom = !pinnedChatroom;
        rebuildPin.value = !rebuildPin.value;
        _refreshExploreFeed();
        debugPrint("Pin button tapped");
      },
      icon: const LMChatIcon(
        type: LMChatIconType.icon,
        icon: Icons.push_pin_outlined,
        style: LMChatIconStyle(
          size: 20,
        ),
      ),
      style: LMChatButtonStyle(
        height: 32,
        width: 32,
        border: Border.all(),
        borderRadius: 16,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  LMChatButton _defaultPinnedButton() {
    return LMChatButton(
      onTap: () {
        pinnedChatroom = !pinnedChatroom;
        rebuildPin.value = !rebuildPin.value;
        _refreshExploreFeed();
        debugPrint("Pin button tapped");
      },
      text: const LMChatText(
        "Pinned",
        style: LMChatTextStyle(
          textStyle: TextStyle(fontSize: 14),
        ),
      ),
      icon: LMChatIcon(
        type: LMChatIconType.icon,
        icon: Icons.push_pin_outlined,
        style: LMChatIconStyle(
          size: 18,
          boxBorder: 1,
          boxBorderRadius: 11,
          boxPadding: const EdgeInsets.all(2),
          boxSize: 22,
          boxBorderColor: LMChatTheme.theme.onContainer,
        ),
      ),
      style: LMChatButtonStyle(
        height: 32,
        spacing: 6,
        border: Border.all(),
        borderRadius: 16,
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 4,
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  void _refreshExploreFeed() {
    exploreFeedPagingController.refresh();
  }

  _addPaginationListener() {
    exploreFeedPagingController.addPageRequestListener(
      (pageKey) {
        exploreBloc.add(
          LMChatFetchExploreEvent(
            getExploreFeedRequest: (GetExploreFeedRequestBuilder()
                  ..orderType(mapLMChatSpacesToInt(_space))
                  ..page(pageKey)
                  ..pinned(pinnedChatroom))
                .build(),
          ),
        );
      },
    );
  }

  void _markRead(int chatroomId) async {
    await LMChatCore.instance.lmChatClient.markReadChatroom(
      (MarkReadChatroomRequestBuilder()..chatroomId(chatroomId)).build(),
    );
  }

  void _updatePagingController(LMChatExploreState state) {
    if (state is LMChatExploreLoadedState) {
      pinnedChatroomCount =
          state.getExploreFeedResponse.pinnedChatroomCount ?? 0;
      _page++;
      if (state.getExploreFeedResponse.chatrooms == null ||
          state.getExploreFeedResponse.chatrooms!.isEmpty) {
        exploreFeedPagingController.appendLastPage([]);
      } else {
        exploreFeedPagingController.appendPage(
          state.getExploreFeedResponse.chatrooms!,
          _page,
        );
      }
      rebuildPin.value = !rebuildPin.value;
    } else if (state is LMChatExploreErrorState) {
      exploreFeedPagingController.error = state.errorMessage;
    }
  }
}
