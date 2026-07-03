import 'package:apakly/constants.dart';
import 'package:flutter/material.dart';
import '../../cart_controller.dart';
import '../../http/artist_requests.dart';
import '../../objects/artist.dart';
import '../../objects/item.dart';
import '../../objects/single.dart';

class ShoppingItem extends StatelessWidget {
  final CartController controller;
  final Item item;
  final int index;
  const ShoppingItem({
    required this.controller,
    required this.item,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //DO NOT CHANGE, Your idea is not smarter
    if(item is Single){
      Size size = MediaQuery.of(context).size;
      return Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: size.height * 0.14,
          width: size.width,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(10),
                  child: AspectRatio(
                    aspectRatio: 1/1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image(
                        image: NetworkImage(item.coverFileLocation!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.itemName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: textColor,
                              fontSize: fSize1,
                              fontWeight: FontWeight.bold,
                          ),
                        ),
                        FutureBuilder<Artist>(
                            future: ArtistRequests.getArtistProfileInformation(item.artist!.id!),
                            builder: (context, artistData) {
                              if (artistData.hasData) {
                                return Text(
                                  artistData.data!.name!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: textColor,
                                      fontSize: fSize1,
                                  ),
                                );
                              } else {
                                return const Text("error");
                              }
                            }
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                      children: [
                        Text(
                          item.price.toString() + ".00€",
                          style:  const TextStyle(
                              color: textColor,
                              fontSize: fSize1,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(12.0),
                              bottomLeft: Radius.circular(12.0),
                              topLeft: Radius.circular(12.0),
                              topRight: Radius.circular(12.0),
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.delete),
                            iconSize: 24,
                            color: Colors.white,
                            onPressed: () {
                              controller.removeSingle(item);
                            },
                          ),
                        ),
                      ]
                  ),
                )
              ]
          ),
        ),
      );
    }else{
      Size size = MediaQuery.of(context).size;
      return Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: size.height * 0.14,
          width: size.width,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(10),
                  child: AspectRatio(
                    aspectRatio: 1/1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image(
                        image: NetworkImage(item.coverFileLocation!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.itemName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: textColor,
                              fontSize: fSize1,
                              fontWeight: FontWeight.bold,
                          ),
                        ),
                        FutureBuilder<Artist>(
                            future: ArtistRequests.getArtistProfileInformation(item.artist!.id!),
                            builder: (context, artistData) {
                              if (artistData.hasData) {
                                return Text(
                                  artistData.data!.name!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: textColor,
                                      fontSize: fSize1,
                                  ),
                                );
                              } else {
                                return const Text("error");
                              }
                            }
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                      children: [
                        Text(
                          item.price.toString() + ".00€",
                          style:  const TextStyle(
                              color: textColor,
                              fontSize: fSize1,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(12.0),
                              bottomLeft: Radius.circular(12.0),
                              topLeft: Radius.circular(12.0),
                              topRight: Radius.circular(12.0),
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.delete),
                            iconSize: 24,
                            color: Colors.white,
                            onPressed: () {
                              controller.removeSingle(item);
                            },
                          ),
                        ),
                      ]
                  ),
                )
              ]
          ),
        ),
      );
    }

  }
}
