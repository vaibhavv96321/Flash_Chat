import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  static String id = 'chat_page';
  String peerId;
  String peerAvatar;
  String peerNickname;

  ChatPage(
      {@required this.peerAvatar,
      @required this.peerId,
      @required this.peerNickname});

  @override
  State createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
