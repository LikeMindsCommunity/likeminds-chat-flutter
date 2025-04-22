/// {@template lm_chat_web_configuration}
/// [LMChatWebConfiguration] to configure the web feed
/// [maxWidth] to set the maximum width of the feed
/// [maxWidgetForDialog] to set the maximum width of the widget for dialog
/// [maxWidthForSnackBars] to set the maximum width of the snack bars
/// {@endtemplate}
class LMChatWebConfiguration {
  final double maxWidth;
  final double maxWidgetForDialog;
  final double maxWidthForSnackBars;

  /// {@macro lm_feed_web_configuration}
  const LMChatWebConfiguration({
    this.maxWidth = 600.0,
    this.maxWidgetForDialog = 400.0,
    this.maxWidthForSnackBars = 400.0,
  });

  /// {@template lm_feed_web_configuration_copywith}
  /// [copyWith] to create a new instance of [LMChatWebConfiguration]
  /// with the provided values
  /// {@endtemplate}
  LMChatWebConfiguration copyWith({
    double? maxWidth,
    double? maxWidgetForDialog,
    double? maxWidthForSnackBars,
  }) {
    return LMChatWebConfiguration(
      maxWidth: maxWidth ?? this.maxWidth,
      maxWidgetForDialog: maxWidgetForDialog ?? this.maxWidgetForDialog,
      maxWidthForSnackBars: maxWidthForSnackBars ?? this.maxWidthForSnackBars,
    );
  }

  /// {@template lm_feed_web_configuration_basic}
  /// [basic] to create a new instance of [LMChatWebConfiguration]
  /// with the provided values
  /// {@endtemplate}
  factory LMChatWebConfiguration.basic(
      {double? maxWidth,
      double? maxWidgetForDialog,
      double? maxWidthForSnackBars}) {
    return LMChatWebConfiguration(
      maxWidth: maxWidth ?? 600.0,
      maxWidgetForDialog: maxWidgetForDialog ?? 400.0,
      maxWidthForSnackBars: maxWidthForSnackBars ?? 400.0,
    );
  }
}
