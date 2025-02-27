import 'package:flutter/material.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/blocs.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/convertors.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/media/audio_handler.dart';
import 'package:likeminds_chat_flutter_core/src/views/participants/participants.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';

class LMChatroomMenu extends StatefulWidget {
  final ChatRoom chatroom;
  final List<ChatroomAction> chatroomActions;
  final CustomPopupMenuController? controller;
  final LMChatCustomPopupMenuStyle? style;

  const LMChatroomMenu({
    super.key,
    required this.controller,
    required this.chatroom,
    required this.chatroomActions,
    this.style,
  });
  LMChatroomMenu copyWith({
    CustomPopupMenuController? controller,
    LMChatCustomPopupMenuStyle? style,
  }) {
    return LMChatroomMenu(
      controller: controller ?? this.controller,
      chatroom: chatroom,
      chatroomActions: chatroomActions,
      style: style ?? this.style,
    );
  }

  @override
  State<LMChatroomMenu> createState() => _ChatroomMenuState();
}

class _ChatroomMenuState extends State<LMChatroomMenu> {
  late List<ChatroomAction> chatroomActions;

  ValueNotifier<bool> rebuildChatroomMenu = ValueNotifier(false);

  final LMChatHomeFeedBloc homeBloc = LMChatHomeFeedBloc.instance;
  final LMChatConversationBloc conversationBloc =
      LMChatConversationBloc.instance;
  final LMChatConversationActionBloc conversationActionBloc =
      LMChatConversationActionBloc.instance;
  @override
  void initState() {
    super.initState();
    chatroomActions = widget.chatroomActions;
  }

  @override
  void didUpdateWidget(LMChatroomMenu old) {
    super.didUpdateWidget(old);
    chatroomActions = widget.chatroomActions;
  }

  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
      pressType: PressType.singleClick,
      showArrow: false,
      controller: widget.controller,
      enablePassEvent: false,
      menuBuilder: () => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: widget.style?.menuBoxWidth,
          height: widget.style?.menuBoxHeight,
          constraints: BoxConstraints(
            minWidth: 12.w,
            maxWidth: 60.w,
          ),
          decoration: widget.style?.menuBoxDecoration ??
              BoxDecoration(
                color: LMChatTheme.theme.container,
              ),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: chatroomActions.length,
            itemBuilder: (BuildContext context, int index) {
              return getListTile(chatroomActions[index]);
            },
          ),
        ),
      ),
      child: LMChatIcon(
        type: LMChatIconType.icon,
        icon: Icons.more_vert_rounded,
        style: LMChatIconStyle(
          size: 28,
          color: LMChatTheme.theme.onContainer,
        ),
      ),
    );
  }

  Widget? getListTile(ChatroomAction action) {
    return ListTile(
      style: ListTileStyle.list,
      onTap: () {
        performAction(action);
      },
      tileColor: Colors.transparent,
      title: AbsorbPointer(
        absorbing: true,
        child: LMChatText(
          action.title,
          style: LMChatTextStyle(
            maxLines: 1,
            padding: EdgeInsets.zero,
            textStyle: widget.style?.menuTextStyle ??
                TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: LMChatTheme.theme.onContainer,
                  overflow: TextOverflow.ellipsis,
                ),
          ),
        ),
      ),
    );
  }

  void performAction(ChatroomAction action) {
    switch (action.id) {
      case 2:
        viewParticipants();
        break;
      case 6:
        muteChatroom(action);
        break;
      case 8:
        muteChatroom(action);
        break;
      case 9:
        showLeaveDialog();
        break;
      case 15:
        showLeaveDialog();
        break;
      case 27:
        showBlockDialog(action);
        break;
      case 28:
        blockDM(action);
        break;
      default:
        unimplemented();
    }
    widget.controller!.hideMenu();
  }

  void unimplemented() {
    toast("Coming Soon");
  }

  void viewParticipants() {
    widget.controller!.hideMenu();
    LMChatAnalyticsBloc.instance.add(
      LMChatFireAnalyticsEvent(
        eventName: LMChatAnalyticsKeys.viewChatroomParticipants,
        eventProperties: {
          'chatroom_id': widget.chatroom.id,
          'community_id': LMChatLocalPreference.instance.getCommunityData()?.id,
          'source': 'chatroom_overflow_menu',
        },
      ),
    );
    LMChatCoreAudioHandler.instance.stopAudio();
    LMChatCoreAudioHandler.instance.stopRecording();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LMChatroomParticipantsPage(
        chatroomViewData: widget.chatroom.toChatRoomViewData(),
      );
    }));
  }

  void muteChatroom(ChatroomAction action) async {
    final response =
        await LMChatCore.client.muteChatroom((MuteChatroomRequestBuilder()
              ..chatroomId(widget.chatroom.id)
              ..value(!widget.chatroom.muteStatus!))
            .build());
    if (response.success) {
      // widget.controller.hideMenu();
      // rebuildChatroomMenu.value = !rebuildChatroomMenu.value;
      if (action.title.toLowerCase() == "mute notifications") {
        LMChatAnalyticsBloc.instance.add(
          LMChatFireAnalyticsEvent(
            eventName: LMChatAnalyticsKeys.chatroomMuted,
            eventProperties: {
              'chatroom_name ': widget.chatroom.header,
            },
          ),
        );
      } else {
        LMChatAnalyticsBloc.instance.add(
          LMChatFireAnalyticsEvent(
            eventName: LMChatAnalyticsKeys.chatroomUnMuted,
            eventProperties: {
              'chatroom_name ': widget.chatroom.header,
            },
          ),
        );
      }
      toast((action.title.toLowerCase() == "mute notifications")
          ? "Notifications muted for this space!"
          : "Notifications unmuted for this space!");
      chatroomActions = chatroomActions.map((element) {
        if (element.title.toLowerCase() == "mute notifications") {
          element.title = "Unmute notifications";
        } else if (element.title.toLowerCase() == "unmute notifications") {
          element.title = "Mute notifications";
        }

        return element;
      }).toList();
      rebuildChatroomMenu.value = !rebuildChatroomMenu.value;
      widget.controller!.hideMenu();
      homeBloc.add(LMChatRefreshHomeFeedEvent());
    } else {
      toast(response.errorMessage!);
    }
  }

  void leaveChatroom() async {
    final User user = LMChatLocalPreference.instance.getUser();

    if (!(widget.chatroom.isSecret ?? false)) {
      final response =
          await LMChatCore.client.followChatroom((FollowChatroomRequestBuilder()
                ..chatroomId(widget.chatroom.id)
                ..memberId(user.id)
                ..value(false))
              .build());
      if (response.success) {
        widget.chatroom.isGuest = true;
        LMChatAnalyticsBloc.instance.add(
          LMChatFireAnalyticsEvent(
            eventName: LMChatAnalyticsKeys.chatroomUnfollowed,
            eventProperties: {
              'chatroom_name ': widget.chatroom.header,
              'chatroom_id': widget.chatroom.id,
              'chatroom_type': 'normal',
              'source': 'overflow_menu',
            },
          ),
        );
        toast("Chatroom left");
        widget.controller!.hideMenu();
        homeBloc.add(LMChatRefreshHomeFeedEvent());
        Navigator.pop(context);
      } else {
        toast(response.errorMessage!);
      }
    } else {
      final response = await LMChatCore.client
          .deleteParticipant((DeleteParticipantRequestBuilder()
                ..chatroomId(widget.chatroom.id)
                ..isSecret(true))
              .build());
      if (response.success) {
        widget.chatroom.isGuest = true;
        LMChatAnalyticsBloc.instance.add(
          LMChatFireAnalyticsEvent(
            eventName: LMChatAnalyticsKeys.chatroomLeft,
            eventProperties: {
              'chatroom_name ': widget.chatroom.header,
              'chatroom_id': widget.chatroom.id,
              'chatroom_type': 'secret',
            },
          ),
        );
        toast("Chatroom left");
        widget.controller!.hideMenu();
        homeBloc.add(LMChatRefreshHomeFeedEvent());
        Navigator.pop(context);
      } else {
        toast(response.errorMessage!);
      }
    }
  }

  void showLeaveDialog() {
    showDialog(
        context: context,
        builder: (context) => LMChatDialog(
              style: LMChatDialogStyle(
                backgroundColor: LMChatTheme.theme.container,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              title: LMChatText(
                "Leave Chatroom?",
                style: LMChatTextStyle(
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: LMChatTheme.theme.onContainer,
                  ),
                ),
              ),
              content: LMChatText(
                widget.chatroom.isSecret != null && widget.chatroom.isSecret!
                    ? 'Are you sure you want to leave this private group? To join back, you\'ll need to reach out to the admin'
                    : 'Are you sure you want to leave this group?',
                style: const LMChatTextStyle(),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 2.0),
                  child: LMChatText(
                    "CANCEL",
                    style: LMChatTextStyle(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: LMChatTheme.theme.onContainer,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: LMChatText("CONFIRM",
                      style: LMChatTextStyle(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: LMChatTheme.theme.primaryColor,
                        ),
                      ), onTap: () {
                    leaveChatroom();
                    Navigator.pop(context);
                  }),
                ),
              ],
            ));
  }

  void showBlockDialog(ChatroomAction action) {
    showDialog(
      context: context,
      builder: (context) => LMChatDialog(
        style: LMChatDialogStyle(
          backgroundColor: LMChatTheme.theme.container,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        title: LMChatText(
          "Block Direct Messaging?",
          style: LMChatTextStyle(
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: LMChatTheme.theme.onContainer,
            ),
          ),
        ),
        content: const LMChatText(
          'Are you sure you do not want to receive new messages from this user?',
          style: LMChatTextStyle(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: LMChatText(
              "CANCEL",
              style: LMChatTextStyle(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: LMChatTheme.theme.onContainer,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: LMChatText("CONFIRM",
                style: LMChatTextStyle(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: LMChatTheme.theme.primaryColor,
                  ),
                ), onTap: () {
              blockDM(action);
              Navigator.pop(context);
            }),
          ),
        ],
      ),
    );
  }

  void blockDM(ChatroomAction action) async {
    final request = (BlockMemberRequestBuilder()
          ..chatroomId(widget.chatroom.id)
          ..status(action.id == 27 ? 0 : 1))
        .build();
    final response = await LMChatCore.client.blockMember(request);
    if (response.success) {
      toast(action.id == 27 ? "Member blocked" : "Member unblocked");

      final conversation = response.data!.conversation!;

      conversationBloc.add(LMChatLocalConversationEvent(
        conversation: conversation.toConversationViewData(),
      ));

      conversationActionBloc.add(LMChatRefreshBarEvent(
        chatroom: widget.chatroom.toChatRoomViewData().copyWith(
              chatRequestState: action.id == 27 ? 2 : 1,
            ),
      ));

      chatroomActions = chatroomActions.map((element) {
        if (element.title.toLowerCase() == "block") {
          element.id = 28;
          element.title = "Unblock";
        } else if (element.title.toLowerCase() == "unblock") {
          element.id = 27;
          element.title = "Block";
        }

        return element;
      }).toList();
      rebuildChatroomMenu.value = !rebuildChatroomMenu.value;
      widget.controller!.hideMenu();
      // Navigator.pop(context);
    } else {
      toast(response.errorMessage!);
    }
  }
}
