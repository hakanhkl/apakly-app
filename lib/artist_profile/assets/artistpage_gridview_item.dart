import 'package:apakly/home/homescreen.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../objects/item.dart';
import '../../marketplace/components/marketplace_item_preview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ArtistpageGridviewItem extends StatelessWidget {
  Item item;
  ArtistpageGridviewItem({
    required this.item,
    super.key
  });

  get child => null;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 8,
        surfaceTintColor: const Color(0xff1e1e1e),
        color: const Color(0xff1e1e1e),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        //shadowColor: Colors.black,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MarketplaceItemPreview(id: item.id)
              ),
            );
          },
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1/1,
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                        item.coverFileLocation!,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        text: TextSpan(
                          text: item.itemName!,
                          style: const TextStyle(
                            fontSize: fSize0,
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4,),
                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      text: TextSpan(
                        text: item.artist!.name,
                        style: const TextStyle(
                          fontSize: fSize0,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            text: TextSpan(
                              text: item.leftEditions! <= 50 ? AppLocalizations.of(context)!.editions : "limitiert auf",
                              style: const TextStyle(
                                fontSize: fSize0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2,),
                          RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            text: TextSpan(
                              text: item.leftEditions! <= 50 ? "${item.leftEditions!} von ${item.editions!}" : "${item.editions!} Editions",
                              style: const TextStyle(
                                fontSize: fSize0,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            text: TextSpan(
                              text: AppLocalizations.of(context)!.price,
                              style: const TextStyle(
                                fontSize: fSize0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2,),
                          RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            text: TextSpan(
                              text: "${item.price}€",
                              style: const TextStyle(
                                fontSize: fSize0,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
