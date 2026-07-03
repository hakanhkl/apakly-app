import 'package:apakly/http/marketplace_requests.dart';
import 'package:flutter/material.dart';
import '../../custom_progress_indicator.dart';
import '../../objects/item.dart';
import 'assets/artistpage_gridview_item.dart';

class ArtistpageAllItems extends StatelessWidget {
  String artistId;
  ArtistpageAllItems({
    required this.artistId,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Item>>(
        future: MarketplaceRequests.getAllItemsFromArtist(artistId),
        builder: (context, songs) {
          if (songs.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 280,
              ),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: songs.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return ArtistpageGridviewItem(item: songs.data!.elementAt(index));
              },
            );
          } else {
            return const CustomProgressIndicator();
          }
        }
    );
  }
}
