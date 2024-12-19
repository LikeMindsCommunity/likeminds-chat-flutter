import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/paginated_list/pagination_controller.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/paginated_list/pagination_utils.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

/// {@template lm_dual_side_paged_list}
/// A widget that displays a list of items that can be paginated from both sides.
/// {@endtemplate}

class LMDualSidePagedList<T> extends StatefulWidget {
  /// The callback function triggered when pagination conditions are satisfied
  final Future<void> Function(
    int page,
    PaginationDirection paginationDirection,
    T? item,
  ) onPaginationTriggered;

  /// The function to build a widget for an item in the list.
  final ItemBuilder<T> itemBuilder;

  /// The builder for the first page's error indicator.
  final WidgetBuilder? firstPageErrorIndicatorBuilder;

  /// The builder for a new page's error indicator.
  final WidgetBuilder? newPageErrorIndicatorBuilder;

  /// The builder for the first page's progress indicator.
  final WidgetBuilder? firstPageProgressIndicatorBuilder;

  /// The builder for a new page's progress indicator.
  final WidgetBuilder? newPageProgressIndicatorBuilder;

  /// The builder for a no items list indicator.
  final WidgetBuilder? noItemsFoundIndicatorBuilder;

  /// The builder for an indicator that all items have been fetched.
  final WidgetBuilder? noMoreItemsIndicatorBuilder;

  /// The initial page to load.
  final int initialPage;

  /// The pagination controller to manage the pagination.
  final LMDualSidePaginationController<T> paginationController;

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

  /// Pagination type
  final PaginationType paginationType;

  /// {@macro lm_dual_side_paged_list}
  const LMDualSidePagedList({
    super.key,
    required this.onPaginationTriggered,
    required this.itemBuilder,
    this.firstPageProgressIndicatorBuilder,
    this.newPageProgressIndicatorBuilder,
    this.noItemsFoundIndicatorBuilder,
    this.noMoreItemsIndicatorBuilder,
    this.firstPageErrorIndicatorBuilder,
    this.newPageErrorIndicatorBuilder,
    required this.initialPage,
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
    this.paginationType = PaginationType.both,
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

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _upSidePage = _currentPage;
    _downSidePage = _currentPage;
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

    Timer? debounce;
    widget.paginationController.scrollController.addListener(() {
      // add listener to hit _loadMoreTop() when hitting top of the scroll view
      if (widget.paginationController.scrollController.position.pixels == 0) {
        if (debounce?.isActive ?? false) debounce?.cancel();
        debounce = Timer(const Duration(milliseconds: 200), () {
          _loadMoreTop();
        });
      }
    });
  }

  Future<void> _loadInitialData() async {
    try {
      await widget.onPaginationTriggered(
        _currentPage,
        PaginationDirection.bottom,
        null,
      );
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
    // Check if type only allows bottom pagination
    if (widget.paginationType == PaginationType.bottom) {
      return;
    }
    if (widget.paginationController.isLoadingTop) {
      return; // Prevent multiple calls
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        widget.paginationController.isLoadingTop = true;
      });
    });

    try {
      await widget.onPaginationTriggered(
        _upSidePage,
        PaginationDirection.top,
        widget.paginationController.itemList.first,
      );
    } catch (e) {
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
    // Check if type only allows top pagination
    if (widget.paginationType == PaginationType.top) {
      return;
    }
    if (widget.paginationController.isLoadingBottom) {
      return; // Prevent multiple calls
    }

    setState(() {
      widget.paginationController.isLoadingBottom = true;
    });

    try {
      await widget.onPaginationTriggered(
        _downSidePage,
        PaginationDirection.bottom,
        widget.paginationController.itemList.last,
      );
    } catch (e) {
      setState(() {
        _paginationError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingFirstPage) {
      return widget.firstPageProgressIndicatorBuilder?.call(context) ??
          const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return widget.firstPageErrorIndicatorBuilder?.call(context) ??
          const Center(child: Text("An error occurred"));
    }
    final items = widget.paginationController.itemList;

    if (items.isEmpty) {
      return widget.noItemsFoundIndicatorBuilder?.call(context) ??
          const Center(child: Text("No items found"));
    }

    return ValueListenableBuilder(
        valueListenable: widget.paginationController.isScrollingNotifier,
        builder: (context, _, __) {
          return _listBuilder(items);
        });
  }

  SuperListView _listBuilder(List<dynamic> items) {
    return SuperListView.builder(
      key: const ObjectKey("dual_side_paged_list"),
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
      controller: widget.paginationController.scrollController,
      listController: widget.paginationController.listController,
      reverse: widget.reverse ?? false,
      itemCount: items.length +
          (widget.paginationController.isLoadingBottom ? 1 : 0) +
          (widget.paginationController.isLoadingTop ? 1 : 0),
      itemBuilder: (context, index) {
        // // Trigger _loadMoreTop() when the first item is being built
        // if (index == 0 && !widget.paginationController.isLoadingTop) {
        //   SchedulerBinding.instance.addPostFrameCallback((_) {
        //     _loadMoreTop();
        //   });
        // }
        if (index == 0 && widget.paginationController.isLoadingTop) {
          return widget.newPageProgressIndicatorBuilder?.call(context) ??
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
        }
        if (widget.paginationController.isLoadingBottom &&
            index == items.length) {
          return widget.newPageProgressIndicatorBuilder?.call(context) ??
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
