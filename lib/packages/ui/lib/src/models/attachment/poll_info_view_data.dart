import 'package:likeminds_chat_flutter_ui/src/models/attachment/poll_view_data.dart';

class LMChatPollInfoViewData {
  final bool? isAnonymous;
  final bool? allowAddOption;
  final int? pollType;
  final String? pollTypeText;
  final String? submitTypeText;
  final int? expiryTime;
  final int? multipleSelectNum;
  final int? multipleSelectState;
  final List<LMChatPollViewData>? pollViewDataList;
  final String? pollAnswerText;
  final bool? isPollSubmitted;
  final bool? toShowResult;
  final int? conversationId;

  LMChatPollInfoViewData._({
    required this.isAnonymous,
    required this.allowAddOption,
    required this.pollType,
    required this.pollTypeText,
    required this.submitTypeText,
    required this.expiryTime,
    required this.multipleSelectNum,
    required this.multipleSelectState,
    required this.pollViewDataList,
    required this.pollAnswerText,
    required this.isPollSubmitted,
    required this.toShowResult,
    required this.conversationId,
  });
}

class LMChatPollInfoViewDataBuilder {
  bool? _isAnonymous;
  bool? _allowAddOption;
  int? _pollType;
  String? _pollTypeText;
  String? _submitTypeText;
  int? _expiryTime;
  int? _multipleSelectNum;
  int? _multipleSelectState;
  List<LMChatPollViewData>? _pollViewDataList;
  String? _pollAnswerText;
  bool? _isPollSubmitted;
  bool? _toShowResult;
  int? _conversationId;

  void isAnonymous(bool? isAnonymous) {
    _isAnonymous = isAnonymous;
  }

  void allowAddOption(bool? allowAddOption) {
    _allowAddOption = allowAddOption;
  }

  void pollType(int? pollType) {
    _pollType = pollType;
  }

  void pollTypeText(String? pollTypeText) {
    _pollTypeText = pollTypeText;
  }

  void submitTypeText(String? submitTypeText) {
    _submitTypeText = submitTypeText;
  }

  void expiryTime(int? expiryTime) {
    _expiryTime = expiryTime;
  }

  void multipleSelectNum(int? multipleSelectNum) {
    _multipleSelectNum = multipleSelectNum;
  }

  void multipleSelectState(int? multipleSelectState) {
    _multipleSelectState = multipleSelectState;
  }

  void pollViewDataList(List<LMChatPollViewData>? pollViewDataList) {
    _pollViewDataList = pollViewDataList;
  }

  void pollAnswerText(String? pollAnswerText) {
    _pollAnswerText = pollAnswerText;
  }

  void isPollSubmitted(bool? isPollSubmitted) {
    _isPollSubmitted = isPollSubmitted;
  }

  void toShowResult(bool? toShowResult) {
    _toShowResult = toShowResult;
  }

  void conversationId(int? conversationId) {
    _conversationId = conversationId;
  }

  LMChatPollInfoViewData build() {
    return LMChatPollInfoViewData._(
      isAnonymous: _isAnonymous,
      allowAddOption: _allowAddOption,
      pollType: _pollType,
      pollTypeText: _pollTypeText,
      submitTypeText: _submitTypeText,
      expiryTime: _expiryTime,
      multipleSelectNum: _multipleSelectNum,
      multipleSelectState: _multipleSelectState,
      pollViewDataList: _pollViewDataList,
      pollAnswerText: _pollAnswerText,
      isPollSubmitted: _isPollSubmitted,
      toShowResult: _toShowResult,
      conversationId: _conversationId,
    );
  }
}

