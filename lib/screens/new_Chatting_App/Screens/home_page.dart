import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/Common/additional/constants.dart';
import 'package:flash_chat/main.dart';
import 'package:flash_chat/screens/new_Chatting_App/additional/providers/auth_provider.dart';
import 'package:flash_chat/screens/new_Chatting_App/additional/user_chat.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../additional/popUp__debouncer.dart';
import '../../Common/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import '../additional/providers/home_provider.dart';
import '../additional/utilities.dart';
import 'chat_page.dart';
import 'setting_page.dart';

class HomePage extends StatefulWidget {
  final String currentUserId;

  static String id = 'home_page';
  HomePage({Key key, this.currentUserId}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController listScrollController = ScrollController();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  int _limit = 20;
  int _limitIncrement = 20;
  String textSearch = "";
  bool isLoading = false;

  String currentUserId;
  AuthProvider authProvider;
  HomeProvider homeProvider;
  Debouncer searchDebouncer = Debouncer(milliseconds: 300);
  StreamController<bool> btnClearController = StreamController<bool>();
  TextEditingController searchEditingConroller = TextEditingController();
  List<PopUpChoices> choices = <PopUpChoices>[
    PopUpChoices(icon: Icons.settings, title: 'Settings'),
    PopUpChoices(icon: Icons.exit_to_app, title: 'Sign Out')
  ];

  void scrollListener() {
    if (listScrollController.offset ==
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void onItemMenuPress(PopUpChoices choice) {
    if (choice.title == 'Sign Out') {
      choice.logoutUser();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => WelcomeScreen()),
          (Route<dynamic> route) => false);
    } else {
      Navigator.pushNamed(context, Setting.id);
    }
  }

  Future<bool> onBackPress() {
    openDialog();
    return Future.value(false);
  }

  Future<void> openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            clipBehavior: Clip.hardEdge,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                color: lightBLueColor,
                padding: EdgeInsets.only(bottom: 10, top: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.exit_to_app,
                        size: 30,
                        color: whiteColor,
                      ),
                      margin: EdgeInsets.only(bottom: 10),
                    ),
                    Text(
                      'Band Karna Hai!',
                      style: TextStyle(
                          color: whiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Sach Mei?',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.cancel,
                        color: lightBLueColor,
                      ),
                      margin: EdgeInsets.only(right: 10),
                    ),
                    Text(
                      'Na Na',
                      style: TextStyle(
                          color: lightBLueColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle,
                        color: lightBLueColor,
                      ),
                      margin: EdgeInsets.only(right: 10),
                    ),
                    Text(
                      'Haan nini tame h',
                      style: TextStyle(
                          color: lightBLueColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        exit(0);
    }
  }

  Widget buildPopUpMenu() {
    return PopupMenuButton<PopUpChoices>(
        icon: Icon(
          Icons.more_vert,
          color: Colors.grey,
        ),
        onSelected: onItemMenuPress,
        itemBuilder: (BuildContext context) {
          return choices.map((PopUpChoices choice) {
            return PopupMenuItem<PopUpChoices>(
              value: choice,
              child: Row(
                children: <Widget>[
                  Icon(
                    choice.icon,
                    color: Colors.grey,
                  ),
                  Container(
                    width: 10,
                  ),
                  Text(
                    choice.title,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }).toList();
        });
  }

  @override
  void dispose() {
    super.dispose();
    btnClearController.close();
  }

  @override
  void initState() {
    super.initState();
    authProvider = context.read<AuthProvider>();
    homeProvider = context.read<HomeProvider>();

    if (authProvider.getUserFirebaseId()?.isNotEmpty == true) {
      currentUserId = authProvider.getUserFirebaseId();
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
          WelcomeScreen.id, (Route<dynamic> route) => false);
    }
    listScrollController.addListener(scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isLight ? lightBLueColor : Colors.blueGrey,
        leading: IconButton(
          icon: Switch(
            value:
                isLight, // here i have to assign if the theme is dark or white that i will implement later
            onChanged: (value) {
              setState(() {
                isLight = value;
              });
            },
            activeTrackColor: Colors.grey,
            activeColor: Colors.white,
            inactiveTrackColor: Colors.grey,
            inactiveThumbColor: Colors.black38,
          ),
          onPressed: () => "",
        ),
        actions: [
          buildPopUpMenu(),
        ],
      ),
      body: WillPopScope(
        onWillPop: onBackPress,
        child: Stack(
          children: [
            Column(
              children: [
                buildSearchBar(),
                Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                  stream: homeProvider.getStreamFirestore(
                      FirebaseConstants.pathUserCollection, _limit, textSearch),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      if ((snapshot.data.docs.length ?? 0) > 0) {
                        return ListView.builder(
                          itemBuilder: (context, index) =>
                              buildItem(context, snapshot.data.docs[index]),
                          itemCount: snapshot.data.docs.length,
                          controller: listScrollController,
                        );
                      } else {
                        return Center(
                          child: Text(
                            'nahi mila bhai...',
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.grey,
                        ),
                      );
                    }
                  },
                ))
              ],
            ),
            Positioned(
                child:
                    isLoading ? CircularProgressIndicator() : SizedBox.shrink())
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            color: Colors.grey,
            size: 20,
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
              child: TextField(
            textInputAction: TextInputAction.search,
            controller: searchEditingConroller,
            onChanged: (value) {
              if (value != null) {
                btnClearController.add(true);
                setState(() {
                  textSearch = value;
                });
              } else {
                btnClearController.add(false);
                setState(() {
                  textSearch = value;
                });
              }
            },
            decoration: InputDecoration.collapsed(
                hintText: "Search here...",
                hintStyle: TextStyle(fontSize: 13, color: Colors.grey)),
            style: TextStyle(fontSize: 13),
          )),
          StreamBuilder(
              stream: btnClearController.stream,
              builder: (context, snapshot) {
                return snapshot.data == true
                    ? GestureDetector(
                        onTap: () {
                          searchEditingConroller.clear();
                          btnClearController.add(false);
                          setState(() {
                            textSearch = "";
                          });
                        },
                        child: Icon(
                          Icons.clear_rounded,
                          color: Colors.grey,
                          size: 20,
                        ),
                      )
                    : SizedBox.shrink();
              })
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: Colors.grey.shade300),
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document != null) {
      UserChat userChat = UserChat.fromDocument(document);
      if (userChat.id == currentUserId) {
        return SizedBox.shrink();
      } else {
        return Container(
          child: TextButton(
            child: Row(
              children: <Widget>[
                Material(
                  child: userChat.photoUrl.isNotEmpty
                      ? Image.network(
                          userChat.photoUrl,
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                  color: Colors.grey,
                                  value: loadingProgress.expectedTotalBytes !=
                                              null &&
                                          loadingProgress.expectedTotalBytes !=
                                              null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes
                                      : null),
                            );
                          },
                          errorBuilder: (context, object, stackTrace) {
                            return Icon(
                              Icons.account_circle,
                              size: 50,
                              color: Colors.black38,
                            );
                          },
                        )
                      : Icon(
                          Icons.account_circle,
                          size: 50,
                          color: Colors.black38,
                        ),
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  clipBehavior: Clip.hardEdge,
                ),
                Flexible(
                    child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          '${userChat.nickname}',
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 5),
                      ),
                      Container(
                        child: Text(
                          '${userChat.aboutMe}',
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.black38,
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20),
                ))
              ],
            ),
            onPressed: () {
              if (Utilities.isKeyboardShowing()) {
                Utilities.closeKeyboard(context);
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatPage(
                          peerAvatar: userChat.photoUrl,
                          peerId: userChat.id,
                          peerNickname: userChat.nickname)));
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.grey.withOpacity(0.2)),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ))),
          ),
          margin: EdgeInsets.only(bottom: 10, left: 5, right: 5),
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }
}
