import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/explore/bloc/explore_bloc.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/chatroom/chatroom_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/realtime/realtime.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_core/src/views/chatroom/chatroom.dart';
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

  int pinnedChatroomCount = 0;
  int _page = 1;
  bool pinnedChatroom = false;

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
    return Scaffold(
      backgroundColor: LMChatTheme.theme.scaffold,
      appBar: _defaultExploreAppBar(),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _defaultExploreMenu(),
              const Spacer(),
              _defaultExplorePinButton(),
            ],
          ),
        ),
        kVerticalPaddingXLarge,
        Expanded(
          child: _defaultExploreBlocConsumer(),
        ),
      ],
    );
  }

  BlocConsumer<LMChatExploreBloc, LMChatExploreState>
      _defaultExploreBlocConsumer() {
    return BlocConsumer<LMChatExploreBloc, LMChatExploreState>(
      bloc: exploreBloc,
      buildWhen: (previous, current) {
        if (current is LMChatExploreLoadingState && _page != 1) {
          return false;
        }
        return true;
      },
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
            return Row(
              children: [
                LMChatText(
                  getStateSpace(_space),
                  style: const LMChatTextStyle(
                    maxLines: 1,
                    textStyle: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_downward,
                  size: 28,
                ),
              ],
            );
          }),
    );
  }

  Container _defaultExploreMenuBox() {
    return Container(
      width: 52.w,
      decoration: BoxDecoration(
        color: LMChatTheme.theme.container,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
            title: const Text(
              "Newest",
            ),
            onTap: () {
              _controller.hideMenu();
              _space = LMChatSpace.newest;
              rebuildLMChatSpace.value = !rebuildLMChatSpace.value;
              _refreshExploreFeed();
            },
          ),
          ListTile(
            title: const Text(
              "Recently Active",
            ),
            onTap: () {
              _controller.hideMenu();
              _space = LMChatSpace.active;
              rebuildLMChatSpace.value = !rebuildLMChatSpace.value;
              _refreshExploreFeed();
            },
          ),
          ListTile(
            title: const Text(
              "Most Participants",
            ),
            onTap: () {
              _controller.hideMenu();
              _space = LMChatSpace.mostParticipants;
              rebuildLMChatSpace.value = !rebuildLMChatSpace.value;
              _refreshExploreFeed();
            },
          ),
          ListTile(
            title: const Text(
              "Most Messages",
            ),
            onTap: () {
              _controller.hideMenu();
              _space = LMChatSpace.mostMessages;
              rebuildLMChatSpace.value = !rebuildLMChatSpace.value;
              _refreshExploreFeed();
            },
          ),
        ],
      ),
    );
  }

  PagedListView<int, ChatRoom> _defaultExploreFeedList() {
    return PagedListView(
      pagingController: exploreFeedPagingController,
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      builderDelegate: PagedChildBuilderDelegate<ChatRoom>(
        noItemsFoundIndicatorBuilder: (context) => const Center(
          child: Text(
            "Opps, no chatrooms found!",
          ),
        ),
        itemBuilder: (context, item, index) =>
            _defaultExploreTile(item, context),
      ),
    );
  }

  LMChatExploreTile _defaultExploreTile(ChatRoom item, BuildContext context) {
    return LMChatExploreTile(
      chatroom: item.toChatRoomViewData(),
      // refresh: () => refresh(),
      onTap: () {
        LMChatRealtime.instance.chatroomId = item.id;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LMChatroomScreen(
              chatroomId: item.id,
            ),
          ),
        );
        _markRead(item.id);
      },
    );
  }

  Widget _defaultExplorePinButton() {
    return ValueListenableBuilder(
      valueListenable: rebuildPin,
      builder: (context, _, __) {
        return pinnedChatroomCount <= 1
            ? const SizedBox()
            : GestureDetector(
                onTap: () {
                  pinnedChatroom = !pinnedChatroom;
                  rebuildPin.value = !rebuildPin.value;
                  _refreshExploreFeed();
                  debugPrint("Pin button tapped");
                },
                child: pinnedChatroom
                    ? _defaultPinnedButton()
                    : _defaultPinButton(),
              );
      },
    );
  }

  Container _defaultPinButton() {
    return Container(
      // height: 18.sp,
      // width: 18.sp,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      child: const Icon(
        Icons.push_pin,
        // size: 10.sp,
        // color: kDarkGreyColor,
      ),
    );
  }

  Container _defaultPinnedButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.red,
        ),
      ),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: LMChatTheme.theme.primaryColor,
                ),
              ),
              child: Icon(
                Icons.push_pin,
                // size: 10.sp,
                // color: LMTheme.buttonColor,
                color: LMChatTheme.theme.primaryColor,
              ),
            ),
            kHorizontalPaddingSmall,
            const Text(
              'Pinned',
              // style: LMTheme.medium.copyWith(
              //     color: LMTheme.buttonColor),
            ),
            kHorizontalPaddingSmall,
            const SizedBox(
              // height: 18.sp,
              // width: 18.sp,
              child: Icon(
                CupertinoIcons.xmark,
                size: 24,
                // size: 12.sp,
                // color: LMTheme.buttonColor,
              ),
            ),
          ]),
    );
  }

  void refresh() => setState(() {});

  void _refreshExploreFeed() {
    _page = 1;
    exploreFeedPagingController.itemList?.clear();
    exploreBloc.add(
      LMChatFetchExploreEvent(
        getExploreFeedRequest: (GetExploreFeedRequestBuilder()
              ..orderType(mapLMChatSpacesToInt(_space))
              ..page(_page)
              ..pinned(pinnedChatroom))
            .build(),
      ),
    );
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
