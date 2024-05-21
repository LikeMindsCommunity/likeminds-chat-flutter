import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:likeminds_chat_fl/likeminds_chat_fl.dart';
import 'package:likeminds_chat_flutter_core/likeminds_chat_flutter_core.dart';
import 'package:likeminds_chat_flutter_sample/environment/env.dart';
import 'package:likeminds_chat_flutter_sample/network_handling.dart';

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
                "Flutter Chat\nSample App",
                textAlign: TextAlign.center,
                style: GoogleFonts.josefinSans(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 64),
              Text(
                "Enter your credentials",
                style: GoogleFonts.josefinSans(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                cursorColor: Colors.white,
                style: GoogleFonts.josefinSans(color: Colors.white),
                controller: _usernameController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'Username',
                  labelStyle: GoogleFonts.josefinSans(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                cursorColor: Colors.white,
                controller: _userIdController,
                style: GoogleFonts.josefinSans(color: Colors.white),
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelText: 'User ID',
                    labelStyle: GoogleFonts.josefinSans(
                      color: Colors.white,
                    )),
              ),
              const SizedBox(height: 12),
              TextField(
                cursorColor: Colors.white,
                controller: _chatroomController,
                style: GoogleFonts.josefinSans(color: Colors.white),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'Default ChatRoom ID (optional)',
                  labelStyle: GoogleFonts.josefinSans(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Text(
                "If no credentials are provided, the app will run with the default credentials of Bot user in your community",
                textAlign: TextAlign.center,
                style: GoogleFonts.josefinSans(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 48),
              Text(
                "Branding",
                style: GoogleFonts.josefinSans(
                  color: Colors.white,
                  fontSize: 24,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 32),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //   child: Row(
              //     children: [
              //       // DropdownMenu(
              //       //   enableFilter: true,
              //       //   width: 42.w,
              //       //   menuHeight: 20.h,
              //       //   label: Text(
              //       //     "Choose font",
              //       //     maxLines: 1,
              //       //     overflow: TextOverflow.ellipsis,
              //       //     style: GoogleFonts.josefinSans(
              //       //       color: Colors.white,
              //       //       fontSize: 12.sp,
              //       //     ),
              //       //   ),
              //       //   textStyle: _textStyle?.copyWith(
              //       //         color: Colors.white,
              //       //         fontSize: 12.sp,
              //       //       ) ??
              //       //       GoogleFonts.josefinSans(
              //       //         color: Colors.white,
              //       //         fontSize: 12.sp,
              //       //       ),
              //       //   inputDecorationTheme: InputDecorationTheme(
              //       //     focusColor: Colors.white,
              //       //     fillColor: Colors.white,
              //       //     hoverColor: Colors.white,
              //       //     floatingLabelStyle: GoogleFonts.josefinSans(
              //       //       color: Colors.white,
              //       //       fontSize: 12.sp,
              //       //     ),
              //       //     labelStyle: GoogleFonts.josefinSans(
              //       //       color: Colors.white,
              //       //       fontSize: 12.sp,
              //       //     ),
              //       //     border: OutlineInputBorder(
              //       //       borderRadius: BorderRadius.circular(8),
              //       //     ),
              //       //   ),
              //       //   dropdownMenuEntries: getGoogleFontsAsMap(),
              //       //   onSelected: (value) {
              //       //     setState(() {
              //       //       _textStyle = GoogleFonts.asMap()[value]?.call();
              //       //     });
              //       //   },
              //       // ),
              //       // const Spacer(),
              //       GestureDetector(
              //         onTap: () => showDialog(
              //           context: context,
              //           builder: (_) {
              //             return AlertDialog(
              //               contentPadding: const EdgeInsets.all(6.0),
              //               title: const Text("Choose header colour"),
              //               content: MaterialColorPicker(
              //                 allowShades: false,
              //                 onlyShadeSelection: false,
              //                 selectedColor: _tempColor,
              //                 onColorChange: (color) => setState(
              //                   () => _tempColor = color,
              //                 ),
              //                 onMainColorChange: (color) => setState(
              //                   () => _tempColor = color,
              //                 ),
              //                 onBack: () => debugPrint("Back button pressed"),
              //               ),
              //               actions: [
              //                 TextButton(
              //                   onPressed: Navigator.of(context).pop,
              //                   child: Text(
              //                     'CANCEL',
              //                     style: GoogleFonts.josefinSans(
              //                       color: Colors.grey,
              //                     ),
              //                   ),
              //                 ),
              //                 TextButton(
              //                   child: Text(
              //                     'SUBMIT',
              //                     style: GoogleFonts.josefinSans(
              //                       color: credColor,
              //                     ),
              //                   ),
              //                   onPressed: () {
              //                     Navigator.of(context).pop();
              //                     setState(
              //                       () => _header = _tempColor,
              //                     );
              //                   },
              //                 ),
              //               ],
              //             );
              //           },
              //         ),
              //         child: Container(
              //           height: 6.h,
              //           width: 6.h,
              //           decoration: BoxDecoration(
              //             color: _header ?? Colors.grey,
              //             borderRadius: BorderRadius.circular(3.h),
              //           ),
              //         ),
              //       ),
              //       const SizedBox(width: 6),
              //       GestureDetector(
              //         onTap: () => showDialog(
              //           context: context,
              //           builder: (_) {
              //             return AlertDialog(
              //               contentPadding: const EdgeInsets.all(6.0),
              //               title: const Text("Choose button colour"),
              //               content: MaterialColorPicker(
              //                 allowShades: false,
              //                 onlyShadeSelection: false,
              //                 selectedColor: _tempColor,
              //                 onColorChange: (color) => setState(
              //                   () => _tempColor = color,
              //                 ),
              //                 onMainColorChange: (color) => setState(
              //                   () => _tempColor = color,
              //                 ),
              //                 onBack: () => debugPrint("Back button pressed"),
              //               ),
              //               actions: [
              //                 TextButton(
              //                   onPressed: Navigator.of(context).pop,
              //                   child: Text(
              //                     'CANCEL',
              //                     style: GoogleFonts.josefinSans(
              //                       color: Colors.grey,
              //                     ),
              //                   ),
              //                 ),
              //                 TextButton(
              //                   child: Text(
              //                     'SUBMIT',
              //                     style: GoogleFonts.josefinSans(
              //                       color: credColor,
              //                     ),
              //                   ),
              //                   onPressed: () {
              //                     Navigator.of(context).pop();
              //                     setState(
              //                       () => _button = _tempColor,
              //                     );
              //                   },
              //                 ),
              //               ],
              //             );
              //           },
              //         ),
              //         child: Container(
              //           height: 6.h,
              //           width: 6.h,
              //           decoration: BoxDecoration(
              //             color: _button ?? Colors.grey,
              //             borderRadius: BorderRadius.circular(3.h),
              //           ),
              //         ),
              //       ),
              //       const SizedBox(width: 6),
              //       GestureDetector(
              //         onTap: () => showDialog(
              //           context: context,
              //           builder: (_) {
              //             return AlertDialog(
              //               contentPadding: const EdgeInsets.all(6.0),
              //               title: const Text("Choose text link colour"),
              //               content: MaterialColorPicker(
              //                 allowShades: false,
              //                 selectedColor: _tempColor,
              //                 onColorChange: (color) => setState(
              //                   () => _tempColor = color,
              //                 ),
              //                 onMainColorChange: (color) => setState(
              //                   () => _tempColor = color,
              //                 ),
              //                 onBack: () => debugPrint("Back button pressed"),
              //               ),
              //               actions: [
              //                 TextButton(
              //                   onPressed: Navigator.of(context).pop,
              //                   child: Text(
              //                     'CANCEL',
              //                     style: GoogleFonts.josefinSans(
              //                       color: Colors.grey,
              //                     ),
              //                   ),
              //                 ),
              //                 TextButton(
              //                   child: Text(
              //                     'SUBMIT',
              //                     style: GoogleFonts.josefinSans(
              //                       color: credColor,
              //                     ),
              //                   ),
              //                   onPressed: () {
              //                     Navigator.of(context).pop();
              //                     setState(
              //                       () => _textLink = _tempColor,
              //                     );
              //                   },
              //                 ),
              //               ],
              //             );
              //           },
              //         ),
              //         child: Container(
              //           height: 6.h,
              //           width: 6.h,
              //           decoration: BoxDecoration(
              //             color: _textLink ?? Colors.grey,
              //             borderRadius: BorderRadius.circular(3.h),
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 48),
              GestureDetector(
                onTap: () async {
                  String username = _usernameController.text.isEmpty
                      ? "divi"
                      : _usernameController.text;
                  String userId = _userIdController.text.isEmpty &&
                          _usernameController.text.isEmpty
                      ? 'divi'
                      : _userIdController.text;
                  int? defaultChatroom = int.tryParse(_chatroomController.text);
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
                        builder: (context) => const LMChatHomeScreen(
                          chatroomType: LMChatroomType.dm,
                        ),
                      );
                      Navigator.push(context, route);
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
                      style: GoogleFonts.josefinSans(
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
