// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:likeminds_chat_flutter_ui/src/models/models.dart';

/// `LMChatConversationViewData` is a model class that holds the data for the conversation view.
/// This class is used to display the conversation information in the chat screen.
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
  final LMChatPollMultiSelectState? multipleSelectState;
  final LMChatOGTagsViewData? ogTags;
  final int? onlineLinkEnableBefore;
  final String? pollAnswerText;
  final LMChatPollType? pollType;
  final int? replyChatroomId;
  final int? replyId;
  final int? startTime;
  final int? state;
  final String? temporaryId;
  final int? memberId;
  final bool? toShowResults;
  final String? pollTypeText;
  final String? submitTypeText;
  final bool? isTimeStamp;
  final LMChatUserViewData? member;
  final int? replyConversation;
  final LMChatConversationViewData? replyConversationObject;
  final List<LMChatReactionViewData>? conversationReactions;
  final List<LMChatPollOptionViewData>? poll;
  final bool? isPollSubmitted;
  LMChatConversationViewType? conversationViewType;
  final bool? noPollExpiry;
  final bool? allowVoteChange;
  final String? widgetId;
  final LMChatWidgetViewData? widget;
  final LMChatRoomViewData? chatRoomViewData;

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
    this.isPollSubmitted,
    this.conversationViewType,
    this.noPollExpiry,
    this.allowVoteChange,
    this.widgetId,
    this.widget,
    this.chatRoomViewData,
  });

  /// copyWith method is used to create a new instance of `LMChatConversationViewData` with the updated values.
  /// If the new values are not provided, the old values are used.
  LMChatConversationViewData copyWith({
    bool? allowAddOption,
    String? answer,
    int? apiVersion,
    int? attachmentCount,
    List<LMChatAttachmentViewData>? attachments,
    bool? attachmentsUploaded,
    int? chatroomId,
    int? communityId,
    String? createdAt,
    int? createdEpoch,
    String? date,
    int? deletedByUserId,
    String? deviceId,
    int? endTime,
    int? expiryTime,
    bool? hasFiles,
    bool? hasReactions,
    String? header,
    int? id,
    String? internalLink,
    bool? isAnonymous,
    bool? isEdited,
    int? lastUpdated,
    String? location,
    String? locationLat,
    String? locationLong,
    int? multipleSelectNo,
    LMChatPollMultiSelectState? multipleSelectState,
    dynamic ogTags,
    int? onlineLinkEnableBefore,
    String? pollAnswerText,
    LMChatPollType? pollType,
    int? replyChatroomId,
    int? replyId,
    int? startTime,
    int? state,
    String? temporaryId,
    int? memberId,
    bool? toShowResults,
    String? pollTypeText,
    String? submitTypeText,
    bool? isTimeStamp,
    LMChatUserViewData? member,
    int? replyConversation,
    LMChatConversationViewData? replyConversationObject,
    List<LMChatReactionViewData>? conversationReactions,
    List<LMChatPollOptionViewData>? poll,
    bool? isPollSubmitted,
    LMChatConversationViewType? conversationViewType,
    bool? noPollExpiry,
    bool? allowVoteChange,
    String? widgetId,
    LMChatWidgetViewData? widget,
    LMChatRoomViewData? chatRoomViewData,
  }) {
    return LMChatConversationViewData._(
      allowAddOption: allowAddOption ?? this.allowAddOption,
      answer: answer ?? this.answer,
      apiVersion: apiVersion ?? this.apiVersion,
      attachmentCount: attachmentCount ?? this.attachmentCount,
      attachments: attachments ?? this.attachments,
      attachmentsUploaded: attachmentsUploaded ?? this.attachmentsUploaded,
      chatroomId: chatroomId ?? this.chatroomId,
      communityId: communityId ?? this.communityId,
      createdAt: createdAt ?? this.createdAt,
      createdEpoch: createdEpoch ?? this.createdEpoch,
      date: date ?? this.date,
      deletedByUserId: deletedByUserId ?? this.deletedByUserId,
      deviceId: deviceId ?? this.deviceId,
      endTime: endTime ?? this.endTime,
      expiryTime: expiryTime ?? this.expiryTime,
      hasFiles: hasFiles ?? this.hasFiles,
      hasReactions: hasReactions ?? this.hasReactions,
      header: header ?? this.header,
      id: id ?? this.id,
      internalLink: internalLink ?? this.internalLink,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      isEdited: isEdited ?? this.isEdited,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      location: location ?? this.location,
      locationLat: locationLat ?? this.locationLat,
      locationLong: locationLong ?? this.locationLong,
      multipleSelectNo: multipleSelectNo ?? this.multipleSelectNo,
      multipleSelectState: multipleSelectState ?? this.multipleSelectState,
      ogTags: ogTags ?? this.ogTags,
      onlineLinkEnableBefore:
          onlineLinkEnableBefore ?? this.onlineLinkEnableBefore,
      pollAnswerText: pollAnswerText ?? this.pollAnswerText,
      pollType: pollType ?? this.pollType,
      replyChatroomId: replyChatroomId ?? this.replyChatroomId,
      replyId: replyId ?? this.replyId,
      startTime: startTime ?? this.startTime,
      state: state ?? this.state,
      temporaryId: temporaryId ?? this.temporaryId,
      memberId: memberId ?? this.memberId,
      toShowResults: toShowResults ?? this.toShowResults,
      pollTypeText: pollTypeText ?? this.pollTypeText,
      submitTypeText: submitTypeText ?? this.submitTypeText,
      isTimeStamp: isTimeStamp ?? this.isTimeStamp,
      member: member ?? this.member,
      replyConversation: replyConversation ?? this.replyConversation,
      replyConversationObject:
          replyConversationObject ?? this.replyConversationObject,
      conversationReactions:
          conversationReactions ?? this.conversationReactions,
      poll: poll ?? this.poll,
      isPollSubmitted: isPollSubmitted ?? this.isPollSubmitted,
      conversationViewType: conversationViewType ?? this.conversationViewType,
      noPollExpiry: noPollExpiry ?? this.noPollExpiry,
      allowVoteChange: allowVoteChange ?? this.allowVoteChange,
      widgetId: widgetId ?? this.widgetId,
      widget: widget ?? this.widget,
      chatRoomViewData: chatRoomViewData ?? this.chatRoomViewData,
    );
  }
}

/// `LMChatConversationViewDataBuilder` is a builder class used to create an instance of `LMChatConversationViewData`.
/// This class is used to create an instance of `LMChatConversationViewData` with the provided values.
class LMChatConversationViewDataBuilder {
  bool? _allowAddOption;
  String? _answer;
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
  LMChatPollMultiSelectState? _multipleSelectState;
  LMChatOGTagsViewData? _ogTags;
  int? _onlineLinkEnableBefore;
  String? _pollAnswerText;
  LMChatPollType? _pollType;
  int? _replyChatroomId;
  int? _replyId;
  int? _startTime;
  int? _state;
  String? _temporaryId;
  int? _memberId;
  bool? _toShowResults;
  String? _pollTypeText;
  String? _submitTypeText;
  bool? _isTimeStamp;
  LMChatUserViewData? _member;
  int? _replyConversation;
  LMChatConversationViewData? _replyConversationObject;
  List<LMChatReactionViewData>? _conversationReactions;
  List<LMChatPollOptionViewData>? _poll;
  bool? _isPollSubmitted;
  LMChatConversationViewType? _conversationViewType;
  bool? _noPollExpiry;
  bool? _allowVoteChange;
  String? _widgetId;
  LMChatWidgetViewData? _widget;
  LMChatRoomViewData? _chatRoomViewData;

  void widgetId(String? widgetId) {
    _widgetId = widgetId;
  }

  void widget(LMChatWidgetViewData? widget) {
    _widget = widget;
  }

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

  void multipleSelectState(LMChatPollMultiSelectState? multipleSelectState) {
    _multipleSelectState = multipleSelectState;
  }

  void ogTags(LMChatOGTagsViewData? ogTags) {
    _ogTags = ogTags;
  }

  void onlineLinkEnableBefore(int? onlineLinkEnableBefore) {
    _onlineLinkEnableBefore = onlineLinkEnableBefore;
  }

  void pollAnswerText(String? pollAnswerText) {
    _pollAnswerText = pollAnswerText;
  }

  void pollType(LMChatPollType? pollType) {
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

  void replyConversationObject(
      LMChatConversationViewData? replyConversationObject) {
    _replyConversationObject = replyConversationObject;
  }

  void conversationReactions(
      List<LMChatReactionViewData>? conversationReactions) {
    _conversationReactions = conversationReactions;
  }

  void poll(List<LMChatPollOptionViewData>? poll) {
    _poll = poll;
  }

  void isPollSubmitted(bool? isPollSubmitted) {
    _isPollSubmitted = isPollSubmitted;
  }

  void conversationViewType(LMChatConversationViewType? conversationViewType) {
    _conversationViewType = conversationViewType;
  }

  void noPollExpiry(bool? noPollExpiry) {
    _noPollExpiry = noPollExpiry;
  }

  void allowVoteChange(bool? allowVoteChange) {
    _allowVoteChange = allowVoteChange;
  }

  void chatRoomViewData(LMChatRoomViewData? chatRoomViewData) {
    _chatRoomViewData = chatRoomViewData;
  }

  /// Builds the `LMChatConversationViewData` object using the provided values.
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
      isPollSubmitted: _isPollSubmitted,
      conversationViewType: _conversationViewType,
      noPollExpiry: _noPollExpiry,
      allowVoteChange: _allowVoteChange,
      widgetId: _widgetId,
      widget: _widget,
      chatRoomViewData: _chatRoomViewData,
    );
  }
}

enum LMChatConversationViewType { top, bottom }
