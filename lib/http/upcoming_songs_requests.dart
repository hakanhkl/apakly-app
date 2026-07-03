import 'package:apakly/constants.dart';
import 'package:apakly/objects/item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../auth_globals.dart';

class UpcomingSongsRequests {

  static Future<List<Item>> getUpcomingItems() async {
    final response = await http.post(
      Uri.parse("$apiUri/marketplace/getUpcomingItems"),
      headers: <String, String>{
        'Content-type': 'application/json',
      },
      body: jsonEncode(<String, String>{}),
    );

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<Item> items = List<Item>.from(l.map((model) => Item.fromJson(model)));
      return items;
    } else {
      throw Exception();
    }
  }

  /// This function retrieves the artist feed for users, which the user
  /// follows. Currently not relevant for MVP.
  static Future<List<Item>> getFeedForUser() async {
    final response = await http.post(
      Uri.parse("$apiUri/marketplace/listAllItems"),
      headers: <String, String>{
        'Content-type': 'application/json',
      },
      body: jsonEncode(<String, String>{}),
    );

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<Item> items = List<Item>.from(l.map((model) => Item.fromJson(model)));
      return items;
    } else {
      throw Exception();
    }
  }

  static Future<List<Item>> getFeedForArtist(String artistId) async {
    var jwt = await storage.read(key: 'jwt');
    final response = await http.post(
      Uri.parse("$apiUri/feed/getFeedForArtist"),
      headers: <String, String>{
        'Content-type': 'application/json',
      },
      body: jsonEncode(<String, String>{'token': jwt!, 'artistId': artistId}),
    );

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<Item> items = List.from(l.map((model) => Item.fromJson(model)));
      return items;
    } else {
      throw Exception();
    }
  }
}
