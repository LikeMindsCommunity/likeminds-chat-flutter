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
  /// Builder function to render a floating action button on screen
  final LMChatButtonBuilder? floatingActionButton;

  /// Builder function to render app bar on screen
  final LMChatHomeAppBarBuilder? appBar;

  /// Constructor for LMChatHomeScreen
  ///
  /// Creates a new instance of the screen widget
  const LMChatHomeScreen({
    super.key,
    this.appBar,
    this.floatingActionButton,
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: DefaultTabController(
        length: 2,
        child: Builder(builder: (context) {
          return _homeScreenBuilder.scaffold(
            backgroundColor: LMChatTheme.theme.backgroundColor,
            appBar: _homeScreenBuilder.appBarBuilder(
              context,
              user,
              DefaultTabController.of(context),
              _defAppBar(),
            ),
            body: const TabBarView(
              children: [
                LMChatHomeFeedList(),
                LMChatDMFeedList(),
              ],
            ),
          );
        }),
      ),
    );
  }

  LMChatAppBar _defAppBar() {
    return LMChatAppBar(
      style: const LMChatAppBarStyle(
        height: 120,
      ),
      leading: const SizedBox.shrink(),
      trailing: [
        const SizedBox(width: 8),
        LMChatProfilePicture(
          fallbackText: user.name,
          imageUrl: user.imageUrl,
          style: const LMChatProfilePictureStyle(
            size: 42,
          ),
        ),
        const SizedBox(width: 8),
      ],
      bottom: TabBar(
        labelColor: LMChatTheme.theme.primaryColor,
        indicatorColor: LMChatTheme.theme.primaryColor,
        tabs: const [
          Tab(text: LMChatStringConstants.groupHomeTabTitle),
          Tab(text: LMChatStringConstants.dmHomeTabTitle),
        ],
      ),
      title: LMChatText(
        LMChatStringConstants.homeFeedTitle,
        style: LMChatTextStyle(
          textStyle: TextStyle(
            fontSize: 22.0.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  LMChatButton _floatingActionButton() {
    return LMChatButton(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LMChatExplorePage(),
          ),
        );
      },
      style: LMChatButtonStyle(
        backgroundColor: LMChatTheme.theme.backgroundColor,
        height: 48,
        width: 48,
        borderRadius: 12,
      ),
      icon: LMChatIcon(
        type: LMChatIconType.icon,
        icon: Icons.message,
        style: LMChatIconStyle(
          color: LMChatTheme.theme.primaryColor,
        ),
      ),
    );
  }
}
