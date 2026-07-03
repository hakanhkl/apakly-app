import 'package:apakly/constants.dart';
import 'package:apakly/music_player/song_repository.dart';
import 'package:flutter/material.dart';
import 'package:atomsbox/atomsbox.dart';
import 'package:atomsbox/src/atomsbox/atoms/config/app_typedef.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../home/blocs/music_player/music_player_bloc.dart';
import 'music_player_data.dart';

/// This is the component

class MusicPlayer extends StatelessWidget {
  /// This is the constructor for the large version, which you get, when
  /// clicking on the bottom widget
  MusicPlayer({
    super.key,
    this.imageUrl,
    this.songUrl,
    this.songName,
    this.artist,
    // Audio Controls properties
    required this.play,
    required this.pause,
    required this.audioPlayerState,
    // Seekbar properties
    required this.position,
    required this.duration,
    this.onChanged,
  }) {
    builder = (context) {
      return BlocConsumer<MusicPlayerBloc, MusicPlayerState>(
        listener: (context, state) {
          if (state.status == MusicPlayerStatus.initial) {
            return;
          } else if (state.status == MusicPlayerStatus.loaded) {
            context.read<MusicPlayerBloc>().add(MusicPlayerPlay());
          }
        },
        builder: (context, state) {
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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (imageUrl != null)
                    AspectRatio(
                      aspectRatio: 1 / 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image(
                          image: NetworkImage(imageUrl!.toString()),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppText.headlineMedium(
                          songName ?? '',
                          color: textColor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        AppText.bodySmall(artist!, color: textColor),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Column(
                    children: [
                      _AppAudioSeekbar(position: position, duration: duration),
                      const SizedBox(height: 20),
                      _AppAudioControls(
                        audioPlayerState: audioPlayerState,
                        play: play,
                        pause: pause,
                        showSecondaryButtons: true,
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return const SizedBox();
            }
          }
        },
      );
    };
  }

  /// This is the bottom widget
  MusicPlayer.dense({
    super.key,
    this.imageUrl,
    this.songUrl,
    this.songName,
    this.artist,
    // Audio Controls properties
    required this.play,
    required this.pause,
    required this.audioPlayerState,
    // Seekbar properties
    required this.position,
    required this.duration,
    this.onChanged,
  }) {
    builder = (context) {
      return AppCard.filled(
        color: backgroundColor,
        shape: const BeveledRectangleBorder(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Column(
                children: [
                  _AppAudioSeekbar(
                    position: position,
                    duration: duration,
                    showDuration: false,
                    showPosition: false,
                  ),
                  AppListTile(
                    leading: AppImage.network(imageUrl!.toString(), height: 48),
                    title: AppText.bodyLarge(
                      songName ?? '',
                      color: Colors.white,
                    ),
                    subtitle: AppText.bodySmall(
                      artist ?? '',
                      color: Colors.white,
                    ),
                    trailing: _AppAudioControls(
                      audioPlayerState: audioPlayerState,
                      play: play,
                      pause: pause,
                      showSecondaryButtons: false,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
          ],
        ),
      );
    };
  }

  late AudioCardBuilder builder;
  final Uri? imageUrl;
  final String? songUrl;
  final String? songName;
  final String? artist;
  final VoidCallback play;
  final VoidCallback pause;
  final AudioPlayerState audioPlayerState;
  late Duration position;
  final Duration duration;
  final Function(double)? onChanged;

  @override
  Widget build(BuildContext context) {
    final audioCard = builder.call(context);
    return audioCard;
  }
}

class _AppAudioSeekbar extends StatelessWidget {
  const _AppAudioSeekbar({
    required this.position,
    required this.duration,
    this.showDuration = true,
    this.showPosition = true,
    this.onChanged,
  });

  final Duration position;
  final Duration duration;
  final Function(double)? onChanged;
  final bool showDuration;
  final bool showPosition;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 2,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5.0),
            overlayShape: const RoundSliderOverlayShape(
              overlayRadius: 0,
            ),
            //showValueIndicator: ShowValueIndicator.onlyForDiscrete,
            inactiveTrackColor: Colors.white.withOpacity(0.1),
          ),
          child: Slider(
            min: 0,
            max: duration.inMilliseconds.toDouble() + 1000.0,
            value: position.inMilliseconds.toDouble(),
            onChanged: (double value) {
              context
                  .read<SongRepository>()
                  .seek(Duration(milliseconds: value.toInt()));
            },
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (showPosition)
              AppText.bodySmall(
                  position.formatDuration(),
                  color: textColor
              ),
            if (showDuration)
              AppText.bodySmall(
                duration.formatDuration(),
                color: textColor,
              ),
          ],
        ),
      ],
    );
  }
}

class _AppAudioControls extends StatelessWidget {
  const _AppAudioControls({
    required this.play,
    required this.pause,
    required this.audioPlayerState,
    this.showSecondaryButtons = false,
  });

  final VoidCallback play;
  final VoidCallback pause;
  final AudioPlayerState audioPlayerState;
  final bool showSecondaryButtons;

  @override
  Widget build(BuildContext context) {
    final primaryButton = _buildPrimaryButton(audioPlayerState);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showSecondaryButtons)
            AppIconButton(
              onPressed: () {
                context
                    .read<SongRepository>()
                    .getAudioHandler()
                    .skipToPrevious();
              },
              child: const Icon(
                  Icons.skip_previous,
                  size: 2 * iconSize,
                  color: iconColor
              ),
            ),
          primaryButton,
          if (showSecondaryButtons)
            AppIconButton(
              onPressed: () async {
                context.read<SongRepository>().getAudioHandler().skipToNext();
              },
              child: const Icon(
                  Icons.skip_next,
                  size: 2 * iconSize,
                  color: iconColor
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton(audioPlayerState) {
    switch (audioPlayerState) {
      case AudioPlayerState.buffering:
      case AudioPlayerState.loading:
        return const SizedBox(
          width: 48,
          height: 48,
          child: CircularProgressIndicator(),
        );
      case AudioPlayerState.paused:
        return IconButton(
          padding: EdgeInsets.zero,
          onPressed: play,
          icon: const Icon(
            Icons.play_arrow_rounded,
            size: 3 * iconSize,
            color: iconColor,
          ),
        );
      case AudioPlayerState.playing:
        return IconButton(
          padding: EdgeInsets.zero,
          onPressed: pause,
          icon: const Icon(
            Icons.pause_rounded,
            size: 3 * iconSize,
            color: iconColor,
          ),
        );
      default:
        return IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {},
          icon: const Icon(
            Icons.replay_rounded,
            size: 2 * iconSize,
            color: iconColor,
          ),
        );
    }
  }
}
