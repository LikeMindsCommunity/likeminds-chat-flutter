import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

/// {@template lm_chat_pagination_controller}
/// A helper class to manage pagination for a list of items.
/// it is used in the [LMDualSidePagedList] widget.
/// {@endtemplate}
class LMChatPaginationController<T> {
  final StreamController<bool> isFirstPageLoadedController =
      StreamController<bool>();
  final StreamController<int> upSidePage = StreamController<int>();
  final StreamController<int> downSidePage = StreamController<int>();

  /// The list of items that have been loaded so far.
  List<T> items = [];

  final ListController _listController;
  final ScrollController _scrollController;

  /// Whether the top page is loading.
  bool isLoadingTop = false;

  /// Whether the bottom page is loading.
  bool isLoadingBottom = false;

  /// Whether the last page has been reached.
  bool _isLastPageToBottomReached = false;

  /// Whether the first page has been reached.
  bool _isLastPageToTopReached = false;

  /// Whether the last page has been reached.
  bool get isLastPageToBottomReached => _isLastPageToBottomReached;

  /// Whether the first page has been reached.
  bool get isLastPageToTopReached => _isLastPageToTopReached;

  /// The list controller to control the list view.
  ListController get listController => _listController;

  /// The scroll controller to control the scroll view.
  ScrollController get scrollController => _scrollController;

  /// Creates a new instance of [LMChatPaginationController].
  LMChatPaginationController({
    required ListController listController,
    required ScrollController scrollController,
  })  : _listController = listController,
        _scrollController = scrollController;

  /// Appends [newItems] to the previously loaded ones and replaces
  /// the next page's key.
  void appendPageToEnd(List<T> newItems, int? nextPageKey) {
    if (nextPageKey == null) {
      _isLastPageToBottomReached = true;
    }
    // if(nextPageKey == 2) {
    isFirstPageLoadedController.add(true);
    // }
    downSidePage.add(nextPageKey ?? 0);
    final previousItems = items;
    final itemList = previousItems + newItems;
    items = itemList;
    isLoadingBottom = false;
  }

  /// Appends [newItems] to the previously loaded ones and sets the next page
  /// key to `null`.
  void appendLastPageToEnd(List<T> newItems) => appendPageToEnd(newItems, null);

  /// Prepends [newItems] to the previously loaded ones and replaces
  /// the previous page's key.
  void appendPageToStart(List<T> newItems, int? previousPageKey) {
    if (previousPageKey == null) {
      _isLastPageToTopReached = true;
    }
    final previousItems = items;
    final itemList = newItems + previousItems;
    upSidePage.add(previousPageKey ?? 0);
    // Use PostFrameCallback to ensure the scroll adjustment happens after the frame
    SchedulerBinding.instance.addPostFrameCallback((_) {
      items = itemList;
      listController.jumpToItem(
        index: newItems.length,
        scrollController: scrollController,
        alignment: 0.0,
      );
      isLoadingTop = false; // Stop the loading state
    });
  }

  /// Prepends [newItems] to the previously loaded ones and sets the previous
  /// page key to `null`.
  void appendFirstPageToStart(List<T> newItems) =>
      appendPageToStart(newItems, null);

  /// clears the list of items.
  /// This is useful when you want to reset the list.
  /// For example, when you want to load a new list of items.
  void clear() {
    items = [];
    upSidePage.add(0);
    downSidePage.add(0);
    _isLastPageToBottomReached = false;
    _isLastPageToTopReached = false;
  }

  /// Appends [newItems] to the previously loaded ones.
  void addAll(List<T> newItems) {
    items.addAll(newItems);
    upSidePage.add(2);
    downSidePage.add(2);
    isLoadingBottom = false;
    isLoadingTop = false;
  }
}