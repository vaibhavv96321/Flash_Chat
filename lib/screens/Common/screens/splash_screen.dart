import 'package:flash_chat/screens/Common/additional/constants.dart';
import 'package:flash_chat/screens/Common/screens/option_Screen.dart';
import 'package:flash_chat/screens/Common/screens/welcome_screen.dart';
import 'package:flash_chat/screens/new_Chatting_App/additional/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/new_Chatting_App/Screens/home_page.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static String id = 'splash_screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      checkSignedIn();
    });
  }

  void checkSignedIn() async {
    AuthProvider authProvider = context.read<AuthProvider>();
    isLoggedIn = await authProvider.isLoggedIn();
    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, HomePage.id);
      return;
    }
    Navigator.pushReplacementNamed(context, WelcomeScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "images/logo.png",
              width: 300,
              height: 300,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "You are about to enter a Whole New Experince!",
              style: TextStyle(color: lightBLueColor),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: lightBLueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
