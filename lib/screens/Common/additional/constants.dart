import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: lightBLueColor,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const lightBLueColor = Colors.lightBlueAccent;
const whiteColor = Colors.white;
const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: lightBLueColor, width: 2.0),
  ),
);

const kFieldstyle = TextStyle(
  color: Colors.black,
);

InputDecoration fieldDecoration(String fillText) {
  return InputDecoration(
    hintText: fillText,
    hintTextDirection: TextDirection.ltr,
    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 17),
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: lightBLueColor, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: lightBLueColor, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
  );
}

class FirebaseConstants {
  static const pathUserCollection = "users";
  static const pathMessageCollection = "messages";
  static const nickname = 'nickname';
  static const aboutMe = 'aboutMe';
  static const photoUrl = 'photoUrl';
  static const phoneNumber = 'phoneNumber';
  static const id = 'id';
  static const chattingFrom = 'chattingFrom';
  static const idFrom = 'idFrom';
  static const idTo = 'idTo';
  static const timeStamp = 'timeStamp';
  static const content = 'content';
  static const type = 'type';
}
