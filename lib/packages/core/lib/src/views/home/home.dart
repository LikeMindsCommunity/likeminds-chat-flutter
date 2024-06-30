import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/convertors/user/user_convertor.dart';
import 'package:likeminds_chat_flutter_core/src/utils/preferences/preferences.dart';
import 'package:likeminds_chat_flutter_core/src/widgets/widgets.dart';
import 'package:likeminds_chat_flutter_ui/likeminds_chat_flutter_ui.dart';

class LMChatHome extends StatefulWidget {
  const LMChatHome({super.key});

  @override
  State<LMChatHome> createState() => _LMChatHomeState();
}

class _LMChatHomeState extends State<LMChatHome> {
  final LMChatUserViewData user =
      LMChatPreferences.instance.currentUser!.toUserViewData();
  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    return Theme(
      data: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: LMChatTheme.theme.primaryColor,
        ),
      ),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              leading: const SizedBox.shrink(),
              titleSpacing: -24,
              centerTitle: false,
              actions: [
                // const Icon(Icons.search),
                const SizedBox(width: 8),
                LMChatProfilePicture(
                  fallbackText: user.name,
                  imageUrl: user.imageUrl,
                  style: const LMChatProfilePictureStyle(
                    size: 42,
                  ),
                ),
                const SizedBox(width: 24),
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(text: groupHomeTabTitle),
                  Tab(text: dmHomeTabTitle),
                ],
              ),
              title: const Text(homeFeedTitle),
            ),
            body: const TabBarView(
              children: [
                LMChatHomeFeedList(),
                LMChatDMFeedList(),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.message),
            ),
          ),
        ),
      ),
    );
  }
}
