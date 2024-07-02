/// {@template widget_builder_delegate}
/// Delegate class for the widget builder.
/// {@endtemplate}
class LMChatWidgetBuilderDelegate {
  static LMChatWidgetBuilderDelegate? _instance;
  LMChatWidgetBuilderDelegate._();
  /// {@macro widget_builder_delegate}
  static LMChatWidgetBuilderDelegate get instance =>
      _instance ??= LMChatWidgetBuilderDelegate._();
}
