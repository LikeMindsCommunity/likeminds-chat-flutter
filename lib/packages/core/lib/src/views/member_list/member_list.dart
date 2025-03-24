import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/member_list/member_list_bloc.dart';

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
      _memberListBloc.add(LMChatGetAllMemberEvent(
        page: pageKey,
        pageSize: _pageSize,
      ));
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void _refresh() {
    _pagingController.refresh();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _screenBuilder.scaffold(
      appBar: _defaultAppBar(),
      body: _buildMemberList(),
    );
  }

  PreferredSizeWidget _defaultAppBar() {
    return LMChatAppBar(
      title: const Text('Members'),
      style: LMChatAppBarStyle(
        backgroundColor: LMChatTheme.theme.primaryColor,
      ),
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
    );
  }
}
