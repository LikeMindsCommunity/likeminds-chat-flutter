import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/user/user_convertor.dart';



class LMChatPollResultScreen extends StatefulWidget {
  const LMChatPollResultScreen({
    super.key,
    required this.pollId,
    required this.conversationId,
    required this.pollOptions,
    this.pollTitle,
    this.selectedOptionId,
    this.noItemsFoundIndicatorBuilder,
    this.firstPageProgressIndicatorBuilder,
    this.newPageProgressIndicatorBuilder,
    this.noMoreItemsIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
    this.firstPageErrorIndicatorBuilder,
    this.tabWidth,
  });

  final int pollId;
  final int conversationId;
  final String? pollTitle;
  final List<LMChatPollOptionViewData> pollOptions;
  final int? selectedOptionId;
  // Builder for empty feed view
  final LMChatContextWidgetBuilder? noItemsFoundIndicatorBuilder;
  // Builder for first page loader when no post are there
  final LMChatContextWidgetBuilder? firstPageProgressIndicatorBuilder;
  // Builder for pagination loader when more post are there
  final LMChatContextWidgetBuilder? newPageProgressIndicatorBuilder;
  // Builder for widget when no more post are there
  final LMChatContextWidgetBuilder? noMoreItemsIndicatorBuilder;
  // Builder for error view while loading a new page
  final LMChatContextWidgetBuilder? newPageErrorIndicatorBuilder;
  // Builder for error view while loading the first page
  final LMChatContextWidgetBuilder? firstPageErrorIndicatorBuilder;
  // width for the poll options tab
  final double? tabWidth;

  @override
  State<LMChatPollResultScreen> createState() => _LMChatPollResultScreenState();
}

class _LMChatPollResultScreenState extends State<LMChatPollResultScreen>
    with SingleTickerProviderStateMixin {
  LMChatThemeData theme = LMChatTheme.theme;
  LMChatUserViewData? user =
      LMChatLocalPreference.instance.getUser().toUserViewData();
  int initialIndex = 0;
  late TabController _tabController;
  late PageController _pagingController;
  int pageSize = 10;

  @override
  initState() {
    super.initState();
    // LMChatAnalyticsBloc.instance.add(LMChatFireAnalyticsEvent(
    //     eventName: LMChatAnalyticsKeys.pollAnswersViewed,
    //     eventProperties: {
    //       LMChatStringConstants.pollId: widget.pollId,
    //       LMChatStringConstants.pollTitle: widget.pollTitle ?? '',
    //     }));
    setTabController();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    setTabController();
  }

  void setTabController() {
    _pagingController = PageController(initialPage: initialIndex);
    _tabController = TabController(
      length: widget.pollOptions.length,
      initialIndex: initialIndex,
      vsync: this,
    );
    if (widget.selectedOptionId != null) {
      int index = widget.pollOptions
          .indexWhere((element) => element.id == widget.selectedOptionId);
      if (index != -1) {
        initialIndex = index;
        if (_tabController.index != initialIndex) {
          _tabController.animateTo(initialIndex);
        }
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (_pagingController.page != initialIndex) {
            _pagingController.jumpToPage(initialIndex);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: theme.container,
        appBar: LMChatAppBar(
          style: LMChatAppBarStyle(
            height: 40,
            padding: EdgeInsets.only(
              right: 16,
            ),
            backgroundColor: theme.container,
            border: Border.all(
              color: Colors.transparent,
            ),
          ),
          leading: BackButton(),
          title: LMChatText(
            'Poll Results',
            style: LMChatTextStyle(
              textStyle: TextStyle(
                color: theme.onContainer,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            TabBar(
              onTap: (index) {
                _pagingController.animateToPage(index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              },
              controller: _tabController,
              dividerColor: theme.primaryColor,
              indicatorColor: theme.primaryColor,
              indicatorWeight: 4,
              isScrollable: true,
              labelColor: theme.primaryColor,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              unselectedLabelColor: theme.inActiveColor,
              tabs: [
                for (var option in widget.pollOptions)
                  Tab(
                    child: SizedBox(
                      width: widget.tabWidth ??
                          (widget.pollOptions.length == 2
                              ? width / 3
                              : width / 4),
                      child: Column(
                        children: [
                          LMChatText(
                            option.noVotes.toString(),
                          ),
                          LMChatText(
                            option.text,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: SafeArea(
                child: PageView.builder(
                  onPageChanged: (index) {
                    triggerPollAnswersToggledEvent(index);
                    _tabController.animateTo(index);
                  },
                  controller: _pagingController,
                  itemCount: widget.pollOptions.length,
                  itemBuilder: (context, index) {
                    return _defListView(widget.pollOptions[index]);
                  },
                ),
              ),
            )
          ],
        ));
  }

  void triggerPollAnswersToggledEvent(int index) {
    // LMChatAnalyticsBloc.instance.add(LMChatFireAnalyticsEvent(
    //     eventName: LMChatAnalyticsKeys.pollAnswersToggled,
    //     eventProperties: {
    //       LMChatStringConstants.pollId: widget.pollId,
    //       LMChatStringConstants.pollOptionId: widget.pollOptions[index].id,
    //       LMChatStringConstants.pollOptionText: widget.pollOptions[index].text,
    //       LMChatStringConstants.pollTitle: widget.pollTitle ?? '',
    // }));
  }

  Widget _defListView(LMChatPollOptionViewData option) {
    if (option.noVotes != null && option.noVotes! <= 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LMChatIcon(
              style: LMChatIconStyle(size: 100),
              type: LMChatIconType.icon,
              icon: Icons.sentiment_dissatisfied,
              // assetPath: lmNoResponsePng,
            ),
            SizedBox(height: 8),
            LMChatText(
              'No Responses',
              style: LMChatTextStyle(
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      );
    }
    PagingController<int, LMChatUserViewData> pagingController =
        PagingController(firstPageKey: 1);
    _addPaginationListener(pagingController, [option.id.toString()]);

    return PagedListView<int, LMChatUserViewData>(
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (context, item, index) {
          return UserTile(user: item);
        },
        // noItemsFoundIndicatorBuilder: widget.noItemsFoundIndicatorBuilder ??
        //     _widgetUtility.noItemsFoundIndicatorBuilderChat,
        // firstPageProgressIndicatorBuilder:
        //     widget.firstPageProgressIndicatorBuilder ??
        //         _widgetUtility.firstPageProgressIndicatorBuilderChat,
        // newPageProgressIndicatorBuilder:
        //     widget.newPageProgressIndicatorBuilder ??
        //         _widgetUtility.newPageProgressIndicatorBuilderChat,
        // noMoreItemsIndicatorBuilder: widget.noMoreItemsIndicatorBuilder ??
        //     _widgetUtility.noMoreItemsIndicatorBuilderChat,
      ),
    );
  }

  void _addPaginationListener(
      PagingController<int, LMChatUserViewData> _pagingController,
      List<String> votes) {
    _pagingController.addPageRequestListener(
      (pageKey) async {
        await _getUserList(_pagingController, pageKey, votes);
      },
    );
  }

  Future<void> _getUserList(
      PagingController<int, LMChatUserViewData> _pagingController,
      int page,
      List<String> votes) async {
    GetPollUsersRequest request = (GetPollUsersRequestBuilder()
          ..conversationId(widget.conversationId)
          ..pollId(widget.pollId))
        .build();

    LMResponse<GetPollUsersResponse> response =
        await LMChatCore.instance.lmChatClient.getPollUsers(request);
    if (!response.success) {
      _pagingController.error = response.errorMessage;
      return;
    }

    // Map<String, LMChatWidgetViewData> widgets =
    //     response.data?.widgets.map((key, value) {
    //           return MapEntry(
    //               key, LMWidgetViewDataConvertor.fromWidgetModel(value));
    //         }) ??
    //         {};

    List<LMChatUserViewData> users = [];
    if (response.data?.data?.isEmpty ?? true) {
      _pagingController.appendLastPage([]);
      return;
    }
    // response.data?.data?.first.users.forEach((e) {
    //   final LMUserViewData user = LMUserViewDataConvertor.fromUser(
    //     response.data!.users[e]!,
    //     topics: topics,
    //     widgets: widgets,
    //     userTopics: response.data!.userTopics,
    //   );
    // users.add(user);
    // });

    if (users.isEmpty) {
      _pagingController.appendLastPage([]);
    } else {
      final isLastPage = users.length < pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(users);
      } else {
        _pagingController.appendPage(users, page + 1);
      }
    }
  }
}

class UserTile extends StatelessWidget {
  final LMChatUserViewData? user;
  const UserTile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: LMChatUserTile(
        userViewData: user!,
        subtitle: SizedBox.shrink(),
        style: const LMChatTileStyle(
          gap: 2,
          padding: EdgeInsets.only(
            left: 16.0,
            top: 16.0,
            right: 8.0,
          ),
        ),
        onTap: () {
          LMChatProfileBloc.instance.add(
            LMChatRouteToUserProfileEvent(
              uuid: user?.sdkClientInfo?.uuid ?? user?.uuid ?? '',
              context: context,
            ),
          );
        },
      ),
    );
  }
}
