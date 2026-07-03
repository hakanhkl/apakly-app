import 'package:apakly/constants.dart';
import 'package:apakly/objects/album.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../auth_globals.dart';
import '../objects/item.dart';
import '../objects/single.dart';

class PlayerRequests {

  /// Returns a list of [{item, artist, song, signedUrl}, ...]
  /// Songs are directly added into playlist
  static Future<List<Single>> getSinglesForOwner() async {

    // print("calling singes");
    var jwt = await storage.read(key: 'jwt');
    final response = await http.post(
      Uri.parse("$apiUri/player/getSinglesForOwner"),
      headers: <String, String> {
        'Content-type': 'application/json',
      },
      body: jsonEncode(<String, String>{ 'token': jwt! }),
    );

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<Single> singles = List<Single>.from(l.map((data) => Item.fromJson(data)));
      return singles;
    } else {
      throw Exception();
    }
  }

  /// Returns a list of albums
  /// [{item, artist, [songs]}, ...]
  static Future<List<Album>> getAlbumsForOwner() async {
    var jwt = await storage.read(key: 'jwt');
    final response = await http.post(
      Uri.parse("$apiUri/player/getAlbumsForOwner"),
      headers: <String, String> {
        'Content-type': 'application/json',
      },
      body: jsonEncode(<String, String>{'token': jwt!}),
    );
    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<Album> albums = List<Album>.from(l.map((model) => Item.fromJson(model)));
      return albums;
    } else {
      throw Exception();
    }
  }
}