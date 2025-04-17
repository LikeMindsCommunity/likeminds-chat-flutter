import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';

///{@template lm_chat_theme}
///
/// A class for manaing the theme of the entire chat experience
/// Use parameters to style, and custmise each aspect.
///
///{@endtemplate}
class LMChatTheme {
  /// Singleton instance of LMChatTheme
  static LMChatTheme? _instance;

  /// Gets the singleton instance of LMChatTheme
  static LMChatTheme get instance => _instance ??= LMChatTheme._();

  /// Gets the theme data
  static LMChatThemeData get theme => instance.themeData;

  /// Gets the text theme
  static TextTheme get text => instance.textTheme;

  // late ValueNotifier<LMChatTheme> themeNotifier;

  static ValueNotifier<LMChatTheme> themeNotifier =
      ValueNotifier<LMChatTheme>(instance);

  /// Sets the theme data
  static void setTheme(LMChatThemeData theme) {
    final instance = LMChatTheme.instance;

    instance.initialise(
      theme: theme,
      isDark: theme.isDark,
    );
    themeNotifier.value = instance;
  }

  /// Sets the theme data
  static void setTextTheme(TextTheme theme) {
    instance.textTheme = theme;
  }

  LMChatTheme._();

  /// The theme data for the chat
  late LMChatThemeData themeData;

  /// The text theme for the chat
  late TextTheme textTheme;

  /// Whether the current theme is dark
  bool isDark = false;

  /// Initializes the theme with optional parameters
  void initialise({
    LMChatThemeData? theme,
    TextTheme? textTheme,
    bool? isDark,
  }) {
    // If theme is provided, use its type, otherwise use isDark parameter or default to false
    this.isDark = theme != null ? theme.isDark : (isDark ?? false);

    // Initialize theme based on isDark if not provided
    themeData = theme ??
        (this.isDark ? LMChatThemeData.dark() : LMChatThemeData.light());
    this.textTheme = textTheme ?? ThemeData.light().textTheme;
  }

  /// Static helper to check if current theme is dark
  static bool get isThemeDark => instance.isDark;

  /// Static helper to toggle between light and dark themes
  static void toggleTheme() {
    final instance = LMChatTheme.instance;
    instance.initialise(
      theme: instance.isDark ? LMChatThemeData.light() : LMChatThemeData.dark(),
      isDark: !instance.isDark,
    );
    themeNotifier.value = instance;
  }
}

class LMChatThemeData {
  /// boolean to figure out which theme we are running
  final bool isDark;

  /// Style for buttons in the chat
  final LMChatButtonStyle buttonStyle;

  /// Style for icons in the chat
  final LMChatIconStyle iconStyle;

  /// Style for loaders in the chat
  final LMChatLoaderStyle loaderStyle;

  /// Style for text fields in the chat
  final LMChatTextFieldStyle textFieldStyle;

  /// Style for dialogs in the chat
  final LMChatDialogStyle dialogStyle;

  /// Style for pop-up menus in the chat
  final LMChatPopUpMenuStyle popUpMenuStyle;

  /// Style for bottom sheets in the chat
  final LMChatBottomSheetStyle bottomSheetStyle;

  /// Style for snack bars in the chat
  final LMChatSnackBarStyle snackBarTheme;

  /// Style for chat tiles
  final LMChatTileStyle chatTileStyle;

  /// Style for app bars in the chat
  final LMChatAppBarStyle appBarStyle;

  /// Style for images in the chat
  final LMChatImageStyle imageStyle;

  /// Style for videos in the chat
  final LMChatVideoStyle videoStyle;

  /// Style for documents in the chat
  final LMChatDocumentStyle documentStyle;

  /// Style for GIFs in the chat
  final LMChatGIFStyle gifStyle;

  /// Style for voice notes in the chat
  final LMChatVoiceNoteStyle voiceNoteStyle;

  /// Style for bubbles in the chat
  final LMChatBubbleStyle bubbleStyle;

  /// Style for state bubbles in the chat
  final LMChatStateBubbleStyle stateBubbleStyle;

  /// Style for reply bubbles in the chat
  final LMChatBubbleReplyStyle replyStyle;

  /// Style for bubble content in the chat
  final LMChatBubbleContentStyle contentStyle;

  /// Style for polls in the chat
  final LMChatPollStyle pollStyle;

  /// Style for bubble reactions in the chat
  final LMChatBubbleReactionsStyle bubbleReactionsStyle;

  /// Style for the reaction bar in the chat
  final LMChatReactionBarStyle reactionBarStyle;

  /// Style for the reaction bottom sheet in the chat
  final LMChatReactionBottomSheetStyle reactionBottomSheetStyle;

  /// Style for the reaction keyboard in the chat
  final LMChatReactionKeyboardStyle reactionKeyboardStyle;

  /// Primary color used in the chat theme
  final Color primaryColor;

  /// Background color used in the chat theme
  final Color backgroundColor;

  /// Secondary color used in the chat theme
  final Color secondaryColor;

  /// Shadow color used in the chat theme
  final Color shadowColor;

  /// Disabled color used in the chat theme
  final Color disabledColor;

  /// Error color used in the chat theme
  final Color errorColor;

  /// Inactive color used in the chat theme
  final Color inActiveColor;

  /// Color for tags in the chat theme
  final Color tagColor;

  /// Color for hashtags in the chat theme
  final Color hashTagColor;

  /// Color for links in the chat theme
  final Color linkColor;

  /// Color for containers in the chat theme
  final Color container;

  /// Color for on-container elements in the chat theme
  final Color onContainer;

  /// Color for on-primary elements in the chat theme
  final Color onPrimary;

  /// Color for the scaffold in the chat theme
  final Color scaffold;

  const LMChatThemeData({
    this.isDark = false,
    required this.primaryColor,
    required this.backgroundColor,
    required this.secondaryColor,
    required this.shadowColor,
    required this.disabledColor,
    required this.errorColor,
    required this.inActiveColor,
    required this.tagColor,
    required this.hashTagColor,
    required this.linkColor,
    required this.container,
    required this.onContainer,
    required this.onPrimary,
    required this.scaffold,
    required this.textFieldStyle,
    required this.dialogStyle,
    required this.popUpMenuStyle,
    required this.loaderStyle,
    required this.buttonStyle,
    required this.iconStyle,
    required this.bottomSheetStyle,
    required this.snackBarTheme,
    required this.imageStyle,
    required this.videoStyle,
    required this.documentStyle,
    required this.gifStyle,
    required this.voiceNoteStyle,
    required this.bubbleStyle,
    required this.replyStyle,
    required this.contentStyle,
    required this.chatTileStyle,
    required this.stateBubbleStyle,
    required this.appBarStyle,
    required this.reactionBarStyle,
    required this.reactionBottomSheetStyle,
    required this.bubbleReactionsStyle,
    required this.reactionKeyboardStyle,
    required this.pollStyle,
  });

  /// Creates a light theme data from the provided ThemeData
  factory LMChatThemeData.fromThemeData(ThemeData theme) {
    return LMChatThemeData.light(
      backgroundColor: theme.colorScheme.surface,
      primaryColor: theme.primaryColor,
      secondaryColor: theme.colorScheme.secondary,
      shadowColor: theme.shadowColor,
      disabledColor: theme.disabledColor,
      errorColor: theme.colorScheme.error,
      inActiveColor: theme.unselectedWidgetColor,
      container: theme.colorScheme.primaryContainer,
      onContainer: theme.colorScheme.onPrimaryContainer,
      onPrimary: theme.colorScheme.onPrimary,
      scaffold: theme.colorScheme.surface,
    );
  }

  /// Creates a light theme data with optional parameters
  factory LMChatThemeData.light({
    Color? primaryColor,
    Color? backgroundColor,
    Color? secondaryColor,
    Color? shadowColor,
    Color? disabledColor,
    Color? errorColor,
    Color? inActiveColor,
    Color? tagColor,
    Color? hashTagColor,
    Color? linkColor,
    Color? scaffold,
    Color? container,
    Color? onContainer,
    Color? onPrimary,
    LMChatButtonStyle? buttonStyle,
    LMChatIconStyle? iconStyle,
    LMChatTextFieldStyle? textFieldStyle,
    LMChatDialogStyle? dialogStyle,
    LMChatPopUpMenuStyle? popUpMenuStyle,
    LMChatLoaderStyle? loaderStyle,
    LMChatBottomSheetStyle? bottomSheetStyle,
    LMChatSnackBarStyle? snackBarTheme,
    LMChatImageStyle? imageStyle,
    LMChatVideoStyle? videoStyle,
    LMChatDocumentStyle? documentStyle,
    LMChatGIFStyle? gifStyle,
    LMChatVoiceNoteStyle? voiceNoteStyle,
    LMChatBubbleReplyStyle? replyStyle,
    LMChatBubbleStyle? bubbleStyle,
    LMChatBubbleContentStyle? contentStyle,
    LMChatTileStyle? chatTileStyle,
    LMChatStateBubbleStyle? stateBubbleStyle,
    LMChatAppBarStyle? appBarStyle,
    LMChatReactionBarStyle? reactionBarStyle,
    LMChatReactionBottomSheetStyle? reactionBottomSheetStyle,
    LMChatBubbleReactionsStyle? bubbleReactionsStyle,
    LMChatReactionKeyboardStyle? reactionKeyboardStyle,
    LMChatPollStyle? pollStyle,
  }) {
    return LMChatThemeData(
        buttonStyle: buttonStyle ?? LMChatButtonStyle.basic(),
        iconStyle: iconStyle ?? LMChatIconStyle.basic(),
        backgroundColor: backgroundColor ?? LMChatDefaultTheme.backgroundColor,
        primaryColor: primaryColor ?? LMChatDefaultTheme.primaryColor,
        secondaryColor: secondaryColor ?? LMChatDefaultTheme.secondaryColor,
        shadowColor: shadowColor ?? LMChatDefaultTheme.shadowColor,
        disabledColor: disabledColor ?? LMChatDefaultTheme.disabledColor,
        errorColor: errorColor ?? LMChatDefaultTheme.errorColor,
        inActiveColor: inActiveColor ?? LMChatDefaultTheme.inactiveColor,
        container: container ?? LMChatDefaultTheme.container,
        scaffold: scaffold ?? LMChatDefaultTheme.container,
        onContainer: onContainer ?? LMChatDefaultTheme.onContainer,
        onPrimary: onPrimary ?? LMChatDefaultTheme.onPrimary,
        hashTagColor: hashTagColor ?? LMChatDefaultTheme.hashTagColor,
        linkColor: linkColor ?? LMChatDefaultTheme.linkColor,
        tagColor: tagColor ?? LMChatDefaultTheme.tagColor,
        textFieldStyle: textFieldStyle ?? LMChatTextFieldStyle.basic(),
        dialogStyle: dialogStyle ?? const LMChatDialogStyle(),
        popUpMenuStyle: popUpMenuStyle ?? const LMChatPopUpMenuStyle(),
        loaderStyle: LMChatLoaderStyle(
          color: primaryColor ?? LMChatDefaultTheme.primaryColor,
        ),
        bottomSheetStyle: bottomSheetStyle ?? const LMChatBottomSheetStyle(),
        snackBarTheme: snackBarTheme ??
            LMChatSnackBarStyle(
              behavior: SnackBarBehavior.floating,
              backgroundColor: primaryColor ?? LMChatDefaultTheme.primaryColor,
            ),
        imageStyle: imageStyle ?? LMChatImageStyle.basic(),
        videoStyle: videoStyle ?? LMChatVideoStyle.basic(),
        documentStyle: documentStyle ?? LMChatDocumentStyle.basic(),
        gifStyle: gifStyle ?? LMChatGIFStyle.basic(),
        voiceNoteStyle: voiceNoteStyle ?? LMChatVoiceNoteStyle.basic(),
        replyStyle: replyStyle ?? const LMChatBubbleReplyStyle(),
        bubbleStyle: bubbleStyle ?? LMChatBubbleStyle(),
        contentStyle: contentStyle ??
            LMChatBubbleContentStyle.basic(
                onContainer: LMChatDefaultTheme.onContainer),
        chatTileStyle: chatTileStyle ?? LMChatTileStyle.basic(),
        stateBubbleStyle:
            stateBubbleStyle ?? LMChatStateBubbleStyle.basic(onContainer),
        appBarStyle: appBarStyle ??
            LMChatAppBarStyle.basic(LMChatDefaultTheme.container),
        pollStyle: pollStyle ??
            LMChatPollStyle.basic(
              primaryColor: primaryColor,
              containerColor: container,
              onContainer: onContainer,
              inActiveColor: inActiveColor,
            ),
        reactionBarStyle: reactionBarStyle ?? LMChatReactionBarStyle.basic(),
        reactionBottomSheetStyle:
            reactionBottomSheetStyle ?? LMChatReactionBottomSheetStyle.basic(),
        bubbleReactionsStyle:
            bubbleReactionsStyle ?? LMChatBubbleReactionsStyle.basic(),
        reactionKeyboardStyle:
            reactionKeyboardStyle ?? LMChatReactionKeyboardStyle.basic());
  }

  /// Creates a dark theme data with optional parameters
  factory LMChatThemeData.dark({
    Color? primaryColor,
    Color? backgroundColor,
    Color? secondaryColor,
    Color? shadowColor,
    Color? disabledColor,
    Color? errorColor,
    Color? inActiveColor,
    Color? tagColor,
    Color? hashTagColor,
    Color? linkColor,
    Color? scaffold,
    Color? container,
    Color? onContainer,
    Color? onPrimary,
    LMChatButtonStyle? buttonStyle,
    LMChatIconStyle? iconStyle,
    LMChatTextFieldStyle? textFieldStyle,
    LMChatDialogStyle? dialogStyle,
    LMChatPopUpMenuStyle? popUpMenuStyle,
    LMChatLoaderStyle? loaderStyle,
    LMChatBottomSheetStyle? bottomSheetStyle,
    LMChatSnackBarStyle? snackBarTheme,
    LMChatImageStyle? imageStyle,
    LMChatVideoStyle? videoStyle,
    LMChatDocumentStyle? documentStyle,
    LMChatGIFStyle? gifStyle,
    LMChatVoiceNoteStyle? voiceNoteStyle,
    LMChatBubbleReplyStyle? replyStyle,
    LMChatBubbleStyle? bubbleStyle,
    LMChatBubbleContentStyle? contentStyle,
    LMChatTileStyle? chatTileStyle,
    LMChatStateBubbleStyle? stateBubbleStyle,
    LMChatAppBarStyle? appBarStyle,
    LMChatReactionBarStyle? reactionBarStyle,
    LMChatReactionBottomSheetStyle? reactionBottomSheetStyle,
    LMChatBubbleReactionsStyle? bubbleReactionsStyle,
    LMChatReactionKeyboardStyle? reactionKeyboardStyle,
    LMChatPollStyle? pollStyle,
  }) {
    return LMChatThemeData(
      isDark: true,
      buttonStyle: buttonStyle ?? LMChatButtonStyle.basic(),
      iconStyle: iconStyle ?? LMChatIconStyle.basic(),
      backgroundColor:
          backgroundColor ?? LMChatDefaultDarkTheme.backgroundColor,
      primaryColor: primaryColor ?? LMChatDefaultDarkTheme.primaryColor,
      secondaryColor: secondaryColor ?? LMChatDefaultDarkTheme.secondaryColor,
      shadowColor: shadowColor ?? LMChatDefaultDarkTheme.shadowColor,
      disabledColor: disabledColor ?? LMChatDefaultDarkTheme.disabledColor,
      errorColor: errorColor ?? LMChatDefaultDarkTheme.errorColor,
      inActiveColor: inActiveColor ?? LMChatDefaultDarkTheme.inactiveColor,
      container: container ?? LMChatDefaultDarkTheme.container,
      scaffold: scaffold ?? LMChatDefaultDarkTheme.container,
      onContainer: onContainer ?? LMChatDefaultDarkTheme.onContainer,
      onPrimary: onPrimary ?? LMChatDefaultDarkTheme.onPrimary,
      hashTagColor: hashTagColor ?? LMChatDefaultDarkTheme.hashTagColor,
      linkColor: linkColor ?? LMChatDefaultDarkTheme.linkColor,
      tagColor: tagColor ?? LMChatDefaultDarkTheme.tagColor,
      textFieldStyle: textFieldStyle ?? LMChatTextFieldStyle.basic(),
      dialogStyle: dialogStyle ?? const LMChatDialogStyle(),
      popUpMenuStyle: popUpMenuStyle ?? const LMChatPopUpMenuStyle(),
      loaderStyle: LMChatLoaderStyle(
        color: primaryColor ?? LMChatDefaultDarkTheme.primaryColor,
      ),
      bottomSheetStyle: bottomSheetStyle ?? const LMChatBottomSheetStyle(),
      snackBarTheme: snackBarTheme ??
          LMChatSnackBarStyle(
            behavior: SnackBarBehavior.floating,
            backgroundColor:
                primaryColor ?? LMChatDefaultDarkTheme.primaryColor,
          ),
      imageStyle: imageStyle ?? LMChatImageStyle.basic(),
      videoStyle: videoStyle ?? LMChatVideoStyle.basic(),
      documentStyle: documentStyle ?? LMChatDocumentStyle.basic(),
      gifStyle: gifStyle ?? LMChatGIFStyle.basic(),
      voiceNoteStyle: voiceNoteStyle ?? LMChatVoiceNoteStyle.basic(),
      replyStyle: replyStyle ?? const LMChatBubbleReplyStyle(),
      bubbleStyle: bubbleStyle ?? LMChatBubbleStyle(),
      contentStyle: contentStyle ??
          LMChatBubbleContentStyle.basic(
              onContainer: LMChatDefaultDarkTheme.onContainer),
      chatTileStyle: chatTileStyle ?? LMChatTileStyle.basic(),
      stateBubbleStyle:
          stateBubbleStyle ?? LMChatStateBubbleStyle.basic(onContainer),
      appBarStyle: appBarStyle ??
          LMChatAppBarStyle.basic(LMChatDefaultDarkTheme.container),
      pollStyle: pollStyle ??
          LMChatPollStyle.basic(
            primaryColor: primaryColor ?? LMChatDefaultDarkTheme.primaryColor,
            containerColor: container ?? LMChatDefaultDarkTheme.container,
            onContainer: onContainer ?? LMChatDefaultDarkTheme.onContainer,
            inActiveColor:
                inActiveColor ?? LMChatDefaultDarkTheme.inactiveColor,
          ),
      reactionBarStyle: reactionBarStyle ?? LMChatReactionBarStyle.basic(),
      reactionBottomSheetStyle:
          reactionBottomSheetStyle ?? LMChatReactionBottomSheetStyle.basic(),
      bubbleReactionsStyle:
          bubbleReactionsStyle ?? LMChatBubbleReactionsStyle.basic(),
      reactionKeyboardStyle:
          reactionKeyboardStyle ?? LMChatReactionKeyboardStyle.basic(),
    );
  }

  /// Creates a copy of the theme data with optional modifications
  LMChatThemeData copyWith({
    Color? primaryColor,
    Color? backgroundColor,
    Color? secondaryColor,
    Color? shadowColor,
    Color? disabledColor,
    Color? errorColor,
    Color? inActiveColor,
    Color? tagColor,
    Color? hashTagColor,
    Color? linkColor,
    Color? container,
    Color? onContainer,
    Color? onPrimary,
    Color? scaffold,
    LMChatButtonStyle? buttonStyle,
    LMChatIconStyle? iconStyle,
    LMChatTextFieldStyle? textFieldStyle,
    LMChatDialogStyle? dialogStyle,
    LMChatPopUpMenuStyle? popUpMenuStyle,
    LMChatLoaderStyle? loaderStyle,
    LMChatBottomSheetStyle? bottomSheetStyle,
    LMChatSnackBarStyle? snackBarTheme,
    LMChatImageStyle? imageStyle,
    LMChatVideoStyle? videoStyle,
    LMChatDocumentStyle? documentStyle,
    LMChatGIFStyle? gifStyle,
    LMChatVoiceNoteStyle? voiceNoteStyle,
    LMChatBubbleReplyStyle? replyStyle,
    LMChatBubbleStyle? bubbleStyle,
    LMChatBubbleContentStyle? contentStyle,
    LMChatTileStyle? chatTileStyle,
    LMChatStateBubbleStyle? stateBubbleStyle,
    LMChatAppBarStyle? appBarStyle,
    LMChatReactionBarStyle? reactionBarStyle,
    LMChatReactionBottomSheetStyle? reactionBottomSheetStyle,
    LMChatBubbleReactionsStyle? bubbleReactionsStyle,
    LMChatReactionKeyboardStyle? reactionKeyboardStyle,
    LMChatPollStyle? pollStyle,
    bool? isDark,
  }) {
    return LMChatThemeData(
      buttonStyle: buttonStyle ?? this.buttonStyle,
      iconStyle: iconStyle ?? this.iconStyle,
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      shadowColor: shadowColor ?? this.shadowColor,
      disabledColor: disabledColor ?? this.disabledColor,
      errorColor: errorColor ?? this.errorColor,
      inActiveColor: inActiveColor ?? this.inActiveColor,
      tagColor: tagColor ?? this.tagColor,
      hashTagColor: hashTagColor ?? this.hashTagColor,
      linkColor: linkColor ?? this.linkColor,
      container: container ?? this.container,
      scaffold: scaffold ?? this.scaffold,
      onContainer: onContainer ?? this.onContainer,
      onPrimary: onPrimary ?? this.onPrimary,
      dialogStyle: dialogStyle ?? this.dialogStyle,
      textFieldStyle: textFieldStyle ?? this.textFieldStyle,
      popUpMenuStyle: popUpMenuStyle ?? this.popUpMenuStyle,
      loaderStyle: loaderStyle ?? this.loaderStyle,
      bottomSheetStyle: bottomSheetStyle ?? this.bottomSheetStyle,
      snackBarTheme: snackBarTheme ?? this.snackBarTheme,
      imageStyle: imageStyle ?? this.imageStyle,
      videoStyle: videoStyle ?? this.videoStyle,
      documentStyle: documentStyle ?? this.documentStyle,
      gifStyle: gifStyle ?? this.gifStyle,
      voiceNoteStyle: voiceNoteStyle ?? this.voiceNoteStyle,
      replyStyle: replyStyle ?? this.replyStyle,
      bubbleStyle: bubbleStyle ?? this.bubbleStyle,
      contentStyle: contentStyle ?? this.contentStyle,
      chatTileStyle: chatTileStyle ?? this.chatTileStyle,
      stateBubbleStyle: stateBubbleStyle ?? this.stateBubbleStyle,
      appBarStyle: appBarStyle ?? this.appBarStyle,
      reactionBarStyle: reactionBarStyle ?? this.reactionBarStyle,
      reactionBottomSheetStyle:
          reactionBottomSheetStyle ?? this.reactionBottomSheetStyle,
      bubbleReactionsStyle: bubbleReactionsStyle ?? this.bubbleReactionsStyle,
      reactionKeyboardStyle:
          reactionKeyboardStyle ?? this.reactionKeyboardStyle,
      pollStyle: pollStyle ?? this.pollStyle,
      isDark: isDark ?? this.isDark,
    );
  }
}

class LMChatTextFieldStyle {
  /// Decoration for the input field
  final InputDecoration? inputDecoration;

  /// Text style for the input field
  final TextStyle? textStyle;

  /// Color of the tag in the input field
  final Color? tagColor;

  /// Background color of the suggestions box
  final Color? suggestionsBoxColor;

  /// Elevation of the suggestions box
  final double? suggestionsBoxElevation;

  /// Border radius of the suggestions box
  final BorderRadius? suggestionsBoxBorderRadius;

  /// Constraints for the suggestions box
  final BoxConstraints? suggestionsBoxConstraints;

  /// Padding for the suggestions box
  final EdgeInsets? suggestionsBoxPadding;

  /// Background color of the suggestion item
  final Color? suggestionItemColor;

  /// Padding for the suggestion item
  final EdgeInsets? suggestionItemPadding;

  /// Text style for the suggestion item
  final LMChatTextStyle? suggestionItemTextStyle;

  /// Style for the avatar in the suggestion item
  final LMChatProfilePictureStyle? suggestionItemAvatarStyle;

  /// Whether to show a loading indicator while fetching suggestions
  final bool? showLoadingIndicator;

  /// Custom widget to show when no suggestions are found
  final Widget Function(BuildContext)? noItemsFoundBuilder;

  /// Duration of debounce on the text field
  final Duration? debounceDuration;

  /// margin for the text field
  final EdgeInsets? margin;

  const LMChatTextFieldStyle({
    this.inputDecoration,
    this.textStyle,
    this.tagColor,
    this.suggestionsBoxColor,
    this.suggestionsBoxElevation,
    this.suggestionsBoxBorderRadius,
    this.suggestionsBoxConstraints,
    this.suggestionsBoxPadding,
    this.suggestionItemColor,
    this.suggestionItemPadding,
    this.suggestionItemTextStyle,
    this.suggestionItemAvatarStyle,
    this.noItemsFoundBuilder,
    this.showLoadingIndicator,
    this.debounceDuration,
    this.margin,
  });

  /// Creates a copy of the text field style with optional modifications
  LMChatTextFieldStyle copyWith({
    InputDecoration? inputDecoration,
    TextStyle? textStyle,
    Color? tagColor,
    Color? suggestionsBoxColor,
    double? suggestionsBoxElevation,
    BorderRadius? suggestionsBoxBorderRadius,
    BoxConstraints? suggestionsBoxConstraints,
    EdgeInsets? suggestionsBoxPadding,
    Color? suggestionItemColor,
    Duration? debounceDuration,
    EdgeInsets? suggestionItemPadding,
    LMChatTextStyle? suggestionItemTextStyle,
    LMChatProfilePictureStyle? suggestionItemAvatarStyle,
    EdgeInsets? margin,
  }) {
    return LMChatTextFieldStyle(
      inputDecoration: inputDecoration ?? this.inputDecoration,
      textStyle: textStyle ?? this.textStyle,
      tagColor: tagColor ?? this.tagColor,
      suggestionsBoxColor: suggestionsBoxColor ?? this.suggestionsBoxColor,
      suggestionsBoxElevation:
          suggestionsBoxElevation ?? this.suggestionsBoxElevation,
      suggestionsBoxBorderRadius:
          suggestionsBoxBorderRadius ?? this.suggestionsBoxBorderRadius,
      suggestionsBoxConstraints:
          suggestionsBoxConstraints ?? this.suggestionsBoxConstraints,
      suggestionsBoxPadding:
          suggestionsBoxPadding ?? this.suggestionsBoxPadding,
      suggestionItemColor: suggestionItemColor ?? this.suggestionItemColor,
      suggestionItemPadding:
          suggestionItemPadding ?? this.suggestionItemPadding,
      suggestionItemTextStyle:
          suggestionItemTextStyle ?? this.suggestionItemTextStyle,
      suggestionItemAvatarStyle:
          suggestionItemAvatarStyle ?? this.suggestionItemAvatarStyle,
      debounceDuration: debounceDuration ?? this.debounceDuration,
      margin: margin ?? this.margin,
    );
  }

  /// Creates a basic text field style with default values
  static LMChatTextFieldStyle basic({
    InputDecoration? inputDecoration,
    TextStyle? textStyle,
    Color? tagColor,
    Color? suggestionsBoxColor,
    double? suggestionsBoxElevation,
    BorderRadius? suggestionsBoxBorderRadius,
    BoxConstraints? suggestionsBoxConstraints,
    EdgeInsets? suggestionsBoxPadding,
    Color? suggestionItemColor,
    EdgeInsets? suggestionItemPadding,
    LMChatTextStyle? suggestionItemTextStyle,
    LMChatProfilePictureStyle? suggestionItemAvatarStyle,
  }) {
    return LMChatTextFieldStyle(
      suggestionsBoxElevation: suggestionsBoxElevation ?? 2.0,
      suggestionsBoxBorderRadius:
          suggestionsBoxBorderRadius ?? BorderRadius.circular(8.0),
      suggestionItemAvatarStyle: suggestionItemAvatarStyle,
    );
  }
}

class LMChatPopUpMenuStyle {
  /// Background color of the pop-up menu
  final Color? backgroundColor;

  /// Icon for the pop-up menu
  final LMChatIcon? icon;

  /// Active icon for the pop-up menu
  final LMChatIcon? activeIcon;

  /// Background color when the item is active
  final Color? activeBackgroundColor;

  /// Color of the active item
  final Color? activeColor;

  /// Color of the inactive item
  final Color? inActiveColor;

  /// Width of the pop-up menu
  final double? width;

  /// Height of the pop-up menu
  final double? height;

  /// Border for the pop-up menu
  final Border? border;

  /// Color of the border
  final Color? borderColor;

  /// Width of the border
  final double? borderWidth;

  const LMChatPopUpMenuStyle({
    this.backgroundColor,
    this.icon,
    this.activeIcon,
    this.activeBackgroundColor,
    this.activeColor,
    this.inActiveColor,
    this.width,
    this.height,
    this.border,
    this.borderColor,
    this.borderWidth,
  });

  /// Creates a copy of the pop-up menu style with optional modifications
  LMChatPopUpMenuStyle copyWith({
    Color? backgroundColor,
    LMChatIcon? icon,
    LMChatIcon? activeIcon,
    Color? activeBackgroundColor,
    Color? activeColor,
    Color? inActiveColor,
    double? width,
    double? height,
  }) {
    return LMChatPopUpMenuStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      icon: icon ?? this.icon,
      activeIcon: activeIcon ?? this.activeIcon,
      activeBackgroundColor:
          activeBackgroundColor ?? this.activeBackgroundColor,
      activeColor: activeColor ?? this.activeColor,
      inActiveColor: inActiveColor ?? this.inActiveColor,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }
}

class LMChatDefaultTheme {
  /// Default background color
  static const Color backgroundColor = Color.fromRGBO(208, 216, 226, 1);

  /// Default primary color
  static const Color primaryColor = Color.fromARGB(255, 50, 105, 200);

  /// Default secondary color
  static const Color secondaryColor = Color.fromARGB(255, 223, 103, 34);

  /// Default shadow color
  static const Color shadowColor = Color.fromRGBO(0, 0, 0, 0.239);

  /// Default disabled color
  static const Color disabledColor = Color.fromRGBO(155, 155, 155, 1);

  /// Default error color
  static const Color errorColor = Color.fromRGBO(251, 22, 9, 1);

  /// Default inactive color
  static const Color inactiveColor = Color.fromRGBO(155, 155, 155, 1);

  /// Default white color
  static const Color whiteColor = Color.fromRGBO(255, 255, 255, 1);

  /// Default grey color
  static const Color greyColor = Color.fromRGBO(102, 102, 102, 1);

  /// Default black color
  static const Color blackColor = Color.fromRGBO(0, 0, 0, 1);

  /// Default tag color
  static const Color tagColor = Color.fromRGBO(0, 122, 255, 1);

  /// Default hashtag color
  static const Color hashTagColor = Color.fromRGBO(0, 122, 255, 1);

  /// Default link color
  static const Color linkColor = Color.fromRGBO(0, 122, 255, 1);

  /// Default heading color
  static const Color headingColor = Color.fromRGBO(51, 51, 51, 1);

  /// Default container color
  static const Color container = whiteColor;

  /// Default on-container color
  static const Color onContainer = blackColor;

  /// Default on-primary color
  static const Color onPrimary = whiteColor;

  /// Default font size for small text
  static const double kFontSmall = 12;

  /// Default font size for buttons
  static const double kButtonFontSize = 12;

  /// Default font size for extra small text
  static const double kFontXSmall = 10;

  /// Default font size for small-medium text
  static const double kFontSmallMed = 14;

  /// Default font size for medium text
  static const double kFontMedium = 16;

  /// Default padding for extra small elements
  static const double kPaddingXSmall = 2;

  /// Default padding for small elements
  static const double kPaddingSmall = 4;

  /// Default padding for medium elements
  static const double kPaddingMedium = 8;

  /// Default padding for large elements
  static const double kPaddingLarge = 16;

  /// Default padding for extra large elements
  static const double kPaddingXLarge = 20;

  /// Default border radius for extra small elements
  static const double kBorderRadiusXSmall = 2;

  /// Default border radius for medium elements
  static const double kBorderRadiusMedium = 8;

  /// Default horizontal padding for extra large elements
  static const SizedBox kHorizontalPaddingXLarge =
      SizedBox(width: kPaddingXLarge);

  /// Default horizontal padding for small elements
  static const SizedBox kHorizontalPaddingSmall =
      SizedBox(width: kPaddingSmall);

  /// Default horizontal padding for extra small elements
  static const SizedBox kHorizontalPaddingXSmall =
      SizedBox(width: kPaddingXSmall);

  /// Default horizontal padding for large elements
  static const SizedBox kHorizontalPaddingLarge =
      SizedBox(width: kPaddingLarge);

  /// Default horizontal padding for medium elements
  static const SizedBox kHorizontalPaddingMedium =
      SizedBox(width: kPaddingMedium);

  /// Default vertical padding for extra large elements
  static const SizedBox kVerticalPaddingXLarge =
      SizedBox(height: kPaddingXLarge);

  /// Default vertical padding for small elements
  static const SizedBox kVerticalPaddingSmall = SizedBox(height: kPaddingSmall);

  /// Default vertical padding for extra small elements
  static const SizedBox kVerticalPaddingXSmall =
      SizedBox(height: kPaddingXSmall);

  /// Default vertical padding for large elements
  static const SizedBox kVerticalPaddingLarge = SizedBox(height: kPaddingLarge);

  /// Default vertical padding for medium elements
  static const SizedBox kVerticalPaddingMedium =
      SizedBox(height: kPaddingMedium);
}

/// Converts a percentage to screen height
extension ScreenHeight on num {
  /// Converts a percentage to screen height
  double get h => (this / 100) * ScreenSize.height;
}

/// Convert integer or double to screen width percentage (w)
extension ScreenWidth on num {
  /// Converts a percentage to screen width
  double get w => (this / 100) * ScreenSize.width;
}

/// Extension to convert double to scaled text size
extension ScreenPoints on double {
  /// Converts a value to scaled text size
  double get sp => ScreenSize.textScale.scale(this);
}

/// Class to initialize the screen size
class ScreenSize {
  /// Width of the screen
  static late double width;

  /// Height of the screen
  static late double height;

  /// Pixel ratio of the screen
  static late double pixelRatio;

  /// Text scaler for the screen
  static late TextScaler textScale;

  /// Block size for horizontal layout
  static late double blockSizeHorizontal;

  /// Block size for vertical layout
  static late double blockSizeVertical;

  /// Safe area horizontal padding
  static late double _safeAreaHorizontal;

  /// Safe area vertical padding
  static late double _safeAreaVertical;

  /// Safe block size for horizontal layout
  static late double safeBlockHorizontal;

  /// Safe block size for vertical layout
  static late double safeBlockVertical;

  /// Initializes the screen size based on the provided context
  static init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    pixelRatio = mediaQuery.devicePixelRatio;
    textScale = mediaQuery.textScaler;
    width = mediaQuery.size.width;
    height = mediaQuery.size.height;
    blockSizeHorizontal = width / 100;
    blockSizeVertical = height / 100;
    _safeAreaHorizontal = mediaQuery.padding.left + mediaQuery.padding.right;
    _safeAreaVertical = mediaQuery.padding.top + mediaQuery.padding.bottom;
    safeBlockHorizontal = (width - _safeAreaHorizontal) / 100;
    safeBlockVertical = (height - _safeAreaVertical) / 100;
  }
}

/// Default dark theme colors and values for the LMChat UI
class LMChatDefaultDarkTheme {
  /// Default background color for dark theme
  static const Color backgroundColor = Color.fromRGBO(18, 18, 18, 1);

  /// Default primary color for dark theme
  static const Color primaryColor = Color.fromARGB(255, 50, 105, 200);

  /// Default secondary color for dark theme
  static const Color secondaryColor = Color.fromARGB(255, 255, 122, 48);

  /// Default shadow color for dark theme
  static const Color shadowColor = Color.fromRGBO(0, 0, 0, 0.5);

  /// Default disabled color for dark theme
  static const Color disabledColor = Color.fromRGBO(128, 128, 128, 1);

  /// Default error color for dark theme
  static const Color errorColor = Color.fromRGBO(255, 82, 82, 1);

  /// Default inactive color for dark theme
  static const Color inactiveColor = Color.fromRGBO(97, 97, 97, 1);

  /// Default white color for dark theme (darker shade for contrast)
  static const Color whiteColor = Color.fromRGBO(242, 242, 242, 1);

  /// Default grey color for dark theme
  static const Color greyColor = Color.fromRGBO(189, 189, 189, 1);

  /// Default black color for dark theme
  static const Color blackColor = Color.fromRGBO(18, 18, 18, 1);

  /// Default tag color for dark theme
  static const Color tagColor = Color.fromRGBO(33, 150, 243, 1);

  /// Default hashtag color for dark theme
  static const Color hashTagColor = Color.fromRGBO(33, 150, 243, 1);

  /// Default link color for dark theme
  static const Color linkColor = Color.fromRGBO(33, 150, 243, 1);

  /// Default heading color for dark theme
  static const Color headingColor = Color.fromRGBO(242, 242, 242, 1);

  /// Default container color for dark theme
  static const Color container = Color.fromRGBO(30, 30, 30, 1);

  /// Default on-container color for dark theme
  static const Color onContainer = whiteColor;

  /// Default on-primary color for dark theme
  static const Color onPrimary = whiteColor;

  // Reuse the same sizing constants from LMChatDefaultTheme
  static const double kFontSmall = LMChatDefaultTheme.kFontSmall;
  static const double kButtonFontSize = LMChatDefaultTheme.kButtonFontSize;
  static const double kFontXSmall = LMChatDefaultTheme.kFontXSmall;
  static const double kFontSmallMed = LMChatDefaultTheme.kFontSmallMed;
  static const double kFontMedium = LMChatDefaultTheme.kFontMedium;
  static const double kPaddingXSmall = LMChatDefaultTheme.kPaddingXSmall;
  static const double kPaddingSmall = LMChatDefaultTheme.kPaddingSmall;
  static const double kPaddingMedium = LMChatDefaultTheme.kPaddingMedium;
  static const double kPaddingLarge = LMChatDefaultTheme.kPaddingLarge;
  static const double kPaddingXLarge = LMChatDefaultTheme.kPaddingXLarge;
  static const double kBorderRadiusXSmall =
      LMChatDefaultTheme.kBorderRadiusXSmall;
  static const double kBorderRadiusMedium =
      LMChatDefaultTheme.kBorderRadiusMedium;

  // Reuse the same spacing widgets from LMChatDefaultTheme
  static const SizedBox kHorizontalPaddingXLarge =
      LMChatDefaultTheme.kHorizontalPaddingXLarge;
  static const SizedBox kHorizontalPaddingSmall =
      LMChatDefaultTheme.kHorizontalPaddingSmall;
  static const SizedBox kHorizontalPaddingXSmall =
      LMChatDefaultTheme.kHorizontalPaddingXSmall;
  static const SizedBox kHorizontalPaddingLarge =
      LMChatDefaultTheme.kHorizontalPaddingLarge;
  static const SizedBox kHorizontalPaddingMedium =
      LMChatDefaultTheme.kHorizontalPaddingMedium;
  static const SizedBox kVerticalPaddingXLarge =
      LMChatDefaultTheme.kVerticalPaddingXLarge;
  static const SizedBox kVerticalPaddingSmall =
      LMChatDefaultTheme.kVerticalPaddingSmall;
  static const SizedBox kVerticalPaddingXSmall =
      LMChatDefaultTheme.kVerticalPaddingXSmall;
  static const SizedBox kVerticalPaddingLarge =
      LMChatDefaultTheme.kVerticalPaddingLarge;
  static const SizedBox kVerticalPaddingMedium =
      LMChatDefaultTheme.kVerticalPaddingMedium;
}
