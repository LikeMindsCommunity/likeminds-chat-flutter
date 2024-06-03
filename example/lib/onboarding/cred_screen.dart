import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_sample/utils/network_handling.dart';

const credColor = Color.fromARGB(255, 48, 159, 116);

class CredScreen extends StatefulWidget {
  const CredScreen({super.key});

  @override
  State<CredScreen> createState() => _CredScreenState();
}

class _CredScreenState extends State<CredScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _chatroomController = TextEditingController();

  @override
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
      backgroundColor: credColor,
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
              GestureDetector(
                onTap: () async {
                  String username = _usernameController.text.isEmpty
                      ? "divi"
                      : _usernameController.text;
                  String userId = _userIdController.text.isEmpty &&
                          _usernameController.text.isEmpty
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
                    final response = await LMChatCore.instance.initiateUser(
                        initiateUserRequest: (InitiateUserRequestBuilder()
                              ..userId(userId)
                              ..userName(username))
                            .build());
                    if (response.success) {
                      MaterialPageRoute route = MaterialPageRoute(
                        builder: (context) => const LMChatHome(),
                        // builder: (context) => const LMChatHomeScreen(
                        //   chatroomType: LMChatroomType.dm,
                        // ),
                      );
                      Navigator.push(context, route);
                    } else {
                      toast(response.errorMessage ?? "An error occured");
                    }
                  }
                },
                child: Container(
                  width: 200,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      "Submit",
                      style: GoogleFonts.montserrat(
                        color: credColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
