import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash_chat/screens/Common/screens/option_Screen.dart';
import 'package:flash_chat/screens/Common/screens/splash_screen.dart';
import 'package:flash_chat/screens/new_Chatting_App/Screens/chat_page.dart';
import 'package:flash_chat/screens/new_Chatting_App/additional/providers/auth_provider.dart';
import 'package:flash_chat/screens/new_Chatting_App/additional/providers/chat_provider.dart';
import 'package:flash_chat/screens/new_Chatting_App/additional/providers/settings_provider.dart';
import 'screens/new_Chatting_App/Screens/setting_page.dart';
import 'package:flash_chat/screens/new_Chatting_App/Screens/home_page.dart';
import 'screens/new_Chatting_App/additional/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/Common/screens/welcome_screen.dart';
import 'package:flash_chat/screens/Community_Chat_old/Screens/login_screen.dart';
import 'package:flash_chat/screens/Community_Chat_old/Screens/registration_screen.dart';
import 'package:flash_chat/screens/Community_Chat_old/Screens/chat_screen.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/Common/additional/constants.dart';

bool isLight = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        statusBarColor: lightBLueColor, systemNavigationBarColor: whiteColor),
  );
}

class FlashChat extends StatelessWidget {
  SharedPreferences preferences;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
            create: (_) => AuthProvider(
                googleSignIn: GoogleSignIn(),
                firebaseFirestore: firebaseFirestore,
                firebaseAuth: FirebaseAuth.instance,
                preferences: preferences)),
        Provider<SettingProvider>(
            create: (_) => SettingProvider(
                preferences: this.preferences,
                firebaseStorage: this.firebaseStorage,
                firebaseFirestore: this.firebaseFirestore)),
        Provider<HomeProvider>(
          create: (_) => HomeProvider(firebaseFirestore: firebaseFirestore),
        ),
        Provider<ChatProvider>(
          create: (_) => ChatProvider(
              firebaseStorage: this.firebaseStorage,
              firebaseFirestore: this.firebaseFirestore,
              preferences: this.preferences),
        )
      ],
      child: MaterialApp(
          initialRoute: SplashScreen.id,
          debugShowCheckedModeBanner: false,
          routes: {
            WelcomeScreen.id: (context) => WelcomeScreen(),
            LoginScreen.id: (context) => LoginScreen(),
            OptionScreen.id: (context) => OptionScreen(),
            RegistrationScreen.id: (context) => RegistrationScreen(),
            ChatScreen.id: (context) => ChatScreen(),
            HomePage.id: (context) => HomePage(),
            SplashScreen.id: (context) => SplashScreen(),
            Setting.id: (context) => Setting(),
          }),
    );
  }
}
