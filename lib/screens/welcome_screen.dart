import 'package:flutter/material.dart';
import '../widgets/button.dart';
import 'login_screen.dart';
import 'register.dart';

class WelcomeScreen extends StatefulWidget {
  static const String routes = 'welcome_screen';
  const WelcomeScreen({Key? key}) : super(key: key);
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Image.asset(
                'image/logo.png',
                height: 150,
              ),
            ),
            Text(
              "Let's Chat",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: Colors.blue[900],
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            BuildButton(
              color: Colors.yellow[900]!,
              name: "Sign In ",
              onPressed: () {
                Navigator.of(context).pushNamed(SignInScreen.routes);
              },
            ),
            BuildButton(
              color: Colors.blue[900]!,
              name: "Register ",
              onPressed: () {
                Navigator.of(context).pushNamed(RegisterationScreen.routes);
              },
            ),
          ],
        ),
      ),
    );
  }
}
