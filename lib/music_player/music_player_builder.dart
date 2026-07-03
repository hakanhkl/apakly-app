import 'package:apakly/music_player/music_player_large.dart';
import 'package:apakly/music_player/music_player.dart';
import 'package:atomsbox/atomsbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'music_player_data.dart';
import '../home/blocs/music_player/music_player_bloc.dart';

class MusicPlayerBuilder extends StatelessWidget {
  const MusicPlayerBuilder({super.key, this.dense = false, this.onTap});
  final bool dense;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MusicPlayerBloc, MusicPlayerState>(
      listener: (context, state) {
        if (state.status == MusicPlayerStatus.initial) {
          return;
        } else if (state.status == MusicPlayerStatus.loaded) {
          context.read<MusicPlayerBloc>().add(MusicPlayerPlay());
        }
      },
      builder: (context, state) {
        // print(state);
        if (state.status == MusicPlayerStatus.initial) {
          return const SizedBox();
        } else {
          MusicPlayerData data = state.musicPlayerData!;
          AudioPlayerState audioPlayerState = AudioPlayerState.stopped;

          if (state.musicPlayerData!.playbackState.playing == true) {
            audioPlayerState = AudioPlayerState.playing;
          } else if (state.musicPlayerData!.playbackState.playing == false) {
            audioPlayerState = AudioPlayerState.paused;
          }

          if (data.currentSong != null) {
            return GestureDetector(
                // when the widget is clicked, open large version
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return const MusicPlayerLarge();
                      },
                      fullscreenDialog: true));
                  /*
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return MusicPlayerScreen();
                  },
                );
                */
                },
                child: MusicPlayer.dense(
                  songName: data.currentSong!.title,
                  artist: data.currentSong!.artistName,
                  imageUrl: data.currentSong!.artUri!,
                  songUrl: data.currentSong!.signedUrl,
                  audioPlayerState: audioPlayerState,
                  play: () =>
                      context.read<MusicPlayerBloc>().add(MusicPlayerPlay()),
                  pause: () =>
                      context.read<MusicPlayerBloc>().add(MusicPlayerPause()),
                  position: state.musicPlayerData?.currentSongPosition ??
                      Duration.zero,
                  duration: state.musicPlayerData?.currentSongDuration ??
                      const Duration(days:0, hours: 1,minutes: 0,seconds: 0, milliseconds: 0, microseconds: 0,),
                  ),
              );
            } else {
              return const SizedBox();
            }
        }
      },
    );
  }
}
