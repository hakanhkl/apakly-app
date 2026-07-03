import 'package:animate_gradient/animate_gradient.dart';
import 'package:apakly/auth_globals.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';
import '../custom_progress_indicator.dart';
import '../http/marketplace_requests.dart';
import '../objects/item.dart';

class MarketplaceCongratulationsScreen extends StatelessWidget {
  MarketplaceCongratulationsScreen({
    super.key,
    required this.orderId,
  });

  String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: iconColor,
            ),
            onPressed: () => {
              previewplayer.stop(),
              Navigator.of(context).pop(),
              Navigator.of(context).pop()

            },
          ),
      ),
      body: FutureBuilder<Item>(
        future: MarketplaceRequests.getStatus(orderId),
        builder: (err, item) {
          if (item.hasData) {
            return Column(
              children: [
                paymentSucceeded(item.data!),
              ],
            );
          } else {
            return paymentPending();
          }
        },
      ),
    );
  }

  Widget paymentPending() {
    return const Center(child: CustomProgressIndicator());
  }

  Widget paymentSucceeded(Item item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: AnimateGradient(
              primaryBeginGeometry: const AlignmentDirectional(0, 1),
              primaryEndGeometry: const AlignmentDirectional(0, 2),
              secondaryBeginGeometry: const AlignmentDirectional(2, 0),
              secondaryEndGeometry: const AlignmentDirectional(0, -0.8),
              textDirectionForGeometry: TextDirection.rtl,
              primaryColors: [
                primaryColor,
                primaryColor.withOpacity(0.2),
                primaryColor.withOpacity(0.4),
              ],
              secondaryColors: [
                primaryColor,
                primaryColor.withOpacity(0.6),
                primaryColor.withOpacity(0.8),
              ],
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const WidgetSpan(
                              child: Icon(Icons.content_copy, size: 14),
                            ),
                            TextSpan(
                              text: " 1 von ${item.editions!}",
                              style: const TextStyle(
                                fontSize: fSize1,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    AspectRatio(
                      aspectRatio: 1 / 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          item.coverFileLocation!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        item.itemName!,
                        style: const TextStyle(
                            color: textColor,
                            fontSize: fSize1,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Hey $userFirstName, \n\n${item.thankYouText}\n",
                        style: const TextStyle(
                            color: textColor,
                            fontSize: fSize0,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          style: GoogleFonts.qwitcherGrypen(
                            textStyle: const TextStyle(
                              color: textColor,
                              fontSize: fSize4,
                            ),
                          ),
                        item.artist!.name!
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
