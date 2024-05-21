import 'package:flutter/foundation.dart';
import 'package:likeminds_chat_flutter_ui/packages/linkify/linkify.dart';
import 'package:likeminds_chat_flutter_ui/src/utils/helpers/tagging_helper.dart';

List<String> extractLinkFromString(String text) {
  RegExp exp = RegExp(LMChatTaggingHelper.linkRoute);
  Iterable<RegExpMatch> matches = exp.allMatches(text);
  List<String> links = [];
  for (var match in matches) {
    String link = text.substring(match.start, match.end);
    if (link.isNotEmpty && match.group(1) == null) {
      links.add(link);
    }
  }
  if (links.isNotEmpty) {
    return links;
  } else {
    return [];
  }
}

String getFirstValidLinkFromString(String text) {
  try {
    List<String> links = extractLinkFromString(text);
    List<String> validLinks = [];
    String validLink = '';
    if (links.isNotEmpty) {
      for (String link in links) {
        if (Uri.parse(link).isAbsolute) {
          validLinks.add(link);
        } else {
          link = "https://$link";
          if (Uri.parse(link).isAbsolute) {
            validLinks.add(link);
          }
        }
      }
    }
    if (validLinks.isNotEmpty) {
      validLink = validLinks.first;
    }
    return validLink;
  } on Exception catch (e, stacktrace) {
    debugPrint(e.toString());
    debugPrintStack(stackTrace: stacktrace);
    return '';
  }
}

LinkifyElement? extractLinkAndEmailFromString(String text) {
  final urls = linkify(text, linkifiers: [
    const EmailLinkifier(),
    const UrlLinkifier(),
  ]);
  if (urls.isNotEmpty) {
    if (urls.first is EmailElement || urls.first is UrlElement) {
      return urls.first;
    }
  }
  final links = linkify(text,
      options: const LinkifyOptions(
        looseUrl: true,
      ),
      linkifiers: [
        const EmailLinkifier(),
        const UrlLinkifier(),
      ]);
  if (links.isNotEmpty) {
    if (links.first is EmailElement || links.first is UrlElement) {
      return links.first;
    }
  }
  return null;
}
