import 'package:flutter/material.dart';

import '../constants.dart';
import '../http/token_http.dart';
import '../uicomponents/input_field.dart';

class PasswordResetConfirmScreen extends StatefulWidget {
  final String token;

  const PasswordResetConfirmScreen({Key? key, required this.token})
      : super(key: key);

  @override
  _PasswordResetConfirmScreenState createState() =>
      _PasswordResetConfirmScreenState();
}

class _PasswordResetConfirmScreenState
    extends State<PasswordResetConfirmScreen> {
  final _formKey = GlobalKey<FormState>();
  String password = "";
  String repeatPassword = "";
  bool doPasswordsMatch = false;

  Widget buildSaveBtn() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: 50.0,
        width: double.infinity,
        child: ElevatedButton(
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Center(
                child: Text(
                  'Speichern',
                  style: TextStyle(
                      fontSize: fSize1,
                      color: textColor,
                      fontFamily: 'primFont'),
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.white)),
            ),
            onPressed: !doPasswordsMatch
                ? null
                : () async {
                  await setNewPassword(widget.token, password);
                    Navigator.of(context).popAndPushNamed('/login');
                  }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    String? passwordValidator(String value) {
      if (value.isEmpty) {
        return 'Please enter password';
      } else {
        if (!passwordRegex.hasMatch(value)) {
          return 'Your password must contain at least 8 characters, one uppercase and one lowercase letter and one special character.';
        } else {
          return null;
        }
      }
    }

    void updatePassword(String newText) {
      setState(() {
        if (password.isNotEmpty && repeatPassword.isNotEmpty) {
          if (repeatPassword != newText) {
            doPasswordsMatch = false;
          } else {
            if (passwordRegex.hasMatch(password) && passwordRegex.hasMatch(repeatPassword)) {
              doPasswordsMatch = true;
            } else {
              doPasswordsMatch = false;
            }
          }
        }
        password = newText;
      });
    }

    void updateRepeatPassword(String newText) {
      setState(() {
        if (password.isNotEmpty && repeatPassword.isNotEmpty) {
          if (password != newText) {
            doPasswordsMatch = false;
          } else {
            if (passwordRegex.hasMatch(password) && passwordRegex.hasMatch(repeatPassword)) {
              doPasswordsMatch = true;
            } else {
              doPasswordsMatch = false;
            }
          }
        }
        repeatPassword = newText;
      });
    }

    return Scaffold(
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 60),
                PasswordInputField(
                  callbackFunction: updatePassword,
                  hint: 'Passwort',
                  inputType: TextInputType.visiblePassword,
                  callbackValidator: passwordValidator,
                ),
                const SizedBox(height: 20),
                PasswordInputField(
                    callbackFunction: updateRepeatPassword,
                    hint: 'Passwort wiederholen',
                    inputType: TextInputType.visiblePassword,
                    callbackValidator: passwordValidator),
                buildSaveBtn(),
              ],
            ),
          )),
    );
  }
}
