import 'package:flutter/material.dart';

/// {@template lm_chat_approve_reject_style}
/// Style class for the Approve/Reject widget container.
///
/// This class encapsulates the styling properties of a [Container]
/// used within the LMChatApproveRejectView.
/// {@endtemplate}
class LMChatApproveRejectStyle {
  /// How the child is aligned within the container.
  final AlignmentGeometry? alignment;

  /// Empty space to inscribe inside the [decoration]. The child, if any, is
  /// placed inside this padding.
  final EdgeInsetsGeometry? padding;

  /// The decoration to paint behind the [child].
  ///
  /// The [child] is placed inside the [decoration]. A decoration does not clip.
  /// To clip a child to the shape of a particular [ShapeDecoration], consider
  /// using a [ClipPath] widget.
  final Decoration? decoration;

  /// The decoration to paint in front of the [child].
  final Decoration? foregroundDecoration;

  /// The width of the container.
  final double? width;

  /// The height of the container.
  final double? height;

  /// Additional constraints to apply to the child.
  final BoxConstraints? constraints;

  /// Empty space to surround the [decoration] and [child].
  final EdgeInsetsGeometry? margin;

  /// The transformation matrix to apply before painting the container.
  final Matrix4? transform;

  /// The alignment of the origin, relative to the size of the container, if [transform] is specified.
  ///
  /// When [transform] is null, the value of this property is ignored.
  ///
  /// See also:
  ///
  ///  * [Transform.alignment], which is set by this property.
  final AlignmentGeometry? transformAlignment;

  /// The clip behavior when [Container.decoration] is not null.
  ///
  /// Defaults to [Clip.none]. Must be [Clip.none] if [decoration] is null.
  ///
  /// If a clip is to be applied, the [Decoration.getClipPath] method
  /// for the provided decoration must return a clip path. (This is not
  /// supported by all decorations; the default implementation of that
  /// method throws an [UnsupportedError].)
  final Clip clipBehavior;

  /// {@macro lm_chat_approve_reject_style}
  const LMChatApproveRejectStyle({
    this.alignment,
    this.padding,
    this.decoration,
    this.foregroundDecoration,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.clipBehavior = Clip.none, // Default value from Container
  });

  /// Creates a basic style for [LMChatApproveRejectStyle].
  ///
  /// Derives default values from the provided `_LMChatApproveRejectViewState` example.
  factory LMChatApproveRejectStyle.basic({
    Color? containerColor, // Optional: Pass theme color if needed
  }) {
    // Use a fallback color if containerColor is null
    final defaultBackgroundColor = containerColor ?? Colors.grey[100];

    return LMChatApproveRejectStyle(
      // Width: Use double.infinity for full width like 100.w behavior
      // If you have access to sizer use: width: 100.w,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      // Set decoration for background color, allowing override later
      // Ensure color is null if decoration is set
      decoration: BoxDecoration(
        color: defaultBackgroundColor,
      ),

      clipBehavior: Clip.none, // Default clip behavior
    );
  }

  /// Creates a copy of this [LMChatApproveRejectStyle] but with the given fields
  /// replaced with the new values.
  LMChatApproveRejectStyle copyWith({
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
  }) {
    // Handle the mutual exclusivity of color and decoration
    final newDecoration = decoration ?? this.decoration;

    return LMChatApproveRejectStyle(
      alignment: alignment ?? this.alignment,
      padding: padding ?? this.padding,

      decoration: newDecoration, // Use calculated newDecoration
      foregroundDecoration: foregroundDecoration ?? this.foregroundDecoration,
      width: width ?? this.width,
      height: height ?? this.height,
      constraints: constraints ?? this.constraints,
      margin: margin ?? this.margin,
      transform: transform ?? this.transform,
      transformAlignment: transformAlignment ?? this.transformAlignment,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }
}
