import 'package:apakly/home/homescreen.dart';
import 'package:apakly/objects/item.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../http/artist_requests.dart';
import '../../objects/artist.dart';

class ItemCardOnSuccess extends StatelessWidget {
  Item item;
  ItemCardOnSuccess({super.key, required this.item});

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        const SizedBox(width: 30),
        Container(
          width: 285,
          decoration: const BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.all(
              Radius.circular(28.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    item.coverFileLocation!,
                    width: double.infinity,
                    height: 240,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          item.itemName!,
                          style: const TextStyle(
                            color: textColor,
                            fontSize: fSize2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 18,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  },
                  child: FutureBuilder<Artist>(
                    future: ArtistRequests.getArtistProfileInformation(
                        item.artist!.id!),
                    builder: (context, artist) {
                      if (artist.hasData) {
                        return Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(artist.data!.profileImageUri!),
                              radius: 24,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              artist.data!.name!,
                              style: const TextStyle(
                                  color: textColor,
                                  fontSize: fSize1,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Text("error");
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Flexible(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Your exclusive item',
                      style: TextStyle(
                          color: textColor,
                          fontSize: fSize0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      "#${item.editions! - item.leftEditions!}",
                      style: const TextStyle(
                        color: textColor,
                        fontSize: fSize2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "/ ${item.editions!}",
                      style: const TextStyle(
                          color: textColor,
                          fontSize: fSize1,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
