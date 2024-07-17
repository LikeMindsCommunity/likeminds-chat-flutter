import 'package:flutter/material.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/blocs.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/convertors.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/analytics/analytics.dart';
import 'package:likeminds_chat_flutter_core/src/utils/preferences/preferences.dart';
import 'package:likeminds_chat_flutter_core/src/views/participants/participants.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:overlay_support/overlay_support.dart';

class LMChatroomMenu extends StatefulWidget {
  final ChatRoom chatroom;
  final List<ChatroomAction> chatroomActions;
  final CustomPopupMenuController? controller;
  final LMChatCustomPopupMenuStyle? style;

  const LMChatroomMenu({
    Key? key,
    required this.controller,
    required this.chatroom,
    required this.chatroomActions,
    this.style,
  }) : super(key: key);
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

  LMChatHomeFeedBloc? homeBloc;
  @override
  void initState() {
    super.initState();
    homeBloc = LMChatHomeFeedBloc.instance;
    chatroomActions = widget.chatroomActions;
  }

  @override
  void didUpdateWidget(LMChatroomMenu old) {
    super.didUpdateWidget(old);
    homeBloc = LMChatHomeFeedBloc.instance;
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
        {
          widget.controller!.hideMenu();
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LMChatroomParticipantsPage(
              chatroomViewData: widget.chatroom.toChatRoomViewData(),
            );
          }));
          break;
        }
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
      default:
        unimplemented();
    }
    widget.controller!.hideMenu();
  }

  void unimplemented() {
    toast("Coming Soon");
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
        LMAnalytics.get().track(
          AnalyticsKeys.chatroomMuted,
          {
            'chatroom_name ': widget.chatroom.header,
          },
        );
      } else {
        LMAnalytics.get().track(
          AnalyticsKeys.chatroomUnMuted,
          {
            'chatroom_name ': widget.chatroom.header,
          },
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
      homeBloc!.add(LMChatRefreshHomeFeedEvent());
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
        LMAnalytics.get().track(
          AnalyticsKeys.chatroomLeft,
          {
            'chatroom_name ': widget.chatroom.header,
            'chatroom_id': widget.chatroom.id,
            'chatroom_type': 'normal',
          },
        );
        toast("Chatroom left");
        widget.controller!.hideMenu();
        homeBloc?.add(LMChatRefreshHomeFeedEvent());
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
        LMAnalytics.get().track(
          AnalyticsKeys.chatroomLeft,
          {
            'chatroom_name ': widget.chatroom.header,
            'chatroom_id': widget.chatroom.id,
            'chatroom_type': 'secret',
          },
        );
        toast("Chatroom left");
        widget.controller!.hideMenu();
        homeBloc?.add(LMChatRefreshHomeFeedEvent());
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
        title: const Text("Leave chatroom"),
        content: Text(
          widget.chatroom.isSecret != null && widget.chatroom.isSecret!
              ? 'Are you sure you want to leave this private group? To join back, you\'ll need to reach out to the admin'
              : 'Are you sure you want to leave this group?',
        ),
        // actionText: 'Confirm',
        // onActionPressed: onTap,
        actions: [
          LMChatText(
            'Cancel',
            onTap: () {
              Navigator.pop(context);
            },
            style: const LMChatTextStyle(
              maxLines: 1,
              textStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          LMChatText(
            'Confirm',
            onTap: () {
              leaveChatroom();
              Navigator.pop(context);
            },
            style: const LMChatTextStyle(
              maxLines: 1,
              textStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
