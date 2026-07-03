import 'package:flutter/material.dart';
import 'package:apakly/constants.dart';
import '../../marketplace/components/marketplace_item_preview.dart';
import '../../objects/artist.dart';
import '../../objects/item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class UpcomingSongCard extends StatefulWidget {
  Item? item;
  UpcomingSongCard({super.key, required this.item});

  @override
  _UpcomingSongCard createState() => _UpcomingSongCard(item);
}

class _UpcomingSongCard extends State<UpcomingSongCard> {
  Item? item;
  late Artist artist;

  _UpcomingSongCard(this.item);

  @override
  void initState() {
    super.initState();
    artist = item!.artist!; //Setting future before widget building
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        titleAlignment: ListTileTitleAlignment.top,
        leading: CircleAvatar(
          backgroundImage: NetworkImage(artist.profileImageUri!),
        ),
        title: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: InkWell(
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        text: TextSpan(
                          text: artist.name!,
                          style: const TextStyle(
                            fontSize: fSize1,
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ],
        ),
        subtitle: Column(
            children: [
          Container(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              item!.feedText!,
              style: const TextStyle(
                fontSize: fSize0,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(height: 10,),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MarketplaceItemPreview(id: item!.id!,)));
            },
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              const SizedBox(
                height: 5,
              ),
              Ink(
                // padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12.0),
                      topLeft: Radius.circular(12.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "${item!.editions!} ${AppLocalizations.of(context)!.editions}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: fSize1,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              ),
              Ink(
                width: double.infinity,
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12.0),
                        bottomRight: Radius.circular(12.0),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(item!.coverFileLocation!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.5),
                            Colors.black.withOpacity(0.9),
                          ],
                          stops: const [
                            0.75,
                            0.85,
                            1.0,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0),
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item!.itemType!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: fSize1,
                                color: textColor,
                              ),
                            ),
                            Text(
                              "${item!.price!}€",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: fSize2,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ]),
          ),
        ])
      ),

    ]);
  }
}
