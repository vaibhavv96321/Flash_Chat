import 'package:flash_chat/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/roundedButtons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: TextButton(
                  child: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            Container(
              height: 200.0,
              child: Hero(tag: 'logo', child: Image.asset('images/logo.png')),
            ),
            SizedBox(
              height: 48.0,
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
              margin: EdgeInsets.symmetric(horizontal: 150, vertical: 10),
              alignment: Alignment.center,
              child: GestureDetector(
                  onTap: toggle, child: Text(obscurity ? "Show" : "Hide")),
            ),
            Buttons(
              pushedName: () async {
                // print(email);
                // print(password);
                try {
                  final user = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  if (user != null) {
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
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
      ),
    );
  }
}
