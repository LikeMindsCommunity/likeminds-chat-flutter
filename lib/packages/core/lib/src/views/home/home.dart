import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/user/user_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/widgets.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

/// LMChatHomeScreen is the main screen to enter LM Chat experience.
///
/// To customize it pass appropriate builders to constructor.
class LMChatHomeScreen extends StatefulWidget {
  /// Constructor for LMChatHomeScreen
  ///
  /// Creates a new instance of the screen widget
  const LMChatHomeScreen({
    super.key,
  });

  @override
  State<LMChatHomeScreen> createState() => _LMChatHomeScreenState();
}

class _LMChatHomeScreenState extends State<LMChatHomeScreen> {
  final LMChatUserViewData user =
      LMChatLocalPreference.instance.getUser().toUserViewData();
  final _homeScreenBuilder = LMChatCore.config.homeConfig.builder;

  @override
  void didUpdateWidget(covariant LMChatHomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    return DefaultTabController(
      length: 2,
      child: Builder(builder: (context) {
        return _homeScreenBuilder.scaffold(
          backgroundColor: LMChatTheme.theme.backgroundColor,
          appBar: _homeScreenBuilder.appBarBuilder(
            context,
            user,
            DefaultTabController.of(context),
            _defAppBar(context),
          ),
          body: const TabBarView(
            children: [
              LMChatHomeFeedList(),
              LMChatDMFeedList(),
            ],
          ),
        );
      }),
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
      bottom: _homeScreenBuilder.tabBarBuilder(
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
