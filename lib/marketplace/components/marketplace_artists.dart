import 'package:apakly/marketplace/components/item_preview/marketplace_artist_item.dart';
import 'package:apakly/marketplace/marketplace_artists_screen.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../custom_progress_indicator.dart';
import '../../http/artist_requests.dart';
import '../../objects/artist.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MarketplaceArtists extends StatelessWidget {
  const MarketplaceArtists({ super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Artist>>(
        future: ArtistRequests.getAllArtists(), builder: (context, artists) {
      if (artists.hasData) {
        if (artists.data!.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '☹️',
                style: TextStyle(color: Colors.white, fontSize: fSize4*4),
              ),
              const SizedBox(height: 20,),
              Text(
                AppLocalizations.of(context)!.noavailableartists,
                style: const TextStyle(color: textColor, fontSize: fSize2, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          );
        } else{
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        AppLocalizations.of(context)!.artists,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: fSize3,
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
                              builder: (context) => MarketplaceArtistsScreen(artists: artists),
                            )
                        );
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: iconColor,
                        size: iconSize*1.4,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MarketplaceArtistsScreen(artists: artists,),
                      )
                  );
                },
              ),
              const SizedBox(height: 8,),
              SizedBox(
                height: 240,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: artists.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MarketplaceArtistItem(artistData: artists.data!.elementAt(index),);
                  },
                ),
              ),
              const SizedBox(height: 20,),

            ],
          );
        }
      } else {
        return const SizedBox(
            height: 200,
            child: Center(
                child: CustomProgressIndicator()
            ),
        );
      }
    });
  }
}
