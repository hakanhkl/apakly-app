import 'package:apakly/marketplace/components/marketplace_artists.dart';
import 'package:flutter/material.dart';
import 'components/marketplace_items.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: const Size.fromHeight(0.0), child: AppBar(),),
      body: const SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MarketplaceItems(),
                MarketplaceArtists(),
              ]
          ),
        ),
    );
  }
}
