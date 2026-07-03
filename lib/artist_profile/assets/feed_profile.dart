import 'package:flutter/material.dart';
import 'feed_release.dart';
import '../../home/components/upcoming_song_card.dart';
import '../../http/upcoming_songs_requests.dart';
import '../../objects/item.dart';

class FeedProfile extends StatefulWidget {
  String id;
  FeedProfile({
    required this.id,
    Key? key}) : super(key: key);

  @override
  State<FeedProfile> createState() => _FeedProfileState();
}

class _FeedProfileState extends State<FeedProfile> {
  @override
  Widget build(BuildContext context) {
    String id = widget.id;
    return FutureBuilder<List<Item>>(
      future: UpcomingSongsRequests.getFeedForArtist(id),
      builder: (err, feed) {
        if (feed.hasData) {
          return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: feed.data!.length,
              itemBuilder: (BuildContext context, int index) {
                if (
                    feed.data!.elementAt(index).releaseDateTime!
                    .compareTo(DateTime.now()) <
                    0) {
                  return FeedRelease(item: feed.data!.elementAt(index));
                } else {
                  return UpcomingSongCard(item: feed.data!.elementAt(index));
                }
              });
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

