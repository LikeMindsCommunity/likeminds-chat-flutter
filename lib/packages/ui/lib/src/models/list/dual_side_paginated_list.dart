import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:super_sliver_list/super_sliver_list.dart'; // Ensure you have the SuperListView package

typedef ItemBuilder<T> = Widget Function(BuildContext context, T item);
typedef LoadingBuilder = Widget Function(BuildContext context);
typedef ErrorBuilder = Widget Function(
    BuildContext context, VoidCallback retry);

class LMDualSidePagedList<T> extends StatefulWidget {
  final Future<List<T>> Function(int page, int pageSize) fetchData;
  final ItemBuilder<T> itemBuilder;
  final LoadingBuilder? firstPageLoadingBuilder;
  final LoadingBuilder? paginationLoadingBuilder;
  final WidgetBuilder? noItemsBuilder;
  final WidgetBuilder? noMoreItemsBuilder;
  final ErrorBuilder? errorBuilder;
  final ErrorBuilder? paginationErrorBuilder;
  final int pageSize;
  final int initialPage;
  final int? topSideLimit;
  final int? bottomSideLimit;
  final ScrollController? scrollController;
  final ListController? listController;

  const LMDualSidePagedList({
    super.key,
    required this.fetchData,
    required this.itemBuilder,
    this.firstPageLoadingBuilder,
    this.paginationLoadingBuilder,
    this.noItemsBuilder,
    this.noMoreItemsBuilder,
    this.errorBuilder,
    this.paginationErrorBuilder,
    this.pageSize = 20,
    required this.initialPage,
    this.topSideLimit,
    this.bottomSideLimit,
    this.scrollController,
    this.listController,
  });

  @override
  LMDualSidePagedListState<T> createState() => LMDualSidePagedListState<T>();
}

class LMDualSidePagedListState<T> extends State<LMDualSidePagedList<T>> {
  final List<T> items = [];
  late int currentPage; // Starting page
  late int upSidePage;
  late int downSidePage;
  bool _isLoadingFirstPage = true;
  bool _isLoadingTop = false;
  bool _isLoadingBottom = false;
  bool _hasError = false;
  bool _paginationError = false;
  late final ScrollController scrollController;
  late final ListController listController;

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialPage;
    upSidePage = currentPage;
    downSidePage = currentPage;
    scrollController = widget.scrollController ?? ScrollController();
    listController = widget.listController ?? ListController();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final newData = await widget.fetchData(currentPage, widget.pageSize);
      if (mounted) {
        setState(() {
          items.addAll(newData);
          _isLoadingFirstPage = false;
          _hasError = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoadingFirstPage = false;
        });
      }
    }
  }

  Future<void> _loadMoreTop() async {
    // Check if the top side limit is reached
    if (widget.topSideLimit != null && upSidePage <= widget.topSideLimit!) {
      return;
    }
    if (_isLoadingTop) return; // Prevent multiple calls
    setState(() {
      _isLoadingTop = true;
    });

    try {
      final newData = await widget.fetchData(--upSidePage, widget.pageSize);
      if (newData.isNotEmpty) {
        // Use PostFrameCallback to ensure the scroll adjustment happens after the frame
        SchedulerBinding.instance.addPostFrameCallback((_) {
          // Insert new data at the top
          items.insertAll(0, newData);
          listController.jumpToItem(
            index: newData.length + 3,
            scrollController: scrollController,
            alignment: 0.0,
          );
          // setState(() {
          _isLoadingTop = false; // Stop the loading state
          // });
        });
      } else {
        upSidePage++; // Revert if no new data
        setState(() {
          _isLoadingTop = false;
        });
      }
    } catch (e) {
      upSidePage++; // Revert if error occurs
      setState(() {
        _paginationError = true;
        _isLoadingTop = false;
      });
    }
  }

  Future<void> _loadMoreBottom() async {
    // Check if the bottom side limit is reached
    if (widget.bottomSideLimit != null &&
        downSidePage >= widget.bottomSideLimit!) {
      return;
    }
    if (_isLoadingBottom) return; // Prevent multiple calls
    setState(() {
      _isLoadingBottom = true;
    });

    try {
      final newData = await widget.fetchData(++downSidePage, widget.pageSize);
      if (newData.isNotEmpty && mounted) {
        setState(() {
          items.addAll(newData);
        });
      }
    } catch (e) {
      downSidePage--; // revert page increment if no data is returned
      setState(() {
        _paginationError = true;
      });
    } finally {
      setState(() {
        _isLoadingBottom = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingFirstPage) {
      return widget.firstPageLoadingBuilder?.call(context) ??
          const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return widget.errorBuilder?.call(context, _loadInitialData) ??
          const Center(child: Text("An error occurred"));
    }

    if (items.isEmpty) {
      return widget.noItemsBuilder?.call(context) ??
          const Center(child: Text("No items found"));
    }

    return SuperListView.builder(
      controller: scrollController,
      listController: listController,
      itemCount:
          items.length + (_isLoadingBottom ? 1 : 0) + (_isLoadingTop ? 1 : 0),
      itemBuilder: (context, index) {
        // Trigger _loadMoreTop() when the first item is being built
        if (index == 0 && !_isLoadingTop) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _loadMoreTop();
          });
        }
        if (index == 0 && _isLoadingTop) {
          return widget.paginationLoadingBuilder?.call(context) ??
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
        }
        if (_isLoadingBottom && index == items.length) {
          return widget.paginationLoadingBuilder?.call(context) ??
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
        }

        final actualIndex = _isLoadingTop ? index - 1 : index;

        // Trigger _loadMoreBottom() when the last item is being built
        if (actualIndex == items.length - 1 && !_isLoadingBottom) {
          debugPrint("Triggering load more bottom");
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _loadMoreBottom();
          });
        }
        if (actualIndex < items.length) {
          return widget.itemBuilder(context, items[actualIndex]);
        }
        return null;
      },
    );
  }
}
