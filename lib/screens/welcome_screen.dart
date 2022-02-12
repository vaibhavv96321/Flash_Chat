import 'package:flash_chat/screens/home_page.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/roundedButtons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

Animation borderanimation;

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  final GoogleSignIn googleSignin = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;
  SharedPreferences preferences;

  bool isLoggedIn = false;
  bool isLoading = false;
  User currentUser;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    //here i am making a COlorTween it is basically changes to one color to other and there are many more Tweens on the flutter documentation make sure to chek them out.
    animation = ColorTween(
      begin: Colors.blueGrey,
      end: Colors.white,
    ).animate(controller);

    borderanimation = BorderRadiusTween(
      begin: BorderRadius.circular(5),
      end: BorderRadius.circular(35),
    ).animate(controller);

    //this is the CurvedAnimation animation to change the value according to the curves option available there
    // animation = CurvedAnimation(
    //   parent: controller,
    //   curve: Curves.decelerate,
    // );
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
    isSingedIn();
  }

  void isSingedIn() async {
    this.setState(() {
      isLoggedIn = true;
    });

    preferences = await SharedPreferences.getInstance();

    isLoggedIn = await googleSignin.isSignedIn();
    if (isLoggedIn) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomePage(currentUserId: preferences.getString("id"))));
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, RegistrationScreen.id);
                          },
                          child: Image.asset('images/logo.png')),
                      height: 60,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Flash Chat',
                          speed: Duration(milliseconds: 250),
                          textStyle: TextStyle(
                            fontSize: 45.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 48.0,
              ),
              Buttons(
                text: 'Log In',
                color: Colors.lightBlueAccent,
                pushedName: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                borderAnimation: borderanimation.value,
              ),
              Buttons(
                  text: 'Register',
                  color: Colors.blueAccent,
                  pushedName: () {
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  },
                  borderAnimation: borderanimation.value),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 75),
                child: GestureDetector(
                    child: Center(
                        child: Text(
                      'Sign in with Google',
                      style: TextStyle(
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                      ),
                    )),
                    onTap: controlSignIn),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> controlSignIn() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    GoogleSignInAccount googleUser = await googleSignin.signIn();
    GoogleSignInAuthentication googleAuthentication =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuthentication.idToken,
        accessToken: googleAuthentication.accessToken);

    User firebaseUser = (await auth.signInWithCredential(credential)).user;

    //SignIn Success
    if (firebaseUser != null) {
      final QuerySnapshot resultQuery = await FirebaseFirestore.instance
          .collection('messages')
          .where('sender', isEqualTo: firebaseUser.uid)
          .get();
      final List<DocumentSnapshot> documentSnapshot = resultQuery.docs;
      if (documentSnapshot.length == 0) {
        //that the user is new and we have to store the information
        FirebaseFirestore.instance
            .collection("messages")
            .doc(firebaseUser.uid)
            .set({
          "nickname": firebaseUser.displayName,
          "photoUrl": firebaseUser.photoURL,
          "sender": firebaseUser.uid,
          "aboutMe": "i am using Vaibhav's Chatting App",
          "createdAt": DateTime.now().millisecondsSinceEpoch,
          "chattingWith": null,
        });
        currentUser = firebaseUser;
        await preferences.setString("sender", currentUser.uid);
        await preferences.setString("nickname", currentUser.displayName);
        await preferences.setString("photoUrl", currentUser.photoURL);
      } else {
        //write data to local
        currentUser = firebaseUser;
        await preferences.setString('sender', documentSnapshot[0]["sender"]);
        await preferences.setString(
            'nickname', documentSnapshot[0]["nickname"]);
        await preferences.setString(
            'photoUrl', documentSnapshot[0]["photoUrl"]);
        await preferences.setString('aboutMe', documentSnapshot[0]["aboutMe"]);
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('SignIn Success!'),
        duration: Duration(seconds: 2),
      ));
      setState(() {
        isLoading = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    currentUserId: firebaseUser.uid,
                  )));
    }
    //Sign Failed
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('SignIn Failed! Try Again.'),
        duration: Duration(seconds: 2),
      ));
      setState(() {
        isLoading = false;
      });
    }
  }
}
