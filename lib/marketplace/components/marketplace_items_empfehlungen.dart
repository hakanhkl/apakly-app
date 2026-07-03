import 'package:apakly/http/marketplace_requests.dart';
import 'package:apakly/marketplace/components/item_preview/marketplace_item_empfehlung.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../custom_progress_indicator.dart';
import '../../objects/item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MarketplaceItemsEmpfehlungen extends StatelessWidget {
  String id;

  MarketplaceItemsEmpfehlungen({
    required this.id,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocalizations.of(context)!.moresongs,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: fSize1,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: size.width*0.9,
            child: FutureBuilder<List<Item>>(
                future: MarketplaceRequests.listAllItems(),
                builder: (context, songs) {
                  if (songs.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: songs.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        if(songs.data!.elementAt(index).id != id) {
                          return MarketplaceItemEmpfehlung(item: songs.data!.elementAt(index));
                        }else{
                          return const SizedBox();
                        }
                      },
                    );
                  } else {
                    return const CustomProgressIndicator();
                  }
                }
            ),
          ),
          const SizedBox(height: 80,),
        ]
    );
  }
}
