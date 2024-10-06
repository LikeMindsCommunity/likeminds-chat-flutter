import 'package:flutter/material.dart';

/// Regular expression for links and tags
const String kRegexLinksAndTags =
    r'(?:(?:http|https|ftp|www)\:\/\/)?[a-zA-Z0-9\-\.]+\.[a-zA-Z]{1,}(?::[a-zA-Z0-9]*)?\/?[^\s\n]+|[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,}|<<([^<>]+)\|route://member/([a-zA-Z-0-9]+)>>|<<@participants\|route://participants>>|<<([^<>]+)\|route://user_profile/([a-zA-Z-0-9]+)>>';

/// Attachment type constant for images
const String kAttachmentTypeImage = "image";

/// Attachment type constant for videos
const String kAttachmentTypeVideo = "video";

/// Attachment type constant for audio files
const String kAttachmentTypeAudio = "audio";

/// Attachment type constant for PDF files
const String kAttachmentTypePDF = "pdf";

/// Attachment type constant for GIFs
const String kAttachmentTypeGIF = "gif";

/// Attachment type constant for links
const String kAttachmentTypeLink = "link";

/// Attachment type constant for voice notes
const String kAttachmentTypeVoiceNote = "voice_note";

/// Font size constant for small text
const double kFontSmall = 12;

/// Font size constant for button text
const double kButtonFontSize = 12;

/// Font size constant for extra small text
const double kFontXSmall = 11;

/// Font size constant for small-medium text
const double kFontSmallMed = 14;

/// Font size constant for medium text
const double kFontMedium = 16;

/// Padding constant for extra small padding
const double kPaddingXSmall = 2;

/// Padding constant for small padding
const double kPaddingSmall = 4;

/// Padding constant for medium padding
const double kPaddingMedium = 8;

/// Padding constant for large padding
const double kPaddingLarge = 16;

/// Padding constant for extra large padding
const double kPaddingXLarge = 20;

/// Border radius constant for extra small radius
const double kBorderRadiusXSmall = 2;

/// Border radius constant for medium radius
const double kBorderRadiusMedium = 8;

/// Horizontal padding constant for extra large padding
const SizedBox kHorizontalPaddingXLarge = SizedBox(width: kPaddingXLarge);

/// Horizontal padding constant for small padding
const SizedBox kHorizontalPaddingSmall = SizedBox(width: kPaddingSmall);

/// Horizontal padding constant for extra small padding
const SizedBox kHorizontalPaddingXSmall = SizedBox(width: kPaddingXSmall);

/// Horizontal padding constant for large padding
const SizedBox kHorizontalPaddingLarge = SizedBox(width: kPaddingLarge);

/// Horizontal padding constant for medium padding
const SizedBox kHorizontalPaddingMedium = SizedBox(width: kPaddingMedium);

/// Vertical padding constant for extra large padding
const SizedBox kVerticalPaddingXLarge = SizedBox(height: kPaddingXLarge);

/// Vertical padding constant for small padding
const SizedBox kVerticalPaddingSmall = SizedBox(height: kPaddingSmall);

/// Vertical padding constant for extra small padding
const SizedBox kVerticalPaddingXSmall = SizedBox(height: kPaddingXSmall);

/// Vertical padding constant for large padding
const SizedBox kVerticalPaddingLarge = SizedBox(height: kPaddingLarge);

/// Vertical padding constant for medium padding
const SizedBox kVerticalPaddingMedium = SizedBox(height: kPaddingMedium);
