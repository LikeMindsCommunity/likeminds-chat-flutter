import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/blocs.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/constants/assets.dart';
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
  final _screenBuilder = LMChatCore.config.exploreConfig.builder;
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
            overlay: chatroom.externalSeen != null &&
                    chatroom.externalSeen! == false
                ? _defaultNewText()
                : Positioned(
                    bottom: 0,
                    right: 0,
                    child:
                        chatroom.isPinned != null && chatroom.isPinned! == true
                            ? _screenBuilder.pinIconBuilder(
                                context,
                                _defaultPinnedIcon(),
                              )
                            : const SizedBox.shrink(),
                  ),
            imageUrl: chatroom.chatroomImageUrl,
            style: LMChatProfilePictureStyle.basic().copyWith(
              size: 56,
              textPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 9,
              ),
            ),
          ),
      title: widget.title ?? _defaulltExploreTitle(),
      subtitle: widget.subtitle ??
          _screenBuilder.subtitleBuilder(
            context,
            LMChatText(
              chatroom.title,
              style: LMChatTextStyle(
                textAlign: TextAlign.left,
                maxLines: 2,
                minLines: 1,
                textStyle: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: LMChatTheme.theme.onContainer,
                ),
              ),
            ),
          ),
    );
  }

  Row _defaulltExploreTitle() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  chatroom.isSecret ?? false
                      ? LMChatText(
                          chatroom.header,
                          style: LMChatTextStyle(
                            maxLines: 1,
                            textStyle: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: LMChatTheme.theme.onContainer,
                            ),
                          ),
                        )
                      : Expanded(
                          child: _screenBuilder.headerBuilder(
                            context,
                            LMChatText(
                              chatroom.header,
                              style: LMChatTextStyle(
                                maxLines: 1,
                                textStyle: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 16,
                                  color: LMChatTheme.theme.onContainer,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(width: 4),
                  if (chatroom.isSecret ?? false)
                    _screenBuilder.lockIconBuilder(
                      context,
                      LMChatIcon(
                        type: LMChatIconType.svg,
                        assetPath: secretLockIcon,
                        style: LMChatIconStyle(
                          size: 18,
                          color: LMChatTheme.theme.onContainer.withOpacity(0.8),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              _defaultSpaceStats(),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _defaultJoinButton(),
      ],
    );
  }

  LMChatIcon _defaultPinnedIcon() {
    return LMChatIcon(
      type: LMChatIconType.icon,
      icon: Icons.push_pin,
      style: LMChatIconStyle(
        size: 18,
        boxSize: 24,
        boxBorder: 2,
        boxPadding: const EdgeInsets.all(4),
        boxBorderRadius: 12,
        color: LMChatTheme.theme.onContainer,
        backgroundColor: LMChatTheme.theme.container,
      ),
    );
  }

  Row _defaultSpaceStats() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _screenBuilder.memberCountIconBuilder(
          context,
          LMChatIcon(
            type: LMChatIconType.icon,
            icon: Icons.people_outline,
            style: LMChatIconStyle(
              size: 20,
              color: LMChatTheme.theme.onContainer.withOpacity(0.6),
            ),
          ),
        ),
        const SizedBox(width: 4),
        _screenBuilder.memberCountBuilder(
          context,
          chatroom.participantCount ?? 0,
          LMChatText(
            chatroom.participantCount.toString(),
            style: LMChatTextStyle(
              maxLines: 1,
              textStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 14,
                color: LMChatTheme.theme.onContainer.withOpacity(0.6),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        _screenBuilder.totalResponseCountIconBuilder(
          context,
          LMChatIcon(
            type: LMChatIconType.icon,
            icon: CupertinoIcons.chat_bubble,
            style: LMChatIconStyle(
              size: 20,
              color: LMChatTheme.theme.onContainer.withOpacity(0.6),
            ),
          ),
        ),
        const SizedBox(width: 4),
        _screenBuilder.totalResponseCountBuilder(
          context,
          chatroom.totalResponseCount ?? 0,
          LMChatText(
            chatroom.totalResponseCount.toString(),
            style: LMChatTextStyle(
              maxLines: 1,
              textStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 14,
                color: LMChatTheme.theme.onContainer.withOpacity(0.6),
              ),
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
          backgroundColor: LMChatTheme.theme.errorColor,
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
      } else {
        final request = (DeleteParticipantRequestBuilder()
              ..chatroomId(chatroom.id)
              ..memberId(user.userUniqueId!)
              ..isSecret(true))
            .build();
        response =
            await LMChatCore.instance.lmChatClient.deleteParticipant(request);
        LMChatAnalyticsBloc.instance.add(
          LMChatFireAnalyticsEvent(
            eventName: LMChatAnalyticsKeys.chatroomLeft,
            eventProperties: {
              'chatroom_name ': widget.chatroom.header,
              'chatroom_id': widget.chatroom.id,
              'chatroom_type': 'normal',
              'source': 'overflow_menu',
            },
          ),
        );
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
        LMChatAnalyticsBloc.instance.add(
          LMChatFireAnalyticsEvent(
            eventName: LMChatAnalyticsKeys.chatroomFollowed,
            eventProperties: {
              'chatroom_name ': widget.chatroom.header,
              'chatroom_id': widget.chatroom.id,
              'chatroom_type': 'normal',
              'source': 'overflow_menu',
            },
          ),
        );
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
