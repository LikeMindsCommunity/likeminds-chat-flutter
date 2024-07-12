import 'package:flutter/material.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/blocs.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/widgets.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:overlay_support/overlay_support.dart';

///{@template lm_chat_explore_tile}
/// Core widget to represent an Explore chatroom tile
///
/// Uses [LMChatTile] internally, so can be styled with [LMChatTileStyle]
///
/// Requires a chatroom model [LMChatRoomViewData]
/// {@endtemplate}
class LMChatExploreTile extends StatefulWidget {
  /// Style class used to customise look and feel of widget
  final LMChatTileStyle? style;

  /// Chatroom view model required to render the widget
  final LMChatRoomViewData chatroom;

  /// Callback function to handle tap event
  final VoidCallback? onTap;

  /// Flag to absorb touch events
  final bool? absorbTouch;

  /// Widget to display on the left side of the tile
  final Widget? leading;

  /// Widget to display as title
  final Widget? title;

  /// Widget to display as subtitle
  final Widget? subtitle;

  /// Widget to display on the right side of the tile
  final Widget? trailing;

  ///{@macro lm_chat_explore_tile}
  const LMChatExploreTile({
    super.key,
    this.style,
    this.onTap,
    this.absorbTouch,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    required this.chatroom,
  });

  /// CopyWith method to update the widget with new values
  /// Returns a new instance of the widget with updated values
  LMChatExploreTile copyWith({
    LMChatTileStyle? style,
    VoidCallback? onTap,
    bool? absorbTouch,
    Widget? leading,
    Widget? title,
    Widget? subtitle,
    Widget? trailing,
    LMChatRoomViewData? chatroom,
  }) {
    return LMChatExploreTile(
      style: style ?? this.style,
      onTap: onTap ?? this.onTap,
      absorbTouch: absorbTouch ?? this.absorbTouch,
      leading: leading ?? this.leading,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      trailing: trailing ?? this.trailing,
      chatroom: chatroom ?? this.chatroom,
    );
  }

  @override
  State<LMChatExploreTile> createState() => _LMChatExploreTileState();
}

class _LMChatExploreTileState extends State<LMChatExploreTile> {
  late LMChatRoomViewData chatroom;
  final User user = LMChatLocalPreference.instance.getUser();
  ValueNotifier<bool> isJoinedNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    chatroom = widget.chatroom;
  }

  @override
  Widget build(BuildContext context) {
    return LMChatTile(
      onTap: widget.onTap,
      absorbTouch: widget.absorbTouch ?? false,
      style: widget.style ??
          LMChatTheme.theme.chatTileStyle.copyWith(
            gap: 6,
          ),
      leading: widget.leading ??
          LMChatProfilePicture(
            fallbackText: chatroom.header,
            overlay: chatroom.externalSeen != null && !chatroom.externalSeen!
                ? _defaultNewText()
                : const SizedBox.shrink(),
            imageUrl: chatroom.chatroomImageUrl,
            style: LMChatProfilePictureStyle.basic().copyWith(
              size: 56,
            ),
          ),
      title: widget.title ??
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LMChatText(
                      chatroom.header,
                      style: const LMChatTextStyle(
                        maxLines: 1,
                        textStyle: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    _defaultSpaceStats(),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _defaultJoinButton(),
            ],
          ),
      subtitle: widget.subtitle ??
          LMChatText(
            chatroom.title,
            // style: LMTheme.regular.copyWith(color: kGrey3Color),
            style: const LMChatTextStyle(
              textAlign: TextAlign.left,
              maxLines: 2,
              minLines: 1,
              textStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
      trailing: widget.trailing,
    );
  }

  Row _defaultSpaceStats() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LMChatIcon(
          type: LMChatIconType.icon,
          icon: Icons.people_outline,
          style: LMChatIconStyle(
            size: 20,
          ),
        ),
        const SizedBox(width: 4),
        LMChatText(
          chatroom.participantCount.toString(),
          style: const LMChatTextStyle(
            maxLines: 1,
            textStyle: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const LMChatIcon(
          type: LMChatIconType.icon,
          icon: Icons.chat_bubble_outline,
          style: LMChatIconStyle(
            size: 20,
          ),
        ),
        const SizedBox(width: 4),
        LMChatText(
          chatroom.totalResponseCount.toString(),
          style: const LMChatTextStyle(
            maxLines: 1,
            textStyle: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _defaultJoinButton() {
    return ValueListenableBuilder(
        valueListenable: isJoinedNotifier,
        builder: (context, _, __) {
          return LMChatJoinButton(
            chatroom: chatroom,
            onTap: () async {
              debugPrint("Chat tile tapped");
              _onTapJoinButton();
            },
          );
          // bool isJoined = chatroom.followStatus!;
          // return chatroom.isSecret != null && chatroom.isSecret!
          //     ? LMChatButton(
          //         onTap: () {},
          //         text: LMChatText(isJoined ? 'Joined' : 'Join'),
          //         icon: const LMChatIcon(
          //           type: LMChatIconType.icon,
          //           icon: Icons.notification_add_outlined,
          //         ),
          //       )
          //     : const SizedBox.shrink();
        });
  }

  Widget _defaultNewText() {
    return Positioned(
      bottom: 0,
      child: LMChatText(
        'NEW',
        style: LMChatTextStyle(
          padding: const EdgeInsets.symmetric(
            vertical: 2.0,
            horizontal: 2.0,
          ),
          backgroundColor: LMChatTheme.theme.secondaryColor,
          textStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: LMChatTheme.theme.onPrimary,
          ),
        ),
      ),
    );
  }

  void _onTapJoinButton() async {
    if (chatroom.followStatus == true) {
      LMResponse response;
      if (chatroom.isSecret == null || chatroom.isSecret! == false) {
        final request = (FollowChatroomRequestBuilder()
              ..chatroomId(chatroom.id)
              ..memberId(user.id)
              ..value(false))
            .build();
        response =
            await LMChatCore.instance.lmChatClient.followChatroom(request);
      } else {
        final request = (DeleteParticipantRequestBuilder()
              ..chatroomId(chatroom.id)
              ..memberId(user.userUniqueId!)
              ..isSecret(true))
            .build();
        response =
            await LMChatCore.instance.lmChatClient.deleteParticipant(request);
      }
      chatroom = chatroom.copyWith(followStatus: false);
      isJoinedNotifier.value = !isJoinedNotifier.value;
      if (!response.success) {
        chatroom = chatroom.copyWith(followStatus: true);
        isJoinedNotifier.value = !isJoinedNotifier.value;
        toast(response.errorMessage ?? 'An error occurred');
      } else {
        toast("Chatroom left");
        LMChatHomeFeedBloc.instance.add(LMChatRefreshHomeFeedEvent());
      }
    } else {
      final request = (FollowChatroomRequestBuilder()
            ..chatroomId(chatroom.id)
            ..memberId(user.id)
            ..value(true))
          .build();
      LMResponse response =
          await LMChatCore.instance.lmChatClient.followChatroom(request);
      chatroom = chatroom.copyWith(followStatus: true);
      isJoinedNotifier.value = !isJoinedNotifier.value;
      if (!response.success) {
        chatroom = chatroom.copyWith(followStatus: false);
        isJoinedNotifier.value = !isJoinedNotifier.value;
        toast(response.errorMessage ?? 'An error occurred');
      } else {
        toast("Chatroom joined");
        LMChatHomeFeedBloc.instance.add(LMChatRefreshHomeFeedEvent());
      }
    }
  }
}
