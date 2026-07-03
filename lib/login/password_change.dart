import 'package:apakly/http/auth.dart';
import 'package:apakly/login/custom_snackbar.dart';
import 'package:apakly/login/login_screen.dart';
import 'package:apakly/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../auth_globals.dart';
import '../constants.dart';
import '../uicomponents/input_field.dart';

class PasswordChangeScreen extends StatefulWidget {
  const PasswordChangeScreen({super.key});

  @override
  _PasswordChangeScreenState createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final _formKey = GlobalKey<FormState>();
  String password = "";
  String repeatPassword = "";
  bool doPasswordsMatch = false;
  bool isPasswordValid = false;

  Widget buildSaveBtn() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: 50.0,
        width: double.infinity,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              if (doPasswordsMatch && isPasswordValid) {
                await changePassword(userEmail!, password);
                CustomSnackbar().showSnackbar(
                    context,
                    AppLocalizations.of(context)!.passwordchangedsuccesfully,
                    const Icon(
                      Icons.info,
                      color: iconColor,
                    ));
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              } else {
                CustomSnackbar().showSnackbar(context, AppLocalizations.of(context)!.typecorrectpassword , const Icon(
                  Icons.warning_amber_outlined,
                  color: iconColor,
                ));
              }
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.save,
                  style: const TextStyle(
                      fontSize: fSize1,
                      color: textColor,
                      fontFamily: 'primFont'
                  ),
                ),
              ),
            )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? passwordValidator(String value) {
      if (value.isEmpty) {
        isPasswordValid = false;
        return AppLocalizations.of(context)!.pleaseenterpassword;
      } else {
        if (!passwordRegex.hasMatch(value)) {
          isPasswordValid = false;
          return passwordErrorInfoText;
        } else {
          isPasswordValid = true;
          return null;
        }
      }
    }

    void updatePassword(String newText) {
      setState(() {
        password = newText;
        if (password == repeatPassword) {
          doPasswordsMatch = true;
        } else {
          doPasswordsMatch = false;
        }
      });
    }

    void updateRepeatPassword(String newText) {
      setState(() {
        repeatPassword = newText;
        if (password == repeatPassword) {
          doPasswordsMatch = true;
        } else {
          doPasswordsMatch = false;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: iconColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 60),
                PasswordInputField(
                  callbackFunction: updatePassword,
                  hint: AppLocalizations.of(context)!.password,
                  inputType: TextInputType.visiblePassword,
                  callbackValidator: passwordValidator,
                ),
                const SizedBox(height: 20),
                PasswordInputField(
                    callbackFunction: updateRepeatPassword,
                    hint: AppLocalizations.of(context)!.repeatpassword,
                    inputType: TextInputType.visiblePassword,
                    callbackValidator: passwordValidator),
                buildSaveBtn(),
              ],
            ),
          )),
    );
  }
}
