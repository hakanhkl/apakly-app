import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../../constants.dart';
import '../../../objects/item.dart';
import '../marketplace_item_preview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MarketplaceItemCardGridView extends StatelessWidget {
  Item item;
  MarketplaceItemCardGridView({
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
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                  child: FadeInImage.memoryNetwork(
                    fit: BoxFit.cover,
                    placeholder: kTransparentImage,
                    image: item.coverFileLocation!,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                              text: item.itemName!,
                              style: const TextStyle(
                                fontSize: fSize0,
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          InkWell(
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
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                              text: item.leftEditions! <= 50 ? AppLocalizations.of(context)!.editions : AppLocalizations.of(context)!.limitedto,
                              style: TextStyle(
                                fontSize: fSize0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            text: TextSpan(
                              text: item.leftEditions! <= 50 ? "${item.leftEditions!} / ${item.editions!}" : "${item.editions!} AppLocalizations.of(context)!.editions",
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
                            text: const TextSpan(
                              text: 'Preis',
                              style: TextStyle(
                                fontSize: fSize0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
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
