import 'package:apakly/http/marketplace_requests.dart';
import 'package:apakly/marketplace/marketplace_all_items_screen.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../custom_progress_indicator.dart';
import '../../objects/item.dart';
import 'item_preview/marketplace_item_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MarketplaceItems extends StatelessWidget {

  const MarketplaceItems({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<List<Item>>(
        future: MarketplaceRequests.listAllItems(),
        builder: (context, items) {
          if (items.hasData) {
            if(items.data!.isEmpty){
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '☹️',
                    style: TextStyle(color: Colors.white, fontSize: fSize4*4),
                  ),
                  Text(
                    AppLocalizations.of(context)!.nosongsawaible,
                    style: const TextStyle(color: textColor, fontSize: fSize2, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }else{
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MarketplaceAllItemsScreen(items: items),
                            )
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppLocalizations.of(context)!.newreleases,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: fSize3,
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MarketplaceAllItemsScreen(items: items),
                                  )
                              );
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: iconColor,
                              size: iconSize*1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8,),
                    SizedBox(
                      height: size.width*1.12,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: items.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return MarketplaceItemCard(item: items.data!.elementAt(index));
                        },
                      ),
                    ),
                  ]
              );
            }
          } else {
            return SizedBox(
              height: size.width,
              child: const Center(child: CustomProgressIndicator()),
            );
          }
        }
    );

  }
}
