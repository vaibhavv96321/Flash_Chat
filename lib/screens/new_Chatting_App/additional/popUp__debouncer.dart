import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

class PopUpChoices {
  String title;
  IconData icon;
  PopUpChoices({@required this.icon, @required this.title});

  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<Null> logoutUser() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
  }
}

class Debouncer {
  int milliseconds;
  Timer timer;

  Debouncer({@required this.milliseconds});

  run(VoidCallback action) {
    timer.cancel();

    timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
