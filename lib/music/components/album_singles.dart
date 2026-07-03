import 'package:apakly/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../http/signed_url_handler.dart';
import '../../music_player/song_repository.dart';
import '../../objects/song.dart';

class AlbumSingles extends StatelessWidget {
  String artistId;
  List<Song> allSongs;
  Song song;
  int index;
  AlbumSingles({
    required this.artistId,
    required this.song,
    required this.index,
    required this.allSongs,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () async {
        // empty current queue
        await context.read<SongRepository>().emptyQueue();

        // add current song into queue
        await SignedUrlHandler.fetchSignedUrl(song);
        context.read<SongRepository>().setCurrentSong(song);
        context.read<SongRepository>().play();

        // Commented out because it makes problems
        // add other songs into queue
        // for (Song song in allSongs) {
        //   if (song != this.song) {
        //     context.read<SongRepository>().addItemsToQueue(allSongs);
        //   }
        // }
      },
      child: SizedBox(
        height: size.height * 0.12,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  '${index+1}',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontSize: fSize1,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.title!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: fSize1,
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              song.artistName!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: fSize1,
                                color: textColor,
                              ),
                            )
                          ]
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
