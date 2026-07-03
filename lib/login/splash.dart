import 'dart:async';
import 'dart:io';

import 'package:apakly/home/homescreen.dart';
import 'package:apakly/login/login_screen.dart';
import 'package:atomsbox/atomsbox.dart';
import 'package:flutter/material.dart';
import '../http/auth.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    navigatetohome();
  }

  navigatetohome() async {

    bool isValid = await isJwtValid();
    if (isValid) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: ((context) => const HomeScreen())));
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: ((context) => LoginScreen())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText.headlineLarge("test splash")
          ],
        )));
  }
}
