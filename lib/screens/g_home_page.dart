import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/main.dart';
import 'package:flash_chat/screens/setting_page.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  final String currentUserId;

  static String id = 'home_page';
  HomePage({Key key, this.currentUserId}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  TextEditingController searchTextEditingController = TextEditingController();

  AppBar bodyHeader() {
    return AppBar(
      backgroundColor: Colors.lightBlueAccent,
      title: Container(
          child: TextField(
        decoration: fieldDecoration('Search').copyWith(
            prefixIcon: Icon(
              Icons.perm_contact_cal_rounded,
              size: 30,
              color: Colors.lightBlueAccent,
            ),
            suffixIcon: IconButton(
                onPressed: () {
                  searchTextEditingController.clear();
                },
                icon: Icon(
                  Icons.clear,
                  color: Colors.lightBlueAccent,
                  size: 30,
                ))),
        controller: searchTextEditingController,
      )),
      automaticallyImplyLeading: false,
      actions: <Widget>[
        IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingPage()));
            },
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: bodyHeader(),
      body: ElevatedButton.icon(
          onPressed: logoutUser,
          icon: Icon(Icons.close),
          label: Text('Sign Out')),
      backgroundColor: Colors.white,
    );
  }

  Future<Null> logoutUser() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => FlashChat()),
        (Route<dynamic> route) => false);
  }
}
