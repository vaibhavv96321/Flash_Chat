import 'package:flash_chat/screens/Common/additional/constants.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/Community_Chat_old/additional/roundedButtons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../../Common/screens/welcome_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool loading = false;
  FirebaseAuth _auth;
  void start() async {
    await Firebase
        .initializeApp(); // we have to use this command to access the FireBase
    _auth = FirebaseAuth.instance;
  }

  String email;
  String password;
  bool obscurity = true;
  void toggle() {
    setState(() {
      obscurity = !obscurity;
    });
  }

  @override
  void initState() {
    super.initState();
    start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: InteractiveViewer(
        child: ModalProgressHUD(
          inAsyncCall: loading,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: TextButton(
                          child: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            Navigator.pushNamed(context, WelcomeScreen.id);
                          }),
                    ),
                    Center(
                      child: Text(
                        'REGISTER',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: 200.0,
                      child: Flexible(
                          fit: FlexFit.loose,
                          child: Hero(
                              tag: 'logo',
                              child: Image.asset('images/app_icon.png'))),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    TextField(
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: fieldDecoration('Enter your email')),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextField(
                      obscureText: obscurity,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: fieldDecoration('Enter your password'),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 150, vertical: 10),
                      alignment: Alignment.center,
                      child: GestureDetector(
                          onTap: toggle,
                          child: Text(obscurity ? "Show" : "Hide")),
                    ),
                    Buttons(
                      pushedName: () async {
                        setState(() {
                          loading = true;
                        });
                        try {
                          final user =
                              await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);
                          if (user != null) {
                            Navigator.pushNamed(context, ChatScreen.id);
                          }
                          setState(() {
                            loading = false;
                          });
                        } catch (e) {
                          print(e);
                        }
                      },
                      color: Colors.blueAccent,
                      text: 'Register',
                      borderAnimation: BorderRadius.circular(30),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
