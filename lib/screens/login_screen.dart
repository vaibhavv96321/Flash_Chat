import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/roundedButtons.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
              onChanged: (value) {
                //Do something with the user input.
              },
              style: kFieldstyle,
              decoration: fieldDecoration('Enter your email'),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              onChanged: (value) {
                //Do something with the user input.
              },
              style: kFieldstyle,
              decoration: fieldDecoration('Enter your password'),
            ),
            SizedBox(
              height: 24.0,
            ),
            Buttons(
              pushedName: () {},
              color: Colors.lightBlueAccent,
              text: 'Log In',
              borderAnimation: BorderRadius.circular(30),
            )
          ],
        ),
      ),
    );
  }
}
