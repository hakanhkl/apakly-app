import 'package:flutter/material.dart';
import '../http/auth.dart';
import '../config/size_config.dart';
import '../uicomponents/clickable_rich_text.dart';
import 'login_screen.dart';
import 'signup_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});
  String? email;
  String? password;

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isRememberMe = false;

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.white,
    padding: const EdgeInsets.only(right: 2),
  );

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.purple;
  }

  Widget buildLoginBtn() {
    return Container(
        height: 60,
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: ApaklyClickableRichText(
                  callback: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()
                      ),
                    );
                  },
                  preText: AppLocalizations.of(context)!.youhaveanaccount,
                  clickableText: AppLocalizations.of(context)!.login,
                  postText: '',
                  height: 45
              ),
            ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    isJwtValid()
        .then((value) => value ? Navigator.pushNamed(context, '/home') : null);
    SizeConfig().init(context);

    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          minimum: EdgeInsets.only(
            left: 35,
            right: 35,
            top: 60,
            bottom: 60,
          ),
          child: SingleChildScrollView(
            child: SignupForm(),
          )
      ),
    );
  }
}
