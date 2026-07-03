import 'package:apakly/objects/artist.dart';
import 'package:apakly/objects/single.dart';
import 'package:apakly/objects/song.dart';
import 'album.dart';

/// Item is a superclass of singles and albums
abstract class Item {
  String? id;
  Artist? artist;
  String? itemName;
  String? coverFileLocation;
  int? editions;
  int? leftEditions;
  String? price;
  int? nftToken;
  String? genre;
  String? previewUri;
  DateTime? releaseDateTime;
  String? itemType;
  String? sentence;
  String? information;
  String? tokenStandard;
  String? chain;
  String? credits;
  int? balance;
  String? exclusivity;
  String? feedText;
  String? thankYouText;

  Item({
    this.id,
    this.artist,
    this.itemName,
    this.coverFileLocation,
    this.editions,
    this.price,
    this.nftToken,
    this.genre,
    this.releaseDateTime,
    this.leftEditions,
    this.itemType,
    this.tokenStandard,
    this.chain,
    this.credits,
    this.sentence,
    this.previewUri,
    this.balance,
    this.exclusivity,
    this.feedText,
    this.thankYouText
  });

  factory Item.fromJson(Map<String, dynamic> json) {

    if (json["item"]['type'] == 'Single') {
      Artist artist = Artist.fromJson(json["artist"]);
      Song song = Song.fromJson(json["song"],
          artist.name!, Uri.parse(json["item"]['coverFileLocation']));

      Single single = Single(
        id: json["item"]['_id'],
        artist: artist,
        itemName: json["item"]['name'],
        coverFileLocation: json["item"]['coverFileLocation'],
        editions: json["item"]['editions'],
        price: double.parse(json["item"]['price']['\$numberDecimal']).toStringAsFixed(2),
        nftToken: json["item"]['nft_token'],
        genre: json["item"]['genre'],
        releaseDateTime: DateTime.parse(json["item"]['releaseDateTime']),
        leftEditions: json["item"]['leftEditions'],
        itemType: json["item"]['type'],
        sentence: json["item"]['sentence'],
        previewUri: json["item"]['previewUri'],
        song: song,
        balance: json["balance"] != null ? int.parse(json["balance"]) : 1,
        exclusivity: json["item"]['exclusivity'],
        feedText: json["item"]['feedText'],
        thankYouText: json["item"]['thankYouText'],
      );
      return single;
    } else {
      Artist artist = Artist.fromJson(json["artist"]);
      List<Song> songs = List<Song>.from(json["songs"].map((model) =>
          Song.fromJson(model, artist.name!,
              Uri.parse(json["item"]['coverFileLocation']))));

      Album album = Album(
          id: json["item"]['_id'],
          artist: artist,
          itemName: json["item"]['name'],
          coverFileLocation: json["item"]['coverFileLocation'],
          editions: json["item"]['editions'],
          price: json["item"]['price'],
          nftToken: json["item"]['nft_token'],
          genre: json["item"]['genre'],
          releaseDateTime: json["item"]['releaseDateTime'],
          leftEditions: json["item"]['leftEditions'],
          itemType: json["item"]['type'],
          sentence: json["item"]['sentence'],
          previewUri: json["item"]['previewUri'],
          songs: songs);
      return album;
    }
  }
}
