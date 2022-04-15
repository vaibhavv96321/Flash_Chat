import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Common/additional/constants.dart';

class UserChat {
  String id;
  String photoUrl;
  String nickname;
  String aboutMe;
  String phoneNumber;
  UserChat(
      {@required this.id,
      @required this.aboutMe,
      @required this.photoUrl,
      @required this.nickname,
      @required this.phoneNumber});

  Map<String, String> toJson() {
    return {
      FirebaseConstants.nickname: nickname,
      FirebaseConstants.aboutMe: aboutMe,
      FirebaseConstants.photoUrl: photoUrl,
      FirebaseConstants.phoneNumber: phoneNumber,
    };
  }

  factory UserChat.fromDocument(DocumentSnapshot doc) {
    print("reached Userchat");
    String photoUrl = "";
    String nickname = "";
    String aboutMe = "";
    String phoneNumber = "";
    try {
      aboutMe = doc.get(FirebaseConstants.aboutMe);
    } catch (e) {
      print("unable to get aboutMe");
    }
    try {
      photoUrl = doc.get(FirebaseConstants.photoUrl);
    } catch (e) {
      print("unable to get photoURL");
    }
    try {
      nickname = doc.get(FirebaseConstants.nickname);
    } catch (e) {
      print("unable to get nickname");
    }
    try {
      phoneNumber = doc.get(FirebaseConstants.phoneNumber);
    } catch (e) {
      print("unable to get phonenumber");
    }
    print("completed usrchat");
    return UserChat(
        id: doc.id,
        aboutMe: aboutMe,
        photoUrl: photoUrl,
        nickname: nickname,
        phoneNumber: phoneNumber);
  }
}
