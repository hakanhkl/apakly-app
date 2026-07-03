import 'package:apakly/music_player/current_queue.dart';
import 'package:apakly/music_player/music_player.dart';
import 'package:apakly/music_player/music_player_data.dart';
import 'package:atomsbox/atomsbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants.dart';
import '../home/blocs/music_player/music_player_bloc.dart';

/// This is a wrapper for the large version of the player
/// It uses the music_player.dart object
class MusicPlayerLarge extends StatefulWidget {
  const MusicPlayerLarge({Key? key}) : super(key: key);

  @override
  State<MusicPlayerLarge> createState() => _MusicPlayerLargeState();
}

class _MusicPlayerLargeState extends State<MusicPlayerLarge> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: iconColor,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(
                Icons.playlist_play,
                color: iconColor,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return const CurrentQueue();
                    },
                    fullscreenDialog: true));
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            BlocConsumer<MusicPlayerBloc, MusicPlayerState>(
                listener: (context, state) {
              if (state.status == MusicPlayerStatus.initial) {
                return;
              } else if (state.status == MusicPlayerStatus.loaded) {
                context.read<MusicPlayerBloc>().add(MusicPlayerPlay());
              }
            }, builder: (context, state) {
              if (state.status == MusicPlayerStatus.initial) {
                return const SizedBox();
              } else {
                MusicPlayerData data = state.musicPlayerData!;
                AudioPlayerState audioPlayerState = AudioPlayerState.stopped;

                if (state.musicPlayerData!.playbackState.playing == true) {
                  audioPlayerState = AudioPlayerState.playing;
                } else if (state.musicPlayerData!.playbackState.playing ==
                    false) {
                  audioPlayerState = AudioPlayerState.paused;
                }

                if (data.currentSong != null) {
                  return MusicPlayer(
                    songName: data.currentSong!.title,
                    artist: data.currentSong!.artistName!,
                    imageUrl: data.currentSong!.artUri!,
                    songUrl: data.currentSong!.signedUrl,
                    audioPlayerState: audioPlayerState,
                    //onChanged: (value) {},
                    play: () =>
                        context.read<MusicPlayerBloc>().add(MusicPlayerPlay()),
                    pause: () =>
                        context.read<MusicPlayerBloc>().add(MusicPlayerPause()),
                    position: state.musicPlayerData?.currentSongPosition ??
                        Duration.zero,
                    duration: state.musicPlayerData?.currentSongDuration ??
                        Duration.zero,
                  );
                } else {
                  return const SizedBox();
                }
              }
            }),
          ],
        ),
      ),
    );
  }
}
