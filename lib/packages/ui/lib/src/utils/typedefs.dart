// import 'package:flutter/material.dart';
// import 'package:likeminds_feed_flutter_ui/src/models/models.dart';
// import 'package:likeminds_feed_flutter_ui/src/widgets/widgets.dart';

// /// {@template post_header_builder}
// /// Builder function to build the post header.
// /// i.e. user image, name, time, menu button
// /// must return a widget, takes in [BuildContext] and [LMPostViewData] as params
// /// {@endtemplate}
// typedef LMChatPostHeaderBuilder = Widget Function(
//     BuildContext, LMChatPostHeader, LMPostViewData);

// /// {@template post_footer_builder}
// /// Builder function to build the post footer.
// /// i.e. like, comment, share, save buttons
// /// must return a widget, takes in [BuildContext] and [LMPostViewData] as params
// /// {@endtemplate}
// typedef LMChatPostFooterBuilder = Widget Function(
//     BuildContext, LMChatPostFooter, LMPostViewData);

// /// {@template post_menu_builder}
// /// Builder function to build the post widget.
// /// i.e. edit, delete, report, pin etc.
// /// must return a widget, takes in [BuildContext] and [LMPostViewData] as params
// /// {@endtemplate}
// typedef LMChatPostMenuBuilder = Widget Function(
//     BuildContext, LMChatMenu, LMPostViewData);

// /// {@template post_topic_builder}
// /// Builder function to build the topic widget.
// /// must return a widget, takes in [BuildContext]
// /// and [LMTopicViewData] as params
// /// {@endtemplate}
// typedef LMChatPostTopicBuilder = Widget Function(
//     BuildContext, LMChatPostTopic, LMPostViewData);

// /// {@template post_widget_builder}
// /// Builder function to build the post widget.
// /// must return a widget, takes in [BuildContext] and [LMPostViewData] as params
// /// {@endtemplate}
// typedef LMChatPostMediaBuilder = Widget Function(
//     BuildContext, LMChatPostMedia, LMPostViewData);

// /// {@template post_widget_builder}
// /// Builder function to build the post widget.
// /// must return a widget, takes in [BuildContext] and [LMPostViewData] as params
// /// {@endtemplate}
// typedef LMChatPostContentBuilder = Widget Function(
//     BuildContext, LMChatPostContent, LMPostViewData);

// /// {@template post_widget_builder}
// /// Builder function to build the post widget.
// /// must return a widget, takes in [BuildContext] and [LMPostViewData] as params
// /// {@endtemplate}
// typedef LMChatPostWidgetBuilder = Widget Function(
//     BuildContext, LMChatPostWidget, LMPostViewData);

// /// {@template feed_image_builder}
// /// Builder function to build the image widget.
// /// must return a widget, takes in [LMChatImage] as params
// /// {@endtemplate}
// typedef LMChatImageBuilder = Widget Function(LMChatImage);

// /// {@template feed_video_builder}
// /// Builder function to build the video widget.
// /// must return a widget, takes in [LMChatVideo] as params
// /// {@endtemplate}
// typedef LMChatVideoBuilder = Widget Function(LMChatVideo);

// /// {@template feed_poll_builder}
// /// Builder function to build the poll widget.
// /// must return a widget, takes in [LMChatPoll] as params
// /// {@endtemplate}
// typedef LMChatPollBuilder = Widget Function(LMChatPoll);

// /// {@template feed_carousel_indicator_builder}
// /// Builder function to build the carousel indicator widget.
// /// must return a widget, takes in [int] as params
// /// [int] is the current index of the carousel
// /// {@endtemplate}
// typedef LMChatCarouselIndicatorBuilder = Widget Function(
//     BuildContext, int, int, Widget);

// ///{@template post_callback}
// /// A callback to handle interactions with the post.
// /// {@endtemplate}
// typedef LMChatOnPostTap = void Function(BuildContext, LMPostViewData);

// ///{@template post_appbar_builder}
// /// Builder function to build the post appbar.
// /// must return a PreferredSizeWidget,
// /// takes in [BuildContext] and [LMPostViewData] as params.
// /// {@endtemplate}
// typedef LMChatPostAppBarBuilder = PreferredSizeWidget Function(
//     BuildContext, LMChatAppBar);

// /// {@template post_comment_builder}
// /// Builder function to build the post comment.
// /// must return a widget,
// /// takes in [BuildContext], [LMUserViewData] and [LMCommentViewData] as params.
// /// {@endtemplate}
// typedef LMChatPostCommentBuilder = Widget Function(
//     BuildContext, LMChatCommentWidget, LMPostViewData);

// typedef LMChatTopicBarBuilder = Widget Function(LMChatTopicBar topicBar);

// /// {@template feed_error_handler}
// /// A callback to handle errors in the feed.
// /// {@endtemplate}
// typedef LMChatErrorHandler = Function(String, StackTrace);

// /// {@template feed_on_tag_tap}
// /// A callback to handle tag tap in the feed.
// /// {@endtemplate}
// typedef LMChatOnTagTap = void Function(String);

// /// {@template feed_button_builder}
// /// Builder function to build the button widget.
// /// must return a widget, takes in [LMChatButton] as params
// /// {@endtemplate}
// typedef LMChatButtonBuilder = Widget Function(LMChatButton);

// typedef LMChatRoomTileBuilder = Widget Function(
//   BuildContext context,
//   LMChatRoomViewData viewData,
//   LMChatTile oldWidget,
// );

/// {@template chat_error_handler}
/// A callback to handle errors in the chat.
/// {@endtemplate}
typedef LMChatErrorHandler = Function(String, StackTrace);
