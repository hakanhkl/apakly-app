//import 'package:apakly/authentication/wizard/contact_data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//Future<ContactData>? user;
String? userFirstName;
String? userLastName;
String? userEmail;
String? userCryptoAddress;

// the storage is used to store the jwt token mainly
const storage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ),
);