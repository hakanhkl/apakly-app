import 'package:apakly/artist_profile/artist_profile.dart';
import 'package:apakly/objects/artist.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../../constants.dart';

class MarketplaceArtistItem extends StatelessWidget {
  MarketplaceArtistItem({required this.artistData, super.key});
  Artist artistData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          InkWell(
            child: Column(
              children: [
                Ink(
                  child: SizedBox(
                    height: 140,
                    width: 140,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: artistData.profileImageUri!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Ink(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    text: TextSpan(
                      text: artistData.name!,
                      style: const TextStyle(
                        fontSize: fSize1,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArtistProfile(
                      artistData: artistData,
                    ),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
