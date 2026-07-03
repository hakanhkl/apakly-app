import 'dart:async';

import 'package:atomsbox/atomsbox.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

// TEST
// const apiUri = "http://test-api.apakly-app.com";

// LIVE
const apiUri = "https://api.apakly-app.com";

// const apiUri = "http://192.168.178.21:8080";

// TODO: load from a secure config / CI secret before shipping a real build.
const stripePublishableKey = "pk_test_YOUR_STRIPE_PUBLISHABLE_KEY";

const appLTDark = AppListTileThemeData(
  backgroundColor: backgroundColor,
  foregroundColor: primaryColor,
  splashColor: primaryColor,
);

const appLDark = AppLabelThemeData(
  backgroundColor: backgroundColor,
  foregroundColor: primaryColor,
);

ThemeData themeData = ThemeData(
  fontFamily: 'Poppins',
  appBarTheme: const AppBarTheme(
      elevation: 0,
      surfaceTintColor: Colors.black,
      color: backgroundColor,
  ),
  scaffoldBackgroundColor: backgroundColor,
  primarySwatch: Colors.purple,
  primaryColor: backgroundColor,
  cardColor: backgroundColor,
  canvasColor: backgroundColor,
  dividerColor: backgroundColor,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    background: backgroundColor,
    primary: primaryColor,
    secondary: primaryColor,
    onPrimary: primaryColor,
    onSecondary: Colors.yellow,
    error: Colors.red,
    onError: Colors.orange,
    onBackground: backgroundColor,
    surface: Colors.grey,
    onSurface: textColor,
  ),
  extensions: const <ThemeExtension<dynamic>>[appLTDark, appLDark],
);

const backgroundColor = Color(0xFF232323);
const backgroundColorFade = Color(0xFF232323);
const primaryColor = Color(0xFF9933FF);
const textColor = Color(0xFFFFFFFF);
const softTextColor = Color(0xFFB6B6B6);
const linkedColor = Color(0xFF9966FF);

const textColor2 = Colors.black87;
const iconColor = Color(0xFFFFFFFF);

const widgetColor = Color(0xFFFFFFFF);
const shadowColor = Colors.black26;
const purchaseDialogColor = Colors.black26;
const widgetTextColor = Colors.black26;
const checkedBoxColor = Colors.white;
const buttonColor = Color(0xFFE0E0E0);
const boxColor = Color(0xFF9933FF);


const fSize0 = 12.0;
const fSize1 = 14.0;
const fSize2 = 18.0;
const fSize3 = 22.0;
const fSize4 = 26.0;
const iconSize = 12.0;

AudioPlayer previewplayer = AudioPlayer();


const passwordResetDeepLink = "passwordreset";
const sharedSongDeepLink = "sharesong";

var passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!#$%()*+,\-./:;=?@<>\]\[^_{|}~]).{8,}$');
var nameRegex = RegExp(r'[a-z A-Z]+$');