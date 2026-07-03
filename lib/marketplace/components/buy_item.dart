
import 'package:apakly/cart_controller.dart';
import 'package:apakly/http/artist_requests.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../artist_profile/artist_profile.dart';
import '../../navigation_bar.dart';
import '../../constants.dart';
import '../../objects/artist.dart';
import '../../objects/item.dart';
import '../marketplace_screen.dart';

class BuyItem extends StatefulWidget {
  Item item;
  BuyItem({
    required this.item,
    super.key,
  });

  @override
  State<BuyItem> createState() => _BuyItemState();
}

class _BuyItemState extends State<BuyItem> {

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());
    return Stack(
        children: [
          Scaffold(
            endDrawer: const NavBar(),
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: iconColor,),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: AspectRatio(
                          aspectRatio: 1/1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              widget.item.coverFileLocation!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16,),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                widget.item.itemName!,
                                style: const TextStyle(
                                    color: textColor,
                                    fontSize: fSize2,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            const SizedBox(height: 12,),
                            FutureBuilder<Artist>(
                              future: ArtistRequests.getArtistProfileInformation(widget.item.artist!.id!),
                              builder: (context, artistData){
                                if (artistData.hasData) {
                                  return Row(
                                    children: [
                                      InkWell(
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  artistData.data!.profileImageUri!
                                              ),
                                              radius: 18,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              artistData.data!.name!,
                                              style: const TextStyle(
                                                color: textColor,
                                                fontSize: fSize1,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => ArtistProfile(artistData: artistData.data!,)),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                } else {
                                  return const Text("error");
                                  }
                              }
                            ),
                          ]
                      ),
                      const Divider(
                        height: 60,
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Editions',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: fSize1,
                                    ),
                                  ),
                                  const SizedBox(height: 6,),
                                  Text(
                                    widget.item.editions.toString(),
                                    style: const TextStyle(
                                      color: textColor,
                                      fontSize: fSize2,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ]
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 40,
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    'Price',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: fSize1,
                                    ),
                                  ),
                                  const SizedBox(height: 6,),
                                  Text(
                                    "${widget.item.price}.00€",
                                    style: const TextStyle(
                                      color: textColor,
                                      fontSize: fSize2,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ]
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        height: 60,
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 8)
                          ),
                          onPressed: (){},
                          child: const Text(
                            'Buy Now',
                            style: TextStyle(
                              color: textColor,
                              fontSize: fSize1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6,),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: Colors.transparent,
                              foregroundColor: primaryColor,
                              side: const BorderSide(width: 1, color: primaryColor),
                              padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 8)
                          ),
                          onPressed: (){
                            cartController.addItem(widget.item);
                          },
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(
                              color: textColor,
                              fontSize: fSize1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6,),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: Colors.transparent,
                              foregroundColor: primaryColor,
                              side: const BorderSide(width: 1, color: primaryColor),
                              padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 8)
                          ),
                          onPressed: (){},
                          child: const Text(
                            'Add to Wishlist',
                            style: TextStyle(
                              color: textColor,
                              fontSize: fSize1,
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        height: 60,
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Infos zum Artikel',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: textColor,
                            fontSize: fSize3,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16,),
                      InkWell(
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Includes',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: fSize1,
                                    ),
                                  ),
                                  Text(
                                    'Don´t Go Yet',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: fSize1,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 36,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Description',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: fSize1,
                                    ),
                                  ),
                                  Text(
                                    'The lead single from Camila´s upcoming third album...',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: fSize1,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 36,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 140,
                                    child: Text(
                                      'Label',
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: fSize1,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 140,
                                    child: Text(
                                      'Erscine Records',
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: fSize1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 36,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 140,
                                    child: Text(
                                      'Release Date',
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: fSize1,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 140,
                                    child: Text(
                                      '01.10.2022',
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: fSize1,
                                      ),

                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 36,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 140,
                                    child: Text(
                                      'Duration',
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: fSize1,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 140,
                                    child: Text(
                                      '03:42',
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: fSize1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MarketplaceScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]
    );

  }
  Widget buildButton(BuildContext context, String value, String text) {
    return MaterialButton(
      onPressed: () {  },
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: textColor,
              fontSize: fSize1,
            ),
          ),
          const SizedBox(height: 2,),
          Text(
            text,
            style: const TextStyle(
              color: textColor,
              fontSize: fSize1,
            ),
          ),
          const SizedBox(height: 2,)
        ],
      ),
    );
  }

}
