import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';

class LMChatApproveRejectView extends StatefulWidget {
  const LMChatApproveRejectView({
    super.key,
    required this.onApproveButtonClicked,
    required this.onRejectButtonClicked,
    this.approveButtonBuilder,
    this.rejectButtonBuilder,
  });

  final VoidCallback onApproveButtonClicked;
  final VoidCallback onRejectButtonClicked;
  final LMChatButtonBuilder? approveButtonBuilder;
  final LMChatButtonBuilder? rejectButtonBuilder;

  @override
  State<LMChatApproveRejectView> createState() =>
      _LMChatApproveRejectViewState();
}

class _LMChatApproveRejectViewState extends State<LMChatApproveRejectView> {
  @override
  Widget build(BuildContext context) {
    return LMChatDialog(
      title: const Text('Approve or Reject'),
      actions: [
        widget.approveButtonBuilder?.call(_defaultApproveButton(context)) ??
            _defaultApproveButton(context),
        widget.rejectButtonBuilder?.call(_defaultRejectButton(context)) ??
            _defaultRejectButton(context),
      ],
    );
  }

  LMChatButton _defaultApproveButton(BuildContext context) {
    return LMChatButton(
      onTap: widget.onApproveButtonClicked,
      child: Text('Approve'),
    );
  }

  LMChatButton _defaultRejectButton(BuildContext context) {
    return LMChatButton(
      onTap: widget.onRejectButtonClicked,
      child: Text('Reject'),
    );
  }
}
