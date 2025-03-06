import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';

class LMChatProfilePicture extends StatelessWidget {
  const LMChatProfilePicture({
    super.key,
    this.imageUrl,
    this.filePath,
    required this.fallbackText,
    this.onTap,
    this.style,
    this.overlay,
  });

  final String? imageUrl;
  final String? filePath;
  final String fallbackText;
  final Function()? onTap;
  final LMChatProfilePictureStyle? style;
  final Widget? overlay;

  // Determines if the image is an SVG image based on the file extension of the URL
  bool _isSvgImage() {
    return imageUrl != null && imageUrl!.endsWith('.svg');
  }

  @override
  Widget build(BuildContext context) {
    final inStyle = style ?? LMChatProfilePictureStyle.basic();
    final isSvgImage = _isSvgImage();
    return AbsorbPointer(
      absorbing: onTap == null,
      child: GestureDetector(
        onTap: () {
          if (onTap != null) onTap!();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: inStyle.size,
              width: inStyle.size,
              decoration: BoxDecoration(
                borderRadius: inStyle.boxShape == null
                    ? BorderRadius.circular(inStyle.borderRadius ?? 0)
                    : null,
                border: Border.all(
                  color: Colors.white,
                  width: inStyle.border ?? 0,
                ),
                shape: inStyle.boxShape ?? BoxShape.rectangle,
                color: imageUrl != null && imageUrl!.isNotEmpty
                    ? Colors.grey.shade300
                    : inStyle.backgroundColor ??
                        (LMChatTheme.isThemeDark
                            ? LMChatTheme.theme.container
                            : LMChatTheme.theme.primaryColor),
                image: filePath != null
                    ? DecorationImage(
                        image: FileImage(File(filePath!)),
                        fit: BoxFit.cover,
                      )
                    : imageUrl != null && imageUrl!.isNotEmpty && !isSvgImage
                        ? DecorationImage(
                            image: NetworkImage(imageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
              ),
              padding: !isSvgImage
                  ? inStyle.textPadding ?? const EdgeInsets.all(5)
                  : EdgeInsets.zero,
              child: isSvgImage ||
                      (imageUrl == null || imageUrl!.isEmpty) &&
                          filePath == null
                  ? Center(
                      child: _isSvgImage()
                          ? SvgPicture.network(
                              imageUrl!,
                              fit: BoxFit.cover,
                              height: inStyle.size,
                              width: inStyle.size,
                            )
                          : LMChatText(
                              getInitials(fallbackText).toUpperCase(),
                              style: inStyle.fallbackTextStyle ??
                                  LMChatTextStyle(
                                    maxLines: 1,
                                    minLines: 1,
                                    textAlign: TextAlign.center,
                                    textStyle: TextStyle(
                                      overflow: TextOverflow.clip,
                                      color: LMChatTheme.isThemeDark
                                          ? LMChatTheme.theme.onContainer
                                          : LMChatTheme.theme.onPrimary,
                                      fontSize: inStyle.size != null
                                          ? inStyle.size! / 2
                                          : 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                            ),
                    )
                  : null,
            ),
            if (overlay != null) overlay!,
          ],
        ),
      ),
    );
  }

  LMChatProfilePicture copyWith({
    String? imageUrl,
    String? fallbackText,
    Function()? onTap,
    LMChatProfilePictureStyle? style,
  }) {
    return LMChatProfilePicture(
      fallbackText: fallbackText ?? this.fallbackText,
      imageUrl: imageUrl ?? this.imageUrl,
      onTap: onTap ?? this.onTap,
      style: style ?? this.style,
    );
  }
}

class LMChatProfilePictureStyle {
  final double? size;
  final LMChatTextStyle? fallbackTextStyle;
  final double? borderRadius;
  final double? border;
  final Color? backgroundColor;
  final BoxShape? boxShape;
  final EdgeInsets? textPadding;

  const LMChatProfilePictureStyle({
    this.size = 48,
    this.borderRadius = 24,
    this.border = 0,
    this.backgroundColor,
    this.boxShape,
    this.textPadding,
    this.fallbackTextStyle,
  });

  factory LMChatProfilePictureStyle.basic() {
    return LMChatProfilePictureStyle(
      backgroundColor: (LMChatTheme.isThemeDark
          ? LMChatTheme.theme.container
          : LMChatTheme.theme.primaryColor),
      boxShape: BoxShape.circle,
      fallbackTextStyle: LMChatTextStyle(
        textStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: LMChatTheme.isThemeDark
              ? LMChatTheme.theme.primaryColor
              : LMChatTheme.theme.onPrimary,
        ),
      ),
    );
  }

  LMChatProfilePictureStyle copyWith({
    double? size,
    LMChatTextStyle? fallbackTextStyle,
    double? borderRadius,
    double? border,
    Color? backgroundColor,
    BoxShape? boxShape,
    EdgeInsets? textPadding,
  }) {
    return LMChatProfilePictureStyle(
      size: size ?? this.size,
      borderRadius: borderRadius ?? this.borderRadius,
      border: border ?? this.border,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      boxShape: boxShape ?? this.boxShape,
      fallbackTextStyle: fallbackTextStyle ?? this.fallbackTextStyle,
      textPadding: textPadding ?? this.textPadding,
    );
  }
}
