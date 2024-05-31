import 'package:likeminds_chat_flutter_ui/src/models/models.dart';

class LMChatRoomViewData {
  final bool? access;
  final String? answerText;
  final int? answersCount;
  final int? attachmentCount;
  final List<LMChatAttachmentViewData> attachments;
  final bool? attachmentsUploaded;
  final int? attendingCount;
  final bool? attendingStatus;
  final int? audioCount;
  final List<dynamic>? audios;
  final bool? autoFollowDone;
  final String? cardCreationTime;
  final int? communityId;
  final String? communityName;
  final dynamic createdAt;
  final int? lastConversationId;
  final String? date;
  final String? chatroomImageUrl;
  final int? unseenCount;
  final int? dateEpoch;
  final int? dateTime;
  final int? duration;
  final bool? followStatus;
  final bool? hasEventRecording;
  final String header;
  final int id;
  final int? imageCount;
  final List<dynamic>? images;
  final bool? includeMembersLater;
  final bool? isEdited;
  final bool? isGuest;
  final bool? isPaid;
  final bool? isPending;
  final bool? isPrivate;
  final bool? isPrivateMember;
  final bool? isSecret;
  final bool? isTagged;
  final bool? isPinned;
  final LMChatRoomMemberViewData? member;
  final LMChatConversationViewData? topic;
  final bool? muteStatus;
  final int? onlineLinkEnableBefore;
  final dynamic onlineLinkType;
  final List<dynamic>? pdf;
  final int? pdfCount;
  final int? pollsCount;
  final List<dynamic>? reactions;
  final bool? secretChatroomLeft;
  final String? shareLink;
  final int? state;
  final String title;
  final int? type;
  final int? videoCount;
  final List<dynamic>? videos;
  final int? participantCount;
  final int? totalResponseCount;
  final bool? externalSeen;
  final bool? memberCanMessage;
  final int? chatRequestState;
  final LMChatRoomMemberViewData? chatRequestedBy;
  final int? chatRequestedById;
  final LMChatRoomMemberViewData? chatroomWithUser;
  final int? chatroomWithUserId;
  final int? userId;
  final List<LMChatRoomMemberViewData>? lastResponseMembers;

  LMChatRoomViewData._({
    required this.access,
    required this.answerText,
    required this.answersCount,
    required this.attachmentCount,
    required this.attachments,
    required this.attachmentsUploaded,
    required this.attendingCount,
    required this.attendingStatus,
    required this.audioCount,
    required this.audios,
    required this.autoFollowDone,
    required this.cardCreationTime,
    required this.communityId,
    required this.communityName,
    required this.createdAt,
    required this.lastConversationId,
    required this.date,
    required this.chatroomImageUrl,
    required this.unseenCount,
    required this.dateEpoch,
    required this.dateTime,
    required this.duration,
    required this.hasEventRecording,
    required this.header,
    required this.id,
    required this.imageCount,
    required this.images,
    required this.includeMembersLater,
    required this.isEdited,
    required this.isPaid,
    required this.isPending,
    required this.isPrivate,
    required this.isPrivateMember,
    required this.isSecret,
    required this.isTagged,
    required this.isPinned,
    required this.member,
    required this.topic,
    required this.muteStatus,
    required this.onlineLinkEnableBefore,
    required this.onlineLinkType,
    required this.pdf,
    required this.pdfCount,
    required this.pollsCount,
    required this.reactions,
    required this.secretChatroomLeft,
    required this.shareLink,
    required this.state,
    required this.title,
    required this.type,
    required this.videoCount,
    required this.videos,
    required this.participantCount,
    required this.totalResponseCount,
    required this.memberCanMessage,
    required this.chatRequestState,
    required this.chatRequestedBy,
    required this.chatRequestedById,
    required this.chatroomWithUser,
    required this.chatroomWithUserId,
    required this.userId,
    required this.lastResponseMembers,
    required this.externalSeen,
    required this.isGuest,
    required this.followStatus,
  });
}

class LMChatRoomViewDataBuilder {
  bool? _access;
  String? _answerText;
  int? _answersCount;
  int? _attachmentCount;
  List<LMChatAttachmentViewData> _attachments = [];
  bool? _attachmentsUploaded;
  int? _attendingCount;
  bool? _attendingStatus;
  int? _audioCount;
  List<dynamic>? _audios;
  bool? _autoFollowDone;
  String? _cardCreationTime;
  int? _communityId;
  String? _communityName;
  dynamic _createdAt;
  int? _lastConversationId;
  String? _date;
  String? _chatroomImageUrl;
  int? _unseenCount;
  int? _dateEpoch;
  int? _dateTime;
  int? _duration;
  bool? _followStatus;
  bool? _hasEventRecording;
  String _header = '';
  int _id = 0;
  int? _imageCount;
  List<dynamic>? _images;
  bool? _includeMembersLater;
  bool? _isEdited;
  bool? _isGuest;
  bool? _isPaid;
  bool? _isPending;
  bool? _isPrivate;
  bool? _isPrivateMember;
  bool? _isSecret;
  bool? _isTagged;
  bool? _isPinned;
  LMChatRoomMemberViewData? _member;
  LMChatConversationViewData? _topic;
  bool? _muteStatus;
  int? _onlineLinkEnableBefore;
  dynamic _onlineLinkType;
  List<dynamic>? _pdf;
  int? _pdfCount;
  int? _pollsCount;
  List<dynamic>? _reactions;
  bool? _secretChatroomLeft;
  String? _shareLink;
  int? _state;
  String _title = '';
  int? _type;
  int? _videoCount;
  List<dynamic>? _videos;
  int? _participantCount;
  int? _totalResponseCount;
  bool? _externalSeen;
  bool? _memberCanMessage;
  int? _chatRequestState;
  LMChatRoomMemberViewData? _chatRequestedBy;
  int? _chatRequestedById;
  LMChatRoomMemberViewData? _chatroomWithUser;
  int? _chatroomWithUserId;
  int? _userId;
  List<LMChatRoomMemberViewData>? _lastResponseMembers;

  void access(bool? access) {
    _access = access;
  }

  void answerText(String? answerText) {
    _answerText = answerText;
  }

  void answersCount(int? answersCount) {
    _answersCount = answersCount;
  }

  void attachmentCount(int? attachmentCount) {
    _attachmentCount = attachmentCount;
  }

  void attachment(List<LMChatAttachmentViewData> attachment) {
    _attachments = attachment;
  }

  void attachmentsUploaded(bool? attachmentsUploaded) {
    _attachmentsUploaded = attachmentsUploaded;
  }

  void attendingCount(int? attendingCount) {
    _attendingCount = attendingCount;
  }

  void attendingStatus(bool? attendingStatus) {
    _attendingStatus = attendingStatus;
  }

  void audioCount(int? audioCount) {
    _audioCount = audioCount;
  }

  void audio(List<dynamic>? audio) {
    _audios = audio;
  }

  void autoFollowDone(bool? autoFollowDone) {
    _autoFollowDone = autoFollowDone;
  }

  void cardCreationTime(String? cardCreationTime) {
    _cardCreationTime = cardCreationTime;
  }

  void communityId(int? communityId) {
    _communityId = communityId;
  }

  void communityName(String? communityName) {
    _communityName = communityName;
  }

  void createdAt(dynamic createdAt) {
    _createdAt = createdAt;
  }

  void lastConversationId(int? lastConversationId) {
    _lastConversationId = lastConversationId;
  }

  void date(String? date) {
    _date = date;
  }

  void chatroomImageUrl(String? chatroomImageUrl) {
    _chatroomImageUrl = chatroomImageUrl;
  }

  void unseenCount(int? unseenCount) {
    _unseenCount = unseenCount;
  }

  void dateEpoch(int? dateEpoch) {
    _dateEpoch = dateEpoch;
  }

  void dateTime(int? dateTime) {
    _dateTime = dateTime;
  }

  void duration(int? duration) {
    _duration = duration;
  }

  void followStatus(bool? followStatus) {
    _followStatus = followStatus;
  }

  void hasEventRecording(bool? hasEventRecording) {
    _hasEventRecording = hasEventRecording;
  }

  void header(String header) {
    _header = header;
  }

  void id(int id) {
    _id = id;
  }

  void imageCount(int? imageCount) {
    _imageCount = imageCount;
  }

  void image(List<dynamic>? images) {
    _images = images;
  }

  void includeMembersLater(bool? includeMembersLater) {
    _includeMembersLater = includeMembersLater;
  }

  void isEdited(bool? isEdited) {
    _isEdited = isEdited;
  }

  void isGuest(bool? isGuest) {
    _isGuest = isGuest;
  }

  void isPaid(bool? isPaid) {
    _isPaid = isPaid;
  }

  void isPending(bool? isPending) {
    _isPending = isPending;
  }

  void isPrivate(bool? isPrivate) {
    _isPrivate = isPrivate;
  }

  void isPrivateMember(bool? isPrivateMember) {
    _isPrivateMember = isPrivateMember;
  }

  void isSecret(bool? isSecret) {
    _isSecret = isSecret;
  }

  void isTagged(bool? isTagged) {
    _isTagged = isTagged;
  }

  void isPinned(bool? isPinned) {
    _isPinned = isPinned;
  }

  void member(LMChatRoomMemberViewData? member) {
    _member = member;
  }

  void topic(LMChatConversationViewData? topic) {
    _topic = topic;
  }

  void muteStatus(bool? muteStatus) {
    _muteStatus = muteStatus;
  }

  void onlineLinkEnableBefore(int? onlineLinkEnableBefore) {
    _onlineLinkEnableBefore = onlineLinkEnableBefore;
  }

  void onlineLinkType(dynamic onlineLinkType) {
    _onlineLinkType = onlineLinkType;
  }

  void pdf(List<dynamic> pdf) {
    _pdf = pdf;
  }

  void pdfCount(int? pdfCount) {
    _pdfCount = pdfCount;
  }

  void pollsCount(int? pollsCount) {
    _pollsCount = pollsCount;
  }

  void veaction(List<dynamic>? reactions) {
    _reactions = reactions;
  }

  void secretChatroomLeft(bool? secretChatroomLeft) {
    _secretChatroomLeft = secretChatroomLeft;
  }

  void shareLink(String? shareLink) {
    _shareLink = shareLink;
  }

  void state(int? state) {
    _state = state;
  }

  void title(String title) {
    _title = title;
  }

  void type(int? type) {
    _type = type;
  }

  void videoCount(int? videoCount) {
    _videoCount = videoCount;
  }

  void video(List<dynamic>? videos) {
    _videos = videos;
  }

  void participantCount(int? participantCount) {
    _participantCount = participantCount;
  }

  void totalResponseCount(int? totalResponseCount) {
    _totalResponseCount = totalResponseCount;
  }

  void externalSeen(bool? externalSeen) {
    _externalSeen = externalSeen;
  }

  void memberCanMessage(bool? memberCanMessage) {
    _memberCanMessage = memberCanMessage;
  }

  void chatRequestState(int? chatRequestState) {
    _chatRequestState = chatRequestState;
  }

  void chatRequestedBy(LMChatRoomMemberViewData? chatRequestedBy) {
    _chatRequestedBy = chatRequestedBy;
  }

  void chatRequestedById(int? chatRequestedById) {
    _chatRequestedById = chatRequestedById;
  }

  void chatroomWithUser(LMChatRoomMemberViewData? chatroomWithUser) {
    _chatroomWithUser = chatroomWithUser;
  }

  void chatroomWithUserId(int? chatroomWithUserId) {
    _chatroomWithUserId = chatroomWithUserId;
  }

  void userId(int? userId) {
    _userId = userId;
  }

  void lastResponseMember(List<LMChatRoomMemberViewData>? members) {
    _lastResponseMembers = members;
  }

  LMChatRoomViewData build() {
    return LMChatRoomViewData._(
      access: _access,
      answerText: _answerText,
      answersCount: _answersCount,
      attachmentCount: _attachmentCount,
      attachments: _attachments,
      attachmentsUploaded: _attachmentsUploaded,
      attendingCount: _attendingCount,
      attendingStatus: _attendingStatus,
      audioCount: _audioCount,
      audios: _audios,
      autoFollowDone: _autoFollowDone,
      cardCreationTime: _cardCreationTime,
      communityId: _communityId,
      communityName: _communityName,
      createdAt: _createdAt,
      lastConversationId: _lastConversationId,
      date: _date,
      chatroomImageUrl: _chatroomImageUrl,
      unseenCount: _unseenCount,
      dateEpoch: _dateEpoch,
      dateTime: _dateTime,
      duration: _duration,
      hasEventRecording: _hasEventRecording,
      header: _header,
      id: _id,
      imageCount: _imageCount,
      images: _images,
      includeMembersLater: _includeMembersLater,
      isEdited: _isEdited,
      isPaid: _isPaid,
      isPending: _isPending,
      isPrivate: _isPrivate,
      isPrivateMember: _isPrivateMember,
      isSecret: _isSecret,
      isTagged: _isTagged,
      isPinned: _isPinned,
      member: _member,
      topic: _topic,
      muteStatus: _muteStatus,
      onlineLinkEnableBefore: _onlineLinkEnableBefore,
      onlineLinkType: _onlineLinkType,
      pdf: _pdf,
      pdfCount: _pdfCount,
      pollsCount: _pollsCount,
      reactions: _reactions,
      secretChatroomLeft: _secretChatroomLeft,
      shareLink: _shareLink,
      state: _state,
      title: _title,
      type: _type,
      videoCount: _videoCount,
      videos: _videos,
      participantCount: _participantCount,
      totalResponseCount: _totalResponseCount,
      memberCanMessage: _memberCanMessage,
      chatRequestState: _chatRequestState,
      chatRequestedBy: _chatRequestedBy,
      chatRequestedById: _chatRequestedById,
      chatroomWithUser: _chatroomWithUser,
      chatroomWithUserId: _chatroomWithUserId,
      userId: _userId,
      lastResponseMembers: _lastResponseMembers,
      externalSeen: _externalSeen,
      isGuest: _isGuest,
      followStatus: _followStatus,
    );
  }
}
