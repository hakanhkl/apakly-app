import 'package:apakly/constants.dart';
import 'package:apakly/objects/artist.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ArtistRequests {
  static Future<List<Artist>> getAllArtists() async {
    final response = await http.get(
      Uri.parse("$apiUri/artist/getAllArtists"),
      headers: <String, String> {
        'Content-type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<Artist> artists = List<Artist>.from(l.map((model) => Artist.fromJson(model)));
      return artists;
    } else {
      throw Exception();
    }
  }
  static Future<Artist> getArtistProfileInformation(String id) async {
    final response = await http.get(
      Uri.parse("$apiUri/artist/read/$id"),
      headers: <String, String> {
        'Content-type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      Artist artist = Artist.fromJson(json.decode(response.body));
      return artist;
    } else {
      throw Exception();
    }
  }
}