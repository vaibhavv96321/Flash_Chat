import 'package:flash_chat/screens/Community_Chat_old/additional/roundedButtons.dart';
import 'package:flash_chat/screens/Common/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

class OptionScreen extends StatelessWidget {
  static String id = 'option_screen';
  @override
  Widget build(BuildContext context) {
    //TODO: in this i am making a screen which will appear at the start and it will let the usr decide whether he wants to chose community chat option which will contain simple login option and a private chat which will contain google sign in option to directly login to the home_page.dart
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              Buttons(
                  pushedName: () {
                    Navigator.pushNamed(context, WelcomeScreen.id);
                  },
                  text: "Community Chat",
                  borderAnimation: BorderRadius.circular(20),
                  color: Colors.yellow),
              SizedBox(
                height: 50,
              ),
              Buttons(
                  pushedName: () {
                    Navigator.pushNamed(context, WelcomeScreen.id);
                  },
                  text: "Private Chat",
                  borderAnimation: BorderRadius.circular(20),
                  color: Colors.orangeAccent)
            ],
          ),
        ),
      ),
    );
  }
}
