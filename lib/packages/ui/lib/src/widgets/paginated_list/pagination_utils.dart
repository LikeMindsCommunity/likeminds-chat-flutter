import 'package:flutter/material.dart';

/// {@template lm_dual_side_paged_list_item_builder}
/// A builder function that builds a widget for an item in the list.
/// The [context] is the build context.
/// The [item] is the item to build the widget for.
/// The [index] is the index of the item in the list.
/// {@endtemplate}
typedef ItemBuilder<T> = Widget Function(
    BuildContext context, T item, int index);

/// enum to represent the direction of pagination
enum LMPaginationDirection {
  /// bottom side pagination, if reversed is true.
  bottom,

  /// bottom side pagination, if reversed is true.
  top,
}

/// enum to represent the direction in which pagination call will be triggered
enum LMPaginationType {
  /// trigger pagination when the user scrolls to the bottom of the list, if reversed is true.
  bottom,

  /// trigger pagination when the user scrolls to the top of the list, if reversed is true.
  top,

  /// trigger pagination when the user scrolls to the top or bottom of the list
  both,
}
