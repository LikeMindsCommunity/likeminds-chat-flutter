import 'package:flutter/material.dart';

/// A builder function that builds a widget for an item in the list.
/// The [context] is the build context.
/// The [item] is the item to build the widget for.
/// The [index] is the index of the item in the list.
typedef ItemBuilder<T> = Widget Function(
    BuildContext context, T item, int index);

/// A builder function that builds a widget for loading the first page.
/// The [context] is the build context.
/// The [retry] is a callback function to retry loading the first page.
typedef LoadingBuilder = Widget Function(BuildContext context);

/// A builder function that builds a widget for loading more items.
/// The [context] is the build context.
/// The [retry] is a callback function to retry loading more items.
typedef ErrorBuilder = Widget Function(
    BuildContext context, VoidCallback retry);

/// enum to represent the direction of pagination
enum PaginationDirection {
  /// top side pagination
  top,

  /// bottom side pagination
  bottom,
}
