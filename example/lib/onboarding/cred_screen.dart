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
  late Color backgroundColor;

  final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    fixedSize: const Size(
      200,
      42,
    ),
  );
  late TextStyle buttonTextStyle = TextStyle(
    color: backgroundColor,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

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
    backgroundColor = Theme.of(context).primaryColor;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 96),
              const Text(
                "LikeMinds Chat\nFlutter Sample App",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 64),
              const Text(
                "Enter your credentials",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                cursorColor: Colors.white,
                controller: _apiKeyController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'API Key',
                  labelStyle: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                controller: _usernameController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'Username',
                  labelStyle: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                cursorColor: Colors.white,
                controller: _userIdController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelText: 'User ID',
                    labelStyle: const TextStyle(
                      color: Colors.white,
                    )),
              ),
              const SizedBox(height: 48),
              const Text(
                "If no credentials are provided, the app will run with the default credentials.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
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
                  await LMChatLocalPreference.instance.clearLocalData();
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
    );
  }

  Future<void> _onSubmit() async {
    String apiKey = _apiKeyController.text;
    String username = _usernameController.text;
    String userId = _userIdController.text;
    if (apiKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter the API Key"),
        ),
      );
      return;
    }
    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter the User ID"),
        ),
      );
    } else {
      final response = await LMChatCore.instance.showChatWithApiKey(
        apiKey: apiKey,
        uuid: userId,
        userName: username,
      );
      if (response.success) {
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => const LMChatHomeScreen(
              // chatroomType: LMChatroomType.dm,
              ),
        );
        Navigator.push(context, route);
      } else {
        toast(response.errorMessage ?? "An error occurred");
      }
    }
  }
}
