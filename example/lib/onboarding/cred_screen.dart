import 'package:flutter/material.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_sample/utils/network_handling.dart';

/// The credentials screen for the app.
class CredScreen extends StatefulWidget {
  /// Constructor for the CredScreen
  const CredScreen({super.key});

  @override
  State<CredScreen> createState() => _CredScreenState();
}

class _CredScreenState extends State<CredScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController();
  bool isDarkMode = false;

  ButtonStyle get buttonStyle => ElevatedButton.styleFrom(
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        fixedSize: const Size(
          200,
          42,
        ),
      );

  TextStyle get buttonTextStyle => TextStyle(
        color: isDarkMode ? Colors.white : Theme.of(context).primaryColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );

  Color get backgroundColor =>
      isDarkMode ? Colors.grey[900]! : Theme.of(context).primaryColor;

  Color get textColor => isDarkMode ? Colors.white : Colors.white;

  Color get textFieldBorderColor =>
      isDarkMode ? Colors.grey[700]! : Colors.white;

  @override
  void initState() {
    super.initState();
    NetworkConnectivity networkConnectivity = NetworkConnectivity.instance;
    networkConnectivity.initialise();
    _setTextFieldData();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _userIdController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  void _setTextFieldData() {
    User? user = LMChatCore.instance.lmChatClient.getLoggedInUser().data;
    String? apiKey = LMChatLocalPreference.instance
        .fetchCache(LMChatStringConstants.apiKey)
        ?.value as String?;
    if (user != null) {
      _usernameController.text = user.name;
      _userIdController.text = user.sdkClientInfo?.uuid ?? "";
    }
    if (apiKey != null) {
      _apiKeyController.text = apiKey;
    }
  }

  void _clearTextFieldData() {
    _usernameController.clear();
    _userIdController.clear();
    _apiKeyController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 600,
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            centerTitle: false,
            title: Text(
              "LMChat Flutter Showcase",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  children: [
                    Icon(
                      isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: textColor,
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: isDarkMode,
                      onChanged: (value) {
                        setState(() {
                          isDarkMode = value;
                        });
                        LMChatTheme.setTheme(
                          isDarkMode
                              ? LMChatThemeData.dark()
                              : LMChatThemeData.light(),
                        );
                      },
                      activeColor: Colors.grey[800],
                      activeTrackColor: Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 48),
                  Text(
                    "Enter your credentials",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    cursorColor: textColor,
                    controller: _apiKeyController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      fillColor: textColor,
                      focusColor: textColor,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: textFieldBorderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: textFieldBorderColor),
                      ),
                      labelText: 'API Key',
                      labelStyle: TextStyle(
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    cursorColor: textColor,
                    style: TextStyle(color: textColor),
                    controller: _usernameController,
                    decoration: InputDecoration(
                      fillColor: textColor,
                      focusColor: textColor,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: textFieldBorderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: textFieldBorderColor),
                      ),
                      labelText: 'Username',
                      labelStyle: TextStyle(
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    cursorColor: textColor,
                    controller: _userIdController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      fillColor: textColor,
                      focusColor: textColor,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: textFieldBorderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: textFieldBorderColor),
                      ),
                      labelText: 'User ID',
                      labelStyle: TextStyle(
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Text(
                    "If no credentials are provided, the app will run with the default credentials.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 72),
                  ElevatedButton(
                    style: buttonStyle,
                    onPressed: _onSubmit,
                    child: Text(
                      "Submit",
                      style: buttonTextStyle,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: buttonStyle,
                    onPressed: () async {
                      final response = await LMChatCore.instance.logout();
                      if (!response.success) {
                        await LMChatLocalPreference.instance.clearLocalData();
                      } else {
                        toast("Logged out successfully");
                      }
                      _clearTextFieldData();
                      setState(() {});
                    },
                    child: Text(
                      "Clear Data",
                      style: buttonTextStyle,
                    ),
                  ),
                  const SizedBox(height: 18),
                  LMChatAIButton(
                    style: LMChatAIButtonStyle.basic().copyWith(
                      backgroundColor:
                          isDarkMode ? Colors.grey[800] : Colors.white,
                      textColor: isDarkMode ? Colors.white : backgroundColor,
                      borderRadius: 12,
                    ),
                    props: LMChatAIButtonProps(
                      uuid: _userIdController.text,
                      userName: _usernameController.text,
                      apiKey: _apiKeyController.text,
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmit() async {
    await LMChatLocalPreference.instance.clearLocalData();
    String apiKey = _apiKeyController.text;
    String username = _usernameController.text;
    String userId = _userIdController.text;
    // Ensure all data is fetched correctly
    if (apiKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the API Key")),
      );
      return;
    }
    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the User ID")),
      );
    } else {
      final response = await LMChatCore.instance.showChatWithApiKey(
        apiKey: apiKey,
        uuid: userId,
        userName: username,
      );
      if (response.success) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const LMCommunityHybridChatScreen()),
        );
      } else {
        toast(response.errorMessage ?? "An error occurred");
      }
    }
  }
}
