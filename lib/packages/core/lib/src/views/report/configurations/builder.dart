import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/src/views/report/report.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// {@template lm_chat_report_builder_delegate}
/// Delegate class for building the report widget
/// {@endtemplate}
class LMChatReportBuilderDelegate {
  /// {@macro lm_chat_report_builder_delegate}
  const LMChatReportBuilderDelegate();

  /// Builds the report chip.
  Widget reportChipBuilder(
    BuildContext context,
    LMChatReportTagViewData data,
  ) {
    return const SizedBox();
  }

  /// Builds the report content.
  Widget reportContentBuilder(
    BuildContext context,
    LMReportContentWidget reportContentWidget,
  ) {
    return reportContentWidget;
  }
}
