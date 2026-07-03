import 'package:flutter/material.dart';

import '../constants.dart';
import '../http/token_http.dart';
import '../uicomponents/input_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  String? password;
  String? email;

  Widget buildSendBtn() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: 50.0,
        width: double.infinity,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              await sendPasswordResetEmail(email!);
              Navigator.of(context).pop();
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.passwordresetlink,
                  style: const TextStyle(
                      fontSize: fSize1,
                      color: textColor,
                      fontFamily: 'primFont'
                  ),
                ),
              ),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void updateMail(String newText) {
      setState(() {
        email = newText;
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
                InputField(
                    callbackFunction: updateMail,
                    hint: AppLocalizations.of(context)!.email,
                    inputType: TextInputType.emailAddress),
                buildSendBtn(),
              ],
            ),
          )),
    );
  }
}
