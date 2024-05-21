import 'package:flutter/material.dart';

const String kRegexLinksAndTags =
    r'(?:(?:http|https|ftp|www)\:\/\/)?[a-zA-Z0-9\-\.]+\.[a-zA-Z]{1,}(?::[a-zA-Z0-9]*)?\/?[^\s\n]+|[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,}|<<([^<>]+)\|route://member/([a-zA-Z-0-9]+)>>|<<@participants\|route://participants>>';

// Attachment Type Constants
const String kAttachmentTypeImage = "image";
const String kAttachmentTypeVideo = "video";
const String kAttachmentTypeAudio = "audio";
const String kAttachmentTypePDF = "pdf";
const String kAttachmentTypeGIF = "gif";
const String kAttachmentTypeVoiceNote = "voice_note";

const double kFontSmall = 12;
const double kButtonFontSize = 12;
const double kFontXSmall = 11;
const double kFontSmallMed = 14;
const double kFontMedium = 16;
const double kPaddingXSmall = 2;
const double kPaddingSmall = 4;
const double kPaddingMedium = 8;
const double kPaddingLarge = 16;
const double kPaddingXLarge = 20;
const double kBorderRadiusXSmall = 2;
const double kBorderRadiusMedium = 8;
const SizedBox kHorizontalPaddingXLarge = SizedBox(width: kPaddingXLarge);
const SizedBox kHorizontalPaddingSmall = SizedBox(width: kPaddingSmall);
const SizedBox kHorizontalPaddingXSmall = SizedBox(width: kPaddingXSmall);
const SizedBox kHorizontalPaddingLarge = SizedBox(width: kPaddingLarge);
const SizedBox kHorizontalPaddingMedium = SizedBox(width: kPaddingMedium);
const SizedBox kVerticalPaddingXLarge = SizedBox(height: kPaddingXLarge);
const SizedBox kVerticalPaddingSmall = SizedBox(height: kPaddingSmall);
const SizedBox kVerticalPaddingXSmall = SizedBox(height: kPaddingXSmall);
const SizedBox kVerticalPaddingLarge = SizedBox(height: kPaddingLarge);
const SizedBox kVerticalPaddingMedium = SizedBox(height: kPaddingMedium);
