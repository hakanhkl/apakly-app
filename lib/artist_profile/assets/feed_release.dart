import 'package:apakly/home/homescreen.dart';
import 'package:apakly/http/artist_requests.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../cart_controller.dart';
import '../../constants.dart';
import '../../objects/artist.dart';
import '../../objects/item.dart';

class FeedRelease extends StatefulWidget {
  Item? item;
  FeedRelease({super.key, required this.item});

  @override
  _FeedRelease createState() => _FeedRelease(item);
}

class _FeedRelease extends State<FeedRelease> {
  Item? item;
  late Future<Artist> artist;

  _FeedRelease(this.item);

  @override
  void initState() {
    super.initState();
    artist = ArtistRequests.getArtistProfileInformation(item!.artist!.id!);  //Setting future before widget building
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());

    return FutureBuilder<Artist>(
        future: artist,
        builder: (context, artist) {
          if (artist.hasData) {
            return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(artist.data!.profileImageUri!),
                    ),
                    title: Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                                    );
                                  },
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    text: TextSpan(
                                      text: artist.data!.name!,
                                      style: const TextStyle(
                                        fontSize: fSize1,
                                        color: textColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                            ),
                            Text(
                             "${item!.releaseDateTime!.day}.${item!.releaseDateTime!.month}.${item!.releaseDateTime!.year} ${item!.releaseDateTime!.hour}:${item!.releaseDateTime!.minute}",
                              style: const TextStyle(
                                fontSize: fSize0,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    subtitle: Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        '${item!.itemName!} ist now on sale.                                                                  ',
                        style: const TextStyle(
                          fontSize: fSize1,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                  Column(
                      children: [
                        const SizedBox(height: 5,),
                        Ink(
                          width: 350,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12.0),
                                topLeft: Radius.circular(12.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "${item!.leftEditions!}/${item!.editions!} left",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: fSize1,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Ink(
                          width: 350,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: AspectRatio(
                            aspectRatio: 1/1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(12.0),
                                  bottomRight: Radius.circular(12.0),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(item!.coverFileLocation!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.5),
                                      Colors.black.withOpacity(0.9),
                                    ],
                                    stops: const [
                                      0.75,
                                      0.85,
                                      1.0,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(12.0),
                                    bottomRight: Radius.circular(12.0),
                                  ),
                                ),
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item!.itemType!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: fSize1,
                                          color: textColor,
                                        ),
                                      ),
                                      Text(
                                        "${item!.price!}.00€",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: fSize2,
                                          color: textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item!.itemName!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: fSize1,
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        artist.data!.name!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: fSize1,
                                          color: textColor,
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 25.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  child: const Text(
                                    'Add to Cart',
                                    style: TextStyle(
                                      fontSize: fSize1,
                                      color: textColor,
                                    ),
                                  ),
                                  onPressed: () {
                                    final snackBar = SnackBar(
                                      /// need to set following properties for best effect of awesome_snackbar_content
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: '',
                                        message: 'Item added to Cart',
                                        contentType: ContentType.success,
                                      ),
                                    );

                                    cartController.addItem(item!);

                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);


                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]
                  ),
                ]
            );
          } else {
            return const Text("");
            }
          }
        );

  }

}
