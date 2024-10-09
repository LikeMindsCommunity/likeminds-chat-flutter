import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

part 'analytics_event.dart';
part 'analytics_state.dart';
part 'handler/fire_analytics_event_handler.dart';

/// {@template lm_analytics_bloc}
/// LMChatAnalyticsBloc handle all the analytics related actions
/// like fire analytics event.
/// LMChatAnalyticsEvent defines the events which are handled by this bloc.
/// LMChatAnalyticsState defines the states which are emitted by this bloc
/// {@endtemplate}
class LMChatAnalyticsBloc
    extends Bloc<LMChatAnalyticsEvent, LMChatAnalyticsState> {
  /// {@macro lm_analytics_bloc}
  static LMChatAnalyticsBloc? _lmAnalyticsBloc;

  /// {@macro lm_analytics_bloc}
  static LMChatAnalyticsBloc get instance =>
      _lmAnalyticsBloc ??= LMChatAnalyticsBloc._();

  LMChatAnalyticsBloc._() : super(LMChatAnalyticsInitiated()) {
    on<LMChatFireAnalyticsEvent>(fireAnalyticsEventHandler);
  }
}

class LMChatAnalyticsKeys {
  static const String chatroomCreationStarted = 'Chatroom creation started';
  static const String chatroomCreationCompleted = 'Chatroom creation completed';
  static const String chatroomRenamed = 'Chatroom renamed';
  static const String chatroomMuted = 'Chatroom muted';
  static const String chatroomDeleted = 'Chatroom deleted';
  static const String chatroomReported = 'Chatroom reported';
  static const String chatroomFollowed = 'Chatroom followed';
  static const String chatroomUnfollowed = 'Chatroom unfollowed';
  static const String chatroomResponded = 'Chatroom responded';
  static const String chatroomOpened = 'Chatroom opened';
  static const String viewChatroomParticipants = 'View Chatroom participants';
  static const String viewCommunity = 'View community';
  static const String chatroomCreationError = 'Chatroom creation error';
  static const String attachmentUploadedError = 'Attachment uploaded error';
  static const String messageSendingError = 'Message sending error';
  static const String followBeforeLogin = 'Follow before login';
  static const String autoFollowEnabled = 'Auto follow enabled';
  static const String attachmentsUploaded = 'Attachments uploaded';
  static const String imageViewed = 'Image viewed';
  static const String markChatroomActive = 'Mark chatroom active';
  static const String markChatroomInActive = 'Mark chatroom inactive';
  static const String chatroomSharingStarted = 'Chatroom sharing started';
  static const String userTagsSomeone = 'User tags someone';
  static const String groupTagged = 'Group tagged';
  static const String eventAttended = 'Event attended';
  static const String scrollUpToView = 'Scroll up to view';
  static const String chatroomCreated = 'Chatroom created';
  static const String participantsAdded = 'Participants added';
  static const String chatroomAccessRestricted = 'Chatroom access restricted';
  static const String videoPlayed = 'Video played';
  static const String audioPlayed = 'Audio played';
  static const String chatLinkClicked = 'Chat link clicked';
  static const String notificationPageOpened = 'Notification page opened';
  static const String notificationRemoved = 'Notification removed';
  static const String notificationMuted = 'Notification muted';
  static const String aboutSectionViewed = 'About section viewed';
  static const String pinnedChatroomsViewed = 'Pinned chatrooms viewed';
  static const String memberGroupAdded = 'Member group added';
  static const String chatroomLeft = 'Chatroom left';
  static const String secretChatroomInvite = 'Secret Chatroom invite';
  static const String communityTabClicked = 'Community Tab clicked';
  static const String groupDetailsScreen = 'Group details screen';
  static const String syncComplete = 'Sync Complete';
  static const String chatroomUnMuted = 'Chatroom unmuted';
  static const String voiceMessageRecorded = 'Voice message recorded';
  static const String voiceMessagePreviewed = 'Voice message previewed';
  static const String voiceMessageCancelled = 'Voice message cancelled';
  static const String voiceMessageSent = 'Voice message sent';
  static const String voiceMessagePlayed = 'Voice message played';
  static const String attachmentUploaded = 'Attachment uploaded';
  static const String messageSelected = 'Messages selected';
  static const String messageDeleted = 'Message deleted';
  static const String messageCopied = 'Message copied';
  static const String messageReply = 'Message reply';
  static const String messageReported = 'Message reported';
  static const String messageEdited = 'Messages edited';
  static const String emoticonTrayOpened = 'Emoticon Tray Opened';
  static const String reactionAdded = 'Reaction Added';
  static const String reactionListOpened = 'Reaction List Opened';
  static const String reactionRemoved = 'Reaction Removed';
}
