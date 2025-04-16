import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  @override
  void initState() {
    Timer(const Duration(seconds: 1), () => handleSplashScreen(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/launcher/foreground.png',
              width: 200,
              height: 200,
            ),
          ),
        ],
      ),
    );
  }

  //handle splash screen
  void handleSplashScreen(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final bool? firstTime = prefs.getBool('first_time');

    if (firstTime == null || firstTime) {
      await prefs.setBool('first_time', false);
      if (context.mounted) {
        Navigator.of(context).pushNamed('onboarding');
      }
    } else {
      if (context.mounted) {
        Navigator.of(context).pushNamed('nav');
      }
    }
  }
}