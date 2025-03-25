import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/member_list/member_list_bloc.dart';
import 'dart:async';

class LMChatMemberList extends StatefulWidget {
  const LMChatMemberList({super.key});

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

  late final PagingController<int, LMChatUserViewData> _pagingController;

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
        ));
      } else {
        _memberListBloc.add(LMChatGetAllMemberEvent(
          page: pageKey,
          pageSize: _pageSize,
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
      appBar: _defaultAppBar(),
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
          : const Text('Members'),
      trailing: [
        LMChatButton(
          onTap: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchController.clear();
                searchTerm = null;
                _pagingController.refresh();
              }
            });
          },
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

  Widget _buildMemberList() {
    return BlocConsumer<LMChatMemberListBloc, LMChatMemberListState>(
      bloc: _memberListBloc,
      listener: (context, state) {
        if (state is LMChatMemberListError) {
          _pagingController.error = state.message;
        } else if (state is LMChatMemberListLoaded) {
          if (state.members.length < _pageSize) {
            _pagingController.appendLastPage(state.members);
          } else {
            _pagingController.appendPage(state.members, state.page + 1);
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
                  );
                },
                firstPageProgressIndicatorBuilder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
                noItemsFoundIndicatorBuilder: (context) => const Center(
                  child: Text(
                    'No members found',
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  LMChatUserTile _defaultMemberTile(LMChatUserViewData member) {
    return LMChatUserTile(
      userViewData: member,
      style: LMChatTileStyle.basic(),
      onTap: () => _handleUserTileTap(member),
    );
  }

  void _handleUserTileTap(LMChatUserViewData member) async {
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LMChatroomScreen(chatroomId: response.data!.chatroomId!),
        ),
      );
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
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LMChatroomScreen(
                      chatroomId: response.data!.chatRoom!.id)),
            );
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
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('DM Request Limit Exceeded'),
              content: Text(
                'You have exceeded your DM request limit. You can send your next DM request after ${response.data?.newRequestDmTimestamp != null ? DateTime.fromMillisecondsSinceEpoch(response.data!.newRequestDmTimestamp! * 1000).toString() : 'some time'}.'
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
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
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LMChatroomScreen(chatroomId: response.data!.chatRoom!.id)),
          );
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
  }
}
