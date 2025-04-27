import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

/// {@template lm_chat_pagination_controller}
/// A helper class to manage pagination for a list of items.
/// it is used in the [LMDualSidePagedList] widget.
/// {@endtemplate}
class LMDualSidePaginationController<T> {
  StreamController<bool> isFirstPageLoadedController =
      StreamController<bool>.broadcast();
  StreamController<int> upSidePage = StreamController<int>.broadcast();
  StreamController<int> downSidePage = StreamController<int>.broadcast();

  /// The list of items that have been loaded so far.
  List<T> itemList = [];

  final ListController _listController;
  final ScrollController _scrollController;

  /// Whether the top page is loading.
  bool isLoadingTop = false;

  /// Whether the bottom page is loading.
  bool isLoadingBottom = false;

  /// Whether the last page has been reached.
  bool isLastPageToBottomReached = false;

  /// Whether the first page has been reached.
  bool isLastPageToTopReached = false;

  /// The list controller to control the list view.
  ListController get listController => _listController;

  /// The scroll controller to control the scroll view.
  ScrollController get scrollController => _scrollController;

  final ValueNotifier<bool> isScrollingNotifier = ValueNotifier(false);

  /// Creates a new instance of [LMDualSidePaginationController].
  LMDualSidePaginationController({
    required ListController listController,
    required ScrollController scrollController,
  })  : _listController = listController,
        _scrollController = scrollController;

  /// Appends [newItems] to the previously loaded ones and replaces
  /// the next page's key.
  void appendPageToEnd(List<T> newItems, int? nextPageKey) {
    if (nextPageKey == null) {
      isLastPageToBottomReached = true;
    }
    isFirstPageLoadedController.add(true);
    downSidePage.add(nextPageKey ?? 0);
    itemList.addAll([...newItems]);
    isLoadingBottom = false;
  }

  /// Appends [newItems] to the previously loaded ones and sets the next page
  /// key to `null`.
  void appendLastPageToEnd(List<T> newItems) => appendPageToEnd(newItems, null);

  /// Prepends [newItems] to the previously loaded ones and replaces
  /// the previous page's key.
  void appendPageToStart(List<T> newItems, int? previousPageKey) {
    if (previousPageKey == null) {
      isLastPageToTopReached = true;
    }

    upSidePage.add(previousPageKey ?? 0);
    itemList.insertAll(0, [...newItems]);
    isLoadingTop = false;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // isLoadingTop = true;
      try {
        listController.jumpToItem(
          index: newItems.length,
          scrollController: scrollController,
          alignment: 0.0,
        );
      } on Exception catch (e) {
        debugPrint(e.toString());
      }
      isScrollingNotifier.value = !isScrollingNotifier.value;
    });
    // isLoadingTop = false;
    // isScrollingNotifier.value = !isScrollingNotifier.value;
  }

  /// Prepends [newItems] to the previously loaded ones and sets the previous
  /// page key to `null`.
  void appendFirstPageToStart(List<T> newItems) =>
      appendPageToStart(newItems, null);

  /// clears the list of items.
  /// This is useful when you want to reset the list.
  /// For example, when you want to load a new list of items.
  void clear() {
    itemList = [];
    upSidePage.add(0);
    downSidePage.add(0);
    isLastPageToBottomReached = false;
    isLastPageToTopReached = false;
  }

  /// Appends [newItems] to the previously loaded ones.
  void addAll(List<T> newItems) {
    itemList.addAll(newItems);
    upSidePage.add(2);
    downSidePage.add(2);
    isLoadingBottom = false;
    isLoadingTop = false;
  }
}
