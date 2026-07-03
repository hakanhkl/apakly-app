import 'package:apakly/login/custom_snackbar.dart';
import 'package:apakly/login/login_screen.dart';
import 'package:apakly/login/verification.dart';
import 'package:apakly/uicomponents/buttons.dart';
import 'package:apakly/uicomponents/input_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:apakly/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../http/auth.dart';
import '../strings.dart';
import '../uicomponents/clickable_rich_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SignupForm extends StatefulWidget {
  const SignupForm({
    super.key,
  });

  @override
  SignupFormState createState() {
    return SignupFormState();
  }
}

class SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  String? firstName;
  String? lastName;
  String? password;
  String? email;
  bool isRememberMe = false;
  bool checkedNewsletter = false;
  bool checkedAGB = false;

  Widget buildFirstName() {
    return InputField(
        callbackFunction: (value) {
          firstName = value;
        },
        hint: AppLocalizations.of(context)!.firstname,
        inputType: TextInputType.text,
        callbackValidator: (value) {
          if (value.isNotEmpty &&
              nameRegex.hasMatch(value) &&
              value.length > 1) {
            return null;
          } else {
            return invalidNameErrorText;
          }
        });
  }

  Widget buildLastName() {
    return InputField(
        callbackFunction: (value) {
          lastName = value;
        },
        hint: AppLocalizations.of(context)!.lastname,
        inputType: TextInputType.text,
        callbackValidator: (value) {
          if (value.isNotEmpty &&
              nameRegex.hasMatch(value) &&
              value.length > 1) {
            return null;
          } else {
            return invalidNameErrorText;
          }
        });
  }

  Widget buildEmail() {
    return InputField(
        callbackFunction: (value) {
          email = value;
        },
        hint: AppLocalizations.of(context)!.email,
        inputType: TextInputType.text,
        callbackValidator: (value) {
          if (!EmailValidator.validate(value)) {
            return invalidEmailErrorText;
          }
          return null;
        });
  }

  Widget buildPassword() {
    return PasswordInputField(
      callbackFunction: (value) {
        password = value;
      },
      hint: AppLocalizations.of(context)!.password,
      inputType: TextInputType.visiblePassword,
      callbackValidator: (value) {
        if (value.isEmpty) {
          return passwordErrorInvalidText;
        } else {
          if (!passwordRegex.hasMatch(value)) {
            return passwordErrorInfoText;
          } else {
            return null;
          }
        }
      },
    );
  }

  Widget buildRepeatPassword() {
    return TextField(
      obscureText: true,
      style: const TextStyle(
        fontSize: fSize1,
        color: widgetTextColor,
      ),
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 1.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
        //prefixIcon: Icon(
        //    Icons.email,
        //    color: Color(0xff5ac18e)
        //),
        hintText: AppLocalizations.of(context)!.repeatpassword,
        hintStyle: const TextStyle(
          fontSize: fSize1,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget buildSignupBtn() {
    return SizedBox(
        height: 50.0,
        width: double.infinity,
        child: ApaklyElevatedButton(
            callback: () async {
              if (_formKey.currentState!.validate()) {
                if (!checkedAGB) {
                  CustomSnackbar().showSnackbar(
                      context,
                      AppLocalizations.of(context)!.acceptagbanddata,
                      const Icon(
                        Icons.info,
                        color: iconColor,
                      ));
                  return;
                }
                if (await signup(email!, password!, firstName!, lastName!, checkedNewsletter)) {
                  CustomSnackbar().showSnackbar(
                      context,
                      AppLocalizations.of(context)!.verificationcodesent,
                      const Icon(
                        Icons.info,
                        color: iconColor,
                      ));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Verification(
                              email: email!,
                            )),
                  );
                } else {
                  CustomSnackbar().showSnackbar(
                      context,
                      AppLocalizations.of(context)!.existingemail,
                      const Icon(
                        Icons.info,
                        color: iconColor,
                      ));
                }
              }
            },
            btnText: AppLocalizations.of(context)!.register));
  }

  Widget buildCheckAGB() {
    return SizedBox(
        height: 50,
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
              value: checkedAGB,
              activeColor: Colors.white,
              checkColor: primaryColor,
              onChanged: (value) {
                setState(() {
                  checkedAGB = value!;
                });
              },
            ),
          ),
          Flexible(child:
          ApaklyClickableRichText(
              callback: () {
                launchUrl(Uri.parse("https://apakly.de/datenschutzerklaerung"));
              },
              preText: AppLocalizations.of(context)!.ihaveread,
              clickableText: AppLocalizations.of(context)!.agbandprivacypolicy,
              postText: AppLocalizations.of(context)!.acceptit,
              height: 45),)
        ]));
  }

  Widget buildCheckNewsletter() {
    return SizedBox(
        height: 70,
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
              value: checkedNewsletter,
              activeColor: Colors.white,
              checkColor: primaryColor,
              onChanged: (value) {
                setState(() {
                  checkedNewsletter = value!;
                });
              },
            ),
          ),
          Flexible(
            child:Text(
            AppLocalizations.of(context)!.newsletter,
            style: const TextStyle(
              fontSize: fSize0,
              color: textColor,
            ),
          ),),
        ]));
  }

  Widget apaklyAGB() {
    return Text(
      AppLocalizations.of(context)!.apaklyAGB,
      style: const TextStyle(
        fontSize: fSize1,
        color: Colors.white60,
      ),
    );
  }

  Widget termsOfService() {
    return Container(
        height: 40.0,
        color: Colors.transparent,
        child: TextButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.withOpacity(0),
            elevation: 0.0,
          ),
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.privacypolicy,
              style: const TextStyle(
                fontSize: fSize1,
                color: linkedColor,
              ),
            ),
          ),
        ));
  }

  Widget buildScreenTitle() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Text(
        AppLocalizations.of(context)!.register,
        style: const TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: fSize2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildScreenTitle(),
          const SizedBox(height: 20),
          buildFirstName(),
          const SizedBox(height: 20),
          buildLastName(),
          const SizedBox(height: 20),
          buildEmail(),
          const SizedBox(height: 20),
          buildPassword(),
          const SizedBox(height: 20),
          buildCheckAGB(),
          const SizedBox(height: 20),
          buildCheckNewsletter(),
          const SizedBox(height: 20),
          buildSignupBtn(),
          const SizedBox(height: 20),
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
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: Text(
                AppLocalizations.of(context)!.login,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: fSize1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
