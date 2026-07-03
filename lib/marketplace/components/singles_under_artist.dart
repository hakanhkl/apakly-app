import 'package:apakly/constants.dart';
import 'package:apakly/http/artist_requests.dart';
import 'package:flutter/material.dart';
import '../../objects/artist.dart';
import '../../objects/single.dart';
import 'buy_item.dart';


class SinglesUnderArtist extends StatelessWidget {
  Single single;
  SinglesUnderArtist({
    required this.single,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BuyItem(item: single,)),
        );
      },
      child: SizedBox(
        height: size.height * 0.14,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: FutureBuilder<Artist>(
                    future: ArtistRequests.getArtistProfileInformation(single.artist!.id!),
                    builder: (context, artistData) {
                      if (artistData.hasData) {
                        return Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: AspectRatio(
                                aspectRatio: 1/1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image(
                                    image: NetworkImage(single.coverFileLocation!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        single.itemName!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: fSize1,
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        artistData.data!.name.toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: fSize1,
                                          color: textColor,
                                        ),
                                      )
                                    ]
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Text("error");
                      }
                    }
                ),
              ),
              Row(
                children: [
                  InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 18,
                      child: Icon(
                        Icons.music_note_outlined,
                        color: iconColor,
                        size: 16,
                      ),
                    ),
                    onTap: () {},
                  ),
                  InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        Icons.favorite,
                        color: iconColor,
                        size: 16,
                      ),
                    ),
                    onTap: () {},
                  ),
                  InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 18,
                      child: Icon(
                        Icons.more_vert,
                        color: iconColor,
                        size: 16,
                      ),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
