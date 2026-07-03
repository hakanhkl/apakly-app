import 'package:apakly/home/homescreen.dart';
import 'package:apakly/login/signup_screen.dart';
import 'package:apakly/uicomponents/clickable_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:apakly/constants.dart';
import 'package:flutter/services.dart';

import 'login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.white,
    padding: const EdgeInsets.only(right: 1.0),
  );

  Widget buildSignUpBtn() {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: ApaklyClickableRichText(
              callback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                );
              },
              preText: 'Du hast noch keinen Account? ',
              clickableText: 'Registrieren',
              postText: '',
              height: 45),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      backgroundColor,
                      backgroundColorFade,
                    ],
                    stops: [
                      0.4,
                      1.0,
                    ],
                  )),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 30,
                      right: 30,
                      top: 60,
                      bottom: 60,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const LoginForm(),
                        //buildRememberCb(),

                        Container(
                          color: backgroundColor,
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: backgroundColor,
                                shape: RoundedRectangleBorder(side: const BorderSide(
                                  color: primaryColor,
                                  width: 1,
                                ),
                                    borderRadius: BorderRadius.circular(50)),
                              ),

                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignupScreen()),
                                );
                              },
                              child: const Text(
                                'Jetzt registrieren',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: fSize1,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 10,),
                        Container(
                          color: backgroundColor,
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: backgroundColor,
                                shape: RoundedRectangleBorder(side: const BorderSide(
                                  color: primaryColor,
                                  width: 1,
                                ),
                                    borderRadius: BorderRadius.circular(50)),
                              ),

                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                                );
                              },
                              child: const Text(
                                'Ohne Anmeldung fortfahren',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: fSize1,
                                ),
                              ),
                            ),
                          ),

                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
