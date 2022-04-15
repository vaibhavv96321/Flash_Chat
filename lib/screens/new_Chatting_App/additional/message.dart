import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/screens/Common/additional/constants.dart';
import 'package:flutter/cupertino.dart';

class MessageChat {
  String idFrom;
  String idTo;
  String timeStamp;
  String content;
  int type;

  MessageChat({
    @required this.content,
    @required this.idFrom,
    @required this.idTo,
    @required this.timeStamp,
    @required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      FirebaseConstants.idFrom: this.idFrom,
      FirebaseConstants.idTo: this.idTo,
      FirebaseConstants.timeStamp: this.timeStamp,
      FirebaseConstants.content: this.content,
      FirebaseConstants.type: this.type,
    };
  }

  factory MessageChat.fromDocument(DocumentSnapshot doc) {
    String idFrom = doc.get(FirebaseConstants.idFrom);
    String idTo = doc.get(FirebaseConstants.idTo);
    String timeStamp = doc.get(FirebaseConstants.timeStamp);
    String content = doc.get(FirebaseConstants.content);
    int type = doc.get(FirebaseConstants.type);

    return MessageChat(
        content: content,
        idFrom: idFrom,
        idTo: idTo,
        timeStamp: timeStamp,
        type: type);
  }
}
