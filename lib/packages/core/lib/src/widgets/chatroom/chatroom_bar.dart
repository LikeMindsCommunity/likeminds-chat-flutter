import 'dart:async';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/convertors.dart';
import 'package:likeminds_chat_flutter_core/src/utils/member_rights/member_rights.dart';
import 'package:likeminds_chat_flutter_core/src/utils/tagging/tagging_textfield_ta.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/chatroom/chatroom_bar_header.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:overlay_support/overlay_support.dart';

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
  final LMChatConversationActionBloc chatActionBloc =
      LMChatConversationActionBloc.instance;
  final LMChatConversationBloc conversationBloc =
      LMChatConversationBloc.instance;
  final FilePicker filePicker = FilePicker.platform;
  LMChatConversationViewData? replyToConversation;
  List<LMChatMedia>? replyConversationAttachments;
  LMChatConversationViewData? editConversation;
  final CustomPopupMenuController _popupMenuController =
      CustomPopupMenuController();
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LMChatUserViewData currentUser =
      LMChatLocalPreference.instance.getUser().toUserViewData();
  final MemberStateResponse? getMemberState =
      LMChatLocalPreference.instance.getMemberRights();

  List<LMChatTagViewData> tags = [];
  String? result;
  LMChatRoomViewData? chatroom;
  String _textFieldValue = '';
  String previewLink = '';
  LMChatMediaModel? mediaModel = LMChatMediaModel(
    mediaType: LMMediaType.link,
    ogTags: (LMChatOGTagsViewDataBuilder()
          ..title(
              "Yahoo | Mail, Weather, Search, Politics, News, Finance, Sports & Videos")
          ..description(
            "Latest news coverage, email, free stock quotes, live scores and video are just the beginning. Discover more every day at Yahoo!",
          )
          ..imageUrl(
              "https://s.yimg.com/cv/apiv2/social/images/yahoo_default_logo.png")
          ..url(''))
        .build(),
  );
  LMChatMediaModel? linkModel;
  // if set to false link preview should not be displayed
  bool showLinkPreview = true;
  // if a message contains a link, this should be set to true
  bool isActiveLink = false;
  // debounce timer for link preview
  Timer? _debounce;
  // flag to check if a message is sent before the link preview is fetched
  bool _isSentBeforeLinkFetched = false;

  final LMChatThemeData _themeData = LMChatTheme.instance.themeData;
  final _screenBuilder = LMChatCore.config.chatRoomConfig.builder;

  String getText() {
    if (_textEditingController.text.isNotEmpty) {
      return _textEditingController.text;
    } else {
      return "";
    }
  }

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

  void _onTextChanged(String message) {
    _textFieldValue = message;
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    if (!showLinkPreview ||
        replyToConversation != null ||
        editConversation != null) {
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      chatActionBloc.add(LMChatConversationTextChangeEvent(
        text: message,
        previousLink: previewLink,
      ));
    });
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
      _textEditingController.clear();
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
    _textFieldValue = convertedMsgText ?? '';
    _focusNode.requestFocus();
    tags = LMChatTaggingHelper.addUserTagsIfMatched(
        editConversation?.answer ?? '');
  }

  void _setupReplyText() {
    _textEditingController.value = TextEditingValue(
      text: _textFieldValue,
      selection: TextSelection.fromPosition(
        TextPosition(
          offset: _textEditingController.text.length - 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LMChatConversationActionBloc,
        LMChatConversationActionState>(
      bloc: chatActionBloc,
      listener: (context, state) {
        if (state is LMChatEditConversationState) {
          replyToConversation = null;
          editConversation = state.editConversation;
          _setupEditText();
        } else if (state is LMChatEditRemoveState) {
          editConversation = null;
          _setupEditText();
        } else if (state is LMChatReplyConversationState) {
          editConversation = null;
          _setupEditText();
          replyToConversation = state.conversation;
          _setupReplyText();
          _focusNode.requestFocus();
        } else if (state is LMChatReplyRemoveState) {
          replyToConversation = null;
          _focusNode.requestFocus();
        } else if (state is LMChatRefreshBarState) {
          chatroom = state.chatroom;
        } else if (state is LMChatLinkAttachedState) {
          // to prevent the link preview from being displayed if the message is sent before the link preview is fetched
          if (_isSentBeforeLinkFetched) {
            _isSentBeforeLinkFetched = false;
            return;
          }
          linkModel = LMChatMediaModel(
            mediaType: LMMediaType.link,
            ogTags: state.ogTags,
            link: state.link,
          );
          previewLink = state.link;
          isActiveLink = true;
        } else if (state is LMChatLinkRemovedState) {
          linkModel = null;
          previewLink = '';
          isActiveLink = false;
          showLinkPreview = !state.isPermanentlyRemoved;
        }
      },
      builder: (context, state) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            left: 2.w,
            right: 2.w,
            top: 1.5.h,
            bottom: 1.5.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
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
        );
      },
    );
  }

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
        if (isActiveLink &&
            replyToConversation == null &&
            editConversation == null &&
            !_isSentBeforeLinkFetched)
          _defLinkPreview(linkModel!.ogTags!),
        Container(
          width: 80.w,
          constraints: BoxConstraints(
            minHeight: 5.2.h,
            maxHeight: 24.h,
          ),
          decoration: BoxDecoration(
            color: _themeData.container,
            borderRadius: editConversation == null &&
                    replyToConversation == null &&
                    !isActiveLink
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
            child: _screenBuilder.chatroomTextField(
              context,
              _textEditingController,
              _defInnerTextField(context),
            ),
          ),
        ),
      ],
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
      onChange: _onTextChanged,
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
        height: 48,
        width: 48,
      ),
      icon: LMChatIcon(
        type: LMChatIconType.icon,
        icon: Icons.send,
        style: LMChatIconStyle(
          size: 24,
          boxSize: 24,
          boxPadding: const EdgeInsets.only(left: 2),
          color: _themeData.container,
        ),
      ),
    );
  }

  void _onSend() {
    if (_textEditingController.text.trim().isEmpty) {
      toast("Text can't be empty");
      return;
    } else {
      _isSentBeforeLinkFetched = true;
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
        if (!showLinkPreview) {
          showLinkPreview = true;
        }
        widget.scrollToBottom();
      } else {
        if (isActiveLink && linkModel != null) {
          conversationBloc.add(
            LMChatPostMultiMediaConversationEvent(
              (PostConversationRequestBuilder()
                    ..chatroomId(widget.chatroom.id)
                    ..temporaryId(
                        DateTime.now().millisecondsSinceEpoch.toString())
                    ..text(result!)
                    ..replyId(replyToConversation?.id)
                    ..ogTags(linkModel!.ogTags!.toOGTag())
                    ..shareLink(linkModel!.link!))
                  .build(),
              [
                LMChatMedia(
                  mediaType: LMChatMediaType.link,
                  ogTags: linkModel!.ogTags?.toOGTag(),
                ),
              ],
            ),
          );
          if (!showLinkPreview) {
            showLinkPreview = true;
          }
          widget.scrollToBottom();
          chatActionBloc.add(LMChatLinkPreviewRemovedEvent());
        } else {
          String? extractedLink;
          if (showLinkPreview) {
            extractedLink =
                LMChatTaggingHelper.getFirstValidLinkFromString(result!);
          }
          conversationBloc.add(
            LMChatPostConversationEvent(
              text: result ?? '',
              chatroomId: widget.chatroom.id,
              replyId: replyToConversation?.id,
              repliedTo: replyToConversation,
              shareLink: extractedLink,
            ),
          );
        }
        if (!showLinkPreview) {
          showLinkPreview = true;
        }
        widget.scrollToBottom();
        chatActionBloc.add(LMChatLinkPreviewRemovedEvent());
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

  LMChatBarHeader _defReplyConversationWidget() {
    String userText = replyToConversation?.member?.name ?? '';
    if (replyToConversation?.memberId == currentUser.id) {
      userText = 'You';
    }
    return LMChatBarHeader(
      style: LMChatBarHeaderStyle.basic(),
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

  Widget _defLinkPreview(LMChatOGTagsViewData ogTags) {
    return LMChatLinkPreviewBar(
      ogTags: ogTags,
      onCanceled: () {
        chatActionBloc.add(
          LMChatLinkPreviewRemovedEvent(
            isPermanentlyRemoved: true,
          ),
        );
      },
    );
  }
}
