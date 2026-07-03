import 'package:apakly/music_player/song_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../objects/album.dart';
import 'album_singles.dart';
import '../../constants.dart';

class AlbumItemView extends StatelessWidget {
  Album album;
  AlbumItemView({required this.album, super.key});
  String urlImage = 'images/equals_album.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: iconColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  height: 320,
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image(
                        image: NetworkImage(album.coverFileLocation!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    album.itemName!,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          fontSize: fSize2,
                        ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        InkWell(
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(album.artist!.profileImageUri!),
                            radius: 18,
                          ),
                          onTap: () {},
                        ),
                        const SizedBox(width: 12),
                        InkWell(
                          child: Text(
                            album.artist!.name!,
                            style: const TextStyle(
                                color: textColor,
                                fontSize: fSize1,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                album.sentence!,
                style: const TextStyle(
                  color: textColor,
                  fontSize: fSize0,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  child: Ink(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                    ),
                    height: 40,
                    width: 40,
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  onTap: () async {
                    // delete current queue
                    context.read<SongRepository>().emptyQueue();

                    // add all album songs into queue
                    context.read<SongRepository>().addItemsToQueue(album.songs!);

                    // play album
                    context.read<SongRepository>().play();
                  },
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                album.songs!.length,
                (index) => AlbumSingles(
                  artistId: album.artist!.id!,
                  song: album.songs![index],
                  index: index,
                  allSongs: album.songs!,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(
      duration.inMinutes.remainder(60),
    );
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }
}
