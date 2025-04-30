import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/member_list/member_list_bloc.dart';
import 'dart:async';
import 'package:likeminds_chat_flutter_core/src/convertors/convertors.dart';

class LMChatMemberList extends StatefulWidget {
  const LMChatMemberList({super.key, this.showList});
  final int? showList;

  @override
  State<LMChatMemberList> createState() => _LMChatMemberListState();
}

class _LMChatMemberListState extends State<LMChatMemberList> {
  final _memberListBloc = LMChatMemberListBloc.instance;
  final _screenBuilder = LMChatCore.config.memberListConfig.builder;
  final int _pageSize = 10;
  String? searchTerm;
  bool _isSearching = false;
  Timer? _debounceTimer;
  final TextEditingController _searchController = TextEditingController();
  final LMChatUserViewData currentUser =
      LMChatLocalPreference.instance.getUser().toUserViewData();

  late final PagingController<int, LMChatUserViewData> _pagingController;
  bool _isProcessingTap = false;
  @override
  void initState() {
    super.initState();
    _initPagingController();
  }

  void _initPagingController() {
    _pagingController = PagingController(firstPageKey: 1);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      if (searchTerm != null && searchTerm!.isNotEmpty) {
        _memberListBloc.add(LMChatMemberListSearchEvent(
          query: searchTerm!,
          page: pageKey,
          pageSize: _pageSize,
          showList: widget.showList,
        ));
      } else {
        _memberListBloc.add(LMChatGetAllMemberEvent(
          page: pageKey,
          pageSize: _pageSize,
          showList: widget.showList,
        ));
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void _refresh() {
    _pagingController.refresh();
  }

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 200), () {
      setState(() {
        searchTerm = query;
      });
      _pagingController.refresh();
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _screenBuilder.scaffold(
      appBar: _screenBuilder.appBarBuilder(
        context,
        _defaultAppBar(),
        _isSearching,
        _searchController,
        _onSearchChanged,
        _onClear,
      ),
      body: _buildMemberList(),
    );
  }

  LMChatAppBar _defaultAppBar() {
    return LMChatAppBar(
      title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search members',
                border: InputBorder.none,
              ),
              onChanged: _onSearchChanged,
              onSubmitted: (value) {
                setState(() {
                  _isSearching = false;
                });
              },
            )
          : const LMChatText('Members'),
      trailing: [
        LMChatButton(
          onTap: _onClear,
          style: LMChatButtonStyle.basic().copyWith(
            icon: LMChatIcon(
              type: LMChatIconType.icon,
              icon: _isSearching ? Icons.close : Icons.search,
            ),
          ),
        ),
      ],
    );
  }

  void _onClear() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        searchTerm = null;
        _pagingController.refresh();
      }
    });
  }

  Widget _buildMemberList() {
    return BlocConsumer<LMChatMemberListBloc, LMChatMemberListState>(
      bloc: _memberListBloc,
      listener: (context, state) {
        if (state is LMChatMemberListError) {
          _pagingController.error = state.message;
        } else if (state is LMChatMemberListLoaded) {
          final filteredMembers = state.members
              .where((member) => member.id != currentUser.id)
              .toList();
          if (filteredMembers.length < _pageSize) {
            _pagingController.appendLastPage(filteredMembers);
          } else {
            _pagingController.appendPage(filteredMembers, state.page + 1);
          }
        }
      },
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async => _refresh(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: PagedListView<int, LMChatUserViewData>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<LMChatUserViewData>(
                itemBuilder: (context, member, index) {
                  return _screenBuilder.userTileBuilder(
                    context,
                    member,
                    _defaultMemberTile(member),
                    _navigateToChatroom,
                  );
                },
                firstPageErrorIndicatorBuilder: (context) =>
                    _screenBuilder.firstPageErrorIndicatorBuilder(
                        context, _defFirstPageErrorIndicatorBuilder),
                firstPageProgressIndicatorBuilder: (context) =>
                    _screenBuilder.firstPageProgressIndicatorBuilder(
                        context, _defFirstPageProgressIndicatorBuilder),
                noItemsFoundIndicatorBuilder: (context) =>
                    _screenBuilder.noItemsFoundIndicatorBuilder(
                        context, _defNoItemsFoundIndicatorBuilder),
              ),
            ),
          ),
        );
      },
    );
  }

  final Widget _defNoItemsFoundIndicatorBuilder = const Center(
    child: Text(
      'No members found',
    ),
  );

  final Widget _defFirstPageProgressIndicatorBuilder = const Center(
    child: CircularProgressIndicator(),
  );

  final Widget _defFirstPageErrorIndicatorBuilder = const Center(
    child: Text(
      'Failed to load members. Please try again.',
    ),
  );

  LMChatUserTile _defaultMemberTile(LMChatUserViewData member) {
    return LMChatUserTile(
      userViewData: member,
      style: LMChatTileStyle.basic(),
      onTap: () => _handleUserTileTap(member),
    );
  }

  void _handleUserTileTap(LMChatUserViewData member) async {
    // Prevent multiple taps while processing
    if (_isProcessingTap) return;

    // Set flag to true

    _isProcessingTap = true;

    // Get isDMWithRequestEnabled setting from local preferences
    final bool isDMWithRequestEnabled = getIsDMWithRequestEnabled();

    // Build the request body
    final checkDMLimitRequest =
        (CheckDmLimitRequestBuilder()..uuid(member.uuid)).build();
    // check dm limit
    final response = await LMChatCore.client.checkDMLimit(checkDMLimitRequest);
    if (!response.success) {
      // show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(response.errorMessage ?? 'Failed to check DM limit')),
      );
      return;
    }
    // check if the user already have a chatroom with the member
    if (response.data?.chatroomId != null) {
      // navigate to the chatroom
      _navigateToChatroom(response.data?.chatroomId);
    } else {
      if (isDMWithRequestEnabled) {
        // check if limit is not exceeded
        if (!(response.data?.isRequestDmLimitExceeded ?? false)) {
          // create dm chatroom
          final createDmChatroomRequest = (CreateDMChatroomRequestBuilder()
                ..uuid(member.uuid)
                ..memberId(member.id))
              .build();

          // create dm chatroom
          final response =
              await LMChatCore.client.createDMChatroom(createDmChatroomRequest);

          if (response.success) {
            // navigate to the chatroom
            _navigateToChatroom(response.data?.chatRoom?.id);
          } else {
            // show error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      response.errorMessage ?? 'Failed to create DM chatroom')),
            );
          }
        } else {
          // show error
          // Show dialog with DM limit exceeded message
          int? newTime = response.data!.newRequestDmTimestamp;
          showDialog(
            context: context,
            builder: (context) => _screenBuilder.rateLimitDialog(
                context, newTime, _defRateLimitDialog(newTime, context)),
          );
        }
      } else {
        // create dm chatroom
        final createDmChatroomRequest = (CreateDMChatroomRequestBuilder()
              ..uuid(member.uuid)
              ..memberId(member.id))
            .build();

        // create dm chatroom
        final response =
            await LMChatCore.client.createDMChatroom(createDmChatroomRequest);

        if (response.success) {
          // navigate to the chatroom

          _navigateToChatroom(response.data?.chatRoom?.id);
        } else {
          // show error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    response.errorMessage ?? 'Failed to create DM chatroom')),
          );
        }
      }
    }
    _isProcessingTap = false;
  }

  void _navigateToChatroom(int? chatroomId) {
    if (chatroomId == null) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LMChatroomScreen(chatroomId: chatroomId),
      ),
    );
  }

  LMChatDialog _defRateLimitDialog(int? newTime, BuildContext context) {
    return LMChatDialog(
      title: const LMChatText('DM Request Limit Exceeded'),
      content: LMChatText(
          'You have exceeded your DM request limit. You can send your next DM request after ${getTimeLeftToSendReq(newTime)}.'),
      actions: [
        LMChatText(
          'OK',
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }

  /// Returns the time left to send req.
  static String getTimeLeftToSendReq(int? expiryTime) {
    if (expiryTime == null) {
      return "";
    }
    DateTime expiryTimeInDateTime =
        DateTime.fromMillisecondsSinceEpoch(expiryTime);
    DateTime now = DateTime.now();
    Duration difference = expiryTimeInDateTime.difference(now);

    if (difference.isNegative) {
      return "some time.";
    }

    int days = difference.inDays;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;

    if (days > 0) {
      return "$days day${days > 1 ? 's' : ''}";
    } else if (hours > 0) {
      return "$hours hour${hours > 1 ? 's' : ''} $minutes minute${minutes > 1 ? 's' : ''}";
    } else if (minutes > 0) {
      return "$minutes minute${minutes > 1 ? 's' : ''}";
    } else {
      return "some time.";
    }
  }
}
