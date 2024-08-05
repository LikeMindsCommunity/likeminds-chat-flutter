part of '../conversation_action_bloc.dart';

_textChangeEventHandler(LMChatConversationTextChangeEvent event, emit) async {
  String text = event.text;
  String previousLink = event.previousLink;
  if (text.isNotEmpty) {
    final (ogTags, link) =
        await _extractOgTagFromText(text, previousLink, emit);
    if (ogTags != null && link != null) {
      emit(LMChatLinkAttachedState(
        ogTags: ogTags,
        link: link,
      ));
    }
  }
}

Future<(LMChatOGTagsViewData?, String?)> _extractOgTagFromText(
  String text,
  String previousLink,
  emit,
) async {
  String link = LMChatTaggingHelper.getFirstValidLinkFromString(text);
  if (link.isNotEmpty) {
    if (previousLink == link) {
      return (null, null);
    }
    DecodeUrlRequest request = (DecodeUrlRequestBuilder()..url(link)).build();
    LMResponse<DecodeUrlResponse> response =
        await LMChatCore.client.decodeUrl(request);
    if (response.success == true) {
      OgTags? ogTags = response.data!.ogTags;
      LMAnalytics.get().track(
        AnalyticsKeys.attachmentsUploaded,
        {
          'link': link,
        },
      );
      return (ogTags?.toLMChatOGTagViewData(), link);
    }
  }
  // if no link is found, remove the previous link
  emit(LMChatLinkRemovedState());

  return (null, null);
}
