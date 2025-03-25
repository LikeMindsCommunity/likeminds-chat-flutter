import 'package:flutter/material.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_core/src/views/search/configuration/config.dart';
import 'package:likeminds_chat_flutter_ui/src/theme/theme.dart';
import 'package:likeminds_chat_flutter_ui/src/widgets/widgets.dart';

class LMChatSearchConversationScreen extends StatefulWidget {
  static const routeName = '/searchConversation';

  /// The chatroom id
  final int chatRoomId;

  /// {@macro lm_chat_search_conversation_screen}
  const LMChatSearchConversationScreen({super.key, required this.chatRoomId});

  @override
  State<LMChatSearchConversationScreen> createState() =>
      _LMChatSearchConversationScreenState();
}

class _LMChatSearchConversationScreenState
    extends State<LMChatSearchConversationScreen> {
  // Controller for the TextField
  final TextEditingController _searchController = TextEditingController();
  final LMSearchBuilderDelegate _screenBuilder =
      LMChatCore.config.searchConfig.builder;

  // Clear the text in the TextField
  void _clearSearch() {
    setState(() {
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _screenBuilder.scaffold(
      appBar: _screenBuilder.appBarBuilder(context, _defaultAppBar(context)),
      body: Center(
        child: _defUserTile(),
      ),
    );
  }

  LMChatTile _defUserTile() {
    return LMChatTile(
      onTap: () {},
      style: LMChatTileStyle(
        backgroundColor: LMChatTheme.theme.container,
        gap: 4,
        margin: const EdgeInsets.only(bottom: 2),
      ),
      leading: LMChatProfilePicture(
        style: LMChatProfilePictureStyle.basic().copyWith(
          size: 50,
        ),
        fallbackText: 'userViewData.name',
        imageUrl:
            'https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg',
        // onTap: onTap,
      ),
      trailing: null,
      title: Row(
        children: [
          LMChatText(
            'Jane Chooper',
            style: LMChatTextStyle(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: LMChatTheme.theme.onContainer,
              ),
            ),
          ),
          const Spacer(),
          LMChatText(
            'Yesterday',
            style: LMChatTextStyle(
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: LMChatTheme.theme.onContainer,
              ),
            ),
          ),
        ],
      ),
      subtitle: LMChatText(
        'a very long message that is supposed to be displayed here...',
        style: LMChatTextStyle(
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: LMChatTheme.theme.onContainer,
          ),
        ),
      ),
    );
  }

  LMChatAppBar _defaultAppBar(BuildContext context) {
    return LMChatAppBar(
      leading: _screenBuilder.backButton(
        context,
        _defaultBackButton(context),
      ),

      title: _screenBuilder.searchField(
        context,
        _defaultTextField(),
      ),
      trailing: [
        _screenBuilder.clearSearchButton(context, _defaultClearSearchButton()),
      ],
      style:
          LMChatAppBarStyle.basic(Colors.white), // Customize the AppBar style
    );
  }

  LMChatButton _defaultClearSearchButton() {
    return LMChatButton(
      onTap: () {
        _clearSearch();
      },
      style: LMChatButtonStyle(
        height: 28,
        width: 28,
        borderRadius: 6,
        padding: EdgeInsets.zero,
        icon: LMChatIcon(
          type: LMChatIconType.icon,
          icon: Icons.close,
          style: LMChatIconStyle(
            color: LMChatTheme.theme.onContainer,
            size: 24,
            boxSize: 28,
          ),
        ),
        backgroundColor: LMChatTheme.theme.container,
      ),
    );
  }

  LMChatTextField _defaultTextField() {
    return LMChatTextField(
      controller: _searchController,
      chatroomId: 1,
      onTagSelected: (p0) {},
      isDown: false,
      focusNode: FocusNode(),
      // autofocus: true, // Automatically focus on the TextField
      decoration: const InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none, // No border for simplicity
      ),
    );
  }

  LMChatButton _defaultBackButton(BuildContext context) {
    return LMChatButton(
      onTap: () {
        Navigator.of(context).pop();
      },
      style: LMChatButtonStyle(
        height: 28,
        width: 28,
        borderRadius: 6,
        padding: EdgeInsets.zero,
        icon: LMChatIcon(
          type: LMChatIconType.icon,
          icon: Icons.arrow_back,
          style: LMChatIconStyle(
            color: LMChatTheme.theme.onContainer,
            size: 24,
            boxSize: 28,
          ),
        ),
        backgroundColor: LMChatTheme.theme.container,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose the controller to avoid memory leaks
    super.dispose();
  }
}
