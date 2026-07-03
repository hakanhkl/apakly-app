import 'package:flutter/material.dart';
import '../../constants.dart';

class Playlist_Screen extends StatelessWidget {
  const Playlist_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body:NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: iconColor,),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                backgroundColor: backgroundColor,
                elevation: 20,
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text(
                      'Favorites',
                    style: TextStyle(
                      color: textColor,
                      fontSize: fSize2,
                    ),
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      //image: DecorationImage(fit: BoxFit.cover,),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            backgroundColor.withOpacity(1.0),
                          ],
                          stops: const [
                            0.75,
                            1.0
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),

                ),
              ),
            ],
            body: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 16,),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Text(
                            'The Exclusive new Album of Ed Sheeran. Enjoy the new kind of Music. ',
                            style: TextStyle(
                              color: textColor,
                              fontSize: fSize0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16,),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 20,
                                      child: Icon(
                                        Icons.favorite,
                                        color: iconColor,
                                        size: 24,
                                      ),
                                    ),
                                    onTap: (){},
                                  ),
                                  const SizedBox(width: 12,),
                                  InkWell(
                                    customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 20,
                                      child: Icon(
                                        Icons.download_for_offline_outlined,
                                        color: iconColor,
                                        size: 24,
                                      ),
                                    ),
                                    onTap: (){},
                                  ),

                                ],
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    customBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 20,
                                      child: Icon(
                                        Icons.shuffle,
                                        color: iconColor,
                                        size: 24,
                                      ),
                                    ),
                                    onTap: (){},
                                  ),
                                  const SizedBox(width: 12,),
                                  InkWell(
                                    customBorder: const CircleBorder(),
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: primaryColor,
                                      ),
                                      height: 40,
                                      width: 40,
                                      child: const Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    onTap: (){},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16,),
                        /*
                        Song_Singles_old(song: songs[0]),
                        Song_Singles_old(song: songs[1]),
                        Song_Singles_old(song: songs[2]),
                        Song_Singles_old(song: songs[3]),
                        Song_Singles_old(song: songs[4]),

                         */
                      ],
                    ),
                  ),
            ),
          );
  }

}
