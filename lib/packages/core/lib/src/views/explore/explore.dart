import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/explore/bloc/explore_bloc.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/observer.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/realtime/realtime.dart';
import 'package:likeminds_chat_flutter_core/src/views/chatroom/chatroom.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

class LMChatExplorePage extends StatefulWidget {
  const LMChatExplorePage({super.key});

  @override
  State<LMChatExplorePage> createState() => _LMChatExplorePageState();
}

class _LMChatExplorePageState extends State<LMChatExplorePage> {
  late LMChatSpaces _spaces;
  PagingController<int, ChatRoom> exploreFeedPagingController =
      PagingController<int, ChatRoom>(firstPageKey: 1);
  final CustomPopupMenuController _controller = CustomPopupMenuController();
  ValueNotifier<bool> rebuildLMChatSpaces = ValueNotifier(false);
  ValueNotifier<bool> rebuildPin = ValueNotifier(false);
  LMChatExploreBloc? exploreBloc;
  bool pinnedChatroom = false;
  int pinnedChatroomCount = 0;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    Bloc.observer = LMChatBlocObserver();
    _spaces = LMChatSpaces.newest;
    exploreBloc = LMChatExploreBloc.instance;
    exploreBloc!.add(
      LMChatFetchExploreEvent(
        getExploreFeedRequest: (GetExploreFeedRequestBuilder()
              ..orderType(mapLMChatSpacesToInt())
              ..page(_page)
              ..pinned(pinnedChatroom))
            .build(),
      ),
    );
    _addPaginationListener();
  }

  int mapLMChatSpacesToInt() {
    switch (_spaces) {
      case LMChatSpaces.newest:
        return 0;
      case LMChatSpaces.active:
        return 1;
      case LMChatSpaces.mostMessages:
        return 2;
      case LMChatSpaces.mostParticipants:
        return 3;
    }
  }

  void refreshExploreFeed() {
    _page = 1;
    exploreFeedPagingController.itemList?.clear();
    exploreBloc?.add(
      LMChatFetchExploreEvent(
        getExploreFeedRequest: (GetExploreFeedRequestBuilder()
              ..orderType(mapLMChatSpacesToInt())
              ..page(_page)
              ..pinned(pinnedChatroom))
            .build(),
      ),
    );
  }

  _addPaginationListener() {
    exploreFeedPagingController.addPageRequestListener(
      (pageKey) {
        exploreBloc?.add(
          LMChatFetchExploreEvent(
            getExploreFeedRequest: (GetExploreFeedRequestBuilder()
                  ..orderType(mapLMChatSpacesToInt())
                  ..page(pageKey)
                  ..pinned(pinnedChatroom))
                .build(),
          ),
        );
      },
    );
  }

  String getStateSpace() {
    switch (_spaces) {
      case LMChatSpaces.newest:
        return "Newest";
      case LMChatSpaces.active:
        return "Recently Active";
      case LMChatSpaces.mostParticipants:
        return "Most Participants";
      case LMChatSpaces.mostMessages:
        return "Most Messages";
    }
  }

  Future onChoosingModal(context) => showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListTile(
                  title: const Text("Newest"),
                  onTap: () {
                    _spaces = LMChatSpaces.newest;
                    rebuildLMChatSpaces.value = !rebuildLMChatSpaces.value;
                    refreshExploreFeed();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Recently Active"),
                  onTap: () {
                    _spaces = LMChatSpaces.active;
                    rebuildLMChatSpaces.value = !rebuildLMChatSpaces.value;
                    refreshExploreFeed();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Most Participants"),
                  onTap: () {
                    _spaces = LMChatSpaces.mostParticipants;
                    rebuildLMChatSpaces.value = !rebuildLMChatSpaces.value;
                    refreshExploreFeed();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Most Messages"),
                  onTap: () {
                    _spaces = LMChatSpaces.mostMessages;
                    rebuildLMChatSpaces.value = !rebuildLMChatSpaces.value;
                    refreshExploreFeed();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      );

  void markRead(int chatroomId, {bool toast = false}) async {
    await LMChatCore.instance.lmChatClient.markReadChatroom(
      (MarkReadChatroomRequestBuilder()..chatroomId(chatroomId)).build(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBarChildren: [
        //   // const bb.BackButton(),
        //   const SizedBox(width: 24),
        //   Text(
        //     "Explore Chatrooms",
        //     // style: LMTheme.medium.copyWith(fontSize: 13.sp),
        //   ),
        //   const Spacer(),
        // ],
        appBar: AppBar(),
        body: Column(
          children: [
            kVerticalPaddingSmall,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomPopupMenu(
                  pressType: PressType.singleClick,
                  controller: _controller,
                  showArrow: false,
                  menuBuilder: () => Container(
                    width: 50.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ListTile(
                          title: const Text(
                            "Newest",
                            // style: LMTheme.medium,
                          ),
                          onTap: () {
                            _controller.hideMenu();
                            _spaces = LMChatSpaces.newest;
                            rebuildLMChatSpaces.value =
                                !rebuildLMChatSpaces.value;
                            refreshExploreFeed();
                          },
                        ),
                        ListTile(
                          title: const Text(
                            "Recently Active",
                            // style: LMTheme.medium,
                          ),
                          onTap: () {
                            _controller.hideMenu();
                            _spaces = LMChatSpaces.active;
                            rebuildLMChatSpaces.value =
                                !rebuildLMChatSpaces.value;
                            refreshExploreFeed();
                          },
                        ),
                        ListTile(
                          title: const Text(
                            "Most Participants",
                            // style: LMTheme.medium,
                          ),
                          onTap: () {
                            _controller.hideMenu();
                            _spaces = LMChatSpaces.mostParticipants;
                            rebuildLMChatSpaces.value =
                                !rebuildLMChatSpaces.value;
                            refreshExploreFeed();
                          },
                        ),
                        ListTile(
                          title: const Text(
                            "Most Messages",
                            // style: LMTheme.medium,
                          ),
                          onTap: () {
                            _controller.hideMenu();
                            _spaces = LMChatSpaces.mostMessages;
                            rebuildLMChatSpaces.value =
                                !rebuildLMChatSpaces.value;
                            refreshExploreFeed();
                          },
                        ),
                      ],
                    ),
                  ),
                  child: ValueListenableBuilder(
                      valueListenable: rebuildLMChatSpaces,
                      builder: (context, _, __) {
                        return Row(
                          children: [
                            Text(
                              getStateSpace(),
                              // style: GoogleFonts.montserrat(
                              //   fontSize: 16,
                              //   fontWeight: FontWeight.w400,
                              // ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_downward,
                              size: 28,
                            ),
                          ],
                        );
                      }),
                ),
                const Spacer(),
                ValueListenableBuilder(
                  valueListenable: rebuildPin,
                  builder: (context, _, __) {
                    return pinnedChatroomCount <= 3
                        ? const SizedBox()
                        : GestureDetector(
                            onTap: () {
                              pinnedChatroom = !pinnedChatroom;
                              rebuildPin.value = !rebuildPin.value;
                              refreshExploreFeed();
                              debugPrint("Pin button tapped");
                            },
                            child: pinnedChatroom
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: Colors.red,
                                      ),
                                    ),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            // height: 18.sp,
                                            // width: 18.sp,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  // color: LMTheme.buttonColor,
                                                  ),
                                            ),
                                            child: const Icon(
                                              Icons.push_pin,
                                              // size: 10.sp,
                                              // color: LMTheme.buttonColor,
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
                                  )
                                : Container(
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
                                  ),
                          );
                  },
                ),
              ],
            ),
            kVerticalPaddingXLarge,
            Expanded(
              child: BlocConsumer<LMChatExploreBloc, LMChatExploreState>(
                bloc: exploreBloc,
                buildWhen: (previous, current) {
                  if (current is LMChatExploreLoadingState && _page != 1) {
                    return false;
                  }
                  return true;
                },
                listener: (context, state) {
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
                },
                builder: (context, state) {
                  if (state is LMChatExploreLoadingState) {
                    return const Center(child: LMChatLoader());
                  }

                  if (state is LMChatExploreLoadedState) {
                    return PagedListView(
                      pagingController: exploreFeedPagingController,
                      padding: EdgeInsets.zero,
                      physics: const ClampingScrollPhysics(),
                      builderDelegate: PagedChildBuilderDelegate<ChatRoom>(
                        noItemsFoundIndicatorBuilder: (context) => const Center(
                            child: Text(
                          "Opps, no chatrooms found!",
                          // style: LMTheme.medium,
                        )),
                        itemBuilder: (context, item, index) =>
                            LMChatExploreTile(
                          chatroom: item,
                          refresh: () => refresh(),
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
                            markRead(item.id);
                          },
                        ),
                      ),
                    );
                  } else if (state is LMChatExploreErrorState) {
                    return Center(
                      child: Text(state.errorMessage),
                    );
                  }
                  return const SizedBox();
                  // return const BlocError();
                },
              ),
            ),
          ],
        ));
  }

  void refresh() => setState(() {});
}
