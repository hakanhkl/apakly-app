import 'package:apakly/login/custom_snackbar.dart';
import 'package:apakly/login/password_reset.dart';
import 'package:apakly/login/verification.dart';
import 'package:apakly/uicomponents/buttons.dart';
import 'package:apakly/uicomponents/input_field.dart';
import 'package:flutter/material.dart';
import 'package:apakly/constants.dart';
import '../http/auth.dart';
import '../home/homescreen.dart';
import '../uicomponents/clickable_rich_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


// Define a custom Form widget.
class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {

  void updatePassword(String newText) {
    setState(() {
      password = newText;
    });
  }

  final _formKey = GlobalKey<FormState>();
  String? password;
  String? email;

  bool isRememberMe = false;

  Widget buildEmail() {
    return TextFormField(
      cursorColor: textColor,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(fontSize: fSize1, color: textColor),
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.black54,
        focusColor: primaryColor,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 1.0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3.0),
        ),
        hintText: 'E-Mail',
        hintStyle: TextStyle(fontSize: fSize1, color: Colors.grey),
      ),
      onChanged: (value) {
        email = value;
      },
    );
  }

  Widget buildPassword() {
    return TextFormField(
      cursorColor: textColor,
      obscureText: true,
      style: const TextStyle(fontSize: fSize1, color: textColor),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black54,
        focusColor: primaryColor,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 1.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
        hintText:  AppLocalizations.of(context)!.password,
        hintStyle: const TextStyle(
          fontSize: fSize1,
          color: Colors.grey,
        ),
      ),
      onChanged: (value) {
        password = value;
      },
    );
  }

  Widget buildForgotPwBtn() {
    return Center(
      child: ApaklyClickableRichText(
        callback: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PasswordResetScreen()),
          );
          },
        preText: AppLocalizations.of(context)!.forgotpassword,
        clickableText: AppLocalizations.of(context)!.resetpassword,
        postText: '',
        height: 45,
      ),
    );
  }

  Widget buildRememberCb() {
    return SizedBox(
        height: 20,
        child: Row(children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(3),
                topRight: Radius.circular(3),
                bottomLeft: Radius.circular(3),
                bottomRight: Radius.circular(3),
              )),
              value: isRememberMe,
              activeColor: Colors.white,
              checkColor: primaryColor,
              onChanged: (value) {
                setState(() {
                  isRememberMe = value!;
                });
              },
            ),
          ),
          Text(
            AppLocalizations.of(context)!.rememberme,
            style: const TextStyle(
              fontSize: fSize1,
              color: textColor,
            ),
          ),
        ]));
  }

  Widget buildLoginBtn() {
    return SizedBox(
        height: 50.0,
        width: double.infinity,
        child: ApaklyElevatedButton(
            callback: () {
              if (_formKey.currentState!.validate()) {
                Future<int> res = login(email!, password!);
                res.then((value) => {
                      if (value == 1)
                        {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()))
                        }
                      else if (value == 2)
                        {
                          CustomSnackbar().showSnackbar(
                              context,
                              '${AppLocalizations.of(context)!.usernotverified} \n ${AppLocalizations.of(context)!.codesent}',
                              const Icon(
                                Icons.info,
                                color: iconColor,
                              )),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Verification(email: email!)))
                        } else {
                          // User email or password wrong
                          CustomSnackbar().showSnackbar(
                              context,
                              AppLocalizations.of(context)!.emailorpasswordwrong,
                              const Icon(
                                Icons.info,
                                color: iconColor,
                              ))
                        }
                    });
              }
            },
            btnText: AppLocalizations.of(context)!.login));
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Email field
          Center(
            child: Image.asset(
              'images/logo.png',
              height: 100,
            ),
          ),
          const SizedBox(height: 60),
          buildEmail(),
          const SizedBox(height: 20),
          PasswordInputField(
              callbackFunction: updatePassword,
              hint: AppLocalizations.of(context)!.password,
              inputType: TextInputType.visiblePassword),
          const SizedBox(height: 20),
          buildLoginBtn(),
          const SizedBox(height: 20),
          buildForgotPwBtn(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
