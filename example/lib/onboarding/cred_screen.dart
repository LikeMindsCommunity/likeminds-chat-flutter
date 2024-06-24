import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:likeminds_chat_flutter_sample/utils/mock_intiate_user.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_sample/utils/network_handling.dart';

class CredScreen extends StatefulWidget {
  const CredScreen({super.key});

  @override
  State<CredScreen> createState() => _CredScreenState();
}

class _CredScreenState extends State<CredScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _chatroomController = TextEditingController();
  static const backgroundColor = Color.fromARGB(255, 48, 159, 116);

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
  final TextStyle buttonTextStyle = GoogleFonts.montserrat(
    color: backgroundColor,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  @override
  void initState() {
    super.initState();
    NetworkConnectivity networkConnectivity = NetworkConnectivity.instance;
    networkConnectivity.initialise();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 96),
              Text(
                "LikeMinds Chat\nFlutter Sample App",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 64),
              Text(
                "Enter your credentials",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                cursorColor: Colors.white,
                style: GoogleFonts.montserrat(color: Colors.white),
                controller: _usernameController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'Username',
                  labelStyle: GoogleFonts.montserrat(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                cursorColor: Colors.white,
                controller: _userIdController,
                style: GoogleFonts.montserrat(color: Colors.white),
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelText: 'User ID',
                    labelStyle: GoogleFonts.montserrat(
                      color: Colors.white,
                    )),
              ),
              const SizedBox(height: 12),
              TextField(
                cursorColor: Colors.white,
                controller: _chatroomController,
                style: GoogleFonts.montserrat(color: Colors.white),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'Default ChatRoom ID (optional)',
                  labelStyle: GoogleFonts.montserrat(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Text(
                "If no credentials are provided, the app will run with the default credentials.",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
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
                },
                child: Text(
                  "Clear Data",
                  style: buttonTextStyle,
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
    String username =
        _usernameController.text.isEmpty ? "divi" : _usernameController.text;
    String userId =
        _userIdController.text.isEmpty && _usernameController.text.isEmpty
            ? 'divi'
            : _userIdController.text;
    // int? defaultChatroom = int.tryParse(_chatroomController.text);
    if (username.isEmpty || userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter valid credentials"),
        ),
      );
    } else {
      // final (accessToken, accessToken) = await mockInitiateUser(
      //   apiKey: "",
      //   userName: username,
      //   userId: userId,
      // );
      final response = await LMChatCore.instance.showChatWithApiKey(
        apiKey: "",
        uuid: userId,
        userName: username,
      );
      // final response = await LMChatCore.instance.showChatWithoutApiKey(
      //   accessToken: accessToken,
      //   refreshToken: refreshToken,
      // );
      if (response.success) {
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => const LMChatHomeScreen(
            chatroomType: LMChatroomType.dm,
          ),
        );
        Navigator.push(context, route);
      } else {
        toast(response.errorMessage ?? "An error occurred");
      }
    }
  }
}
