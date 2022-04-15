import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flash_chat/screens/Common/additional/constants.dart';
import 'package:flash_chat/screens/new_Chatting_App/additional/user_chat.dart';

enum Status {
  uninitialized,
  authenticating,
  authenticated,
  authenticationError,
  authenticationCanceled,
}

class AuthProvider extends ChangeNotifier {
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  SharedPreferences preferences;

  Status _status = Status.uninitialized;

  Status get status => _status;
  AuthProvider(
      {this.googleSignIn,
      this.firebaseFirestore,
      this.firebaseAuth,
      this.preferences});

  String getUserFirebaseId() {
    return preferences.getString(FirebaseConstants.id);
  }

  Future<bool> isLoggedIn() async {
    preferences = await SharedPreferences.getInstance();
    bool isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn &&
        preferences.getString(FirebaseConstants.id)?.isNotEmpty == true) {
      // this means that the user is logged in and we also have the id of the user then it will return true
      return true;
    } else {
      return false;
    }
  }

  Future<bool> handleSignIn() async {
    print("reached handleSIgnIN");
    _status = Status.authenticating;
    notifyListeners();

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      User firebaseUser =
          (await firebaseAuth.signInWithCredential(credential)).user;

      if (firebaseUser != null) {
        final QuerySnapshot result = await firebaseFirestore
            .collection(FirebaseConstants.pathUserCollection)
            .where(FirebaseConstants.id, isEqualTo: firebaseUser.uid)
            .get();
        final List<DocumentSnapshot> document = result.docs;
        if (document.length == 0) {
          firebaseFirestore
              .collection(FirebaseConstants.pathUserCollection)
              .doc(firebaseUser.uid)
              .set({
            FirebaseConstants.nickname: firebaseUser.displayName,
            FirebaseConstants.photoUrl: firebaseUser.photoURL,
            FirebaseConstants.id: firebaseUser.uid,
            'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
            FirebaseConstants.chattingFrom: null,
            FirebaseConstants.aboutMe: "hi i a using Vaibhav's Chat app",
            FirebaseConstants.phoneNumber: "+91xxxxxxxxxx"
          });
          print("hello new user mid");
          User currentUser = firebaseUser;
          await preferences.setString(FirebaseConstants.id, currentUser.uid);
          await preferences.setString(
              FirebaseConstants.nickname, currentUser.displayName ?? "");
          await preferences.setString(
              FirebaseConstants.photoUrl, currentUser.photoURL ?? "");
          await preferences.setString(
              FirebaseConstants.phoneNumber, currentUser.phoneNumber ?? "");
        } else {
          preferences = await SharedPreferences.getInstance();
          print("exsisting user start");
          DocumentSnapshot documentSnapshot = document[0];
          UserChat userChat = UserChat.fromDocument(documentSnapshot);

          print("came back from userchat");
          await preferences.setString(FirebaseConstants.id, userChat.id);
          await preferences.setString(
              FirebaseConstants.nickname, userChat.nickname);
          await preferences.setString(
              FirebaseConstants.photoUrl, userChat.photoUrl);
          await preferences.setString(
              FirebaseConstants.aboutMe, userChat.aboutMe);
          await preferences.setString(
              FirebaseConstants.phoneNumber, userChat.phoneNumber);
          print('existing user finish');
        }
        print("authenticated and notified");
        _status = Status.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = Status.authenticationError;
        notifyListeners();
        return false;
      }
    } else {
      _status = Status.authenticationCanceled;
      notifyListeners();
      return false;
    }
  }

  Future<void> handleSignOut() async {
    _status = Status.uninitialized;
    await firebaseAuth.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
  }
}
