import 'dart:async';

import 'package:apakly/constants.dart';
import 'package:apakly/objects/album.dart';
import 'package:apakly/objects/item.dart';
import 'package:apakly/objects/song.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:retry/retry.dart';

import '../auth_globals.dart';
import '../objects/single.dart';

class MarketplaceRequests {
  //Song => Single
  static Future<Item> getSingle(String id) async {
    final response = await http.post(
      Uri.parse("$apiUri/marketplace/getSingleOrAlbumById"),
      headers: <String, String>{
        'Content-type': 'application/json',
      },
      body: jsonEncode(<String, String>{'id': id}),
    );

    if (response.statusCode == 200) {
      Item item = Item.fromJson(json.decode(response.body));
      return item;
    } else {
      throw Exception();
    }
  }

  //Song => Single
  static Future<List<Single>> getAllSingles() async {
    var jwt = await storage.read(key: 'jwt');
    final response = await http.post(
      Uri.parse("$apiUri/marketplace/listAllSingles"),
      headers: <String, String>{
        'Content-type': 'application/json',
      },
      body: jsonEncode(<String, String>{'token': jwt!}),
    );

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<Single> singles =
          List<Single>.from(l.map((model) => Item.fromJson(model)));
      return singles;
    } else {
      throw Exception();
    }
  }

  static Future<List<Item>> listAllItems() async {
    final response = await http.post(
      Uri.parse("$apiUri/marketplace/listAllItems"),
      headers: <String, String>{
        'Content-type': 'application/json',
      },
      body: jsonEncode(<String, String>{}),
    );

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<Item> items =
          List<Item>.from(l.map((model) => Item.fromJson(model)));
      return items;
    } else {
      throw Exception();
    }
  }

  //Song => Single
  static Future<List<Single>> getTopSingles() async {
    var jwt = await storage.read(key: 'jwt');
    final response = await http.post(
      Uri.parse("$apiUri/marketplace/getChartsByName"),
      headers: <String, String>{
        'Content-type': 'application/json',
      },
      body: jsonEncode(<String, String>{'token': jwt!, 'name': 'Top Singles'}),
    );

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<Single> singles =
          List<Single>.from(l.map((model) => Item.fromJson(model)));
      return singles;
    } else {
      throw Exception();
    }
  }

  static Future<List<Album>> getTopAlbums() async {
    var jwt = await storage.read(key: 'jwt');
    final response = await http.post(
      Uri.parse("$apiUri/marketplace/getChartsByName"),
      headers: <String, String>{
        'Content-type': 'application/json',
      },
      body: jsonEncode(<String, String>{'token': jwt!, 'name': 'Top Albums'}),
    );
    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<Album> albums =
          List<Album>.from(l.map((model) => Item.fromJson(model)));
      return albums;
    } else {
      throw Exception();
    }
  }

  static Future<List<Item>> getAllAlbums() async {
    var jwt = await storage.read(key: 'jwt');
    final response = await http.post(
      Uri.parse("$apiUri/marketplace/listAllAlbums"),
      headers: <String, String>{
        'Content-type': 'application/json',
      },
      body: jsonEncode(<String, String>{'token': jwt!}),
    );

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<Item> albums =
          List<Item>.from(l.map((model) => Item.fromJson(model)));
      return albums;
    } else {
      throw Exception();
    }
  }

  static Future<List<Item>> getAllItemsFromArtist(String id) async {
    final response = await http.post(
      Uri.parse("$apiUri/marketplace/listAllItemsFromArtist"),
      headers: <String, String>{
        'Content-type': 'application/json',
      },
      body: jsonEncode(<String, String>{'artistId': id}),
    );

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<Item> items =
          List<Item>.from(l.map((model) => Item.fromJson(model)));
      return items;
    } else {
      throw Exception();
    }
  }

  static Future<List<Album>> getAllAlbumsFromArtist(String id) async {
    final response = await http.post(
      Uri.parse("$apiUri/marketplace/listAllAlbumsFromArtist"),
      headers: <String, String>{
        'Content-type': 'application/json',
      },
      body: jsonEncode(<String, String>{'artistId': id}),
    );

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<Album> albums =
          List<Album>.from(l.map((model) => Item.fromJson(model)));
      return albums;
    } else {
      throw Exception();
    }
  }

  //Song => Single
  static Future<List<Single>> getAllSongsFromArtist(String id) async {
    final response = await http.post(
      Uri.parse("$apiUri/marketplace/listAllSongsFromArtist"),
      headers: <String, String>{
        'Content-type': 'application/json',
      },
      body: jsonEncode(<String, String>{'artistId': id}),
    );
    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<Single> singles =
          List<Single>.from(l.map((model) => Item.fromJson(model)));
      return singles;
    } else {
      throw Exception();
    }
  }

  static Future<List<Song>> listAllAlbumSongs(Album album) async {
    final response = await http.post(
      Uri.parse("$apiUri/marketplace/listAlbumSongs"),
      headers: <String, String>{
        'Content-type': 'application/json',
      },
      body: jsonEncode(<String, String>{'albumId': album.id!}),
    );
    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      List<Song> albumSongs = List<Song>.from(
          l.map((model) => Song.fromJson(model, "Album Song", Uri.parse(""))));
      return albumSongs;
    } else {
      throw Exception();
    }
  }

  static Future<Item> getStatus(String orderId) async {
    var jwt = await storage.read(key: 'jwt');

    late final Item resItem;

    await retry(
      () async {
        final response = await http.post(
          Uri.parse("$apiUri/purchase/status"),
          headers: <String, String>{
            'Content-type': 'application/json',
          },
          body: jsonEncode(<String, dynamic>{
            'token': jwt!,
            'orderId': orderId,
          }),
        ).timeout(const Duration(seconds: 3));

        // print(response.body);

        if (response.body == "open" || response.body == "failed" || response.body == "Order not found") {
          throw TimeoutException("order open");
        } else {
          Item item = Item.fromJson(json.decode(response.body));
          resItem = item;
        }
      },
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is TimeoutException,
    );

    // print("finished");
    // print(resItem);

    return resItem;
  }

  static Future<dynamic> getPaymentSheet(String orderId) async {
    var jwt = await storage.read(key: 'jwt');

    final response = await http.post(
      Uri.parse("$apiUri/purchase/payment_sheet"),
      headers: <String, String>{
        'Content-type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{'token': jwt!, 'orderId': orderId}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  static Future<String> createOrder(int nftToken) async {
    var jwt = await storage.read(key: 'jwt');

    final response = await http.post(
      Uri.parse("$apiUri/purchase/create_order"),
      headers: <String, String>{
        'Content-type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{'token': jwt!, 'nftToken': nftToken}),
    );

    if (response.statusCode == 200) {
      String orderId = json.decode(response.body)["orderId"];
      return orderId;
    } else {
      throw Exception(response.body);
    }
  }

  static Future<bool> transferToken(String orderId) async {
    var jwt = await storage.read(key: 'jwt');

    final response = await http.post(
      Uri.parse("$apiUri/purchase/transfer_token"),
      headers: <String, String>{
        'Content-type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{'token': jwt!, 'orderId': orderId}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(response.body);
    }
  }

  static Future<bool> abortOrder(String orderId) async {
    var jwt = await storage.read(key: 'jwt');

    final response = await http.post(
      Uri.parse("$apiUri/purchase/abort"),
      headers: <String, String>{
        'Content-type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{'token': jwt!, 'orderId': orderId}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(response.body);
    }
  }
}
