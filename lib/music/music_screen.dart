import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants.dart';
import '../custom_progress_indicator.dart';
import '../http/auth.dart';
import '../http/player_requests.dart';
import '../main.dart';
import '../objects/album.dart';
import '../objects/single.dart';
import 'components/album_item_view.dart';
import 'components/singles_listview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  late List<Single> singlesList;
  late List<Album> albumsList;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: isJwtValid(),
        builder: (context, isValid) {
          if (isValid.hasData) {
            if (isValid.data!) {
              // jwt is valid
              return DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(60.0),
                    child: AppBar(
                      bottom: TabBar(
                        indicatorColor: Colors.white,
                        enableFeedback: true,
                        labelColor: textColor,
                        unselectedLabelColor: Colors.grey,
                        padding: EdgeInsets.zero,
                        indicator: const UnderlineTabIndicator(
                          borderSide: BorderSide(
                            color: primaryColor,
                          ),
                        ),
                        tabs: [
                          Tab(text: AppLocalizations.of(context)!.singles,),
                          Tab(text: AppLocalizations.of(context)!.albums,),
                          //Tab(text: 'Playlists'),
                        ],
                      ),
                    ),
                  ),


                  body: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      FutureBuilder<List<Single>>(
                          future: PlayerRequests.getSinglesForOwner(),
                          builder: (context, singles) {
                            if (singles.hasData) {
                              singlesList = singles.data!;
                              return RefreshIndicator(
                                  onRefresh: () async {
                                    List<Single> tmpSingles =
                                    await PlayerRequests
                                        .getSinglesForOwner();
                                    setState(() {
                                      singlesList = tmpSingles;
                                    });
                                  },
                                  child: SizedBox(
                                      height: double.infinity,
                                      child: singles.data!.isEmpty ?
                                      ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: 1,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                              return Padding(
                                                  padding: const EdgeInsets.all(40),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      const SizedBox(height: 100,),
                                                      const IconButton(onPressed: null ,icon: Icon(Icons.replay_rounded, size: iconSize*8,),),
                                                      const SizedBox(height: 20,),
                                                      Text(
                                                        AppLocalizations.of(context)!.lookaroundmarketplace,
                                                        style: const TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: fSize3,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  )
                                              );
                                        },) : ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: singlesList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return SinglesListView(
                                              single: singlesList
                                                  .elementAt(index),
                                              allSingles: singlesList);
                                        },
                                      )));
                            } else {
                              return const Center(child: CircularProgressIndicator());
                            }
                          }),
                      FutureBuilder<List<Album>>(
                          future: PlayerRequests.getAlbumsForOwner(),
                          builder: (context, albums) {
                            if (albums.hasData) {
                              albumsList = albums.data!;
                              return RefreshIndicator(
                                  onRefresh: () async {
                                    List<Album> tmpAlbums =
                                    await PlayerRequests
                                        .getAlbumsForOwner();
                                    setState(() {
                                      albumsList = tmpAlbums;
                                    });
                                  },
                                  child: SizedBox(
                                      height: double.infinity,
                                      child: albums.data!.isEmpty ?
                                      ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: 1,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                              padding: const EdgeInsets.all(40),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(height: 100,),
                                                  const IconButton(onPressed: null ,icon: Icon(Icons.replay_rounded, size: iconSize*8,),),
                                                  const SizedBox(height: 20,),
                                                  Text(
                                                    AppLocalizations.of(context)!.lookaroundmarketplace,
                                                    style: const TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: fSize3,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              )
                                          );
                                        },
                                      ) : ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: albumsList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return AlbumItemView(
                                              album: albumsList
                                                  .elementAt(index));
                                        },
                                      )
                                  )
                              );

                            } else {
                              return const CustomProgressIndicator();
                            }
                          }),
                    ],
                  ),
                ),
              );
            } else {
              // jwt is not valid
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.notloggedin,
                      style: const TextStyle(
                          color: textColor,
                          fontSize: fSize2,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)!.mustfirstlogin,
                      style: const TextStyle(color: textColor, fontSize: fSize0),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 80,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: backgroundColor,
                        ),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                backgroundColor: primaryColor,
                              ),
                              onPressed: () async {
                                RestartWidget.restartApp(context);
                              },
                              child: Text(
                                AppLocalizations.of(context)!.tothelogin,
                                style: const TextStyle(
                                  color: textColor,
                                  fontSize: fSize1,
                                ),
                              ),
                            )))
                  ],
                ),
              );
            }
          } else {
            return const Center(child: CustomProgressIndicator(),);
          }
        });
  }
}