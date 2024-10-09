import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/user/user_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/utils/constants/assets.dart';

/// {@template lm_chat_poll_result_screen}
/// A screen to display poll results.
/// {@endtemplate}
class LMChatPollResultScreen extends StatefulWidget {
  /// {@macro lm_chat_poll_result_screen}
  const LMChatPollResultScreen({
    super.key,
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

  final int conversationId;
  final String? pollTitle;
  final List<LMChatPollOptionViewData> pollOptions;
  final int? selectedOptionId;
  // Builder for empty feed view
  final LMChatContextWidgetBuilder? noItemsFoundIndicatorBuilder;
  // Builder for first page loader when no user are there
  final LMChatContextWidgetBuilder? firstPageProgressIndicatorBuilder;
  // Builder for pagination loader when more user are there
  final LMChatContextWidgetBuilder? newPageProgressIndicatorBuilder;
  // Builder for widget when no more user are there
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

  @override
  initState() {
    super.initState();
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
        appBar: _defAppBar(),
        body: Column(
          children: [
            TabBar(
              onTap: (index) {
                _pagingController.animateToPage(index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              },
              controller: _tabController,
              dividerColor: theme.inActiveColor,
              indicatorColor: theme.primaryColor,
              indicatorWeight: 4,
              isScrollable: true,
              labelColor: theme.primaryColor,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: const TextStyle(
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
                          _defVoteCountText(option),
                          _defOptionText(option),
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

  LMChatText _defOptionText(LMChatPollOptionViewData option) {
    return LMChatText(
      option.text,
    );
  }

  LMChatText _defVoteCountText(LMChatPollOptionViewData option) {
    return LMChatText(option.noVotes.toString());
  }

  LMChatAppBar _defAppBar() {
    return LMChatAppBar(
      style: LMChatAppBarStyle(
        height: 50,
        padding: const EdgeInsets.only(
          right: 16,
        ),
        backgroundColor: theme.container,
        border: Border.all(
          color: Colors.transparent,
        ),
      ),
      leading: const BackButton(),
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
    );
  }

  Widget _defListView(LMChatPollOptionViewData option) {
    if (option.noVotes != null && option.noVotes! <= 0) {
      return _defNoResponse();
    }
    PagingController<int, LMChatUserViewData> pagingController =
        PagingController(firstPageKey: 1);
    _addPaginationListener(pagingController, option.id!);

    return PagedListView<int, LMChatUserViewData>(
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (context, item, index) {
          return _defUserTile(item);
        },
        noItemsFoundIndicatorBuilder: (context) {
          return widget.noItemsFoundIndicatorBuilder?.call(context) ??
              _defNoResponse();
        },
      ),
    );
  }

  LMChatUserTile _defUserTile(LMChatUserViewData item) {
    return LMChatUserTile(
      userViewData: item,
    );
  }

  Center _defNoResponse() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LMChatImage(
            imageAssetPath: emptyViewImage,
            style: LMChatImageStyle(
              height: 100,
              width: 100,
              margin: EdgeInsets.only(bottom: 16),
            ),
          ),
          LMChatText(
            'No Response',
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

  void _addPaginationListener(
    PagingController<int, LMChatUserViewData> _pagingController,
    int pollOptionId,
  ) {
    _pagingController.addPageRequestListener(
      (pageKey) async {
        await _getUserList(
          _pagingController,
          pageKey,
          pollOptionId,
        );
      },
    );
  }

  Future<void> _getUserList(
    PagingController<int, LMChatUserViewData> pagingController,
    int page,
    int pollOptionId,
  ) async {
    GetPollUsersRequest request = (GetPollUsersRequestBuilder()
          ..conversationId(widget.conversationId)
          ..pollId(pollOptionId))
        .build();

    LMResponse<GetPollUsersResponse> response =
        await LMChatCore.instance.lmChatClient.getPollUsers(request);
    if (!response.success) {
      pagingController.error = response.errorMessage;
      return;
    }

    final List<LMChatUserViewData> users =
        response.data!.data!.map((e) => e.toUserViewData()).toList();

    pagingController.appendLastPage(
      users,
    );
  }
}