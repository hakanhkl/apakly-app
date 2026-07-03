import 'package:flutter/material.dart';
import '../constants.dart';
import '../objects/item.dart';
import 'components/item_preview/marketplace_item_card_gridview.dart';

class MarketplaceAllItemsScreen extends StatelessWidget {
  AsyncSnapshot<List<Item>> items;
  MarketplaceAllItemsScreen({
    required this.items,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text(
          'Marketplace',
          style: TextStyle(
              color: textColor,
              fontSize: fSize1
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 280,
            ),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return MarketplaceItemCardGridView(item: items.data!.elementAt(index));
            },
          ),
        ),
      ),
    );
  }
}