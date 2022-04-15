import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/Community_Chat_old/Screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/Common/additional/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String textMessage;
  final textController = TextEditingController();

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  final _auth = FirebaseAuth.instance;

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser);
      }
    } catch (e) {
      print(e);
    }
  }

  // Future<void> sendMesssage() async {
  //   if (textController.text.length > 0) {
  //     String msgId = _firestore.collection("messages").doc('msgId');
  //     await _firestore.collection("messages").document(msgId).setData({
  //       "messageTime": DateTime.now() // message DateTime
  //     });
  //     textController.clear();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          TextButton(
              child: Text(
                'Log Out',
                style: TextStyle(
                  color: whiteColor,
                ),
              ),
              onPressed: () {
                _auth.signOut();
                Navigator.pushNamed(context, LoginScreen.id);
              }),
        ],
        title: Center(child: Text('⚡️Chat')),
        backgroundColor: lightBLueColor,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            BubbleStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onChanged: (value) {
                        textMessage = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      textController.clear();
                      _firestore.collection('messages').add({
                        'text': textMessage,
                        'sender': loggedInUser.email,
                        'timeStamp': DateTime.now(),
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BubbleStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          _firestore.collection('messages').orderBy('timeStamp').snapshots(),
      builder: (context, snapshot) {
        List<Bubble> messageWidgets = [];
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: lightBLueColor,
            ),
          );
        }
        final messages = snapshot.data.docs.reversed;
        for (var message in messages) {
          final textSender = message.get('sender');
          final textMessage = message.get('text');
          final userTime = message.get('timeStamp');
          final currentUser = loggedInUser.email;
          final messageWidget = Bubble(
            text: textMessage,
            time: userTime,
            sender: textSender,
            isMe: currentUser == textSender,
          );
          messageWidgets.add(messageWidget);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

class Bubble extends StatelessWidget {
  Bubble({this.text, this.sender, this.isMe, this.time});

  final String sender;
  final String text;
  final bool isMe;
  final Timestamp time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            elevation: 5,
            color: isMe ? whiteColor : lightBLueColor,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: Text(
                '$text',
                style: TextStyle(
                  fontSize: 17,
                  color: isMe ? Colors.black54 : whiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
