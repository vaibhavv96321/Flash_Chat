import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/roundedButtons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

bool loading = false;

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth _auth;

  void start() async {
    await Firebase.initializeApp();
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
    start();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: InteractiveViewer(
        child: ModalProgressHUD(
          inAsyncCall: loading,
          child: GestureDetector(
            onTap: () {
              setState(() {
                loading = false;
              });
            },
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
                          'LOG IN',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        height: 200.0,
                        child: Flexible(
                            child: Hero(
                                tag: 'logo',
                                child: Image.asset('images/logo.png'))),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          email = value;
                        },
                        style: kFieldstyle,
                        decoration: fieldDecoration('Enter your email'),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextField(
                        textAlign: TextAlign.center,
                        obscureText: obscurity,
                        onChanged: (value) {
                          password = value;
                        },
                        style: kFieldstyle,
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
                            final user = await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                            if (user != null) {
                              Navigator.pushNamed(context, ChatScreen.id);
                            }
                            setState(() {
                              loading = false;
                            });
                          } catch (e) {
                            setState(() {
                              loading = false;
                            });
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Invalid Email or Password'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        color: Colors.lightBlueAccent,
                        text: 'Log In',
                        borderAnimation: BorderRadius.circular(30),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
