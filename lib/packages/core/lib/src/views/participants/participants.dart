import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/participants/participants_bloc.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// [LMChatroomParticipantsPage] is a page to display the participants of a chat room.
/// It uses [LMChatParticipantsBloc] to fetch the participants of a chat room.
class LMChatroomParticipantsPage extends StatefulWidget {
  /// [chatroomViewData] is the chat room for which the participants are to be fetched.
  final LMChatRoomViewData chatroomViewData;

  /// [LMChatroomParticipantsPage] constructor to create an instance of [LMChatroomParticipantsPage].
  const LMChatroomParticipantsPage({
    super.key,
    required this.chatroomViewData,
  });

  @override
  State<LMChatroomParticipantsPage> createState() =>
      _LMChatroomParticipantsPageState();
}

class _LMChatroomParticipantsPageState
    extends State<LMChatroomParticipantsPage> {
  LMChatParticipantsBloc? participantsBloc = LMChatParticipantsBloc.instance;
  FocusNode focusNode = FocusNode();
  String? searchTerm;
  final ValueNotifier<bool> _showSearchBarTextField =
      ValueNotifier<bool>(false);
  final TextEditingController _searchController = TextEditingController();
  final PagingController<int, LMChatUserViewData> _pagingController =
      PagingController(firstPageKey: 1);
  Timer? _debounce;
  final int _pageSize = 10;
  final LMChatParticipantBuilderDelegate _screenBuilder =
      LMChatCore.config.participantConfig.builder;

  @override
  void initState() {
    super.initState();
    _addPaginationListener();
  }

  @override
  void dispose() {
    focusNode.dispose();
    _searchController.dispose();
    _showSearchBarTextField.dispose();
    _pagingController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  _addPaginationListener() {
    _pagingController.addPageRequestListener((pageKey) {
      participantsBloc!.add(
        LMChatGetParticipantsEvent(
          chatroomId: widget.chatroomViewData.id,
          page: pageKey,
          pageSize: _pageSize,
          search: searchTerm,
          isSecret: widget.chatroomViewData.isSecret ?? false,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _screenBuilder.scaffold(
      backgroundColor: LMChatTheme.instance.themeData.container,
      appBar: _screenBuilder.appBarBuilder(
        context,
        _searchController,
        _onSearchTap,
        _defAppBar(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocListener(
                bloc: participantsBloc,
                listener: _updatePaginationState,
                child: _buildParticipantsList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LMChatAppBar _defAppBar() {
    return LMChatAppBar(
      style: LMChatAppBarStyle(
        height: 72,
        gap: 0,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
      ),
      title: ValueListenableBuilder(
        valueListenable: _showSearchBarTextField,
        builder: (context, value, __) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              // vertical: 2.h,
            ),
            child: _showSearchBarTextField.value
                ? TextField(
                    focusNode: focusNode,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    controller: _searchController,
                    onChanged: _onSearchTextChange,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search...",
                      hintStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const LMChatText(
                        "Participants",
                        style: LMChatTextStyle(
                          maxLines: 1,
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      kVerticalPaddingSmall,
                      Text(
                        _memberCountText,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
      trailing: [
        ValueListenableBuilder(
            valueListenable: _showSearchBarTextField,
            builder: (context, value, __) {
              return GestureDetector(
                onTap: _onSearchTap,
                child: LMChatIcon(
                    type: LMChatIconType.icon,
                    icon: value ? Icons.close : Icons.search,
                    style: const LMChatIconStyle(
                      size: 24,
                    )),
              );
            }),
      ],
    );
  }

  void _onSearchTap() {
    if (_showSearchBarTextField.value) {
      searchTerm = null;
      _searchController.clear();
      _pagingController.nextPageKey = 2;
      _pagingController.itemList = <LMChatUserViewData>[];
      participantsBloc!.add(
        LMChatGetParticipantsEvent(
          chatroomId: widget.chatroomViewData.id,
          page: 1,
          pageSize: _pageSize,
          search: searchTerm,
          isSecret: widget.chatroomViewData.isSecret ?? false,
        ),
      );
    } else {
      if (focusNode.canRequestFocus) {
        focusNode.requestFocus();
      }
    }
    _showSearchBarTextField.value = !_showSearchBarTextField.value;
  }

  String get _memberCountText {
    final int count = widget.chatroomViewData.participantCount ?? 0;
    return count == 1 ? "$count Member" : "$count Members";
  }

  void _onSearchTextChange(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        searchTerm = value;
        _pagingController.nextPageKey = 2;
        _pagingController.itemList = <LMChatUserViewData>[];
        participantsBloc!.add(
          LMChatGetParticipantsEvent(
            chatroomId: widget.chatroomViewData.id,
            page: 1,
            pageSize: _pageSize,
            search: searchTerm,
            isSecret: widget.chatroomViewData.isSecret ?? false,
          ),
        );
      },
    );
  }

  void _updatePaginationState(context, state) {
    if (state is LMChatParticipantsLoadedState) {
      if (state.participants.length < _pageSize) {
        _pagingController.appendLastPage(
          state.participants,
        );
      } else {
        _pagingController.appendPage(
          state.participants,
          state.page + 1,
        );
      }
    } else if (state is LMChatParticipantsErrorState) {
      _pagingController.error = state.errorMessage;
    }
  }

  Widget _buildParticipantsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: PagedListView(
        padding: EdgeInsets.zero,
        pagingController: _pagingController,
        physics: const ClampingScrollPhysics(),
        builderDelegate: PagedChildBuilderDelegate<LMChatUserViewData>(
          itemBuilder: (context, item, index) {
            LMChatUserTile userTile = LMChatUserTile(
              userViewData: item,
            );
            return _screenBuilder.userTileBuilder(context, item, userTile);
          },
          firstPageErrorIndicatorBuilder:
              _screenBuilder.firstPageErrorIndicatorBuilder,
          newPageErrorIndicatorBuilder:
              _screenBuilder.newPageErrorIndicatorBuilder,
          firstPageProgressIndicatorBuilder:
              _screenBuilder.firstPageProgressIndicatorBuilder,
          newPageProgressIndicatorBuilder:
              _screenBuilder.newPageProgressIndicatorBuilder,
          noItemsFoundIndicatorBuilder:
              _screenBuilder.noItemsFoundIndicatorBuilder,
          noMoreItemsIndicatorBuilder:
              _screenBuilder.noMoreItemsIndicatorBuilder,
        ),
      ),
    );
  }
}
