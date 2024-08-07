import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';

class LMChatTheme {
  static LMChatTheme? _instance;
  static LMChatTheme get instance => _instance ??= LMChatTheme._();
  static LMChatThemeData get theme => instance.themeData;

  LMChatTheme._();

  late final LMChatThemeData themeData;

  void initialise({
    LMChatThemeData? theme,
  }) {
    themeData = theme ?? LMChatThemeData.light();
  }
}

class LMChatThemeData {
  final LMChatButtonStyle buttonStyle;
  final LMChatIconStyle iconStyle;
  final LMChatLoaderStyle loaderStyle;
  final LMChatTextFieldStyle textFieldStyle;
  final LMChatDialogStyle dialogStyle;
  final LMChatPopUpMenuStyle popUpMenuStyle;
  final LMChatBottomSheetStyle bottomSheetStyle;
  final LMChatSnackBarStyle snackBarTheme;
  final LMChatImageStyle imageStyle;
  final LMChatTileStyle chatTileStyle;
  final LMChatAppBarStyle appBarStyle;

  final LMChatBubbleStyle bubbleStyle;
  final LMChatStateBubbleStyle stateBubbleStyle;
  final LMChatBubbleReplyStyle replyStyle;
  final LMChatBubbleContentStyle contentStyle;

  final Color primaryColor;
  final Color backgroundColor;
  final Color secondaryColor;
  final Color shadowColor;
  final Color disabledColor;
  final Color errorColor;
  final Color inActiveColor;
  final Color tagColor;
  final Color hashTagColor;
  final Color linkColor;
  final Color container;
  final Color onContainer;
  final Color onPrimary;
  final Color scaffold;

  const LMChatThemeData({
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
    required this.bubbleStyle,
    required this.replyStyle,
    required this.contentStyle,
    required this.chatTileStyle,
    required this.stateBubbleStyle,
    required this.appBarStyle,
  });

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
    );
  }

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
    LMChatBubbleReplyStyle? replyStyle,
    LMChatBubbleStyle? bubbleStyle,
    LMChatBubbleContentStyle? contentStyle,
    LMChatTileStyle? chatTileStyle,
    LMChatStateBubbleStyle? stateBubbleStyle,
    LMChatAppBarStyle? appBarStyle,
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
      textFieldStyle: textFieldStyle ??
          LMChatTextFieldStyle.basic(
            backgroundColor: LMChatDefaultTheme.backgroundColor,
          ),
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
      replyStyle: replyStyle ?? const LMChatBubbleReplyStyle(),
      bubbleStyle: bubbleStyle ?? LMChatBubbleStyle(),
      contentStyle: contentStyle ?? LMChatBubbleContentStyle.basic(),
      chatTileStyle: chatTileStyle ?? LMChatTileStyle.basic(),
      stateBubbleStyle: stateBubbleStyle ?? LMChatStateBubbleStyle.basic(onContainer),
      appBarStyle: appBarStyle ?? LMChatAppBarStyle.basic(),
    );
  }

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
    LMChatBubbleReplyStyle? replyStyle,
    LMChatBubbleStyle? bubbleStyle,
    LMChatBubbleContentStyle? contentStyle,
    LMChatTileStyle? chatTileStyle,
    LMChatStateBubbleStyle? stateBubbleStyle,
    LMChatAppBarStyle? appBarStyle,
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
      replyStyle: replyStyle ?? this.replyStyle,
      bubbleStyle: bubbleStyle ?? this.bubbleStyle,
      contentStyle: contentStyle ?? this.contentStyle,
      chatTileStyle: chatTileStyle ?? this.chatTileStyle,
      stateBubbleStyle: stateBubbleStyle ?? this.stateBubbleStyle,
      appBarStyle: appBarStyle ?? this.appBarStyle,
    );
  }
}

class LMChatTextFieldStyle {
  final Color? backgroundColor;
  final InputDecoration? decoration;

  const LMChatTextFieldStyle({
    this.backgroundColor,
    this.decoration,
  });

  LMChatTextFieldStyle copyWith({
    Color? backgroundColor,
    InputDecoration? decoration,
  }) {
    return LMChatTextFieldStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      decoration: decoration ?? this.decoration,
    );
  }

  factory LMChatTextFieldStyle.basic({
    Color? backgroundColor,
  }) {
    return LMChatTextFieldStyle(
      backgroundColor: backgroundColor ?? LMChatDefaultTheme.backgroundColor,
      decoration: const InputDecoration(
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }
}

class LMChatPopUpMenuStyle {
  final Color? backgroundColor;
  final LMChatIcon? icon;
  final LMChatIcon? activeIcon;
  final Color? activeBackgroundColor;
  final Color? activeColor;
  final Color? inActiveColor;
  final double? width;
  final double? height;
  final Border? border;
  final Color? borderColor;
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
  static const Color backgroundColor = Color.fromRGBO(208, 216, 226, 1);
  static const Color primaryColor = Color.fromARGB(255, 37, 64, 110);
  static const Color secondaryColor = Color.fromARGB(255, 223, 103, 34);
  static const Color shadowColor = Color.fromRGBO(0, 0, 0, 0.239);
  static const Color disabledColor = Color.fromRGBO(208, 216, 226, 1);
  static const Color errorColor = Color.fromRGBO(251, 22, 9, 1);
  static const Color inactiveColor = Color.fromRGBO(155, 155, 155, 1);
  static const Color whiteColor = Color.fromRGBO(255, 255, 255, 1);
  static const Color greyColor = Color.fromRGBO(102, 102, 102, 1);
  static const Color blackColor = Color.fromRGBO(0, 0, 0, 1);
  static const Color tagColor = Color.fromRGBO(0, 122, 255, 1);
  static const Color hashTagColor = Color.fromRGBO(0, 122, 255, 1);
  static const Color linkColor = Color.fromRGBO(0, 122, 255, 1);
  static const Color headingColor = Color.fromRGBO(51, 51, 51, 1);
  static const Color container = whiteColor;
  static const Color onContainer = blackColor;
  static const Color onPrimary = whiteColor;

  static const double kFontSmall = 12;
  static const double kButtonFontSize = 12;
  static const double kFontXSmall = 10;
  static const double kFontSmallMed = 14;
  static const double kFontMedium = 16;
  static const double kPaddingXSmall = 2;
  static const double kPaddingSmall = 4;
  static const double kPaddingMedium = 8;
  static const double kPaddingLarge = 16;
  static const double kPaddingXLarge = 20;
  static const double kBorderRadiusXSmall = 2;
  static const double kBorderRadiusMedium = 8;
  static const SizedBox kHorizontalPaddingXLarge =
      SizedBox(width: kPaddingXLarge);
  static const SizedBox kHorizontalPaddingSmall =
      SizedBox(width: kPaddingSmall);
  static const SizedBox kHorizontalPaddingXSmall =
      SizedBox(width: kPaddingXSmall);
  static const SizedBox kHorizontalPaddingLarge =
      SizedBox(width: kPaddingLarge);
  static const SizedBox kHorizontalPaddingMedium =
      SizedBox(width: kPaddingMedium);
  static const SizedBox kVerticalPaddingXLarge =
      SizedBox(height: kPaddingXLarge);
  static const SizedBox kVerticalPaddingSmall = SizedBox(height: kPaddingSmall);
  static const SizedBox kVerticalPaddingXSmall =
      SizedBox(height: kPaddingXSmall);
  static const SizedBox kVerticalPaddingLarge = SizedBox(height: kPaddingLarge);
  static const SizedBox kVerticalPaddingMedium =
      SizedBox(height: kPaddingMedium);
}

extension ScreenHeight on num {
  double get h => (this / 100) * ScreenSize.height;
}

// Convert integer or double to screen width percentage (w)
extension ScreenWidth on num {
  double get w => (this / 100) * ScreenSize.width;
}

extension ScreenPoints on double {
  double get sp => ScreenSize.textScale.scale(this);
}

// Class to initialize the screen size
class ScreenSize {
  static late double width;
  static late double height;
  static late double pixelRatio;
  static late TextScaler textScale;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;

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
