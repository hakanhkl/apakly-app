import 'package:flutter/material.dart';

import '../constants.dart';
import '../custom_progress_indicator.dart';
import '../http/artist_requests.dart';
import '../marketplace/components/item_preview/marketplace_artist_item.dart';
import '../objects/artist.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ArtistpageArtistRecommendations extends StatelessWidget {
  String artistId;
  ArtistpageArtistRecommendations({
    required this.artistId,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerLeft,
          child: Text(
            AppLocalizations.of(context)!.otherartists,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: fSize1,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 30,),
        SizedBox(
          height: 160,
          child: FutureBuilder<List<Artist>>(
              future: ArtistRequests.getAllArtists(),
              builder: (context, artists) {
            if (artists.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: artists.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  if(artistId == artists.data!.elementAt(index).id){
                    return const SizedBox();
                  }else{
                    return MarketplaceArtistItem(artistData: artists.data!.elementAt(index),);
                  }
                },
              );
            } else {
                return const CustomProgressIndicator();
            }
          }),
        ),
      ],
    );
  }
}
