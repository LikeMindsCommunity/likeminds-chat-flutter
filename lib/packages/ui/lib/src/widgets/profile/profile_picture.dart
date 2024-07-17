import 'dart:io';

import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final inStyle = style ?? LMChatProfilePictureStyle.basic();
    return GestureDetector(
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
                  : inStyle.backgroundColor ?? LMChatTheme.theme.primaryColor,
              image: filePath != null
                  ? DecorationImage(
                      image: FileImage(File(filePath!)),
                      fit: BoxFit.cover,
                    )
                  : imageUrl != null && imageUrl!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
            ),
            padding: inStyle.textPadding ?? const EdgeInsets.all(5),
            child: (imageUrl == null || imageUrl!.isEmpty) && filePath == null
                ? Center(
                    child: LMChatText(
                      getInitials(fallbackText).toUpperCase(),
                      style: inStyle.fallbackTextStyle ??
                          LMChatTextStyle(
                            maxLines: 1,
                            minLines: 1,
                            textAlign: TextAlign.center,
                            textStyle: TextStyle(
                              overflow: TextOverflow.clip,
                              color: LMChatTheme.theme.onPrimary,
                              fontSize:
                                  inStyle.size != null ? inStyle.size! / 2 : 24,
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
      backgroundColor: LMChatTheme.theme.primaryColor,
      boxShape: BoxShape.circle,
      fallbackTextStyle: LMChatTextStyle(
        textStyle: TextStyle(
          color: LMChatTheme.theme.onPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
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
