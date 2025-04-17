import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/moderation/moderation_bloc.dart';
import 'package:likeminds_chat_flutter_core/src/views/report/configurations/builder.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:overlay_support/overlay_support.dart';

/// {@template lm_chat_report_screen}
/// Report screen for reporting abuse
/// [reportChipBuilder] - Report chip builder
/// [reportContentBuilder] - Report content builder
/// [entityId] - The id of the entity to report (i.e. conversation)
/// [entityCreatorId] - The id of the entity creator
/// [entityType] - The type of the entity
/// {@endtemplate}
class LMChatReportScreen extends StatefulWidget {
  /// Report chip builder
  final Widget Function(BuildContext, LMChatDeleteReasonViewData)?
      reportChipBuilder;

  /// Report content builder
  final Widget Function(BuildContext, LMReportContentWidget)?
      reportContentBuilder;

  /// The id of the entity to report (i.e. conversation)
  final String entityId;

  /// The id of the entity creator
  final String entityCreatorId;

  /// The type of the entity
  final int? entityType;

  /// {@macro lm_chat_report_screen}
  const LMChatReportScreen({
    Key? key,
    required this.entityId,
    required this.entityCreatorId,
    this.entityType,
    this.reportChipBuilder,
    this.reportContentBuilder,
  }) : super(key: key);

  @override
  State<LMChatReportScreen> createState() => _LMChatReportScreenState();
}

class _LMChatReportScreenState extends State<LMChatReportScreen> {
  late Size screenSize;
  final LMChatWidgetSource _widgetSource = LMChatWidgetSource.report;
  LMChatThemeData theme = LMChatTheme.instance.themeData;
  final TextEditingController _reportReasonController = TextEditingController();
  LMChatReportTagViewData? _selectedReportTag;
  final LMChatReportBuilderDelegate _screenBuilder =
      LMChatCore.config.reportConfig.builder;
  final LMChatModerationBloc _moderationBloc = LMChatModerationBloc();

  @override
  void initState() {
    super.initState();
    _moderationBloc.add(LMChatModerationFetchTagsEvent());
  }

  @override
  void dispose() {
    super.dispose();
    _reportReasonController.dispose();
    _moderationBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.sizeOf(context);
    return ValueListenableBuilder(
        valueListenable: LMChatTheme.themeNotifier,
        builder: (context, _, child) {
          return _screenBuilder.scaffold(
            backgroundColor: theme.container,
            source: _widgetSource,
            appBar: _screenBuilder.appBarBuilder(context, _defAppBar(context)),
            body: SafeArea(
              top: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 20,
                          ),
                          widget.reportContentBuilder
                                  ?.call(context, _defReportContentWidget()) ??
                              _defReportContentWidget(),
                          const SizedBox(
                            height: 24,
                          ),
                          _defChipListBuilder(),
                          if (_selectedReportTag?.name.toLowerCase() ==
                                  'others' ||
                              _selectedReportTag?.name.toLowerCase() == 'other')
                            _screenBuilder.otherReasonTextFieldBuilder(
                              context,
                              _reportReasonController,
                              _defOtherReasonTextField(),
                            )
                        ],
                      ),
                    ),
                  ),
                  _screenBuilder.submitButtonBuilder(
                    context,
                    widget.entityId,
                    _selectedReportTag?.id,
                    _reportReasonController.text.trim(),
                    _defSubmitButton(context),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _defOtherReasonTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
      child: TextField(
        cursorColor: Colors.black,
        style: const TextStyle(
          color: Colors.black,
        ),
        controller: _reportReasonController,
        decoration: theme.textFieldStyle.inputDecoration?.copyWith(
              hintText: 'Reason',
              hintStyle: theme.contentStyle.textStyle,
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: theme.disabledColor,
                  width: 1,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: theme.primaryColor,
                  width: 1,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: theme.primaryColor,
                  width: 1,
                ),
              ),
            ) ??
            InputDecoration(
              fillColor: theme.primaryColor,
              focusColor: theme.primaryColor,
              labelText: 'Reason',
              labelStyle: theme.contentStyle.textStyle,
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: theme.disabledColor,
                  width: 1,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: theme.primaryColor,
                  width: 1,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: theme.primaryColor,
                  width: 1,
                ),
              ),
            ),
      ),
    );
  }

  BlocConsumer<LMChatModerationBloc, LMChatModerationState>
      _defChipListBuilder() {
    return BlocConsumer<LMChatModerationBloc, LMChatModerationState>(
        bloc: _moderationBloc,
        listener: (context, state) {
          if (state is LMChatModerationReportPostedState) {
            toast('Reported successfully');
            context.pop();
          }
        },
        buildWhen: (previous, current) {
          if (previous is LMChatModerationTagLoadedState &&
              current is LMChatModerationReportPostedState) {
            return false;
          }
          return true;
        },
        builder: (context, state) {
          if (state is LMChatModerationTagLoadingState) {
            return const LMChatLoader();
          }
          if (state is LMChatModerationTagLoadedState) {
            List<LMChatReportTagViewData> reportTags = state.tags;
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 16,
              ),
              child: Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: reportTags.isNotEmpty
                      ? reportTags
                          .map(
                            (tagViewData) => _screenBuilder.reportChipBuilder(
                              context,
                              tagViewData,
                              _defChip(tagViewData),
                            ),
                          )
                          .toList()
                      : []),
            );
          } else {
            return const SizedBox();
          }
        });
  }

  LMChatChip _defChip(LMChatReportTagViewData tagViewData) {
    return LMChatChip(
      onTap: () {
        setState(() {
          if (_selectedReportTag?.id == tagViewData.id) {
            if (_selectedReportTag?.name.toLowerCase() == 'others' ||
                _selectedReportTag?.name.toLowerCase() == 'other') {
              _reportReasonController.clear();
            }
            _selectedReportTag = null;
          } else {
            _selectedReportTag = tagViewData;
          }
        });
      },
      label: LMChatText(
        tagViewData.name,
        style: LMChatTextStyle(
          textStyle: const TextStyle(
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ).copyWith(
            fontSize: 14,
            color: _selectedReportTag?.id == tagViewData.id
                ? Colors.white
                : theme.inActiveColor,
          ),
        ),
      ),
      style: LMChatChipStyle.basic().copyWith(
        backgroundColor: _selectedReportTag?.id == tagViewData.id
            ? theme.primaryColor
            : theme.container,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
          side: BorderSide(
            color: _selectedReportTag?.id == tagViewData.id
                ? theme.primaryColor
                : theme.inActiveColor,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
      ),
    );
  }

  LMChatButton _defSubmitButton(BuildContext context) {
    return LMChatButton(
      style: LMChatButtonStyle(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 60.0),
        margin: const EdgeInsets.symmetric(vertical: 24.0),
        backgroundColor: _selectedReportTag == null
            ? theme.errorColor.withOpacity(0.2)
            : theme.errorColor,
        borderRadius: 50,
      ),
      text: LMChatText(
        'Report',
        style: LMChatTextStyle(
          textStyle: TextStyle(
              color: theme.container,
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
      ),
      onTap: _onSubmit,
    );
  }

  void _onSubmit() async {
    String? reason = _reportReasonController.text.trim();
    if (_selectedReportTag == null) {
      showReasonNotSelectedSnackbar();
      return;
    }

    String deleteReasonLowerCase = _selectedReportTag!.name.toLowerCase();
    if ((deleteReasonLowerCase == 'others' ||
        deleteReasonLowerCase == 'other')) {
      if (reason.isEmpty) {
        toast('Please enter a reason');
        return;
      }
    }

    if (_selectedReportTag != null) {
      _moderationBloc.add(
        LMChatModerationPostReportEvent(
          entityId: widget.entityId,
          reportTagId: _selectedReportTag!.id,
          reason: reason,
        ),
      );
    } else {
      showReasonNotSelectedSnackbar();
      return;
    }
  }

  LMChatAppBar _defAppBar(BuildContext context) {
    return LMChatAppBar(
      style: LMChatAppBarStyle(
        backgroundColor: theme.container,
        showBackButton: false,
        height: 56,
        border: Border(
          bottom: BorderSide(
            color: theme.disabledColor,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
      ),
      trailing: [
        LMChatButton(
          onTap: () {
            context.pop();
          },
          style: LMChatButtonStyle(
            height: 48,
            backgroundColor: Colors.transparent,
            borderRadius: 0,
            icon: LMChatIcon(
              type: LMChatIconType.icon,
              icon: Icons.close,
              style: LMChatIconStyle(
                color: theme.onContainer,
              ),
            ),
          ),
        )
      ],
      title: LMChatText(
        'Report',
        style: LMChatTextStyle(
          textStyle: TextStyle(
            fontSize: 20,
            color: theme.errorColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void showReasonNotSelectedSnackbar() {
    toast('Please select a reason');
  }

  LMReportContentWidget _defReportContentWidget() {
    return LMReportContentWidget(
      title: 'Please specify the problem to continue',
      description:
          'You would be able to report this message after selecting a problem.',
      style: LMReportContentWidgetStyle(
        titleStyle: LMChatTextStyle(
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: theme.onContainer,
          ),
        ),
        descriptionStyle: LMChatTextStyle(
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: theme.inActiveColor,
            overflow: TextOverflow.visible,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}

/// {@template lm_chat_report_screen_style}
/// Style for the report screen
/// [LMReportContentWidgetStyle] - Style for the report content widget
/// [LMChatButtonStyle] - Style for the submit button
/// {@endtemplate}
class LMReportScreenStyle {
  /// Style for the report content widget
  LMReportContentWidgetStyle? reportContentWidgetStyle;

  /// Style for the submit button
  LMChatButtonStyle? submitButtonStyle;

  /// {@macro lm_chat_report_screen_style}
  LMReportScreenStyle({
    this.reportContentWidgetStyle,
    this.submitButtonStyle,
  });

  /// Copy the current style with the provided values
  /// [reportContentWidgetStyle] - Style for the report content widget
  /// [submitButtonStyle] - Style for the submit button
  LMReportScreenStyle copyWith({
    LMReportContentWidgetStyle? reportContentWidgetStyle,
    LMChatButtonStyle? submitButtonStyle,
  }) {
    return LMReportScreenStyle(
      reportContentWidgetStyle:
          reportContentWidgetStyle ?? this.reportContentWidgetStyle,
      submitButtonStyle: submitButtonStyle ?? this.submitButtonStyle,
    );
  }
}

/// {@template lm_chat_report_content_widget}
/// A widget to display the report content
/// [title] - The title of the report content
/// [description] - The description of the report content
/// [style] - The style of the report content widget
/// {@endtemplate}
class LMReportContentWidget extends StatelessWidget {
  /// The title of the report content
  final String title;

  /// The description of the report content
  final String description;

  /// The style of the report content widget

  final LMReportContentWidgetStyle? style;

  /// {@macro lm_chat_report_content_widget}
  const LMReportContentWidget({
    super.key,
    required this.title,
    required this.description,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: style?.margin,
      padding: style?.padding,
      child: Column(
        crossAxisAlignment:
            style?.crossAxisAlignment ?? CrossAxisAlignment.start,
        mainAxisAlignment: style?.mainAxisAlignment ?? MainAxisAlignment.start,
        children: <Widget>[
          LMChatText(
            title,
            style: style?.titleStyle,
          ),
          SizedBox(
            height: style?.titleDescriptionSpacing ?? 8,
          ),
          LMChatText(
            description,
            style: style?.descriptionStyle,
          ),
        ],
      ),
    );
  }
}

/// {@template lm_chat_report_content_widget_style}
/// Style for the report content widget
/// [LMChatTextStyle] - Style for the title
/// [LMChatTextStyle] - Style for the description
/// [CrossAxisAlignment] - Cross axis alignment
/// [MainAxisAlignment] - Main axis alignment
/// [double] - Spacing between title and description
/// [EdgeInsets] - Padding
/// [EdgeInsets] - Margin
/// {@endtemplate}
class LMReportContentWidgetStyle {
  /// Style for the title
  final LMChatTextStyle? titleStyle;

  /// Style for the description
  final LMChatTextStyle? descriptionStyle;

  /// Cross axis alignment
  final CrossAxisAlignment? crossAxisAlignment;

  /// Main axis alignment
  final MainAxisAlignment? mainAxisAlignment;

  /// Spacing between title and description
  final double? titleDescriptionSpacing;

  /// Padding
  final EdgeInsets? padding;

  /// Margin
  final EdgeInsets? margin;

  /// {@macro lm_chat_report_content_widget_style}
  const LMReportContentWidgetStyle({
    this.titleStyle,
    this.descriptionStyle,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.titleDescriptionSpacing,
    this.padding,
    this.margin,
  });
}
