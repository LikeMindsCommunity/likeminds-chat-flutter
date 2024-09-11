import 'package:likeminds_chat_flutter_ui/src/widgets/media/document/preview.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/media/document/thumbnail.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/media/document/tile.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/shimmers/document_shimmer.dart';

export 'package:likeminds_chat_flutter_ui/src/widgets/media/document/preview.dart';
export 'package:likeminds_chat_flutter_ui/src/widgets/media/document/thumbnail.dart';
export 'package:likeminds_chat_flutter_ui/src/widgets/media/document/tile.dart';

class LMChatDocumentStyle {
  final LMChatDocumentPreviewStyle? previewStyle;
  final LMChatDocumentShimmerStyle? shimmerStyle;
  final LMChatDocumentTilePreviewStyle? previewTileStyle;
  final LMChatDocumentThumbnailStyle? thumbnailStyle;
  final LMChatDocumentTileStyle? tileStyle;

  LMChatDocumentStyle({
    this.previewStyle,
    this.previewTileStyle,
    this.shimmerStyle,
    this.tileStyle,
    this.thumbnailStyle,
  });

  factory LMChatDocumentStyle.basic() {
    return LMChatDocumentStyle(
      previewStyle: LMChatDocumentPreviewStyle.basic(),
      previewTileStyle: LMChatDocumentTilePreviewStyle.basic(),
      shimmerStyle: LMChatDocumentShimmerStyle.basic(),
      thumbnailStyle: LMChatDocumentThumbnailStyle.basic(),
      tileStyle: LMChatDocumentTileStyle.basic(),
    );
  }

  LMChatDocumentStyle copyWith({
    LMChatDocumentPreviewStyle? previewStyle,
    LMChatDocumentShimmerStyle? shimmerStyle,
    LMChatDocumentTilePreviewStyle? previewTileStyle,
    LMChatDocumentThumbnailStyle? thumbnailStyle,
    LMChatDocumentTileStyle? tileStyle,
  }) {
    return LMChatDocumentStyle(
      previewStyle: previewStyle ?? this.previewStyle,
      shimmerStyle: shimmerStyle ?? this.shimmerStyle,
      previewTileStyle: previewTileStyle ?? this.previewTileStyle,
      thumbnailStyle: thumbnailStyle ?? this.thumbnailStyle,
      tileStyle: tileStyle ?? this.tileStyle,
    );
  }
}
