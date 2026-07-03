import 'package:apakly/auth_globals.dart';
import 'package:apakly/constants.dart';
import 'package:apakly/login/password_change.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../custom_progress_indicator.dart';
import '../http/auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../login/login_screen.dart';
import '../main.dart';

class UserProfile extends StatefulWidget {

  const UserProfile({
    super.key
  });
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: isJwtValid(),
        builder: (context, isValid) {
          if (isValid.hasData) {
            if (isValid.data!) {
              // jwt is valid
              return Stack(
                  children: [
                    Scaffold(
                      appBar: AppBar(
                        toolbarHeight: 0,
                      ),
                      body: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              child: Row(
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 4, color: textColor),
                                        gradient: LinearGradient(
                                          colors: [Color((math.Random().nextDouble() * 0x9933FF).toInt()).withOpacity(1.0), Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0)],
                                          stops: const [0.25, 0.75],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            spreadRadius: 2,
                                            blurRadius: 10,
                                            color: Colors.black.withOpacity(0.1),
                                          ),
                                        ],
                                        image: const DecorationImage(
                                            scale: 1.5,
                                            fit: BoxFit.contain,
                                            image: AssetImage('images/logo-white-plec.png')
                                        )

                                    ),
                                  ),
                                  const SizedBox(width: 20,),
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${userFirstName!} ${userLastName!}",
                                          style: const TextStyle(
                                            color: textColor,
                                            fontSize: fSize2,
                                          ),
                                        ),
                                        const SizedBox(height: 6,),
                                        Text(
                                          userEmail!,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: fSize0,
                                          ),
                                        ),
                                      ]
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      AppLocalizations.of(context)!.settings,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: fSize1,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  InkWell(
                                    child: ListTile(
                                      leading: const Icon(Icons.wallet_rounded),
                                      title: Text(
                                        AppLocalizations.of(context)!.wallet,
                                        style: const TextStyle(
                                          fontSize: fSize0,
                                        ),
                                      ),
                                    ),
                                    onTap: () => launchUrl(Uri.parse('https://polygonscan.com/address/${userCryptoAddress!}')),
                                  ),
                                  InkWell(
                                    child: ListTile(
                                      leading: const Icon(Icons.change_circle_rounded),
                                      title: Text(
                                        AppLocalizations.of(context)!.changepassword,
                                        style: const TextStyle(
                                          fontSize: fSize0,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PasswordChangeScreen()));
                                    },
                                  ),
                                  InkWell(
                                    child: ListTile(
                                      leading: const Icon(Icons.delete),
                                      title: Text(
                                        AppLocalizations.of(context)!.deleteaccount,
                                        style: const TextStyle(
                                          fontSize: fSize0,
                                        ),
                                      ),
                                    ),
                                    onTap: () => launchUrl(Uri.parse('https://delete.apakly.com/')),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      AppLocalizations.of(context)!.aboutapakly,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: fSize1,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  InkWell(
                                    child: ListTile(
                                      leading: const Icon(Icons.share_rounded),
                                      title: Text(
                                        AppLocalizations.of(context)!.shareapakly,
                                        style: const TextStyle(
                                          fontSize: fSize0,
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      await Share.share("${AppLocalizations.of(context)!.shareapaklytext} https://www.apakly.de/get-apakly ");
                                    },
                                  ),
                                  InkWell(
                                    child: ListTile(
                                      leading: const Icon(Icons.info_rounded),
                                      title: Text(
                                        AppLocalizations.of(context)!.website,
                                        style: const TextStyle(
                                          fontSize: fSize0,
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      if(!await launchUrl(Uri.parse("https://apakly.de"))){
                                        throw Exception("Could not launch");
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30,),
                            Container(
                              color: backgroundColor,
                              height: 100,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 40),
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

                                  onPressed: () async {
                                    await storage.delete(key: 'jwt');
                                    RestartWidget.restartApp(context);
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.logout,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: fSize1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]
              );
            } else {
              // jwt is not valid
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.notloggedin,
                      style: const TextStyle(
                          color: textColor,
                          fontSize: fSize2,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)!.notloggedinprofilesettings,
                      style: const TextStyle(color: textColor, fontSize: fSize0),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 80,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: backgroundColor,
                        ),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                backgroundColor: primaryColor,
                              ),
                              onPressed: () async {
                                RestartWidget.restartApp(context);
                                // Navigator.pushNamed(context, "/login");
                                // context.go("/login");
                              },
                              child: Text(
                                AppLocalizations.of(context)!.tothelogin,
                                style: const TextStyle(
                                  color: textColor,
                                  fontSize: fSize1,
                                ),
                              ),
                            )))
                  ],
                ),
              );
            }
          } else {
            return const CustomProgressIndicator();
          }
        });
  }

  Widget buildButton(BuildContext context, String value, String text) {
    return MaterialButton(
      onPressed: () {  },
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: textColor,
              fontSize: fSize1,
            ),
          ),
          const SizedBox(height: 2,),
          Text(
            text,
            style: const TextStyle(
              color: textColor,
              fontSize: fSize1,
            ),
          ),
          const SizedBox(height: 2,),
        ],
      ),
    );
  }


}
