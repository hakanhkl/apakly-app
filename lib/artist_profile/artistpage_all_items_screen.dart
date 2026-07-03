import 'package:apakly/artist_profile/artistpage_all_items.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ArtistpageAllItemsScreen extends StatelessWidget {
  String artistId;
  ArtistpageAllItemsScreen({
    required this.artistId,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          AppLocalizations.of(context)!.allitems,
          style: const TextStyle(
              color: textColor,
              fontSize: fSize1
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: ArtistpageAllItems(artistId: artistId,),
        ),
      ),
    );
  }
}