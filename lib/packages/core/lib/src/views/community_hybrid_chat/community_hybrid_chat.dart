import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/user/user_convertor.dart';

/// {@template lm_community_hybrid_chat_screen}
/// LMCommunityHybridChatScreen is the main screen to enter LM Chat experience.
///
/// To customize it pass appropriate builders to constructor.
/// {@endtemplate}
class LMCommunityHybridChatScreen extends StatefulWidget {
  /// Constructor for LMCommunityHybridChatScreen
  ///
  /// Creates a new instance of the screen widget
  const LMCommunityHybridChatScreen({
    super.key,
  });

  @override
  State<LMCommunityHybridChatScreen> createState() =>
      _LMCommunityHybridChatScreenState();
}

class _LMCommunityHybridChatScreenState
    extends State<LMCommunityHybridChatScreen> {
  final LMChatUserViewData user =
      LMChatLocalPreference.instance.getUser().toUserViewData();
  final _screenBuilder = LMChatCore.config.communityHybridChatConfig.builder;
  final _webConfiguration = LMChatCore.config.webConfiguration;

  @override
  void didUpdateWidget(covariant LMCommunityHybridChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    ScreenSize.init(context,
        setWidth: kIsWeb ? _webConfiguration.maxWidth : null);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: _webConfiguration.maxWidth,
          maxHeight: MediaQuery.of(context).size.height,
        ),
        child: ValueListenableBuilder(
          valueListenable: LMChatTheme.themeNotifier,
          builder: (context, _, child) {
            return DefaultTabController(
              length: 2,
              child: Builder(builder: (context) {
                return _screenBuilder.scaffold(
                  backgroundColor: LMChatTheme.theme.backgroundColor,
                  appBar: _screenBuilder.appBarBuilder(
                    context,
                    user,
                    DefaultTabController.of(context),
                    _defAppBar(context),
                  ),
                  body: const TabBarView(
                    children: [
                      // home feed -> community
                      // dm feed -> networking
                      LMCommunityChatScreen(),
                      LMNetworkingChatScreen(),
                    ],
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }

  LMChatAppBar _defAppBar(BuildContext context) {
    return LMChatAppBar(
      style: LMChatAppBarStyle(
        height: 120,
        gap: 8,
        backgroundColor: LMChatTheme.theme.container,
      ),
      leading: const SizedBox.shrink(),
      trailing: [
        const SizedBox(width: 8),
        LMChatProfilePicture(
          fallbackText: user.name,
          imageUrl: user.imageUrl,
          style: const LMChatProfilePictureStyle(
            size: 32,
          ),
        ),
        const SizedBox(width: 8),
      ],
      bottom: _screenBuilder.tabBarBuilder(
        context,
        DefaultTabController.of(context),
        _defTabBar(),
      ),
      title: LMChatText(
        LMChatStringConstants.homeFeedTitle,
        style: LMChatTextStyle(
          textStyle: TextStyle(
            fontSize: 22.0.sp,
            fontWeight: FontWeight.w600,
            color: LMChatTheme.theme.onContainer,
          ),
        ),
      ),
    );
  }

  TabBar _defTabBar() {
    return TabBar(
      labelColor: LMChatTheme.theme.onContainer,
      indicatorColor: LMChatTheme.theme.primaryColor,
      labelStyle: TextStyle(color: LMChatTheme.theme.onContainer),
      unselectedLabelStyle: TextStyle(color: LMChatTheme.theme.onContainer),
      tabs: const [
        Tab(text: LMChatStringConstants.groupHomeTabTitle),
        Tab(text: LMChatStringConstants.dmHomeTabTitle),
      ],
    );
  }

  LMChatAIButton _floatingActionButton() {
    return const LMChatAIButton();
  }
}
