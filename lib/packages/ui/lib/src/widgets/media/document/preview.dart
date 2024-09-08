import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:path/path.dart';

///{@template lm_chat_document_preview}
/// A widget that displays a document preview with multiple attachments.
/// {@endtemplate}
class LMChatDocumentPreview extends StatefulWidget {
  /// The list of documents to display.
  final List<LMChatMediaModel> mediaList;

  ///{@macro lm_chat_document_preview}
  const LMChatDocumentPreview({
    Key? key,
    required this.mediaList,
  }) : super(key: key);

  @override
  State<LMChatDocumentPreview> createState() => _LMChatDocumentPreviewState();
}

/// The state for the DocumentFactory widget.
class _LMChatDocumentPreviewState extends State<LMChatDocumentPreview> {
  /// The list of documents to display.
  List<LMChatMediaModel>? mediaList;

  /// A notifier that triggers a rebuild of the widget.
  ValueNotifier<bool> rebuildCurr = ValueNotifier<bool>(false);

  /// The result of the document preview.
  String? result;

  /// The current position in the list of documents.
  int currPosition = 0;

  /// Checks if there are multiple attachments.
  bool checkIfMultipleAttachments() {
    return mediaList!.length > 1;
  }

  @override
  void dispose() {
    rebuildCurr.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    mediaList = widget.mediaList;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: rebuildCurr,
      builder: (context, _, __) {
        return Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100.w, maxHeight: 60.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: LMChatDocumentThumbnail(
                      media: mediaList![currPosition],
                    ),
                  ),
                  kVerticalPaddingXLarge,
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        width: 80.w,
                        child: LMChatText(
                          basenameWithoutExtension(
                              mediaList![currPosition].mediaFile!.path),
                          style: const LMChatTextStyle(
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            textStyle: TextStyle(
                              fontSize: 12,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      kVerticalPaddingSmall,
                      getDocumentDetails(mediaList![currPosition]),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

///{@template lm_chat_document_tile_preview}
/// A widget that displays multiple document previews.
/// {@endtemplate}
class LMChatDocumentTilePreview extends StatefulWidget {
  /// The list of documents to display.
  final List<LMChatMediaModel> mediaList;

  ///{@macro lm_chat_document_tile_preview}
  const LMChatDocumentTilePreview({
    Key? key,
    required this.mediaList,
  }) : super(key: key);

  @override
  State<LMChatDocumentTilePreview> createState() =>
      LMChatDocumentTilePreviewState();
}

/// The state for the GetMultipleDocPreview widget.
class LMChatDocumentTilePreviewState extends State<LMChatDocumentTilePreview> {
  /// The list of documents to display.
  List<LMChatMediaModel>? mediaList;

  /// A notifier that triggers a rebuild of the widget.
  ValueNotifier<bool> rebuildCurr = ValueNotifier<bool>(false);

  /// The number of documents to display initially.
  int length = 2;

  /// Callback for when the "more" button is tapped.
  void onMoreButtonTap() {
    length = mediaList!.length;
    rebuildCurr.value = !rebuildCurr.value;
  }

  @override
  Widget build(BuildContext context) {
    mediaList = widget.mediaList;
    return ValueListenableBuilder(
      valueListenable: rebuildCurr,
      builder: (context, _, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: length,
              itemBuilder: (context, index) => LMChatDocumentTile(
                media: mediaList![index],
              ),
            ),
            mediaList!.length > 2 && mediaList!.length != length
                ? const SizedBox(height: 8)
                : const SizedBox(),
            mediaList!.length > 2 && mediaList!.length != length
                ? GestureDetector(
                    onTap: onMoreButtonTap,
                    behavior: HitTestBehavior.translucent,
                    child: SizedBox(
                      width: 72,
                      height: 24,
                      child: LMChatText(
                        '+ ${mediaList!.length - 2} more',
                        style: LMChatTextStyle(
                          textStyle: TextStyle(
                            color: LMChatTheme.theme.secondaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        );
      },
    );
  }
}
