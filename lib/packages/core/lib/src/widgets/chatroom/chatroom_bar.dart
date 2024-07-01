import 'dart:async';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:image_picker/image_picker.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/blocs.dart';
import 'package:likeminds_chat_flutter_core/src/blocs/observer.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/og_tag/og_tag_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/core/core.dart';
import 'package:likeminds_chat_flutter_core/src/utils/analytics/analytics.dart';
import 'package:likeminds_chat_flutter_core/src/utils/member_rights/member_rights.dart';
import 'package:likeminds_chat_flutter_core/src/utils/preferences/preferences.dart';
import 'package:likeminds_chat_flutter_core/src/utils/tagging/tagging_textfield_ta.dart';
import 'package:likeminds_chat_flutter_core/src/utils/utils.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:overlay_support/overlay_support.dart';

class LMChatroomBar extends StatefulWidget {
  final ChatRoom chatroom;
  final Conversation? replyToConversation;
  final List<LMChatMedia>? replyConversationAttachments;
  final Conversation? editConversation;
  final Map<int, User?>? userMeta;
  final VoidCallback scrollToBottom;

  const LMChatroomBar({
    super.key,
    required this.chatroom,
    this.replyToConversation,
    this.replyConversationAttachments,
    this.editConversation,
    required this.scrollToBottom,
    this.userMeta,
  });

  @override
  State<LMChatroomBar> createState() => _LMChatroomBarState();
}

class _LMChatroomBarState extends State<LMChatroomBar> {
  LMChatConversationActionBloc? chatActionBloc;
  LMChatConversationBloc? conversationBloc;
  ImagePicker? imagePicker;
  FilePicker? filePicker;
  Conversation? replyToConversation;
  List<LMChatMedia>? replyConversationAttachments;
  Conversation? editConversation;
  Map<int, User?>? userMeta;
  late CustomPopupMenuController _popupMenuController;
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;
  User? currentUser = LMChatLocalPreference.instance.getUser();
  MemberStateResponse? getMemberState =
      LMChatLocalPreference.instance.getMemberRights();

  List<LMChatTagViewData> tags = [];
  String? result;

  ValueNotifier<bool> rebuildLinkPreview = ValueNotifier(false);
  String previewLink = '';
  LMChatMediaModel? linkModel;
  bool showLinkPreview =
      true; // if set to false link preview should not be displayed
  bool isActiveLink = true;
  Timer? _debounce;

  @override
  void initState() {
    Bloc.observer = LMChatBlocObserver();
    chatActionBloc = LMChatConversationActionBloc.instance;
    conversationBloc = LMChatConversationBloc.instance;
    _popupMenuController = CustomPopupMenuController();
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
    imagePicker = ImagePicker();
    filePicker = FilePicker.platform;
    super.initState();
  }

  String getText() {
    if (_textEditingController.text.isNotEmpty) {
      return _textEditingController.text;
    } else {
      return "";
    }
  }

  @override
  void dispose() {
    _popupMenuController.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();
    replyToConversation = null;
    _debounce?.cancel();
    super.dispose();
  }

  void _onTextChanged(String message) {
    // if (!showLinkPreview) return;
    isActiveLink = true;
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      handleTextLinks(message);
    });
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
          mediaType: LMMediaType.link,
          link: previewLink,
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

  bool checkIfAnnouncementChannel() {
    if (getMemberState!.member!.state != 1 && widget.chatroom.type == 7) {
      return false;
    } else if (!LMChatMemberRightUtil.checkRespondRights(getMemberState)) {
      return false;
    } else {
      return true;
    }
  }

  String getChatBarHintText() {
    if (getMemberState!.member!.state != 1 && widget.chatroom.type == 7) {
      return 'Only Community Managers can respond here';
    } else if (!LMChatMemberRightUtil.checkRespondRights(getMemberState)) {
      return 'The community managers have restricted you from responding here';
    } else {
      return "Type something...";
    }
  }

  void setupEditText() {
    editConversation = widget.editConversation;
    String? convertedMsgText =
        LMChatTaggingHelper.convertRouteToTag(editConversation?.answer);
    if (widget.editConversation == null) {
      return;
    }
    _textEditingController.value =
        TextEditingValue(text: convertedMsgText ?? '');
    _textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textEditingController.text.length));
    tags = LMChatTaggingHelper.addUserTagsIfMatched(
        editConversation?.answer ?? '');
    if (editConversation != null) {
      _focusNode.requestFocus();
    }
  }

  void setupReplyText() {
    replyToConversation = widget.replyToConversation;
    replyConversationAttachments = widget.replyConversationAttachments;
    if (replyToConversation != null) {
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    setupReplyText();
    setupEditText();
    userMeta = widget.userMeta;
    return Column(
      children: [
        ValueListenableBuilder(
            valueListenable: rebuildLinkPreview,
            builder: ((context, value, child) {
              return Container(color: Colors.red);
            })),
        Container(
          width: double.infinity,
          color: LMChatTheme.theme.container,
          padding: EdgeInsets.fromLTRB(
            4.w,
            2.h,
            4.w,
            2.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: checkIfAnnouncementChannel() ? 80.w : 90.w,
                constraints: BoxConstraints(
                  // minHeight: 4.h,
                  minHeight: 4.h,
                  maxHeight: 24.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
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
                    scrollPhysics: const AlwaysScrollableScrollPhysics(),
                    isSecret: widget.chatroom.isSecret ?? false,
                    chatroomId: widget.chatroom.id,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 14),
                    onTagSelected: (tag) {
                      tags.add(tag);
                      LMAnalytics.get().track(AnalyticsKeys.userTagsSomeone, {
                        'community_id': widget.chatroom.id,
                        'chatroom_name': widget.chatroom.title,
                        'tagged_user_id': tag.id,
                        'tagged_user_name': tag.name,
                      });
                    },
                    onChange: (t) {},
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabled: checkIfAnnouncementChannel(),
                      hintMaxLines: 1,
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 14),
                      hintText: getChatBarHintText(),
                    ),
                    focusNode: _focusNode,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              checkIfAnnouncementChannel()
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: GestureDetector(
                        onTap: checkIfAnnouncementChannel()
                            ? () {
                                if (_textEditingController.text.isEmpty) {
                                  toast("Text can't be empty");
                                } else {
                                  final string = _textEditingController.text;
                                  // debugPrint(userTags.length.toString());
                                  tags = LMChatTaggingHelper.matchTags(
                                      string, tags);
                                  // debugPrint(userTags.length.toString());
                                  result = LMChatTaggingHelper.encodeString(
                                      string, tags);
                                  result = result?.trim();
                                  // debugPrint(result! + userTags.length.toString());
                                  // return;
                                  if (editConversation != null) {
                                    linkModel = null;
                                    chatActionBloc!.add(
                                        LMChatEditConversationEvent(
                                            (EditConversationRequestBuilder()
                                                  ..conversationId(
                                                      editConversation!.id)
                                                  ..text(result!))
                                                .build(),
                                            replyConversation: editConversation!
                                                .replyConversationObject));
                                    linkModel = null;
                                    isActiveLink = false;
                                    rebuildLinkPreview.value =
                                        !rebuildLinkPreview.value;
                                    if (!showLinkPreview) {
                                      showLinkPreview = true;
                                    }
                                    widget.scrollToBottom();
                                  } else {
                                    // Fluttertoast.showToast(msg: "Send message");
                                    if (isActiveLink &&
                                        showLinkPreview &&
                                        linkModel != null) {
                                      conversationBloc!.add(
                                          LMChatPostMultiMediaConversationEvent(
                                              (PostConversationRequestBuilder()
                                                    ..chatroomId(
                                                        widget.chatroom.id)
                                                    ..temporaryId(DateTime.now()
                                                        .millisecondsSinceEpoch
                                                        .toString())
                                                    ..text(result!)
                                                    ..replyId(
                                                        replyToConversation?.id)
                                                    ..ogTags(linkModel!.ogTags!
                                                        .toOGTag())
                                                    ..shareLink(
                                                        linkModel!.link!))
                                                  .build(),
                                              [
                                            LMChatMedia(
                                                mediaType: LMChatMediaType.link,
                                                ogTags: linkModel!.ogTags
                                                    ?.toOGTag())
                                          ]));
                                      linkModel = null;
                                      isActiveLink = false;
                                      rebuildLinkPreview.value =
                                          !rebuildLinkPreview.value;
                                      if (!showLinkPreview) {
                                        showLinkPreview = true;
                                      }
                                      widget.scrollToBottom();
                                    } else {
                                      var requestBuilder =
                                          PostConversationRequestBuilder()
                                            ..chatroomId(widget.chatroom.id)
                                            ..text(result!)
                                            ..replyId(replyToConversation?.id)
                                            ..temporaryId(DateTime.now()
                                                .millisecondsSinceEpoch
                                                .toString());
                                      if (showLinkPreview &&
                                          previewLink.isNotEmpty) {
                                        requestBuilder.shareLink(previewLink);
                                      }
                                      conversationBloc!.add(
                                        LMChatPostConversationEvent(
                                          postConversationRequest:
                                              requestBuilder.build(),
                                          repliedTo: replyToConversation,
                                        ),
                                      );
                                    }
                                    linkModel = null;
                                    isActiveLink = false;
                                    rebuildLinkPreview.value =
                                        !rebuildLinkPreview.value;
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
                                          "replied_to_member_id":
                                              replyToConversation?.member?.id,
                                          "replied_to_member_state":
                                              replyToConversation
                                                  ?.member?.state,
                                          "replied_to_message_id":
                                              replyToConversation?.id,
                                        },
                                      );
                                    }
                                  }
                                  if (widget.chatroom.isGuest ?? false) {
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
                                    chatActionBloc!
                                        .add(LMChatReplyRemoveEvent());
                                  }
                                  editConversation = null;
                                  replyToConversation = null;
                                  FocusScope.of(context).unfocus();
                                }
                              }
                            : () {},
                        child: Container(
                          height: 10.w,
                          width: 10.w,
                          decoration: BoxDecoration(
                            color: checkIfAnnouncementChannel()
                                ? LMChatTheme.theme.primaryColor
                                : LMChatDefaultTheme.greyColor,
                            borderRadius: BorderRadius.circular(6.w),
                          ),
                          child: Center(
                            child: LMChatIcon(
                              type: LMChatIconType.icon,
                              icon: Icons.send,
                              style: LMChatIconStyle(
                                // backgroundColor: LMChatTheme.theme.primaryColor,
                                color: LMChatTheme.theme.onPrimary,
                                boxSize: 10.w,
                                size: 6.w,
                                boxBorderRadius: 45.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
