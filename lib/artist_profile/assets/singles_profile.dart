import 'package:apakly/marketplace/components/singles_under_artist.dart';
import 'package:flutter/material.dart';
import '../../http/marketplace_requests.dart';
import '../../objects/single.dart';

class Singles_Profile extends StatefulWidget {
  String id;
  Singles_Profile({
    required this.id,
    super.key});

  @override
  State<Singles_Profile> createState() => _Singles_ProfileState();
}

class _Singles_ProfileState extends State<Singles_Profile> {
  @override
  Widget build(BuildContext context) {
    String id = widget.id;
    return FutureBuilder<List<Single>>(
        future: MarketplaceRequests.getAllSongsFromArtist(id),
        builder: (context, singles){
          if (singles.hasData) {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: singles.data!.length,
              itemBuilder: (BuildContext context, int index) {
              return SinglesUnderArtist(single: singles.data![index],);
              },
            );
          } else {
            return const Text("error");
          }
        }
    );
  }
}

