import 'package:flutter/material.dart';

/// [LMChatContainerExtension] is an extension on [Container]
/// to add a copyWith method to update the properties of the container
extension LMChatContainerExtension on Container {
  /// copyWith method for Container
  /// to update the properties of the container
  /// with new values without changing the original container
  /// height and width are not included in the copyWith method
  /// as they are not mutable properties of the container
  /// to update the height and width of the container
  /// use `constraints` property of the container
  Container copyWith({
    Key? key,
    Alignment? alignment,
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip clipBehavior = Clip.none,
    Widget? child,
  }) {
    return Container(
      key: key ?? this.key,
      alignment: alignment ?? this.alignment,
      padding: padding ?? this.padding,
      color: color ?? this.color,
      decoration: decoration ?? this.decoration,
      foregroundDecoration: foregroundDecoration ?? this.foregroundDecoration,
      constraints: constraints ?? this.constraints,
      margin: margin ?? this.margin,
      transform: transform ?? this.transform,
      transformAlignment: transformAlignment ?? this.transformAlignment,
      clipBehavior: clipBehavior,
      child: child ?? this.child,
    );
  }
}
