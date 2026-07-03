import 'package:apakly/home/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../cart_controller.dart';
import '../constants.dart';
import '../http/marketplace_requests.dart';
import '../objects/item.dart';
import 'components/item.dart';

class Paid_Screen extends StatelessWidget {
  Paid_Screen({Key? key, required this.amount,required this.paymentResult, required this.paymentMethod}) : super(key: key);
  final controller = PageController(initialPage: 1);
  int amount;
  dynamic paymentResult;
  String paymentMethod;


  @override
  Widget build(BuildContext context) {
    final CartController controller = Get.put(CartController());
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            elevation: 20,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: iconColor,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: SizedBox(
                height: 80,
                child: Theme(
                  data: ThemeData(
                    canvasColor: backgroundColor,
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                          primary: Colors.green,
                        ),
                  ),
                  child: Stepper(
                    type: StepperType.horizontal,
                    controlsBuilder: (context, controlDetails) {
                      return const SizedBox();
                    },
                    steps: [
                      Step(
                        title: const Text(
                          'Choose',
                          style: TextStyle(
                            fontSize: fSize1,
                            color: textColor,
                          ),
                        ),
                        content: Container(),
                      ),
                      Step(
                        title: const Text(
                          'Pay',
                          style: TextStyle(
                            fontSize: fSize1,
                            color: textColor,
                          ),
                        ),
                        content: Container(),
                      ),
                      Step(
                        isActive: true,
                        title: const Text(
                          'Enjoy',
                          style: TextStyle(
                            fontSize: fSize1,
                            color: textColor,
                          ),
                        ),
                        content: Container(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: FutureBuilder<Item>(
            future: MarketplaceRequests.getStatus(""),
            builder: (err, items) {
              if (items.hasData) {
                return paymentSucceeded(items.data!);
              } else {
                return paymentFailed();
              }
            },
          ),
        )
      ],
    );
  }

  Widget paymentFailed() {
    return const Column(children: [
      Text(
        'Oops...',
        style: TextStyle(
            color: textColor,
            fontSize: fSize3
        ),
      ),
      SizedBox(height: 5),
      Center(
        child: Text(
          'An error occured while buying your items. Please try again later.',
          style: TextStyle(
              color: textColor, fontSize: fSize1
          ),
        ),
      ),
    ]);
  }

  Widget paymentSucceeded(Item items) {
    return Column(
      children: [
        const Text(
          'Congratulations!',
          style: TextStyle(
              color: textColor,
              fontSize: fSize3,
          ),
        ),
        const SizedBox(height: 5),
        const Center(
          child: Text(
            'You own this item now and can listen to it.',
            style: TextStyle(
                color: textColor,
                fontSize: fSize1,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 480,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ItemCardOnSuccess(item: items,),
        ),
      ],
    );
  }
}
