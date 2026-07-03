import 'package:apakly/http/marketplace_requests.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../custom_progress_indicator.dart';
import '../objects/item.dart';
import 'artistpage_all_items.dart';
import 'artistpage_all_items_screen.dart';
import 'artistpage_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ArtistpageItems extends StatelessWidget {
  String artistId;
  ArtistpageItems({
    required this.artistId,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArtistpageAllItemsScreen(artistId: artistId,),
                  )
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.discography,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: fSize1,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArtistpageAllItems(artistId: artistId,),
                        )
                    );
                  },
                  icon: const Icon(Icons.arrow_forward_ios, color: iconColor, size: iconSize*1.4,),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20,),
          SizedBox(
            height: size.width*0.9,
            child: FutureBuilder<List<Item>>(
                future: MarketplaceRequests.getAllItemsFromArtist(artistId),
                builder: (context, songs) {
                  if (songs.hasData) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: songs.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ArtistpageItem(item: songs.data!.elementAt(index));
                        },
                      ),
                    );
                  } else {
                    return const CustomProgressIndicator();
                  }
                }
            ),
          ),
        ]
    );
  }
}
