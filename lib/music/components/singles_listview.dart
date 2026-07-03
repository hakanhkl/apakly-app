import 'package:apakly/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../http/signed_url_handler.dart';
import '../../login/custom_snackbar.dart';
import '../../objects/single.dart';
import '../../music_player/song_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SinglesListView extends StatelessWidget {
  Single single;
  List<Single> allSingles;
  SinglesListView({required this.single, super.key, required this.allSingles});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () async {
        // empty current queue
        context.read<SongRepository>().emptyQueue();

        // add current song into queue
        if (single.releaseDateTime!.isBefore(DateTime.now())) {
          await SignedUrlHandler.fetchSignedUrl(single.song!);
          context
              .read<SongRepository>()
              .addQueueItem(single.song!.toMediaItem());
        } else {
          CustomSnackbar().showSnackbar(
              context,
              AppLocalizations.of(context)!.songcannotbeplayed,
              const Icon(
                Icons.info,
                color: iconColor,
              ));
          return;
        }

        // add other songs into queue
        for (Single single in allSingles) {
          if (single != this.single &&
              single.releaseDateTime!.isBefore(DateTime.now())) {
            await SignedUrlHandler.fetchSignedUrl(single.song!);
            context
                .read<SongRepository>()
                .addQueueItem(single.song!.toMediaItem());
          }
        }

        // play queue
        context.read<SongRepository>().play();
      },
      child: SizedBox(
        height: size.height * 0.14,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image(
                            image: NetworkImage(single.coverFileLocation!),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                single.itemName!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: fSize1,
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                single.artist!.name!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: fSize1,
                                  color: textColor,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const WidgetSpan(
                                      child: Icon(Icons.content_copy, size: 14),
                                    ),
                                    TextSpan(
                                      text: "  ${single.balance!}",
                                      style: const TextStyle(
                                        fontSize: fSize1,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ]),
                      ),
                    ),
                    if (single.releaseDateTime!.isAfter(DateTime.now()))
                      Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                padding: const EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF9933FF),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.preordered,
                                  style: const TextStyle(
                                    fontSize: fSize0,
                                    color: textColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
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
