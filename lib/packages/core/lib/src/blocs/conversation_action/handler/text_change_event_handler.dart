part of '../conversation_action_bloc.dart';

_textChangeEventHandler(LMChatConversationTextChangeEvent event, emit) async {
  String text = event.text;
  String previousLink = event.previousLink;
  if (text.isNotEmpty) {
    final (ogTags, link) =
        await _extractOgTagFromText(text, previousLink, emit);
    debugPrint('ogTags: $ogTags');
    if (ogTags != null && link != null) {
      emit(LMChatLinkAttachedState(
        ogTags: ogTags,
        link: link,
      ));
    } else if (link != null && previousLink == link) {
      // if the link is the same as the previous link, do nothing
      return;
    }
  } else if (previousLink.isNotEmpty) {
    emit(LMChatLinkRemovedState());
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
      // if the link is the same as the previous link, do nothing
      return (null, previousLink);
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
  if(previousLink.isNotEmpty) {
    emit(LMChatLinkRemovedState());
  }

  return (null, null);
}
