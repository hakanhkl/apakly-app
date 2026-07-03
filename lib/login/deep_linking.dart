import 'dart:async';

import 'package:apakly/constants.dart';
import 'package:apakly/http/marketplace_requests.dart';
import 'package:apakly/http/token_http.dart';
import 'package:apakly/login/custom_snackbar.dart';
import 'package:apakly/login/login_screen.dart';
import 'package:apakly/login/password_reset_confirm.dart';
import 'package:apakly/marketplace/components/marketplace_item_preview.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;

import '../objects/item.dart';
bool initiallyChecked = false;

Future<void> initUniLinks(BuildContext context) async {
  BuildContext currentContext = context;

  try {
    final initialLink = await getInitialLink();
    if (initialLink != null && initialLink.isNotEmpty && !initiallyChecked) {
      initiallyChecked = true;
      if (initialLink.contains(passwordResetDeepLink)) {
        await checkTokenAndNavigate(initialLink, currentContext);
      } else if (initialLink.contains(sharedSongDeepLink)) {
        navigateToSong(initialLink, currentContext);
      }
    }
  } on PlatformException {
    throw Exception("Failed!");
  }

}

Future<void> navigateToSong(String link, BuildContext currentContext) async {
  String songId = link.substring(link.lastIndexOf("/") + 1);
  Item item = await MarketplaceRequests.getSingle(songId);
  Navigator.push(currentContext, MaterialPageRoute(builder: (context) => MarketplaceItemPreview(id: item.id,)));
}

Future<void> checkTokenAndNavigate(
    String link, BuildContext currentContext) async {
  String token = link.substring(link.lastIndexOf("/") + 1);
  if (await doesTokenExist(token)) {
    Navigator.push(
        currentContext,
        MaterialPageRoute(
            builder: (context) => PasswordResetConfirmScreen(token: token)));
  } else {
    CustomSnackbar().showSnackbar(
        currentContext,
        "Token  existiert nicht oder ist ausgelaufen",
        const Icon(
          Icons.info,
          color: iconColor,
        ));
    Navigator.push(
        currentContext, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
