
import 'package:apakly/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:apakly/auth_globals.dart';

Future<bool> follow({required artistId}) async {
  var jwt = await storage.read(key: 'jwt');
  final String jsonstring = jsonEncode(<String, String>{
        'token': jwt!,
        'artistId': artistId,
      });

  final response = await http.post(
    Uri.parse("$apiUri/followers/follow"),
    headers: <String, String>{
      'Content-type': 'application/json',
    },
    body: jsonstring,
  );

  if(response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> unfollow({required String artistId}) async {
  var jwt = await storage.read(key: 'jwt');
  final String jsonstring = jsonEncode(<String, String>{
    'token': jwt!,
    'artistId': artistId,
  });

  final response = await http.post(
    Uri.parse("$apiUri/followers/unfollow"),
    headers: <String, String>{
      'Content-type': 'application/json',
    },
    body: jsonstring,
  );

  if(response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> isFollowing(String artistId) async {
  var jwt = await storage.read(key: 'jwt');
  final String jsonstring = jsonEncode(<String, String>{
    'token': jwt!,
    'artistId': artistId,
  });

  final response = await http.post(
    Uri.parse("$apiUri/followers/isFollowing"),
    headers: <String, String>{
      'Content-type': 'application/json',
    },
    body: jsonstring,
  );

  if(response.statusCode == 200) {
    return json.decode(response.body)["isFollowing"];
  } else {
    return false;
  }
}

Future<int> getNumberOfFollowers({required String artistId}) async {
  var jwt = await storage.read(key: 'jwt');
  final String jsonstring = jsonEncode(<String, String>{
    'token': jwt!,
    'artistId': artistId,
  });

  final response = await http.post(
    Uri.parse("$apiUri/followers/getNumberOfFollowers"),
    headers: <String, String>{
      'Content-type': 'application/json',
    },
    body: jsonstring,
  );

  if(response.statusCode == 200) {
    return json.decode(response.body)["numberOfFollowers"];
  } else {
    return 0;
  }
}