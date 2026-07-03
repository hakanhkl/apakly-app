import 'package:apakly/home/components/no_upcoming_song.dart';
import 'package:apakly/http/upcoming_songs_requests.dart';
import 'package:flutter/material.dart';
import '../../custom_progress_indicator.dart';
import '../../login/deep_linking.dart';
import '../../objects/item.dart';
import 'upcoming_song_card.dart';

class Upcoming extends StatefulWidget {
  const Upcoming({super.key});

  @override
  State<Upcoming> createState() => _BodyState();
}

@override
class _BodyState extends State<Upcoming> {
  @override
  Widget build(BuildContext context) {
    initUniLinks(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          title: SizedBox(
          height: 60,
          child: Center(
          child: Image.asset('images/logo.png',)
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Item>>(
        future: UpcomingSongsRequests.getUpcomingItems(),
        builder: (err, feed) {
          if (feed.hasData) {
            if(feed.data!.isEmpty){
              return const NoUpcomingSong();
            }else{
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: feed.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return UpcomingSongCard(item: feed.data!.elementAt(index));
                    // Only upcoming songs are listed
                  }
              );
            }
          } else {
            return const CustomProgressIndicator();
          }
        },
      ),
    );
  }
}
