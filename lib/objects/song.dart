import 'package:audio_service/audio_service.dart';

class Song {
  String? id;
  String? signedUrl;
  String? title;
  String? artistName;
  Uri? artUri;

  Song({
    this.id,
    this.signedUrl,
    this.title,
    this.artistName,
    this.artUri
  });

  factory Song.fromJson(Map<String, dynamic>json, String artistName, Uri artUri) {
    Song song = Song(
      id: json["_id"],
      title: json["songName"],
      artistName: artistName,
      artUri: artUri
    );
    return song;
  }

  factory Song.fromMediaItem(MediaItem mediaItem) {
    return Song(
      id: mediaItem.id,
      title: mediaItem.title,
      artistName: mediaItem.artist,
      artUri: mediaItem.artUri,
      signedUrl: mediaItem.extras!['url'] as String,
    );
  }

  MediaItem toMediaItem() => MediaItem(
    id: id!,
    artist: artistName,
    title: title!,
    artUri: artUri!,
    extras: <String, dynamic>{
      'url': signedUrl,
    },
  );
}