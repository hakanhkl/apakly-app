import 'package:flutter/material.dart';
import '../constants.dart';
import '../objects/artist.dart';
import 'components/marketplace_all_artists.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MarketplaceArtistsScreen extends StatelessWidget {
  AsyncSnapshot<List<Artist>> artists;
  MarketplaceArtistsScreen({
    required this.artists,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          AppLocalizations.of(context)!.artists,
          style: const TextStyle(
              color: textColor,
              fontSize: fSize2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: MarketplaceAllArtists(artists: artists),
        ),
      ),
    );
  }
}