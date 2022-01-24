import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/screens/login_screen.dart';
import 'package:lets_chat/screens/register.dart';
import 'screens/chat_screen.dart';
import 'screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lets chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const ChatScreen(),
      initialRoute:
          _auth.currentUser != null ? ChatScreen.routes : WelcomeScreen.routes,
      routes: {
        WelcomeScreen.routes: (context) => const WelcomeScreen(),
        SignInScreen.routes: (context) => const SignInScreen(),
        RegisterationScreen.routes: (context) => const RegisterationScreen(),
        ChatScreen.routes: (context) => const ChatScreen(),
      },
    );
  }
}
