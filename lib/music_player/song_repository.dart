import 'package:apakly/http/signed_url_handler.dart';
import 'package:audio_service/audio_service.dart';
import 'package:rxdart/rxdart.dart';
import 'music_player_data.dart';

import '../objects/song.dart';

class SongRepository {
  SongRepository({required AudioHandler audioHandler})
      : _audioHandler = audioHandler;

  final AudioHandler _audioHandler;
  void play() => _audioHandler.play();

  void pause() => _audioHandler.pause();

  void seek(Duration position) => _audioHandler.seek(position);

  void addQueueItem(MediaItem mediaItem) =>
      _audioHandler.addQueueItem(mediaItem);

  ValueStream<String> queueTitle() => _audioHandler.queueTitle;

  Future<List<MediaItem>> queueElementAt(int index) =>
      _audioHandler.queue.elementAt(index);

  ValueStream<List<MediaItem>> getQueue() => _audioHandler.queue;

  AudioHandler getAudioHandler() {
    return _audioHandler;
  }

  /// A stream reporting the combined state of the current media item and its
  /// current position.
  Stream<MusicPlayerData> get musicPlayerDataStream => Rx.combineLatest4<
              PlaybackState,
              List<MediaItem>,
              MediaItem?,
              Duration,
              MusicPlayerData>(_audioHandler.playbackState, _audioHandler.queue,
          _audioHandler.mediaItem, AudioService.position, (
        PlaybackState playbackState,
        List<MediaItem> queue,
        MediaItem? mediaItem,
        Duration position,
      ) {
        Song? currentSong;

        if (mediaItem == null) {
          currentSong = null;
        } else {
          currentSong = Song.fromMediaItem(mediaItem);
        }

        return MusicPlayerData(
          currentSong: currentSong,
          songQueue: queue.map((mediaItem) {
            return Song.fromMediaItem(mediaItem);
          }).toList(),
          playbackState: playbackState,
          currentSongPosition: position,
          currentSongDuration: (mediaItem == null) ? null : mediaItem.duration,
        );
      });

  Future<void> setCurrentSong(Song song) async {
    await SignedUrlHandler.fetchSignedUrl(song);
    _audioHandler.removeQueueItemAt(0);
    _audioHandler.addQueueItem(song.toMediaItem());
  }

  Future<void> emptyQueue() async {
    while (_audioHandler.queue.value.isNotEmpty) {
      _audioHandler.removeQueueItemAt(0);
    }
  }

  Future<void> addItemsToQueue(List<Song> songs) async {
    for (Song song in songs) {
      await SignedUrlHandler.fetchSignedUrl(song);
      _audioHandler.addQueueItem(song.toMediaItem());
    }
  }
}
