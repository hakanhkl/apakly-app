import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../../constants.dart';
import '../../../objects/item.dart';
import '../marketplace_item_preview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MarketplaceItemCard extends StatelessWidget {
  Item item;
  MarketplaceItemCard({required this.item, super.key});

  get child => null;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                  builder: (context) => MarketplaceItemPreview(id: item.id)),
            );
          },
          child: SizedBox(
            width: size.width * 0.8,
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 1 / 1,
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
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
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
                                  fontSize: fSize1,
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
                                    fontSize: fSize1,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          text: TextSpan(
                            text: "${item.itemType![0].toUpperCase()}${item.itemType!.substring(1).toLowerCase()}",
                            style: const TextStyle(
                              fontSize: fSize1,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding:
                  const EdgeInsets.only(left: 12, right: 12, bottom: 8),
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
                                style: const TextStyle(
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
                                text: item.leftEditions! <= 50 ? "${item.leftEditions!} / ${item.editions!}" : "${item.editions!} ${AppLocalizations.of(context)!.editions}",
                                style: const TextStyle(
                                  fontSize: fSize1,
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
                            const SizedBox(
                              height: 2,
                            ),
                            RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              text: TextSpan(
                                text: "${item.price}€",
                                style: const TextStyle(
                                  fontSize: fSize1,
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
      ),
    );
  }
}
