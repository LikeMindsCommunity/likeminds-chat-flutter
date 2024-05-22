import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/blocs.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/analytics/analytics.dart';
import 'package:likeminds_chat_flutter_core/src/utils/preferences/preferences.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:overlay_support/overlay_support.dart';

class LMChatroomMenu extends StatefulWidget {
  final ChatRoom chatroom;
  final List<ChatroomAction> chatroomActions;

  const LMChatroomMenu({
    Key? key,
    required this.chatroom,
    required this.chatroomActions,
  }) : super(key: key);

  @override
  State<LMChatroomMenu> createState() => _ChatroomMenuState();
}

class _ChatroomMenuState extends State<LMChatroomMenu> {
  CustomPopupMenuController? _controller;
  late List<ChatroomAction> chatroomActions;

  ValueNotifier<bool> rebuildChatroomMenu = ValueNotifier(false);

  LMChatHomeBloc? homeBloc;
  @override
  void initState() {
    super.initState();
    chatroomActions = widget.chatroomActions;
    _controller = CustomPopupMenuController();
  }

  @override
  Widget build(BuildContext context) {
    homeBloc = LMChatHomeBloc.instance;
    return CustomPopupMenu(
      pressType: PressType.singleClick,
      showArrow: false,
      controller: _controller,
      enablePassEvent: false,
      menuBuilder: () => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          constraints: BoxConstraints(
            minWidth: 12.w,
            maxWidth: 50.w,
          ),
          color: LMChatTheme.theme.container,
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
            textStyle: TextStyle(
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
        // _controller.hideMenu();
        _controller!.hideMenu();
        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return ChatroomParticipantsPage(
        //     chatroom: widget.chatroom,
        //   );
        // }));
        break;
      case 6:
        muteChatroom(action);
        break;
      case 8:
        muteChatroom(action);
        break;
      case 9:
        leaveChatroom();
        break;
      case 15:
        leaveChatroom();
        break;
      default:
        unimplemented();
    }
    _controller!.hideMenu();
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
      // _controller.hideMenu();
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
          ? "Chatroom muted"
          : "Chatroom unmuted");
      chatroomActions = chatroomActions.map((element) {
        if (element.title.toLowerCase() == "mute notifications") {
          element.title = "Unmute notifications";
        } else if (element.title.toLowerCase() == "unmute notifications") {
          element.title = "Mute notifications";
        }

        return element;
      }).toList();
      rebuildChatroomMenu.value = !rebuildChatroomMenu.value;
      _controller!.hideMenu();
      homeBloc!.add(LMChatUpdateHomeEvent());
    } else {
      toast(response.errorMessage!);
    }
  }

  void leaveChatroom() async {
    final User user = LMChatPreferences.instance.getCurrentUser;
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
        _controller!.hideMenu();
        homeBloc?.add(LMChatUpdateHomeEvent());
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
        _controller!.hideMenu();
        homeBloc?.add(LMChatUpdateHomeEvent());
        Navigator.pop(context);
      } else {
        toast(response.errorMessage!);
      }
    }
    // final response =
    //     await LMChatCore.client.leaveChatroom(LeaveChatroomRequest(
    //   chatroomId: chatroom.id,
    // ));
    // if (response.success) {
    //   toast("Chatroom left");
    // } else {
    //   toast(response.errorMessage!);
    // }
  }
}
