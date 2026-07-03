import 'package:apakly/auth_globals.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class CheckOut extends StatelessWidget {
  const CheckOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Scaffold(
          body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                pinned: true,
                floating: true,
                snap: true,
                elevation: 20,
                title: const Text(
                  'Checkout',
                  style: TextStyle(
                      color: textColor,
                      fontSize: fSize1,
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: iconColor,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
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
                            isActive: true,
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
            ],
            body: Column(
              children: [
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Billing information',
                        style: TextStyle(
                            color: textColor,
                            fontSize: fSize0,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    height: 0.2,
                    color: Colors.white30,
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userFirstName! + ' ' + userLastName!,
                      style: const TextStyle(
                          color: textColor,
                          fontSize: fSize1,
                      ),
                    ),
                    const Text(
                      'Dummy Street 19',
                      style: TextStyle(
                          color: textColor,
                          fontSize: fSize1,
                      ),
                    ),
                    const Text(
                      '12345 London',
                      style: TextStyle(
                          color: textColor,
                          fontSize: fSize1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('You pay with',
                          style: TextStyle(
                            color: textColor,
                            fontSize: fSize0,
                          )),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    height: 0.2,
                    color: Colors.white30,
                  ),
                ),
                const SizedBox(height: 10),
                const Column(
                  children: [
                    Text(
                      'PayPal',
                      style: TextStyle(
                          color: textColor,
                          fontSize: fSize1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            height: 120,
            color: Colors.transparent,
            alignment: Alignment.center,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DefaultTextStyle(
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: fSize2,
                        ),
                        child: Text(
                          'Items (3)',
                        ),
                      ),
                      DefaultTextStyle(
                        style: TextStyle(
                          color: textColor,
                          fontSize: fSize2,
                          fontWeight: FontWeight.bold,
                        ),
                        child: Text(
                          'EUR 3.97',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
