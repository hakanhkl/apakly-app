import 'package:apakly/objects/song.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../auth_globals.dart';
import '../constants.dart';

class SignedUrlHandler {

  static Future<void> fetchSignedUrl(Song song) async {
    // ask for new URI because each click/stream has to be counted for GEMA
    await fetchNewSignedUrl(song);
  }

  /// this function retrieves a new signed URL from the backend
  static Future<void> fetchNewSignedUrl(Song song) async {
    var jwt = await storage.read(key: 'jwt');
    final response = await http.post(
      Uri.parse("$apiUri/player/getNewSignedUrl"),
      headers: <String, String> {
        'Content-type': 'application/json',
      },
      body: jsonEncode(<String, String>{ 'token': jwt!, 'songId': song.id! }),
    );

    if (response.statusCode == 200) {
      storage.write(key: song.id!, value: jsonDecode(response.body)["signedUrl"]);
      song.signedUrl = await storage.read(key: song.id!);
    } else {
      throw Exception();
    }
  }
}