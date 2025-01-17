import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/media/audio_handler.dart';
import 'package:likeminds_chat_flutter_core/src/utils/member_rights/member_rights.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:overlay_support/overlay_support.dart';

/// Example implementation of the UI-layer interface.
/// This keeps business logic in the core.
class LMChatConversationActionHelper extends LMChatConversationActionInterface {
  /// The selection type for the chatroom
  final LMChatSelectionType selectionType;

  /// The selected ids for the chatroom
  final List<int> selectedIds;

  /// The function to call when the selection is reset
  final Function() onResetSelection;

  /// The conversation action bloc
  final LMChatConversationActionBloc convActionBloc;

  /// The chatroom id
  final int chatroomId;

  /// The conversations to be shown in the menu
  final List<LMChatConversationViewData> conversations;

  /// The chat request state
  final int chatRequestState;

  /// Pass in the selection type from wherever you set it in config.
  LMChatConversationActionHelper({
    required this.selectionType,
    required this.selectedIds,
    required this.onResetSelection,
    required this.convActionBloc,
    required this.chatroomId,
    required this.conversations,
    this.chatRequestState = 0,
  });

  @override
  void onCopy(List<LMChatConversationViewData> conversations) {
    String copiedMessage = "";
    if (conversations.length > 1) {
      for (LMChatConversationViewData convo in conversations) {
        copiedMessage +=
            "[${convo.date}] ${convo.member!.name} : ${convo.answer}\n";
      }
    } else {
      copiedMessage = conversations.first.answer;
    }
    Clipboard.setData(ClipboardData(text: copiedMessage)).then((_) {
      LMChatAnalyticsBloc.instance.add(
        LMChatFireAnalyticsEvent(
          eventName: LMChatAnalyticsKeys.messageCopied,
          eventProperties: {
            'type': 'text',
            'chatroom_id': chatroomId,
          },
        ),
      );
      toast("Copied to clipboard");
      onResetSelection();
    });
  }

  @override
  void onDelete(BuildContext context, List<int> conversationIds) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return LMChatDialog(
          style: LMChatDialogStyle(
            backgroundColor: LMChatTheme.theme.container,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          title: LMChatText(
            "Delete Message?",
            style: LMChatTextStyle(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: LMChatTheme.theme.onContainer,
              ),
            ),
          ),
          content: LMChatText(
            "Are you sure you want to delete this message? This action cannot be reversed.",
            style: LMChatTextStyle(
              textStyle: TextStyle(
                color: LMChatTheme.theme.onContainer,
              ),
            ),
          ),
          actions: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              child: LMChatText(
                "CANCEL",
                style: LMChatTextStyle(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: LMChatTheme.theme.onContainer,
                  ),
                ),
                onTap: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: LMChatText(
                "DELETE",
                style: LMChatTextStyle(
                  backgroundColor: LMChatTheme.theme.primaryColor,
                  padding: const EdgeInsets.all(6),
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: LMChatTheme.theme.onPrimary,
                  ),
                ),
                onTap: () {
                  convActionBloc.add(
                    LMChatDeleteConversationEvent(
                      conversationIds: conversationIds,
                      reason: "Delete",
                    ),
                  );
                  LMChatAnalyticsBloc.instance.add(
                    LMChatFireAnalyticsEvent(
                      eventName: LMChatAnalyticsKeys.messageDeleted,
                      eventProperties: {
                        'type': 'text',
                        'chatroom_id': chatroomId,
                      },
                    ),
                  );
                  onResetSelection();
                  Navigator.of(dialogContext).pop();
                  LMChatCoreAudioHandler.instance.stopAudio();
                  LMChatCoreAudioHandler.instance.stopRecording();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void onEdit(LMChatConversationViewData conversation) {
    selectedIds.clear();
    convActionBloc.add(
      LMChatEditingConversationEvent(
        conversationId: conversation.id,
        chatroomId: chatroomId,
        editConversation: conversation,
      ),
    );
    onResetSelection();
  }

  @override
  void onReply(LMChatConversationViewData conversation) {
    convActionBloc.add(
      LMChatReplyConversationEvent(
        conversationId: conversation.id,
        chatroomId: chatroomId,
        replyConversation: conversation,
        attachments: conversation.attachments,
      ),
    );
    onResetSelection();
  }

  @override
  void onReport(LMChatConversationViewData conversation, BuildContext context) {
    selectedIds.clear();
    onResetSelection();
    context.push(
      LMChatReportScreen(
        entityId: conversation.id.toString(),
        entityCreatorId: conversation.member!.id.toString(),
        entityType: 3,
      ),
    );
  }

  @override
  void onReaction() {
    // TODO: Implement reaction handling
  }

  @override
  void showSelectionMenu(BuildContext context, Offset? position) {
    // Depending on selectionType, you can steer
    // the UI to show appbar, floating menu, or bottomsheet
    switch (selectionType) {
      case LMChatSelectionType.appbar:
        // Appbar actions are handled in chatroom.dart
        break;
      case LMChatSelectionType.floating:
        _showFloatingMenu(context, position);
        break;
      case LMChatSelectionType.bottomsheet:
        _showBottomSheetMenu(context);
        break;
    }
  }

  // Example private helper for floating popup flow
  void _showFloatingMenu(BuildContext context, Offset? position) {
    if (position == null) return;

    final selectedConversations =
        conversations.where((conv) => selectedIds.contains(conv.id)).toList();
    if (selectedConversations.isEmpty) return;

    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    // Ensure menu stays within screen bounds
    final double screenWidth = overlay.size.width;
    const double menuWidth = 180.0;

    // Adjust x position if menu would go off screen
    double adjustedX = position.dx;
    if (adjustedX < 0) {
      adjustedX = 0;
    } else if (adjustedX + menuWidth > screenWidth) {
      adjustedX = screenWidth - menuWidth;
    }

    showMenu(
      context: context,
      color: LMChatTheme.theme.container,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      constraints: const BoxConstraints(
        minWidth: 180,
        maxWidth: 180,
      ),
      position: RelativeRect.fromLTRB(
        adjustedX,
        position.dy,
        screenWidth - adjustedX - menuWidth,
        overlay.size.height - position.dy,
      ),
      items: [
        PopupMenuItem(
          height: 40,
          child: ListTile(
            dense: true,
            leading: Icon(Icons.copy, color: LMChatTheme.theme.onContainer),
            title: Text(
              'Copy',
              style: TextStyle(
                color: LMChatTheme.theme.onContainer,
                fontSize: 14,
              ),
            ),
          ),
          onTap: () => onCopy(selectedConversations),
        ),
        if (selectedConversations.length == 1) ...[
          PopupMenuItem(
            height: 40,
            child: ListTile(
              dense: true,
              leading: Icon(Icons.reply, color: LMChatTheme.theme.onContainer),
              title: Text(
                'Reply',
                style: TextStyle(
                  color: LMChatTheme.theme.onContainer,
                  fontSize: 14,
                ),
              ),
            ),
            onTap: () => onReply(selectedConversations.first),
          ),
          PopupMenuItem(
            height: 40,
            child: ListTile(
              dense: true,
              leading: Icon(Icons.edit, color: LMChatTheme.theme.onContainer),
              title: Text(
                'Edit',
                style: TextStyle(
                  color: LMChatTheme.theme.onContainer,
                  fontSize: 14,
                ),
              ),
            ),
            onTap: () => onEdit(selectedConversations.first),
          ),
        ],
        if (selectedConversations.length == 1 &&
            LMChatMemberRightUtil.isReportAllowed(
                selectedConversations.first) &&
            chatRequestState != 2)
          PopupMenuItem(
            height: 40,
            child: ListTile(
              dense: true,
              leading: Icon(Icons.info_outline,
                  color: LMChatTheme.theme.onContainer),
              title: Text(
                'Report',
                style: TextStyle(
                  color: LMChatTheme.theme.onContainer,
                  fontSize: 14,
                ),
              ),
            ),
            onTap: () => onReport(selectedConversations.first, context),
          ),
        PopupMenuItem(
          height: 40,
          child: const ListTile(
            dense: true,
            leading: Icon(Icons.delete_outline, color: Colors.red),
            title: Text(
              'Delete',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          ),
          onTap: () => onDelete(context, selectedIds),
        ),
      ],
    );
  }

  // Example private helper for bottomsheet flow
  void _showBottomSheetMenu(BuildContext context) {
    final selectedConversations =
        conversations.where((conv) => selectedIds.contains(conv.id)).toList();
    if (selectedConversations.isEmpty) return;

    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Copy'),
                onTap: () {
                  onCopy(selectedConversations);
                  Navigator.pop(sheetContext);
                },
              ),
              if (selectedConversations.length == 1) ...[
                ListTile(
                  leading: const Icon(Icons.subdirectory_arrow_left),
                  title: const Text('Reply'),
                  onTap: () {
                    onReply(selectedConversations.first);
                    Navigator.pop(sheetContext);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit'),
                  onTap: () {
                    onEdit(selectedConversations.first);
                    Navigator.pop(sheetContext);
                  },
                ),
              ],
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  onDelete(context, selectedIds);
                  Navigator.pop(sheetContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
