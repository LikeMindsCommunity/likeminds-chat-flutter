// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';
import 'package:likeminds_chat_flutter_ui/src/models/models.dart';

class LMChatTaggingHelper {
  LMChatTagViewData? userTag;
  static final RegExp tagRegExp = RegExp(r'@([^<>~]+)~');
  static RegExp routeRegExp =
      RegExp(r'<<([^<>]+)\|route://([^<>]+)\/([a-zA-Z0-9]+)>>');
  static const String linkRoute =
      r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+|(\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b)';

  /// Encodes the string with the user tags and returns the encoded string
  static String encodeString(String string, List<LMChatTagViewData> userTags) {
    final Iterable<RegExpMatch> matches = tagRegExp.allMatches(string);
    for (final match in matches) {
      final String tag = match.group(1)!;
      final LMChatTagViewData? tagData = userTags.firstWhereOrNull(
          (element) => (element.name == tag || element.name == '@$tag'));
      if (tagData != null) {
        if (tagData.tagType == LMTagType.groupTag) {
          string = string.replaceAll('@$tag~', tagData.tag!);
        } else {
          string = string.replaceAll('@$tag~',
              '<<${tagData.name}|route://user_profile/${tagData.sdkClientInfoViewData?.uuid ?? tagData.uuid}>>');
        }
      }
    }
    return string;
  }

  /// Decodes the string with the user tags and returns the decoded string
  static Map<String, String> decodeString(String string) {
    Map<String, String> result = {};
    final RegExp routeRegExp =
        RegExp(r'<<([^<>]+)\|route://(?:member|user_profile)/([^<>]+)>>');
    final Iterable<RegExpMatch> matches = routeRegExp.allMatches(string);
    for (final match in matches) {
      final String tag = match.group(1)!;
      final String id = match.group(2)!;
      string = string.replaceAll('<<$tag|route://member/$id>>', '@$tag');
      string = string.replaceAll('<<$tag|route://user_profile/$id>>', '@$tag');
      result.addAll({'@$tag': id});
    }
    return result;
  }

  /// Matches the tags in the string and returns the list of matched tags
  static List<LMChatTagViewData> matchTags(
      String text, List<LMChatTagViewData> items) {
    final List<LMChatTagViewData> tags = [];
    final Iterable<RegExpMatch> matches = tagRegExp.allMatches(text);
    for (final match in matches) {
      final String tag = match.group(1)!;
      final LMChatTagViewData? userTag = items.firstWhereOrNull((element) {
        return (element.name == tag || element.name == '@$tag');
      });
      if (userTag != null) {
        tags.add(userTag);
      }
    }
    return tags;
  }

  static void routeToProfile(String userId) {
    debugPrint(userId);
  }

  static String? convertRouteToTag(String? text, {bool withTilde = true}) {
    if (text == null) return null;
    Map<String, String> result = {};
    final RegExp routeRegExp = RegExp(
        r'<<([^<>]+)\|route://(?:member|user_profile|participants)/([^<>]+)>>');
    final Iterable<RegExpMatch> matches = routeRegExp.allMatches(text);

    for (final match in matches) {
      final String tag = match.group(1)!;
      final String id = match.group(2)!;
      text = text!.replaceAll(
          '<<$tag|route://member/$id>>', withTilde ? '@$tag~' : '@$tag');
      text = text.replaceAll(
          '<<$tag|route://user_profile/$id>>', withTilde ? '@$tag~' : '@$tag');
      text = text.replaceAll('<<@participants|route://participants>>', tag);
      result.addAll({'@$tag': id});
    }
    return text;
  }

  static Map<String, dynamic> convertRouteToTagAndUserMap(String text,
      {bool withTilde = true}) {
    final Iterable<RegExpMatch> matches = routeRegExp.allMatches(text);
    List<LMChatTagViewData> tags = [];
    for (final match in matches) {
      final String tag = match.group(1) ?? match.group(4)!;
      final String? mid = match.group(2);
      final String? id = match.group(3);
      if (id != null) {
        text = text.replaceAll(
            '<<$tag|route://$mid/$id>>', withTilde ? '@$tag~' : '@$tag');
      } else {
        text = text.replaceAll('<<@participants|route://participants>>', tag);
      }
      tags.add(
        (LMChatTagViewDataBuilder()
              ..name(tag)
              ..id(int.tryParse(id ?? '')))
            .build(),
      );
    }
    return {'text': text, 'userTags': tags};
  }

  static List<LMChatTagViewData> addUserTagsIfMatched(String input) {
    final RegExp routeRegExp = RegExp(
        r'<<([^<>]+)\|route://(?:member|user_profile|participants)/([^<>]+)>>');
    final Iterable<RegExpMatch> matches = routeRegExp.allMatches(input);
    List<LMChatTagViewData> userTags = [];

    for (final match in matches) {
      final String tag = match.group(1)!;
      final String id = match.group(2)!;
      userTags.add(
        (LMChatTagViewDataBuilder()
              ..name(tag)
              ..id(int.tryParse(id)))
            .build(),
      );
    }
    return userTags;
  }

  static String extractStateMessage(String input) {
    final RegExp stateRegex = RegExp(r"(?<=\<\<).+?(?=\|)");
    final RegExp tagRegex = RegExp(r"<<(?<=\<\<).+?(?=\>\>)>>");
    final Iterable<RegExpMatch> matches = tagRegex.allMatches(input);
    for (RegExpMatch match in matches) {
      final String? routeTag = match.group(0);
      final String? userName = stateRegex.firstMatch(routeTag!)?.group(0);
      input = input.replaceAll(routeTag, '$userName');
    }
    return input;
  }

  static String extractFirstDMStateMessage(
      LMChatConversationViewData input, LMChatUserViewData user) {
    String result = input.answer;
    final RegExp tagRegex = RegExp(r"<<(?<=\<\<).+?(?=\>\>)>>");
    final Iterable<RegExpMatch> matches = tagRegex.allMatches(input.answer);
    for (RegExpMatch match in matches) {
      final String? routeTag = match.group(0);
      final String? userName = routeRegExp.firstMatch(routeTag!)?.group(1);
      final String? userId = routeRegExp.firstMatch(routeTag)?.group(3);
      if (user.id != int.parse(userId!)) {
        result = result.replaceAll(" $routeTag", ' $userName');
      } else {
        result = result.replaceAll(" $routeTag", '');
      }
    }
    return result;
  }

  static List<String> extractLinkFromString(String text) {
    RegExp exp = RegExp(linkRoute);
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

  static String getFirstValidLinkFromString(String text) {
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
    } catch (e) {
      return '';
    }
  }
}
