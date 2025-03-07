import 'dart:async';
import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/packages/flutter_typeahead/lib/flutter_typeahead.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/tag/tag_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';

/// A custom text field widget for chat applications with tagging functionality.
class LMChatTextField extends StatefulWidget {
  /// Determines if suggestions should appear below the text field.
  final bool isDown;

  /// The focus node for the text field.
  final FocusNode focusNode;

  /// Callback function when a tag is selected.
  final Function(LMChatTagViewData) onTagSelected;

  /// The text editing controller for the text field.
  final TextEditingController? controller;

  /// Custom decoration for the text field.
  final InputDecoration? decoration;

  /// Custom text style for the text field.
  final TextStyle? style;

  /// Callback function when the text changes.
  final Function(String)? onChange;

  /// The ID of the chatroom.
  final int chatroomId;

  /// Determines if the chatroom is secret.
  final bool isSecret;

  /// Determines if the text field is enabled.
  final bool enabled;

  /// Custom scroll physics for the suggestions list.
  final ScrollPhysics? scrollPhysics;

  /// Custom styling for the text field.
  final LMChatTextFieldStyle? textFieldStyle;

  const LMChatTextField({
    super.key,
    required this.isDown,
    required this.chatroomId,
    required this.onTagSelected,
    required this.controller,
    required this.focusNode,
    this.enabled = true,
    this.isSecret = false,
    this.style,
    this.decoration,
    this.onChange,
    this.scrollPhysics,
    this.textFieldStyle,
  });

  /// Creates a copy of this widget with the given fields replaced with new values.
  LMChatTextField copyWith({
    bool? isDown,
    FocusNode? focusNode,
    Function(LMChatTagViewData)? onTagSelected,
    TextEditingController? controller,
    InputDecoration? decoration,
    TextStyle? style,
    Function(String)? onChange,
    int? chatroomId,
    bool? isSecret,
    bool? enabled,
    ScrollPhysics? scrollPhysics,
    LMChatTextFieldStyle? textFieldStyle,
  }) {
    return LMChatTextField(
      isDown: isDown ?? this.isDown,
      focusNode: focusNode ?? this.focusNode,
      onTagSelected: onTagSelected ?? this.onTagSelected,
      controller: controller ?? this.controller,
      decoration: decoration ?? this.decoration,
      style: style ?? this.style,
      onChange: onChange ?? this.onChange,
      chatroomId: chatroomId ?? this.chatroomId,
      isSecret: isSecret ?? this.isSecret,
      enabled: enabled ?? this.enabled,
      scrollPhysics: scrollPhysics ?? this.scrollPhysics,
      textFieldStyle: textFieldStyle ?? this.textFieldStyle,
    );
  }

  @override
  State<LMChatTextField> createState() => _LMChatTextFieldState();
}

class _LMChatTextFieldState extends State<LMChatTextField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  final ScrollController _scrollController = ScrollController();
  final SuggestionsBoxController _suggestionsBoxController =
      SuggestionsBoxController();

  List<LMChatTagViewData> _tagViewData = [];

  int _page = 1;
  final ValueNotifier<bool> _tagComplete = ValueNotifier(false);
  String _textValue = "";
  String _tagValue = "";
  static const int _fixedSize = 50;
  late LMChatTextFieldStyle effectiveStyle;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode;
    _controller = widget.controller!;
    _setupScrollListener();
    effectiveStyle = widget.textFieldStyle ?? LMChatTheme.theme.textFieldStyle;
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreTags();
      }
    });
  }

  Future<void> _loadMoreTags() async {
    _page++;
    final taggingData = await _fetchTaggingData(_page);
    if (taggingData.members?.isNotEmpty == true) {
      setState(() {
        _tagViewData
            .addAll(taggingData.members!.map((e) => e.toLMChatTagViewData()));
      });
    }
  }

  Future<TagResponseModel> _fetchTaggingData(int page,
      {String? searchQuery}) async {
    final response = await LMChatCore.client.getTaggingList(
      (TagRequestModelBuilder()
            ..chatroomId(widget.chatroomId)
            ..page(page)
            ..searchQuery(searchQuery ?? '')
            ..pageSize(_fixedSize))
          .build(),
    );
    return response.data!;
  }

  Future<Iterable<LMChatTagViewData>> _getSuggestions(String query) async {
    if (query.isEmpty) {
      return const Iterable.empty();
    }

    if (query.contains('@') && !_tagComplete.value) {
      String tag = _tagValue.substring(1).split(' ').first;
      final taggingData = await _fetchTaggingData(1, searchQuery: tag);

      _tagViewData = _processTaggingData(taggingData);
      return _tagViewData;
    }
    return const Iterable.empty();
  }

  List<LMChatTagViewData> _processTaggingData(TagResponseModel taggingData) {
    List<LMChatTagViewData> result = [];

    if (!widget.isSecret) {
      if (taggingData.groupTags != null && taggingData.groupTags!.isNotEmpty) {
        result
            .addAll(taggingData.groupTags!.map((e) => e.toLMChatTagViewData()));
      }
    }

    if (taggingData.members != null && taggingData.members!.isNotEmpty) {
      result.addAll(taggingData.members!.map((e) => e.toLMChatTagViewData()));
    }

    return result;
  }

  void _handleTextChange(String value) {
    widget.onChange?.call(value);
    _updateTaggingState(value);
  }

  void _updateTaggingState(String value) {
    final int newTagCount = '@'.allMatches(value).length;
    final int completeCount = '~'.allMatches(value).length;

    if (newTagCount == completeCount) {
      _textValue = _controller.text;
      _tagComplete.value = true;
    } else if (newTagCount > completeCount) {
      _tagComplete.value = false;
      _tagValue = value.substring(value.lastIndexOf('@'));
      _textValue = value.substring(0, value.lastIndexOf('@'));
    } else {
      _removeExtraTildeIfNeeded();
    }
  }

  void _removeExtraTildeIfNeeded() {
    int currentPosition = _controller.selection.base.offset;
    if (currentPosition > 0 && _controller.text[currentPosition - 1] == '~') {
      _controller.text = _controller.text
          .replaceRange(currentPosition - 1, currentPosition, "");
      _controller.selection =
          TextSelection.fromPosition(TextPosition(offset: currentPosition - 1));
    }
  }

  void _handleSuggestionSelected(LMChatTagViewData suggestion) {
    widget.onTagSelected.call(suggestion);
    int currentPosition = _controller.selection.base.offset;
    String suffix = _controller.text.substring(currentPosition);

    _textValue = _buildTaggedText(suggestion);
    _controller.text = '$_textValue $suffix';
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length - suffix.length));

    _tagValue = '';
    _textValue = _controller.text;
    _page = 1;
    _tagComplete.value = true;
  }

  String _buildTaggedText(LMChatTagViewData suggestion) {
    String prefix = _textValue.endsWith('~') ? ' ' : '';
    String tagPrefix = suggestion.tagType == LMTagType.groupTag ? '' : '@';
    return '$_textValue$prefix$tagPrefix${suggestion.name}~';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: effectiveStyle.margin?? EdgeInsets.zero,
      child: ValueListenableBuilder(
        valueListenable: _tagComplete,
        builder: (context, value, child) {
          return TypeAheadField<LMChatTagViewData>(
            scrollPhysics:
                widget.scrollPhysics ?? const AlwaysScrollableScrollPhysics(),
            tagColor: effectiveStyle.tagColor ?? LMChatTheme.theme.linkColor,
            onTagTap: (p) {
              print(p);
            },
            autoFlipListDirection: false,
            autoFlipDirection: true,
            suggestionsBoxController: _suggestionsBoxController,
            suggestionsBoxDecoration: _buildSuggestionsBoxDecoration(),
            noItemsFoundBuilder: (context) => const SizedBox.shrink(),
            hideOnEmpty: true,
            hideOnLoading: true,
            debounceDuration: const Duration(milliseconds: 500),
            scrollController: _scrollController,
            textFieldConfiguration: _buildTextFieldConfiguration(),
            direction: AxisDirection.down,
            suggestionsCallback: widget.enabled
                ? (suggestion) => _getSuggestions(suggestion)
                : (s) => Future.value(const Iterable.empty()),
            keepSuggestionsOnSuggestionSelected: true,
            itemBuilder: _buildSuggestionItem,
            onSuggestionSelected: _handleSuggestionSelected,
          );
        },
      ),
    );
  }

  SuggestionsBoxDecoration _buildSuggestionsBoxDecoration() {
    return SuggestionsBoxDecoration(
      offsetX: -4.w,
      elevation: effectiveStyle.suggestionsBoxElevation ?? 2,
      color: effectiveStyle.suggestionsBoxColor ?? LMChatTheme.theme.container,
      clipBehavior: Clip.hardEdge,
      borderRadius: effectiveStyle.suggestionsBoxBorderRadius ??
          const BorderRadius.all(Radius.circular(12.0)),
      hasScrollbar: false,
      constraints: effectiveStyle.suggestionsBoxConstraints ??
          BoxConstraints(maxHeight: 24.h, minWidth: 80.w),
    );
  }

  TextFieldConfiguration _buildTextFieldConfiguration() {
    return TextFieldConfiguration(
      textInputAction: TextInputAction.newline,
      keyboardType: TextInputType.multiline,
      controller: _controller,
      style: effectiveStyle.textStyle ??
          widget.style ??
          const TextStyle(fontSize: 14),
      textCapitalization: TextCapitalization.sentences,
      focusNode: _focusNode,
      minLines: 1,
      maxLines: 200,
      scrollPadding: const EdgeInsets.all(2),
      enabled: widget.decoration?.enabled ?? true,
      decoration: effectiveStyle.inputDecoration ??
          widget.decoration ??
          InputDecoration(
            hintText: 'Type something...',
            hintStyle: widget.style,
            border: InputBorder.none,
            focusColor: LMChatTheme.theme.linkColor,
          ),
      onChanged: _handleTextChange,
    );
  }

  Widget _buildSuggestionItem(BuildContext context, LMChatTagViewData opt) {
    return Container(
      decoration: BoxDecoration(
        color:
            effectiveStyle.suggestionItemColor ?? LMChatTheme.theme.container,
        border: Border(
          bottom: BorderSide(
            color: effectiveStyle.suggestionItemColor ??
                LMChatTheme.theme.container,
            width: 0.2,
          ),
        ),
      ),
      child: Padding(
        padding: effectiveStyle.suggestionItemPadding ??
            const EdgeInsets.symmetric(horizontal: 4),
        child: Container(
          width: double.infinity,
          color:
              effectiveStyle.suggestionsBoxColor ?? LMChatTheme.theme.container,
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              LMChatProfilePicture(
                fallbackText: opt.name,
                imageUrl: opt.imageUrl,
                style: effectiveStyle.suggestionItemAvatarStyle ??
                    LMChatProfilePictureStyle(
                      size: 36,
                      backgroundColor: LMChatTheme.theme.backgroundColor,
                    ),
              ),
              const SizedBox(width: 12),
              LMChatText(
                opt.name,
                style: effectiveStyle.suggestionItemTextStyle ??
                    LMChatTextStyle(
                      textStyle: TextStyle(
                        fontSize: 14,
                        color: LMChatTheme.theme.onContainer,
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
