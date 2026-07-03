import 'package:apakly/login/login_screen.dart';
import 'package:flutter/material.dart';
import '../auth_globals.dart';
import '../constants.dart';
import '../uicomponents/buttons.dart';
import 'custom_snackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class RecoveryPhraseScreen extends StatefulWidget {
  const RecoveryPhraseScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return RecoveryPhraseScreenState();
  }
}

class RecoveryPhraseScreenState extends State<RecoveryPhraseScreen> {
  bool checkedRead = false;

  Future<String> getRecoveryPhrase() async {
    var recoveryphrase = (await storage.read(key: 'recoveryPhrase'));
    return recoveryphrase!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.of(context)!.verificationsuccesful,
                style: const TextStyle(color: textColor, fontSize: fSize3),
              ),
              Text(
                AppLocalizations.of(context)!.recoveryphrasewarning,
                  style: const TextStyle(
                    color: textColor,
                    fontSize: fSize1,
                  ),
                ),
              FutureBuilder<String>(
                  future: getRecoveryPhrase(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: Text('Please wait its loading...'));
                    } else {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        String recoveryPhrase = snapshot.data!;
                        var recoveryPhraseList = recoveryPhrase.split(" ");

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '1. ${recoveryPhraseList[0]}',
                                    style: const TextStyle(
                                      color: textColor,
                                      fontSize: fSize1,
                                    ),
                                  ),
                                  Text(
                                    '2. ${recoveryPhraseList[1]}',
                                    style: const TextStyle(
                                      color: textColor,
                                      fontSize: fSize1,
                                    ),
                                  ),
                                  Text(
                                    '3. ${recoveryPhraseList[2]}',
                                    style: const TextStyle(
                                      color: textColor,
                                      fontSize: fSize1,
                                    ),
                                  ),
                                  Text(
                                    '4. ${recoveryPhraseList[3]}',
                                    style: const TextStyle(
                                      color: textColor,
                                      fontSize: fSize1,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '5. ${recoveryPhraseList[4]}',
                                    style: const TextStyle(
                                      color: textColor,
                                      fontSize: fSize1,
                                    ),
                                  ),
                                  Text(
                                    '6. ${recoveryPhraseList[5]}',
                                    style: const TextStyle(
                                      color: textColor,
                                      fontSize: fSize1,
                                    ),
                                  ),
                                  Text(
                                    '7. ${recoveryPhraseList[6]}',
                                    style: const TextStyle(
                                      color: textColor,
                                      fontSize: fSize1,
                                    ),
                                  ),
                                  Text(
                                    '8. ${recoveryPhraseList[7]}',
                                    style: const TextStyle(
                                      color: textColor,
                                      fontSize: fSize1,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '9. ${recoveryPhraseList[8]}',
                                    style: const TextStyle(
                                      color: textColor,
                                      fontSize: fSize1,
                                    ),
                                  ),
                                  Text(
                                    '10. ${recoveryPhraseList[9]}',
                                    style: const TextStyle(
                                      color: textColor,
                                      fontSize: fSize1,
                                    ),
                                  ),
                                  Text(
                                    '11. ${recoveryPhraseList[10]}',
                                    style: const TextStyle(
                                      color: textColor,
                                      fontSize: fSize1,
                                    ),
                                  ),
                                  Text(
                                    '12. ${recoveryPhraseList[11]}',
                                    style: const TextStyle(
                                      color: textColor,
                                      fontSize: fSize1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  }),
              SizedBox(
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
                        value: checkedRead,
                        activeColor: Colors.white,
                        checkColor: primaryColor,
                        onChanged: (value) {
                          setState(() {
                            checkedRead = value!;
                          });
                        },
                      ),
                    ),
                    Flexible(
                      child: Text(
                        AppLocalizations.of(context)!.recoveryphrasecheck1,                        style: const TextStyle(
                          color: textColor,
                          fontSize: fSize0,
                        ),
                      ),
                    )
                  ])),
              SizedBox(
                  height: 50.0,
                  width: double.infinity,
                  child: ApaklyElevatedButton(
                    callback: () async {
                      if (!checkedRead) {
                        CustomSnackbar().showSnackbar(
                            context,
                            AppLocalizations.of(context)!.recoveryphrasecheck2,
                        const Icon(
                              Icons.info,
                              color: iconColor,
                            ));
                        return;
                      }
                      await storage.delete(key: 'recoveryPhrase');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    btnText: AppLocalizations.of(context)!.next,
                  )),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
