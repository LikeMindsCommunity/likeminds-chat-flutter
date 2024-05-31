// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

class LMChatConversationViewData {
  final bool? allowAddOption;
  final String answer;
  final int? apiVersion;
  final int? attachmentCount;
  final List<LMChatAttachmentViewData>? attachments;
  final bool? attachmentsUploaded;
  final int? chatroomId;
  final int? communityId;
  final String createdAt;
  final int? createdEpoch;
  final String? date;
  final int? deletedByUserId;
  final String? deviceId;
  final int? endTime;
  final int? expiryTime;
  final bool? hasFiles;
  final bool? hasReactions;
  final String? header;
  final int id;
  final String? internalLink;
  final bool? isAnonymous;
  final bool? isEdited;
  final int? lastUpdated;
  final String? location;
  final String? locationLat;
  final String? locationLong;
  final int? multipleSelectNo;
  final int? multipleSelectState;
  final dynamic ogTags;
  final int? onlineLinkEnableBefore;
  final String? pollAnswerText;
  final int? pollType;
  final int? replyChatroomId;
  final int? replyId;
  final int? startTime;
  final int? state;
  final String? temporaryId;
  final int? userId;
  final int? memberId;
  final bool? toShowResults;
  final String? pollTypeText;
  final String? submitTypeText;
  final bool? isTimeStamp;
  final LMChatUserViewData? member;
  final int? replyConversation;
  final LMChatConversationViewData? replyConversationObject;
  final List<LMChatReactionViewData>? conversationReactions;
  final LMChatPollInfoViewData? poll;

  LMChatConversationViewData._({
    this.allowAddOption,
    required this.answer,
    this.apiVersion,
    this.attachmentCount,
    this.attachments,
    this.attachmentsUploaded,
    this.chatroomId,
    this.communityId,
    required this.createdAt,
    this.createdEpoch,
    this.date,
    this.deletedByUserId,
    this.deviceId,
    this.endTime,
    this.expiryTime,
    this.hasFiles,
    this.hasReactions,
    this.header,
    required this.id,
    this.internalLink,
    this.isAnonymous,
    this.isEdited,
    this.lastUpdated,
    this.location,
    this.locationLat,
    this.locationLong,
    this.multipleSelectNo,
    this.multipleSelectState,
    required this.ogTags,
    this.onlineLinkEnableBefore,
    this.pollAnswerText,
    this.pollType,
    this.replyChatroomId,
    this.replyId,
    this.startTime,
    this.state,
    this.temporaryId,
    this.userId,
    this.memberId,
    this.toShowResults,
    this.pollTypeText,
    this.submitTypeText,
    this.isTimeStamp,
    this.member,
    this.replyConversation,
    this.replyConversationObject,
    this.conversationReactions,
    this.poll,
  });
}

class LMChatConversationViewDataBuilder {
  bool? _allowAddOption;
  String? _answer ;
  int? _apiVersion;
  int? _attachmentCount;
  List<LMChatAttachmentViewData>? _attachments;
  bool? _attachmentsUploaded;
  int? _chatroomId;
  int? _communityId;
  String? _createdAt;
  int? _createdEpoch;
  String? _date;
  int? _deletedByUserId;
  String? _deviceId;
  int? _endTime;
  int? _expiryTime;
  bool? _hasFiles;
  bool? _hasReactions;
  String? _header;
  int? _id;
  String? _internalLink;
  bool? _isAnonymous;
  bool? _isEdited;
  int? _lastUpdated;
  String? _location;
  String? _locationLat;
  String? _locationLong;
  int? _multipleSelectNo;
  int? _multipleSelectState;
  dynamic _ogTags;
  int? _onlineLinkEnableBefore;
  String? _pollAnswerText;
  int? _pollType;
  int? _replyChatroomId;
  int? _replyId;
  int? _startTime;
  int? _state;
  String? _temporaryId;
  int? _userId;
  int? _memberId;
  bool? _toShowResults;
  String? _pollTypeText;
  String? _submitTypeText;
  bool? _isTimeStamp;
  LMChatUserViewData? _member;
  int? _replyConversation;
  LMChatConversationViewData? _replyConversationObject;
  List<LMChatReactionViewData>? _conversationReactions;
  LMChatPollInfoViewData? _poll;

  void allowAddOption(bool? allowAddOption) {
    _allowAddOption = allowAddOption;
  }
  void answer(String answer) {
    _answer = answer;
  }
  void apiVersion(int? apiVersion) {
    _apiVersion = apiVersion;
  }
  void attachmentCount(int? attachmentCount) {
    _attachmentCount = attachmentCount;
  }
  void attachments(List<LMChatAttachmentViewData>? attachments) {
    _attachments = attachments;
  }
  void attachmentsUploaded(bool? attachmentsUploaded) {
    _attachmentsUploaded = attachmentsUploaded;
  }
  void chatroomId(int? chatroomId) {
    _chatroomId = chatroomId;
  }
  void communityId(int? communityId) {
    _communityId = communityId;
  }

  void createdAt(String? createdAt) {
    _createdAt = createdAt;
  }

  void createdEpoch(int? createdEpoch) {
    _createdEpoch = createdEpoch;
  }

  void date(String? date) {
    _date = date;
  }

  void deletedByUserId(int? deletedByUserId) {
    _deletedByUserId = deletedByUserId;
  }

  void deviceId(String? deviceId) {
    _deviceId = deviceId;
  }

  void endTime(int? endTime) {
    _endTime = endTime;
  }

  void expiryTime(int? expiryTime) {
    _expiryTime = expiryTime;
  }

  void hasFiles(bool? hasFiles) {
    _hasFiles = hasFiles;
  }

  void hasReactions(bool? hasReactions) {
    _hasReactions = hasReactions;
  }

  void header(String? header) {
    _header = header;
  }

  void id(int? id) {
    _id = id;
  } 

  void internalLink(String? internalLink) {
    _internalLink = internalLink;
  }

  void isAnonymous(bool? isAnonymous) {
    _isAnonymous = isAnonymous;
  }

  void isEdited(bool? isEdited) {
    _isEdited = isEdited;
  }

  void lastUpdated(int? lastUpdated) {
    _lastUpdated = lastUpdated;
  }

  void location(String? location) {
    _location = location;
  }

  void locationLat(String? locationLat) {
    _locationLat = locationLat;
  }

  void locationLong(String? locationLong) {
    _locationLong = locationLong;
  }

  void multipleSelectNo(int? multipleSelectNo) {
    _multipleSelectNo = multipleSelectNo;
  }

  void multipleSelectState(int? multipleSelectState) {
    _multipleSelectState = multipleSelectState;
  }

  void ogTags(dynamic ogTags) {
    _ogTags = ogTags;
  }

  void onlineLinkEnableBefore(int? onlineLinkEnableBefore) {
    _onlineLinkEnableBefore = onlineLinkEnableBefore;
  }

  void pollAnswerText(String? pollAnswerText) {
    _pollAnswerText = pollAnswerText;
  }

  void pollType(int? pollType) {
    _pollType = pollType;
  }

  void replyChatroomId(int? replyChatroomId) {
    _replyChatroomId = replyChatroomId;
  }

  void replyId(int? replyId) {
    _replyId = replyId;
  }

  void startTime(int? startTime) {
    _startTime = startTime;
  }

  void state(int? state) {
    _state = state;
  }

  void temporaryId(String? temporaryId) {
    _temporaryId = temporaryId;
  }

  void userId(int? userId) {
    _userId = userId;
  }

  void memberId(int? memberId) {
    _memberId = memberId;
  }

  void toShowResults(bool? toShowResults) {
    _toShowResults = toShowResults;
  }

  void pollTypeText(String? pollTypeText) {
    _pollTypeText = pollTypeText;
  }

  void submitTypeText(String? submitTypeText) {
    _submitTypeText = submitTypeText;
  }

  void isTimeStamp(bool? isTimeStamp) {
    _isTimeStamp = isTimeStamp;
  }

  void member(LMChatUserViewData? member) {
    _member = member;
  }

  void replyConversation(int? replyConversation) {
    _replyConversation = replyConversation;
  }

  void replyConversationObject(LMChatConversationViewData? replyConversationObject) {
    _replyConversationObject = replyConversationObject;
  }

  void conversationReactions(List<LMChatReactionViewData>? conversationReactions) {
    _conversationReactions = conversationReactions;
  }

  void poll(LMChatPollInfoViewData? poll) {
    _poll = poll;
  }

  LMChatConversationViewData build() {
    return LMChatConversationViewData._(
      allowAddOption: _allowAddOption,
      answer: _answer!,
      apiVersion: _apiVersion,
      attachmentCount: _attachmentCount,
      attachments: _attachments,
      attachmentsUploaded: _attachmentsUploaded,
      chatroomId: _chatroomId,
      communityId: _communityId,
      createdAt: _createdAt!,
      createdEpoch: _createdEpoch,
      date: _date,
      deletedByUserId: _deletedByUserId,
      deviceId: _deviceId,
      endTime: _endTime,
      expiryTime: _expiryTime,
      hasFiles: _hasFiles,
      hasReactions: _hasReactions,
      header: _header,
      id: _id!,
      internalLink: _internalLink,
      isAnonymous: _isAnonymous,
      isEdited: _isEdited,
      lastUpdated: _lastUpdated,
      location: _location,
      locationLat: _locationLat,
      locationLong: _locationLong,
      multipleSelectNo: _multipleSelectNo,
      multipleSelectState: _multipleSelectState,
      ogTags: _ogTags,
      onlineLinkEnableBefore: _onlineLinkEnableBefore,
      pollAnswerText: _pollAnswerText,
      pollType: _pollType,
      replyChatroomId: _replyChatroomId,
      replyId: _replyId,
      startTime: _startTime,
      state: _state,
      temporaryId: _temporaryId,
      userId: _userId,
      memberId: _memberId,
      toShowResults: _toShowResults,
      pollTypeText: _pollTypeText,
      submitTypeText: _submitTypeText,
      isTimeStamp: _isTimeStamp,
      member: _member,
      replyConversation: _replyConversation,
      replyConversationObject: _replyConversationObject,
      conversationReactions: _conversationReactions,
      poll: _poll,
    );
  }


}
