import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_chat_flutter_core/src/utils/media/media_handler.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/convertors.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/member_rights/member_rights.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/tagging/tagging_textfield_ta.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/chatroom/chatroom_bar_header.dart';

/// {@template lm_chatroom_bar}
/// A widget to display the chatroom bar.
/// It has a text field to type the message and send button.
/// {@endtemplate}
class LMChatroomBar extends StatefulWidget {
  /// [chatroom] is the chatroom for which the bar is to be displayed.
  final LMChatRoomViewData chatroom;

  /// [scrollToBottom] is the function to scroll to the bottom of the chat.
  final VoidCallback scrollToBottom;

  /// {@macro lm_chatroom_bar}
  const LMChatroomBar({
    super.key,
    required this.chatroom,
    required this.scrollToBottom,
  });

  @override
  State<LMChatroomBar> createState() => _LMChatroomBarState();
}

class _LMChatroomBarState extends State<LMChatroomBar> {
  LMChatConversationViewData? replyToConversation;
  List<LMChatMediaModel>? replyConversationAttachments;
  LMChatConversationViewData? editConversation;

  // Flutter and other dependecies needed
  final CustomPopupMenuController _popupMenuController =
      CustomPopupMenuController();
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // Instances of BLoCs required
  LMChatConversationActionBloc chatActionBloc =
      LMChatConversationActionBloc.instance;
  LMChatConversationBloc conversationBloc = LMChatConversationBloc.instance;

  // Instance of current user and member state
  final LMChatUserViewData currentUser =
      LMChatLocalPreference.instance.getUser().toUserViewData();
  final MemberStateResponse? getMemberState =
      LMChatLocalPreference.instance.getMemberRights();
  final LMChatThemeData _themeData = LMChatTheme.instance.themeData;
  final _screenBuilder = LMChatCore.config.chatRoomConfig.builder;

  String? result;
  Timer? _debounce;
  String previewLink = '';
  bool isActiveLink = true;
  bool showLinkPreview = true;
  LMChatMediaModel? linkModel;
  LMChatRoomViewData? chatroom;
  List<LMChatTagViewData> tags = [];

  ValueNotifier<bool> rebuildLinkPreview = ValueNotifier(false);
  ValueNotifier<bool> rebuildChatBar = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    chatroom = widget.chatroom;
  }

  @override
  void dispose() {
    _popupMenuController.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LMChatConversationActionBloc,
        LMChatConversationActionState>(
      bloc: chatActionBloc,
      listener: (context, state) {
        if (state is LMChatEditConversationState) {
          editConversation = state.editConversation;
          _setupEditText();
        } else if (state is LMChatEditRemoveState) {
          editConversation = null;
          _setupEditText();
        } else if (state is LMChatReplyConversationState) {
          replyToConversation = state.conversation;
          _focusNode.requestFocus();
        } else if (state is LMChatReplyRemoveState) {
          replyToConversation = null;
          _focusNode.requestFocus();
        } else if (state is LMChatRefreshBarState) {
          chatroom = state.chatroom;
          rebuildChatBar.value = !rebuildChatBar.value;
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            ValueListenableBuilder(
              valueListenable: rebuildLinkPreview,
              builder: ((context, value, child) {
                return Container(color: Colors.red);
              }),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                left: 2.w,
                right: 2.w,
                top: 1.5.h,
                bottom: 1.5.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _isRespondingAllowed()
                      ? _defTextField(context)
                      : _defDisabledTextField(context),
                  if (_isRespondingAllowed())
                    _screenBuilder.sendButton(
                      context,
                      _textEditingController,
                      _onSend,
                      _defSendButton(context),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // Handler functions of the LMChatroomBar
  void _onSend() {
    if (_textEditingController.text.trim().isEmpty) {
      toast("Text can't be empty");
      return;
    } else {
      final string = _textEditingController.text;

      tags = LMChatTaggingHelper.matchTags(string, tags);

      result = LMChatTaggingHelper.encodeString(string, tags);
      result = result?.trim();

      if (editConversation != null) {
        linkModel = null;
        chatActionBloc.add(LMChatEditConversationEvent(
            (EditConversationRequestBuilder()
                  ..conversationId(editConversation!.id)
                  ..text(result!))
                .build(),
            replyConversation:
                editConversation!.replyConversationObject?.toConversation()));
        linkModel = null;
        isActiveLink = false;
        rebuildLinkPreview.value = !rebuildLinkPreview.value;
        if (!showLinkPreview) {
          showLinkPreview = true;
        }
        widget.scrollToBottom();
      } else {
        if (isActiveLink && showLinkPreview && linkModel != null) {
          conversationBloc.add(
            LMChatPostMultiMediaConversationEvent(
              (PostConversationRequestBuilder()
                    ..chatroomId(widget.chatroom.id)
                    ..temporaryId(
                        DateTime.now().millisecondsSinceEpoch.toString())
                    ..text(result!)
                    ..replyId(replyToConversation?.id)
                    ..ogTags(linkModel!.ogTags!.toOGTag())
                    ..shareLink(linkModel!.mediaUrl!))
                  .build(),
              [
                LMChatMediaModel(
                  mediaType: LMChatMediaType.link,
                  ogTags: linkModel!.ogTags,
                ),
              ],
            ),
          );
          linkModel = null;
          isActiveLink = false;
          rebuildLinkPreview.value = !rebuildLinkPreview.value;
          if (!showLinkPreview) {
            showLinkPreview = true;
          }
          widget.scrollToBottom();
        } else {
          bool isLinkPresent = false;
          if (showLinkPreview && previewLink.isNotEmpty) {
            isLinkPresent = true;
          }
          conversationBloc.add(
            LMChatPostConversationEvent(
              text: result ?? '',
              chatroomId: widget.chatroom.id,
              replyId: replyToConversation?.id,
              repliedTo: replyToConversation,
              shareLink: isLinkPresent ? previewLink : null,
            ),
          );
        }
        linkModel = null;
        isActiveLink = false;
        rebuildLinkPreview.value = !rebuildLinkPreview.value;
        if (!showLinkPreview) {
          showLinkPreview = true;
        }
        widget.scrollToBottom();
        if (replyToConversation != null) {
          LMAnalytics.get().track(
            AnalyticsKeys.messageReply,
            {
              "type": "text",
              "chatroom_id": widget.chatroom.id,
              "replied_to_member_id": replyToConversation?.member?.id,
              "replied_to_member_state": replyToConversation?.member?.state,
              "replied_to_message_id": replyToConversation?.id,
            },
          );
        }
      }
      if (widget.chatroom.isGuest ?? false) {
        toast("Chatroom joined");
        widget.chatroom.isGuest = false;
      }
      if (widget.chatroom.followStatus == false) {
        toast("Chatroom joined");
        widget.chatroom.isGuest = false;
      }
      _textEditingController.clear();
      tags = [];
      result = "";
      if (editConversation == null) {
        widget.scrollToBottom();
      }
      if (replyToConversation != null) {
        chatActionBloc.add(LMChatReplyRemoveEvent());
      }
      editConversation = null;
      replyToConversation = null;
    }
  }

  Future<void> handleTextLinks(String text) async {
    String link = LMChatTaggingHelper.getFirstValidLinkFromString(text);
    if (link.isNotEmpty) {
      previewLink = link;
      showLinkPreview = true;
      DecodeUrlRequest request =
          (DecodeUrlRequestBuilder()..url(previewLink)).build();
      LMResponse<DecodeUrlResponse> response =
          await LMChatCore.client.decodeUrl(request);
      if (response.success == true) {
        OgTags? responseTags = response.data!.ogTags;
        linkModel = LMChatMediaModel(
          mediaType: LMChatMediaType.link,
          mediaUrl: previewLink,
          ogTags: responseTags?.toLMChatOGTagViewData(),
        );
        LMAnalytics.get().track(
          AnalyticsKeys.attachmentsUploaded,
          {
            'link': previewLink,
          },
        );
        showLinkPreview = true;
        rebuildLinkPreview.value = !rebuildLinkPreview.value;
      } else {
        linkModel = null;
        if (isActiveLink) {
          rebuildLinkPreview.value = !rebuildLinkPreview.value;
        }
      }
    } else if (link.isEmpty) {
      showLinkPreview = false;
      linkModel = null;
      rebuildLinkPreview.value = !rebuildLinkPreview.value;
    }
  }

  bool _isRespondingAllowed() {
    if (getMemberState!.member!.state != 1 && widget.chatroom.type == 7) {
      return false;
    } else if (!LMChatMemberRightUtil.checkRespondRights(getMemberState)) {
      return false;
    } else if (chatroom!.chatRequestState == 2) {
      return false;
    } else {
      return true;
    }
  }

  String _getChatBarHintText() {
    if (getMemberState!.member!.state != 1 && widget.chatroom.type == 7) {
      return 'Only Community Managers can respond here';
    } else if (!LMChatMemberRightUtil.checkRespondRights(getMemberState)) {
      return 'The community managers have restricted you from responding here';
    } else if (chatroom!.chatRequestState == 2) {
      return "You can not respond to a rejected connection.";
    } else {
      return "Type your response";
    }
  }

  void _setupEditText() {
    String? convertedMsgText =
        LMChatTaggingHelper.convertRouteToTag(editConversation?.answer);
    if (editConversation == null) {
      return;
    }
    _textEditingController.value = TextEditingValue(
      text: convertedMsgText ?? '',
      selection: TextSelection.fromPosition(
        TextPosition(
          offset: _textEditingController.text.length - 1,
        ),
      ),
    );
    _focusNode.requestFocus();
    tags = LMChatTaggingHelper.addUserTagsIfMatched(
        editConversation?.answer ?? '');
  }

  Widget _defTextField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (editConversation != null)
          _screenBuilder.editTextTextFieldHeader(
            context,
            _textEditingController,
            _defEditConversationWidget(),
          ),
        if (replyToConversation != null)
          _screenBuilder.replyTextFieldHeader(
            context,
            _textEditingController,
            _defReplyConversationWidget(),
          ),
        Container(
          width: 80.w,
          constraints: BoxConstraints(
            minHeight: 5.2.h,
            maxHeight: 24.h,
          ),
          decoration: BoxDecoration(
            color: _themeData.container,
            borderRadius:
                editConversation == null && replyToConversation == null
                    ? BorderRadius.circular(24)
                    : const BorderRadius.vertical(
                        bottom: Radius.circular(24),
                      ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 2,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: _screenBuilder.chatroomTextField(
                    context,
                    _textEditingController,
                    _defInnerTextField(context),
                  ),
                ),
                const SizedBox(width: 2),
                _defAttachmentButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget functions for the default widgets of LMChatroomBar
  Widget _defDisabledTextField(BuildContext context) {
    return Container(
      width: 90.w,
      constraints: BoxConstraints(
        minHeight: 4.h,
        maxHeight: 24.h,
      ),
      decoration: BoxDecoration(
        color: _themeData.container,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kPaddingSmall,
          vertical: kPaddingSmall,
        ),
        child: LMChatTextField(
          isDown: false,
          enabled: false,
          isSecret: widget.chatroom.isSecret ?? false,
          chatroomId: widget.chatroom.id,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),
          onTagSelected: (tag) {},
          onChange: (value) {},
          controller: _textEditingController,
          decoration: InputDecoration(
            border: InputBorder.none,
            enabled: false,
            hintMaxLines: 1,
            hintStyle:
                Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),
            hintText: _getChatBarHintText(),
          ),
          focusNode: FocusNode(),
        ),
      ),
    );
  }

  LMChatTextField _defInnerTextField(BuildContext context) {
    return LMChatTextField(
      key: const ObjectKey('chatTextField'),
      isDown: false,
      enabled: false,
      scrollPhysics: const AlwaysScrollableScrollPhysics(),
      isSecret: widget.chatroom.isSecret ?? false,
      chatroomId: widget.chatroom.id,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14),
      onTagSelected: (tag) {
        tags.add(tag);
        LMAnalytics.get().track(AnalyticsKeys.userTagsSomeone, {
          'community_id': widget.chatroom.id,
          'chatroom_name': widget.chatroom.title,
          'tagged_user_id': tag.id,
          'tagged_user_name': tag.name,
        });
      },
      onChange: (value) {},
      controller: _textEditingController,
      decoration: InputDecoration(
        border: InputBorder.none,
        enabled: true,
        hintMaxLines: 1,
        hintStyle: const TextStyle(fontSize: 14),
        hintText: _getChatBarHintText(),
      ),
      focusNode: _focusNode,
    );
  }

  LMChatButton _defSendButton(BuildContext context) {
    return LMChatButton(
      onTap: _onSend,
      style: LMChatButtonStyle(
        backgroundColor: _themeData.primaryColor,
        borderRadius: 100,
        height: 6.h,
        width: 6.h,
      ),
      icon: LMChatIcon(
        type: LMChatIconType.icon,
        icon: Icons.send,
        style: LMChatIconStyle(
          size: 28,
          boxSize: 28,
          boxPadding: const EdgeInsets.only(left: 2),
          color: _themeData.container,
        ),
      ),
    );
  }

  Widget _defAttachmentButton() {
    return _isRespondingAllowed()
        ? CustomPopupMenu(
            controller: _popupMenuController,
            enablePassEvent: false,
            arrowColor: Colors.white,
            showArrow: false,
            menuBuilder: () => _defAttachmentMenu(),
            pressType: PressType.singleClick,
            child: _defAttachmentIcon(),
          )
        : const SizedBox();
  }

  Container _defAttachmentMenu() {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 100.w,
          color: LMChatTheme.theme.container,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 2.h,
              horizontal: 12.w,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          LMChatButton(
                            onTap: () async {
                              _popupMenuController.hideMenu();
                              final res = await LMChatMediaHandler.instance
                                  .pickSingleImage();
                              if (res.data != null) {
                                _navigateToForwarding();
                              }
                            },
                            icon: LMChatIcon(
                              type: LMChatIconType.icon,
                              icon: Icons.camera_alt_outlined,
                              style: LMChatIconStyle(
                                color: LMChatTheme.theme.container,
                                size: 30,
                                boxSize: 48,
                                boxPadding: EdgeInsets.zero,
                              ),
                            ),
                            style: LMChatButtonStyle(
                              height: 48,
                              width: 48,
                              borderRadius: 24,
                              backgroundColor: LMChatTheme.theme.secondaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          LMChatText(
                            'Camera',
                            style: LMChatTextStyle(
                              textStyle: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          LMChatButton(
                            onTap: () async {
                              _popupMenuController.hideMenu();
                              final res =
                                  await LMChatMediaHandler.instance.pickMedia();
                              if (res.data != null) {
                                _navigateToForwarding();
                              }
                            },
                            icon: LMChatIcon(
                              type: LMChatIconType.icon,
                              icon: Icons.photo_outlined,
                              style: LMChatIconStyle(
                                color: LMChatTheme.theme.container,
                                size: 30,
                                boxSize: 48,
                                boxPadding: EdgeInsets.zero,
                              ),
                            ),
                            style: LMChatButtonStyle(
                              height: 48,
                              width: 48,
                              borderRadius: 24,
                              backgroundColor: LMChatTheme.theme.secondaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          LMChatText(
                            'Gallery',
                            style: LMChatTextStyle(
                              textStyle: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          LMChatButton(
                            onTap: () async {
                              _popupMenuController.hideMenu();
                              final res = await LMChatMediaHandler.instance
                                  .pickDocuments();
                              if (res.data != null) {
                                _navigateToForwarding();
                              }
                            },
                            icon: LMChatIcon(
                              type: LMChatIconType.icon,
                              icon: Icons.insert_drive_file_outlined,
                              style: LMChatIconStyle(
                                color: LMChatTheme.theme.container,
                                size: 30,
                                boxSize: 48,
                                boxPadding: EdgeInsets.zero,
                              ),
                            ),
                            style: LMChatButtonStyle(
                              height: 48,
                              width: 48,
                              borderRadius: 24,
                              backgroundColor: LMChatTheme.theme.secondaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          LMChatText(
                            'Documents',
                            style: LMChatTextStyle(
                              textStyle: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          LMChatButton(
                            onTap: () async {
                              _popupMenuController.hideMenu();
                              final res = await LMChatMediaHandler.instance
                                  .pickGIF(context);
                              if (res.data != null) {
                                _navigateToForwarding();
                              }
                            },
                            icon: LMChatIcon(
                              type: LMChatIconType.icon,
                              icon: Icons.gif_box_outlined,
                              style: LMChatIconStyle(
                                color: LMChatTheme.theme.container,
                                size: 30,
                                boxSize: 48,
                                boxPadding: EdgeInsets.zero,
                              ),
                            ),
                            style: LMChatButtonStyle(
                              height: 48,
                              width: 48,
                              borderRadius: 24,
                              backgroundColor: LMChatTheme.theme.secondaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          LMChatText(
                            'GIF',
                            style: LMChatTextStyle(
                              textStyle: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToForwarding() async {
    _popupMenuController.hideMenu();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LMChatMediaForwardingScreen(
          chatroomId: widget.chatroom.id,
          replyConversation: replyToConversation,
        ),
      ),
    );

    // Clear replying or editing state after returning from the forwarding screen
    if (result == true) {
      if (replyToConversation != null) {
        chatActionBloc.add(LMChatReplyRemoveEvent());
      }
      if (editConversation != null) {
        chatActionBloc.add(LMChatEditRemoveEvent());
        _textEditingController.clear();
      }
    }
  }

  LMChatIcon _defAttachmentIcon() {
    return LMChatIcon(
      type: LMChatIconType.icon,
      icon: Icons.attachment,
      style: LMChatIconStyle(
        size: 24,
        boxSize: 48,
        boxPadding: const EdgeInsets.only(
          bottom: 6,
          left: 6,
        ),
        color: LMChatTheme.theme.inActiveColor,
      ),
    );
  }

  LMChatBarHeader _defReplyConversationWidget() {
    String userText = replyToConversation?.member?.name ?? '';
    if (replyToConversation?.memberId == currentUser.id) {
      userText = 'You';
    }
    return LMChatBarHeader(
      style: LMChatBarHeaderStyle.basic().copyWith(height: 8.h),
      titleText: userText,
      onCanceled: () {
        chatActionBloc.add(LMChatReplyRemoveEvent());
      },
      subtitle: LMChatText(
        LMChatTaggingHelper.convertRouteToTag(replyToConversation?.answer) ??
            "",
        style: LMChatTextStyle(
          textStyle: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  LMChatBarHeader _defEditConversationWidget() {
    return LMChatBarHeader(
      style: LMChatBarHeaderStyle.basic(),
      title: LMChatText(
        "Edit message",
        style: LMChatTextStyle(
          textStyle: Theme.of(context).textTheme.bodyLarge,
          maxLines: 1,
        ),
      ),
      onCanceled: () {
        chatActionBloc.add(LMChatEditRemoveEvent());
        _textEditingController.clear();
      },
      subtitle: LMChatText(
        LMChatTaggingHelper.convertRouteToTag(editConversation?.answer) ?? "",
        style: LMChatTextStyle(
          textStyle: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
