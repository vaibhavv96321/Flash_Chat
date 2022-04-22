import 'package:flash_chat/screens/new_Chatting_App/additional/providers/auth_provider.dart';
import 'package:flash_chat/screens/Community_Chat_old/Screens/login_screen.dart';
import 'package:flash_chat/screens/Community_Chat_old/Screens/registration_screen.dart';
import 'package:flash_chat/screens/new_Chatting_App/Screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/screens/Community_Chat_old/additional/roundedButtons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../additional/constants.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

Animation borderanimation;

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  bool isLoading = false;
  User currentUser;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    //here i am making a COlorTween it is basically changes to one color to other and there are many more Tweens on the flutter documentation make sure to chek them out.
    animation = ColorTween(
      begin: Colors.blueGrey,
      end: whiteColor,
    ).animate(controller);

    borderanimation = BorderRadiusTween(
      begin: BorderRadius.circular(5),
      end: BorderRadius.circular(35),
    ).animate(controller);

    //this is the CurvedAnimation animation to change the value according to the curves option available there
    // animation = CurvedAnimation(
    //   parent: controller,
    //   curve: Curves.decelerate,
    // );
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    switch (authProvider.status) {
      case Status.authenticationError:
        Fluttertoast.showToast(msg: "Sign In Failed");
        break;
      case Status.authenticationCanceled:
        Fluttertoast.showToast(msg: "Sign In Canceled");
        break;
      case Status.authenticated:
        Fluttertoast.showToast(msg: "Sign In Success");
        break;
      default:
        break;
    }
    // it will show toast accoeding to the status of the sign in
    return Scaffold(
      backgroundColor: animation.value,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, RegistrationScreen.id);
                          },
                          child: Image.asset('images/app_icon.png')),
                      height: 60,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Flash Chat',
                          speed: Duration(milliseconds: 250),
                          textStyle: TextStyle(
                            fontSize: 45.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 48.0,
              ),
              Buttons(
                text: 'Log In',
                color: lightBLueColor,
                pushedName: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                borderAnimation: borderanimation.value,
              ),
              Buttons(
                  text: 'Register',
                  color: Colors.blueAccent,
                  pushedName: () {
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  },
                  borderAnimation: borderanimation.value),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 75),
                child: GestureDetector(
                  child: Center(
                      child: Text(
                    'Sign in with Google',
                    style: TextStyle(
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                    ),
                  )),
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    bool isSuccess = await authProvider.handleSignIn();
                    if (isSuccess) {
                      setState(() {
                        isLoading = false;
                      });
                      print('Success');
                      Navigator.pushNamed(context, HomePage.id);
                    } else {
                      print("noe t able to proceed the request of hadleSignIn");
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
