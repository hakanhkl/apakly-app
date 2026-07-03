import 'package:apakly/marketplace/components/item_preview/marketplace_gridview_artist.dart';
import 'package:flutter/material.dart';
import '../../objects/artist.dart';


class MarketplaceAllArtists extends StatelessWidget {
  AsyncSnapshot<List<Artist>> artists;
  MarketplaceAllArtists({
    required this.artists,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 240,
        //childAspectRatio: 11 / 16,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: artists.data!.length,
      itemBuilder: (BuildContext context, int index) {
        return MarketplaceGridViewArtist(artistData: artists.data!.elementAt(index),);
        },
    );
  }
}
