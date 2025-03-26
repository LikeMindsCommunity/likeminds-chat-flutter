import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/search_conversation/search_conversation_bloc.dart';

class LMChatSearchConversationScreen extends StatefulWidget {
  static const routeName = '/searchConversation';

  /// The chatroom id
  final int chatRoomId;

  /// {@macro lm_chat_search_conversation_screen}
  const LMChatSearchConversationScreen({super.key, required this.chatRoomId});

  @override
  State<LMChatSearchConversationScreen> createState() =>
      _LMChatSearchConversationScreenState();
}

class _LMChatSearchConversationScreenState
    extends State<LMChatSearchConversationScreen> {
  // Controller for the TextField
  final LMChatSearchConversationBloc _searchConversationBloc =
      LMChatSearchConversationBloc.instance;
  String searchTerm = '';
  bool followStatus = false;

  final PagingController<int, LMChatConversationViewData> _pagingController =
      PagingController(firstPageKey: 1);
  Timer? _debounce;
  final int _pageSize = 10;
  final TextEditingController _searchController = TextEditingController();
  final LMSearchBuilderDelegate _screenBuilder =
      LMChatCore.config.searchConversationConfig.builder;

  @override
  void initState() {
    super.initState();
    _addPaginationListener();
  }

  void _addPaginationListener() {
    _pagingController.addPageRequestListener((pageKey) {
      if (searchTerm.trim().isNotEmpty) {
        _searchConversationBloc.add(
          LMChatGetSearchConversationEvent(
            chatroomId: widget.chatRoomId,
            search: searchTerm,
            page: pageKey,
            followStatus: followStatus,
            pageSize: _pageSize,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    // focusNode.dispose();
    _searchController.dispose();
    // _showSearchBarTextField.dispose();
    _pagingController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // Clear the text in the TextField
  void _clearSearch() {
    _searchController.clear();
    _pagingController.itemList = <LMChatConversationViewData>[];
    _pagingController.nextPageKey = 1; // Reset to the first page
    return;
  }

  @override
  Widget build(BuildContext context) {
    return _screenBuilder.scaffold(
      appBar: _screenBuilder.appBarBuilder(context, _defaultAppBar(context)),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: BlocConsumer<LMChatSearchConversationBloc,
                LMChatSearchConversationState>(
              bloc: _searchConversationBloc,
              listener: _updatePaginationState,
              buildWhen: (previous, current) {
                if (current is LMChatSearchConversationPaginationLoadingState) {
                  return false;
                }
                return true;
              },
              builder: (context, state) {
                if (state is LMChatSearchConversationLoadingState) {
                  return LMChatLoader(
                    style: LMChatTheme.theme.loaderStyle,
                  );
                }
                return _buildSearchResultsList();
              },
            ),
          ),
        ],
      )),
    );
  }

  LMChatTile _defUserTile(LMChatConversationViewData conversation) {
    return LMChatTile(
      onTap: () {},
      style: LMChatTileStyle(
        backgroundColor: LMChatTheme.theme.container,
        gap: 4,
        margin: const EdgeInsets.only(bottom: 2),
      ),
      leading: LMChatProfilePicture(
          style: LMChatProfilePictureStyle.basic().copyWith(
            size: 50,
          ),
          fallbackText: conversation.member?.name ?? '',
          imageUrl: conversation.member?.imageUrl // onTap: onTap,
          ),
      trailing: null,
      title: Row(
        children: [
          LMChatText(
            conversation.member?.name ?? 'NULL',
            style: LMChatTextStyle(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: LMChatTheme.theme.onContainer,
              ),
            ),
          ),
          const Spacer(),
          LMChatText(
            _formatDateFromTimestamp(int.parse(conversation.createdAt)),
            style: LMChatTextStyle(
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: LMChatTheme.theme.onContainer,
              ),
            ),
          ),
        ],
      ),
      subtitle: LMChatText(
        conversation.answer,
        style: LMChatTextStyle(
          textStyle: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: LMChatTheme.theme.onContainer,
          ),
        ),
      ),
    );
  }

  LMChatAppBar _defaultAppBar(BuildContext context) {
    return LMChatAppBar(
      leading: _screenBuilder.backButton(
        context,
        _defaultBackButton(context),
      ),

      title: _screenBuilder.searchField(
        context,
        _defaultTextField(),
      ),
      trailing: [
        _screenBuilder.clearSearchButton(context, _defaultClearSearchButton()),
      ],
      style:
          LMChatAppBarStyle.basic(Colors.white), // Customize the AppBar style
    );
  }

  LMChatButton _defaultClearSearchButton() {
    return LMChatButton(
      onTap: () {
        _clearSearch();
      },
      style: LMChatButtonStyle(
        height: 28,
        width: 28,
        borderRadius: 6,
        padding: EdgeInsets.zero,
        icon: LMChatIcon(
          type: LMChatIconType.icon,
          icon: Icons.close,
          style: LMChatIconStyle(
            color: LMChatTheme.theme.onContainer,
            size: 24,
            boxSize: 28,
          ),
        ),
        backgroundColor: LMChatTheme.theme.container,
      ),
    );
  }

  LMChatTextField _defaultTextField() {
    return LMChatTextField(
      controller: _searchController,
      chatroomId: 1,
      onTagSelected: (p0) {},
      isDown: false,
      focusNode: FocusNode(),
      onChange: _onSearchTextChange,
      // autofocus: true, // Automatically focus on the TextField
      decoration: const InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none, // No border for simplicity
      ),
    );
  }

  String _formatDateFromTimestamp(int timestamp) {
    // Convert the timestamp to a DateTime object
    final givenDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();

    // Calculate the difference in days between the given date and today
    final differenceInDays = now.difference(givenDate).inDays;

    if (differenceInDays == 0) {
      // If it's today, return the time in HH:mm format
      return '${givenDate.hour.toString().padLeft(2, '0')}:${givenDate.minute.toString().padLeft(2, '0')}';
    } else if (differenceInDays == 1) {
      return 'Yesterday';
    } else if (differenceInDays < 7) {
      // Return the day of the week (e.g., "Saturday")
      return [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ][givenDate.weekday - 1];
    } else {
      // Return the formatted date (e.g., "2023-05-10")
      return '${givenDate.month.toString().padLeft(2, '0')}-${givenDate.day.toString().padLeft(2, '0')}-${givenDate.year}';
    }
  }

  void _onSearchTextChange(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        if (value.trim().isEmpty) {
          // Reset the pagination controller and clear the search results
          _pagingController.itemList = <LMChatConversationViewData>[];
          _pagingController.nextPageKey = 1; // Reset to the first page
          return;
        }

        searchTerm = value;
        _pagingController.nextPageKey = 2;
        _pagingController.itemList = <LMChatConversationViewData>[];
        _searchConversationBloc.add(
          LMChatGetSearchConversationEvent(
            chatroomId: widget.chatRoomId,
            search: searchTerm,
            page: 1,
            followStatus: followStatus,
            pageSize: _pageSize,
          ),
        );
      },
    );
  }

  LMChatButton _defaultBackButton(BuildContext context) {
    return LMChatButton(
      onTap: () {
        Navigator.of(context).pop();
      },
      style: LMChatButtonStyle(
        height: 28,
        width: 28,
        borderRadius: 6,
        padding: EdgeInsets.zero,
        icon: LMChatIcon(
          type: LMChatIconType.icon,
          icon: Icons.arrow_back,
          style: LMChatIconStyle(
            color: LMChatTheme.theme.onContainer,
            size: 24,
            boxSize: 28,
          ),
        ),
        backgroundColor: LMChatTheme.theme.container,
      ),
    );
  }

  void _updatePaginationState(context, state) {
    debugPrint(state.toString());
    if (state is LMChatSearchConversationLoadedState) {
      debugPrint(state.toString());
      if (state.results.length < _pageSize) {
        _pagingController.appendLastPage(
          state.results,
        );
      } else {
        _pagingController.appendPage(
          state.results,
          state.page + 1,
        );
      }
    } else if (state is LMChatParticipantsErrorState) {
      _pagingController.error = state.errorMessage;
    }
  }

  ///! remove them
  Widget firstPageProgressIndicatorBuilder(
    BuildContext context,
  ) {
    LMChatThemeData chatThemeData = LMChatTheme.instance.themeData;
    return LMChatLoader(
      style: chatThemeData.loaderStyle,
    );
  }

  Widget newPageProgressIndicatorBuilder(
    BuildContext context,
  ) {
    LMChatThemeData chatThemeData = LMChatTheme.instance.themeData;
    return LMChatLoader(
      style: chatThemeData.loaderStyle,
    );
  }

  Widget noItemsFoundIndicatorBuilder(
    BuildContext context,
  ) {
    return const Center(
      child: LMChatText(
        'No search results found',
        style: LMChatTextStyle(
          textStyle: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResultsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: PagedListView(
        padding: EdgeInsets.zero,
        pagingController: _pagingController,
        physics: const ClampingScrollPhysics(),
        builderDelegate: PagedChildBuilderDelegate<LMChatConversationViewData>(
          itemBuilder: (context, item, index) {
            return _defUserTile(item);
          },
          // firstPageErrorIndicatorBuilder:
          //     _screenBuilder.firstPageErrorIndicatorBuilder,
          // newPageErrorIndicatorBuilder:
          //     _screenBuilder.newPageErrorIndicatorBuilder,
          firstPageProgressIndicatorBuilder: firstPageProgressIndicatorBuilder,
          newPageProgressIndicatorBuilder: newPageProgressIndicatorBuilder,
          noItemsFoundIndicatorBuilder: noItemsFoundIndicatorBuilder,
          // noMoreItemsIndicatorBuilder:
          //     _screenBuilder.noMoreItemsIndicatorBuilder,
        ),
      ),
    );
  }
}
