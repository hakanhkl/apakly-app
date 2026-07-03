import 'package:apakly/marketplace/components/albums_under_artist.dart';
import 'package:flutter/material.dart';
import '../../http/marketplace_requests.dart';
import '../../objects/album.dart';

class Album_Profile extends StatefulWidget {
  String id;
  Album_Profile({
    required this.id,
    Key? key}) : super(key: key);

  @override
  State<Album_Profile> createState() => _Album_ProfileState();
}

class _Album_ProfileState extends State<Album_Profile> {
  @override
  Widget build(BuildContext context) {
    String id = widget.id;
    return FutureBuilder<List<Album>>(
        future: MarketplaceRequests.getAllAlbumsFromArtist(id),
        builder: (context, albums){
          if (albums.hasData) {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: albums.data!.length,
              itemBuilder: (BuildContext context, int index) {
              return AlbumUnderArtist(album: albums.data![index],);
              },
            );
          } else {
            return const Text("error");
          }
        }
    );
  }
}
