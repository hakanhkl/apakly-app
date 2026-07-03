import 'package:apakly/music_player/song_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audio_service/audio_service.dart';
import '../constants.dart';

/// This is a wrapper for the large version of the player
/// It uses the music_player.dart object
class CurrentQueue extends StatefulWidget {
  const CurrentQueue({Key? key}) : super(key: key);

  @override
  State<CurrentQueue> createState() => _CurrentQueue();
}

class _CurrentQueue extends State<CurrentQueue> {
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
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: context
                .read<SongRepository>()
                .getAudioHandler()
                .queue
                .value
                .length,
            itemBuilder: (BuildContext context, int index) {
              MediaItem mediaItem = context
                  .read<SongRepository>()
                  .getAudioHandler()
                  .queue
                  .value
                  .elementAt(index);
              if (context
                      .read<SongRepository>()
                      .getAudioHandler()
                      .mediaItem
                      .value! ==
                  mediaItem) {
                return Container(
                    color: backgroundColorFade,
                    height: MediaQuery.of(context).size.height * 0.10,
                    width: double.infinity,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Image(
                                        image: NetworkImage(
                                            mediaItem.artUri.toString()),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 20),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            mediaItem.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: fSize1,
                                              color: textColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            mediaItem.artist!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: fSize1,
                                              color: textColor,
                                            ),
                                          )
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]));
              }
              return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.10,
                  width: double.infinity,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: AspectRatio(
                                  aspectRatio: 1 / 1,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Image(
                                      image: NetworkImage(
                                          mediaItem.artUri.toString()),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 20),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          mediaItem.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: fSize1,
                                            color: textColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          mediaItem.artist!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: fSize1,
                                            color: textColor,
                                          ),
                                        )
                                      ]),
                                ),
                              ),
                            ],
                          ),
                        )
                      ]));
            },
          ),
        ));
  }
}
