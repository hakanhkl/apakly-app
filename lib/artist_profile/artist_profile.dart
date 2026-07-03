import 'package:apakly/constants.dart';
import 'package:flutter/material.dart';
import '../objects/artist.dart';
import 'artistpage_artist_recommendations.dart';
import 'artistpage_items.dart';

class ArtistProfile extends StatelessWidget {
  Artist artistData;

  ArtistProfile({required this.artistData, super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: iconColor,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: backgroundColor.withOpacity(1),
            surfaceTintColor: Colors.transparent,
            pinned: true,
            expandedHeight: size.width,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 10),
              title: Text(
                artistData.name!,
                style: const TextStyle(
                    color: textColor,
                    fontSize: fSize4,
                    fontWeight: FontWeight.w800),
              ),
              background: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      artistData.profileImageUri!,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        backgroundColor.withOpacity(0.0),
                        backgroundColor.withOpacity(0.8),
                        backgroundColor.withOpacity(1.0),
                      ],
                      stops: const [0.0, 0.8, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Column(
                  children: [
                    Center(
                      child: Text(
                        artistData.profession!,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: fSize1,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          artistData.sentence!,
                          style: const TextStyle(
                            fontSize: fSize1,
                            color: textColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ArtistpageItems(
                      artistId: artistData.id!,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    /*
                    Biografie wird zunächst nicht eingeblendet
                    ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal:20.0, vertical: 15),
                      shape: const Border(),
                      title: const Text(
                        'Biografie',
                        style: TextStyle(
                          color: textColor,
                          fontSize: fSize1,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: iconSize*2,
                        color: Colors.white,
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              artistData.biography!,
                              style: const TextStyle(
                                color: textColor,
                                fontSize: fSize0,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    */
                    /*
                    const ExpansionTile(
                      tilePadding: EdgeInsets.symmetric(horizontal:20.0, vertical: 15),
                      shape: Border(),
                      title: Text(
                        'Text 2',
                        style: TextStyle(
                          color: textColor,
                          fontSize: fSize1,
                        ),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: iconSize*2,
                        color: Colors.white,
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal:20.0, vertical: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Hier stehe Informationen.',
                              style: TextStyle(
                                color: textColor,
                                fontSize: fSize0,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                     */
                    const SizedBox(
                      height: 20,
                    ),
                    /*
                    ArtistpageArtistRecommendations(
                      artistId: artistData.id!,
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                     */
                  ],
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}
