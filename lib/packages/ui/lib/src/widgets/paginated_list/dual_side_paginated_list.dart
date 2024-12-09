import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/paginated_list/pagination_controller.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/paginated_list/pagination_typedef.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

/// {@template lm_dual_side_paged_list}
/// A widget that displays a list of items that can be paginated from both sides.
/// {@endtemplate}

class LMDualSidePagedList<T> extends StatefulWidget {
  /// The function to call when pagination is triggered.
  final Future<void> Function(
    int page,
    PaginationDirection paginationDirection,
    T? item,
  ) onPaginationTriggered;

  /// The function to build a widget for an item in the list.
  final ItemBuilder<T> itemBuilder;

  /// The function to build a widget for loading the first page.
  final LoadingBuilder? firstPageLoadingBuilder;

  /// The function to build a widget for loading more items.
  final LoadingBuilder? paginationLoadingBuilder;

  /// The function to build a widget when there are no items.
  final WidgetBuilder? noItemsBuilder;

  /// The function to build a widget when there are no more items.
  final WidgetBuilder? noMoreItemsBuilder;

  /// The function to build a widget when there is an error.
  final ErrorBuilder? errorBuilder;

  /// The function to build a widget when there is an error during pagination.
  final ErrorBuilder? paginationErrorBuilder;

  /// The initial page to load.
  final int initialPage;

  /// The limit for the top side of the list.
  final int? topSideLimit;

  /// The limit for the bottom side of the list.
  final int? bottomSideLimit;

  /// The pagination controller to manage the pagination.
  final LMChatPaginationController<T> paginationController;

  /// The axis along which the scroll view scrolls.
  final Axis? scrollDirection;

  /// Whether the scroll view scrolls in the reverse direction.
  final bool? reverse;

  /// Whether this is the primary scroll view associated with the parent.
  final bool? primary;

  /// The physics for the scroll view's scrolling behavior.
  final ScrollPhysics? physics;

  /// Whether the extent of the scroll view should be shrink-wrapped.
  final bool? shrinkWrap;

  /// The amount of space by which to inset the children.
  final EdgeInsetsGeometry? padding;

  /// A callback to find the index of a child.
  final ChildIndexGetter? findChildIndexCallback;

  /// Whether to add automatic keep-alives to children.
  final bool? addAutomaticKeepAlives;

  /// Whether to add repaint boundaries to children.
  final bool? addRepaintBoundaries;

  /// Whether to add semantic indexes to children.
  final bool? addSemanticIndexes;

  /// The amount of space to cache before and after the visible area.
  final double? cacheExtent;

  /// The number of children that contribute to the semantics tree.
  final int? semanticChildCount;

  /// The drag start behavior for the scroll view.
  final DragStartBehavior? dragStartBehavior;

  /// The behavior for dismissing the keyboard when scrolling.
  final ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior;

  /// The restoration ID to save and restore the scroll view's state.
  final String? restorationId;

  /// The clip behavior for the scroll view.
  final Clip? clipBehavior;

  /// Provides an estimation of the extent of the scroll view.
  final ExtentEstimationProvider? extentEstimation;

  /// The policy for pre-calculating the extent of the scroll view.
  final ExtentPrecalculationPolicy? extentPrecalculationPolicy;

  /// Whether to delay populating the cache area.
  final bool? delayPopulatingCacheArea;

  /// {@macro lm_dual_side_paged_list}
  const LMDualSidePagedList({
    super.key,
    required this.onPaginationTriggered,
    required this.itemBuilder,
    this.firstPageLoadingBuilder,
    this.paginationLoadingBuilder,
    this.noItemsBuilder,
    this.noMoreItemsBuilder,
    this.errorBuilder,
    this.paginationErrorBuilder,
    required this.initialPage,
    this.topSideLimit,
    this.bottomSideLimit,
    required this.paginationController,
    this.scrollDirection,
    this.reverse,
    this.primary,
    this.physics,
    this.shrinkWrap,
    this.padding,
    this.findChildIndexCallback,
    this.addAutomaticKeepAlives,
    this.addRepaintBoundaries,
    this.addSemanticIndexes,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior,
    this.keyboardDismissBehavior,
    this.restorationId,
    this.clipBehavior,
    this.extentEstimation,
    this.extentPrecalculationPolicy,
    this.delayPopulatingCacheArea,
  });

  @override
  State<LMDualSidePagedList<T>> createState() => _LMDualSidePagedListState<T>();
}

class _LMDualSidePagedListState<T> extends State<LMDualSidePagedList<T>> {
  late int _currentPage; // Starting page
  late int _upSidePage;
  late int _downSidePage;
  bool _isLoadingFirstPage = true;
  bool _hasError = false;
  bool _paginationError = false;
  late final ScrollController _scrollController;
  late final ListController _listController;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _upSidePage = _currentPage;
    _downSidePage = _currentPage;
    _scrollController = widget.paginationController.scrollController;
    _listController = widget.paginationController.listController;
    _loadInitialData();
    widget.paginationController.isFirstPageLoadedController.stream
        .listen((event) {
      if (event) {
        setState(() {
          _isLoadingFirstPage = false;
        });
      }
    });
    widget.paginationController.upSidePage.stream.listen((event) {
      _upSidePage = event;
    });
    widget.paginationController.downSidePage.stream.listen((event) {
      _downSidePage = event;
    });
  }

  Future<void> _loadInitialData() async {
    try {
      await widget.onPaginationTriggered(
        _currentPage,
        PaginationDirection.bottom,
        null,
      );
      if (mounted) {
        // setState(() {
        //   _isLoadingFirstPage = false;
        //   _hasError = false;
        // });
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
    // check if last page is reached
    if (widget.paginationController.isLastPageToTopReached) {
      return;
    }
    // Check if the top side limit is reached
    if (widget.topSideLimit != null && _upSidePage <= widget.topSideLimit!) {
      return;
    }
    if (widget.paginationController.isLoadingTop) {
      return; // Prevent multiple calls
    }
    setState(() {
      widget.paginationController.isLoadingTop = true;
    });

    try {
      // _upSidePage++;
      int previousItemsCount = widget.paginationController.items.length;
      await widget.onPaginationTriggered(
        _upSidePage,
        PaginationDirection.top,
        widget.paginationController.items.first,
      );
      int newItemsCount = widget.paginationController.items.length;
      int newItemsLength = newItemsCount - previousItemsCount;
      // Use PostFrameCallback to ensure the scroll adjustment happens after the frame
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _listController.jumpToItem(
          index: newItemsLength - 1,
          scrollController: _scrollController,
          alignment: 0.0,
        );
        widget.paginationController.isLoadingTop =
            false; // Stop the loading state
      });
    } catch (e) {
      _upSidePage--; // Revert if error occurs
      setState(() {
        _paginationError = true;
      });
    }
  }

  Future<void> _loadMoreBottom() async {
    // check if last page is reached
    if (widget.paginationController.isLastPageToBottomReached) {
      return;
    }
    // Check if the bottom side limit is reached
    if (widget.bottomSideLimit != null &&
        _downSidePage >= widget.bottomSideLimit!) {
      return;
    }
    if (widget.paginationController.isLoadingBottom) {
      return; // Prevent multiple calls
    }

    setState(() {
      widget.paginationController.isLoadingBottom = true;
    });

    try {
      // _downSidePage++;
      await widget.onPaginationTriggered(
        _downSidePage,
        PaginationDirection.bottom,
        widget.paginationController.items.last,
      );
    } catch (e) {
      _downSidePage--; // revert page increment if no data is returned
      setState(() {
        _paginationError = true;
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
    final items = widget.paginationController.items;

    if (items.isEmpty) {
      return widget.noItemsBuilder?.call(context) ??
          const Center(child: Text("No items found"));
    }

    return _listBuilder(items);
  }

  SuperListView _listBuilder(List<dynamic> items) {
    return SuperListView.builder(
      key: widget.key,
      scrollDirection: widget.scrollDirection ?? Axis.vertical,
      primary: widget.primary,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap ?? false,
      padding: widget.padding,
      findChildIndexCallback: widget.findChildIndexCallback,
      addAutomaticKeepAlives: widget.addAutomaticKeepAlives ?? true,
      addRepaintBoundaries: widget.addRepaintBoundaries ?? true,
      addSemanticIndexes: widget.addSemanticIndexes ?? true,
      cacheExtent: widget.cacheExtent,
      semanticChildCount: widget.semanticChildCount,
      dragStartBehavior: widget.dragStartBehavior ?? DragStartBehavior.start,
      keyboardDismissBehavior: widget.keyboardDismissBehavior ??
          ScrollViewKeyboardDismissBehavior.manual,
      restorationId: widget.restorationId,
      clipBehavior: widget.clipBehavior ?? Clip.hardEdge,
      extentEstimation: widget.extentEstimation,
      extentPrecalculationPolicy: widget.extentPrecalculationPolicy,
      delayPopulatingCacheArea: widget.delayPopulatingCacheArea ?? false,
      controller: _scrollController,
      listController: _listController,
      reverse: widget.reverse ?? false,
      itemCount: items.length +
          (widget.paginationController.isLoadingBottom ? 1 : 0) +
          (widget.paginationController.isLoadingTop ? 1 : 0),
      itemBuilder: (context, index) {
        // Trigger _loadMoreTop() when the first item is being built
        if (index == 3 && !widget.paginationController.isLoadingTop) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _loadMoreTop();
          });
        }
        if (index == 0 && widget.paginationController.isLoadingTop) {
          return widget.paginationLoadingBuilder?.call(context) ??
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
        }
        if (widget.paginationController.isLoadingBottom &&
            index == items.length) {
          return widget.paginationLoadingBuilder?.call(context) ??
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
        }

        final actualIndex =
            widget.paginationController.isLoadingTop ? index - 1 : index;

        // Trigger _loadMoreBottom() when the last item is being built
        if (actualIndex == items.length - 3 &&
            !widget.paginationController.isLoadingBottom) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _loadMoreBottom();
          });
        }
        if (actualIndex < items.length) {
          return widget.itemBuilder(context, items[actualIndex], actualIndex);
        }
        return null;
      },
    );
  }
}