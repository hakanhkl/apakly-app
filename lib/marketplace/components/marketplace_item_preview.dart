import 'dart:async';
import 'dart:io' show Platform;
import 'package:apakly/http/auth.dart';
import 'package:apakly/marketplace/components/seekbar.dart';
import 'package:apakly/marketplace/marketplace_congratulations_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:go_router/go_router.dart';
import '../../artist_profile/artist_profile.dart';
import '../../constants.dart';
import '../../custom_progress_indicator.dart';
import '../../login/custom_snackbar.dart';
import '../../music_player/song_repository.dart';
import '../../objects/item.dart';
import '../../http/marketplace_requests.dart';
import 'package:share_plus/share_plus.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

class MarketplaceItemPreview extends StatefulWidget {
  //Item item;
  String? id;

  MarketplaceItemPreview(
      {required this.id,
      //required this.item,
      super.key});

  @override
  State<MarketplaceItemPreview> createState() => _MarketplaceItemPreviewState();
}

// Auto-consume must be true on iOS.
// To try without auto-consume on another platform, change `true` to `false` here.
final bool _kAutoConsume = Platform.isIOS || true;

const String singleMediumId = 'single_m';
const String singleSmallId = 'single_s';
const String _kUpgradeId = 'upgrade';
const String _kSilverSubscriptionId = 'testsong';
const String _kGoldSubscriptionId = 'testsong';
const List<String> _kProductIds = <String>[
  singleSmallId, singleMediumId,
];

class _MarketplaceItemPreviewState extends State<MarketplaceItemPreview> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = <String>[];
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  List<String> _consumables = <String>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;
  var _isLoading = false;
  var _isLoadingStripe = false;

  bool playing = false;
  late String orderId;

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          previewplayer.positionStream,
          previewplayer.bufferedPositionStream,
          previewplayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      // handle error here.
    });
    initStoreInfo();

    super.initState();
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            unawaited(deliverProduct(purchaseDetails));
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          if (!_kAutoConsume && purchaseDetails.productID == singleMediumId) {
            final InAppPurchaseAndroidPlatformAddition androidAddition =
                _inAppPurchase.getPlatformAddition<
                    InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    // Call apakly api for token transfer and redirect to result page

    debugPrint("delivering");

    try {
      var response = await MarketplaceRequests.transferToken(orderId);

      if (response) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MarketplaceCongratulationsScreen(
              orderId: orderId,
            ),
          ),
        );
      }
    } catch (err) {
      CustomSnackbar().showSnackbar(
          context,
          err.toString().replaceRange(0, 11, ""),
          const Icon(
            Icons.info,
            color: iconColor,
          ));
    }
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    debugPrint("Verifying...");
    debugPrint(purchaseDetails.purchaseID);
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        _notFoundIds = <String>[];
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    debugPrint(productDetailResponse.toString());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    // final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      // _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
  }

  Future<void> initPaymentSheet() async {
    Item item = await MarketplaceRequests.getSingle(widget.id!);
    try {
      stripe.Stripe.publishableKey = stripePublishableKey;
      stripe.Stripe.merchantIdentifier = "merchant.com.apakly.app";
      await stripe.Stripe.instance.applySettings();

      // 1. create payment intent on the server
      final data;
      try {
        data = await MarketplaceRequests.getPaymentSheet(orderId);
      } catch (err) {
        CustomSnackbar().showSnackbar(
            context,
            err.toString().replaceRange(0, 11, ""),
            const Icon(
              Icons.info,
              color: iconColor,
            ));
        return;
      }

      orderId = data["orderId"];

      debugPrint(orderId);

      // 2. initialize the payment sheet
      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'apakly UG (haftungsbeschränkt)',
          paymentIntentClientSecret: data['paymentIntent'],
          // Customer keys
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['customer'],
          googlePay: const stripe.PaymentSheetGooglePay(
            merchantCountryCode: 'DE',
            testEnv: false,
          ),
          style: ThemeMode.light,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  Future<void> confirmPriceChange(BuildContext context) async {
    // Price changes for Android are not handled by the application, but are
    // instead handled by the Play Store. See
    // https://developer.android.com/google/play/billing/price-changes for more
    // information on price changes on Android.
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
    }
  }

  @override
  Widget build(BuildContext context) {
    // player.setAudioSource(AudioSource.uri(Uri.parse(widget.item.previewUri!)));
    return FutureBuilder<Item>(
        future: MarketplaceRequests.getSingle(widget.id!),
        builder: (context, item) {
          if (item.hasData) {
            return PopScope(
                onPopInvoked: (bool didPop) {
                  if (didPop) {
                    previewplayer.stop();
                  }
                },
                child: Scaffold(
                  body: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        leading: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: iconColor,
                          ),
                          onPressed: () => {
                            previewplayer.stop(),
                            Navigator.of(context).pop()
                          },
                        ),
                        backgroundColor: backgroundColor,
                        pinned: true,
                        actions: [
                          IconButton(
                            icon: const Icon(
                              Icons.share_rounded,
                              color: iconColor,
                            ),
                            onPressed: () async {
                              /*
                              var id = "id";
                              context.goNamed("sample", pathParameters: {'id': id});
                               */

                              Share.shareUri(Uri.parse(
                                  "https://apakly.com/sharesong/${item.data!.id}"));
                            },
                          ),
                        ],
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      AspectRatio(
                                        aspectRatio: 1 / 1,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: Image.network(
                                            item.data!.coverFileLocation!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.data!.itemName!,
                                              style: const TextStyle(
                                                  color: textColor,
                                                  fontSize: fSize2,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            Row(
                                              children: [
                                                InkWell(
                                                  child: Row(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(
                                                          item.data!.artist!
                                                              .profileImageUri!,
                                                        ),
                                                        radius: 24,
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Text(
                                                        item.data!.artist!
                                                            .name!,
                                                        style: const TextStyle(
                                                          color: textColor,
                                                          fontSize: fSize1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  onTap: () {
                                                    previewplayer.stop();
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ArtistProfile(
                                                          artistData: item
                                                              .data!.artist!,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ]),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!.price,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: fSize1,
                                                ),
                                              ),
                                              Text(
                                                '${item.data!.price}€',
                                                style: const TextStyle(
                                                  color: textColor,
                                                  fontSize: fSize2,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                item.data!.leftEditions! <= 50 ? AppLocalizations.of(context)!.editions : AppLocalizations.of(context)!.limitedto,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: fSize1,
                                                ),
                                              ),
                                              Text(
                                                item.data!.leftEditions! <= 50 ? "${item.data!.leftEditions} / ${item.data!.editions}" : "${item.data!.editions} ${AppLocalizations.of(context)!.editions}",
                                                style: const TextStyle(
                                                  color: textColor,
                                                  fontSize: fSize2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 80,
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          color: backgroundColor,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              shape: const StadiumBorder(),
                                              backgroundColor: _isLoading
                                                  ? primaryColor
                                                      .withOpacity(0.7)
                                                  : primaryColor,
                                            ),
                                            icon: _isLoading
                                                ? Container(
                                                    width: 24,
                                                    height: 24,
                                                    padding:
                                                        const EdgeInsets.all(2.0),
                                                    child:
                                                        const CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 3,
                                                    ),
                                                  )
                                                : const Icon(
                                                    Icons.shopping_cart,
                                                    color: Colors.white),
                                            onPressed: () async {
                                              if (_isLoading) {
                                                return;
                                              }

                                              setState(() => _isLoading = true);

                                              if (!(await isJwtValid())) {
                                                showModalBottomSheet(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            color:
                                                                backgroundColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      25.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      25.0),
                                                            ),
                                                          ),
                                                          height: 250,
                                                          width:
                                                              double.infinity,
                                                          child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      30.0),
                                                              child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              30.0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            AppLocalizations.of(context)!.notloggedin,
                                                                            style: const TextStyle(
                                                                                color: textColor,
                                                                                fontSize: fSize2,
                                                                                fontWeight: FontWeight.bold),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                20,
                                                                          ),
                                                                          Text(
                                                                            AppLocalizations.of(context)!.mustfirstlogin,
                                                                            style:
                                                                                const TextStyle(color: textColor, fontSize: fSize0),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                20,
                                                                          ),
                                                                          Container(
                                                                              height: 80,
                                                                              width: double.infinity,
                                                                              decoration: const BoxDecoration(
                                                                                color: backgroundColor,
                                                                              ),
                                                                              child: Padding(
                                                                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                                                                  child: ElevatedButton(
                                                                                    style: ElevatedButton.styleFrom(
                                                                                      shape: const StadiumBorder(),
                                                                                      backgroundColor: primaryColor,
                                                                                    ),
                                                                                    onPressed: () async {
                                                                                      while (context.canPop()) {
                                                                                        context.pop();
                                                                                      }
                                                                                    },
                                                                                    child: Text(
                                                                                      AppLocalizations.of(context)!.tothelogin,
                                                                                      style: const TextStyle(
                                                                                        color: textColor,
                                                                                        fontSize: fSize1,
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                              )
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                              ),
                                                          ),
                                                      );
                                                    });
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                                return;
                                              }

                                              try {
                                                orderId =
                                                    await MarketplaceRequests
                                                        .createOrder(item
                                                            .data!.nftToken!);
                                              } catch (err) {
                                                CustomSnackbar().showSnackbar(
                                                    context,
                                                    err.toString(),
                                                    const Icon(
                                                      Icons.info,
                                                      color: iconColor,
                                                    ));

                                                return;
                                              }

                                              showModalBottomSheet(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return StatefulBuilder(
                                                        builder: (BuildContext
                                                                context,
                                                            StateSetter
                                                                setState /*You can rename this!*/) {
                                                      return Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            color:
                                                                backgroundColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      25.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      25.0),
                                                            ),
                                                          ),
                                                          height: 600,
                                                          width:
                                                              double.infinity,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(30.0),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  AppLocalizations.of(context)!.purchaseoverview,
                                                                  style:
                                                                      const TextStyle(
                                                                    color:
                                                                        textColor,
                                                                    fontSize:
                                                                        fSize2,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            150,
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                10),
                                                                        child:
                                                                            AspectRatio(
                                                                          aspectRatio:
                                                                              1 / 1,
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                            child:
                                                                                Image(
                                                                              image: NetworkImage(item.data!.coverFileLocation!),
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical: 5.0,
                                                                              horizontal: 20),
                                                                          child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  item.data!.itemName!,
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: const TextStyle(
                                                                                    fontSize: fSize1,
                                                                                    color: textColor,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  item.data!.artist!.name!,
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: const TextStyle(
                                                                                    fontSize: fSize1,
                                                                                    color: textColor,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),const SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Text(
                                                                  "${AppLocalizations.of(context)!.thesongisexclusivefor} ${item.data!.exclusivity!}.",
                                                                  style:
                                                                  const TextStyle(
                                                                    color:
                                                                    Colors.grey,
                                                                    fontSize:
                                                                    fSize0,
                                                                  ),
                                                                ),
                                                                if (DateTime.timestamp().isBefore(item.data!.releaseDateTime!))
                                                                  Text(
                                                                  '${AppLocalizations.of(context)!.youcanplaythissongfrom} ${item.data!.releaseDateTime!.day.toString()}.${item.data!.releaseDateTime!.month.toString()}.${item.data!.releaseDateTime!.year.toString()}.',
                                                                    style:
                                                                    const TextStyle(
                                                                      color:
                                                                      Colors.grey,
                                                                      fontSize:
                                                                      fSize0,
                                                                    ),
                                                                  ),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        AppLocalizations.of(context)!.purchaseoverview,
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              Colors.grey,
                                                                          fontSize:
                                                                              fSize1,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${item.data!.price}€',
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              textColor,
                                                                          fontSize:
                                                                              fSize2,
                                                                        ),
                                                                      ),
                                                                    ]),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),
                                                                if (Platform
                                                                    .isAndroid)
                                                                  Container(
                                                                    width: double
                                                                        .infinity,
                                                                    height: 50,
                                                                    child:
                                                                        ElevatedButton
                                                                            .icon(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        shape:
                                                                            const StadiumBorder(),
                                                                        backgroundColor: _isLoadingStripe
                                                                            ? primaryColor.withOpacity(0.7)
                                                                            : primaryColor,
                                                                      ),
                                                                      icon: _isLoadingStripe
                                                                          ? Container(
                                                                              width: 24,
                                                                              height: 24,
                                                                              padding: const EdgeInsets.all(2.0),
                                                                              child: const CircularProgressIndicator(
                                                                                color: Colors.white,
                                                                                strokeWidth: 3,
                                                                              ),
                                                                            )
                                                                          : const Icon(Icons.shopping_cart, color: Colors.white),
                                                                      onPressed:
                                                                          () async {
                                                                        if (_isLoadingStripe) {
                                                                          return;
                                                                        }
                                                                        setState(() =>
                                                                            _isLoadingStripe =
                                                                                true);
                                                                        previewplayer
                                                                            .stop();
                                                                        await initPaymentSheet();
                                                                        try {
                                                                          // payment successful
                                                                          await stripe
                                                                              .Stripe
                                                                              .instance
                                                                              .presentPaymentSheet();
                                                                          setState(() =>
                                                                          _isLoadingStripe = false);
                                                                          Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder: (context) => MarketplaceCongratulationsScreen(
                                                                                orderId: orderId,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        } catch (err) {
                                                                          setState(() =>
                                                                              _isLoadingStripe = false);
                                                                          CustomSnackbar().showSnackbar(
                                                                              context,
                                                                              AppLocalizations.of(context)!.anyotherthougtssongreserved,
                                                                              const Icon(
                                                                                Icons.info,
                                                                                color: iconColor,
                                                                              ));
                                                                        }
                                                                      },
                                                                      label: _isLoadingStripe
                                                                          ? Text(
                                                                          AppLocalizations.of(context)!.almostthere,
                                                                              style: const TextStyle(
                                                                                color: textColor,
                                                                                fontSize: fSize1,
                                                                              ),
                                                                            )
                                                                          : Text(
                                                                              AppLocalizations.of(context)!.continuewithpayment,
                                                                              style: const TextStyle(
                                                                                color: textColor,
                                                                                fontSize: fSize1,
                                                                              ),
                                                                            ),
                                                                    ),
                                                                  ),
                                                                if (Platform
                                                                    .isIOS)
                                                                  ElevatedButton(
                                                                    style:
                                                                        ButtonStyle(
                                                                      backgroundColor:
                                                                          MaterialStateProperty.all<Color>(
                                                                              primaryColor),
                                                                      overlayColor:
                                                                          MaterialStateProperty.all<Color>(
                                                                              linkedColor),
                                                                      minimumSize: MaterialStateProperty.all<
                                                                              Size>(
                                                                          const Size
                                                                              .fromHeight(
                                                                              50)),
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      try {
                                                                        // set price category for Apple in-app purchase products
                                                                        String
                                                                            priceCategory =
                                                                            "";
                                                                        if (item.data!.price! ==
                                                                            '4.99') {
                                                                          priceCategory =
                                                                              "single_m";
                                                                        }
                                                                        if (item.data!.price! ==
                                                                            '1.99') {
                                                                          priceCategory =
                                                                              "single_s";
                                                                        }

                                                                        PurchaseParam
                                                                            purchaseParam =
                                                                            PurchaseParam(
                                                                          productDetails: _products.firstWhere((element) =>
                                                                              element.id ==
                                                                              priceCategory),
                                                                        );
                                                                        _inAppPurchase.buyConsumable(
                                                                            purchaseParam:
                                                                                purchaseParam,
                                                                            autoConsume:
                                                                                _kAutoConsume);
                                                                      } catch (err) {
                                                                        debugPrint(
                                                                            err.toString());
                                                                        CustomSnackbar().showSnackbar(
                                                                            context,
                                                                            AppLocalizations.of(context)!.itemnotavailableinyourcountry,
                                                                            const Icon(
                                                                              Icons.info,
                                                                              color: iconColor,
                                                                            ));
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                        AppLocalizations.of(context)!.continuewithpayment,
                                                                        style: const TextStyle(
                                                                            color: textColor,
                                                                            fontSize: fSize1,
                                                                      ),
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                          )
                                                      );
                                                    });
                                                  });

                                              setState(
                                                  () => _isLoading = false);

                                              // previewplayer.stop();
                                            },
                                            label: _isLoading
                                                ? Text(
                                                AppLocalizations.of(context)!.isbeingprocessed,
                                                    style: const TextStyle(
                                                      color: textColor,
                                                      fontSize: fSize1,
                                                    ),
                                                  )
                                                : DateTime.timestamp().isBefore(item.data!.releaseDateTime!) ? Text(
                                              AppLocalizations.of(context)!.preordernow,
                                                    style: const TextStyle(
                                                      color: textColor,
                                                      fontSize: fSize1,
                                                    ),
                                                  ) :
                                            Text(
                                              AppLocalizations.of(context)!.buynow,
                                              style: const TextStyle(
                                                color: textColor,
                                                fontSize: fSize1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(16),
                                              topRight: Radius.circular(16),
                                              bottomLeft: Radius.circular(16),
                                              bottomRight: Radius.circular(16),
                                            ),
                                            color: Colors.black26),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  AppLocalizations.of(context)!.listentotrialversion,
                                                  style: const TextStyle(
                                                    color: textColor,
                                                    fontSize: fSize1,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                children: [
                                                  ControlButtons(previewplayer,
                                                      item.data!.previewUri!),
                                                  Expanded(
                                                    child: StreamBuilder<
                                                        PositionData>(
                                                      stream:
                                                          _positionDataStream,
                                                      builder:
                                                          (context, snapshot) {
                                                        final positionData =
                                                            snapshot.data;
                                                        return SeekBar(
                                                          duration: positionData
                                                                  ?.duration ??
                                                              Duration.zero,
                                                          position: positionData
                                                                  ?.position ??
                                                              Duration.zero,
                                                          bufferedPosition:
                                                              positionData
                                                                      ?.bufferedPosition ??
                                                                  Duration.zero,
                                                          onChangeEnd:
                                                              previewplayer
                                                                  .seek,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ExpansionTile(
                                  tilePadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 15),
                                  shape: const Border(),
                                  title: Text(
                                    AppLocalizations.of(context)!.description,
                                    style: const TextStyle(
                                      color: textColor,
                                      fontSize: fSize1,
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: iconSize * 2,
                                    color: Colors.white,
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          item.data!.sentence!,
                                          style: const TextStyle(
                                            color: textColor,
                                            fontSize: fSize0,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                ExpansionTile(
                                  tilePadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 15),
                                  shape: const Border(),
                                  title: Text(
                                    AppLocalizations.of(context)!.details,
                                    style: const TextStyle(
                                      color: textColor,
                                      fontSize: fSize1,
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: iconSize * 2,
                                    color: Colors.white,
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 4),
                                              Text(
                                                AppLocalizations.of(context)!.token,
                                                style: const TextStyle(
                                                  color: textColor,
                                                  fontSize: fSize0,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                AppLocalizations.of(context)!.tokenstandard,
                                                style: const TextStyle(
                                                  color: textColor,
                                                  fontSize: fSize0,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                AppLocalizations.of(context)!.blockchain,
                                                style: const TextStyle(
                                                  color: textColor,
                                                  fontSize: fSize0,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                AppLocalizations.of(context)!.exclusivity,
                                                style: const TextStyle(
                                                  color: textColor,
                                                  fontSize: fSize0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 30.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 4),
                                                Text(
                                                  item.data!.nftToken!
                                                      .toString(),
                                                  style: const TextStyle(
                                                    color: textColor,
                                                    fontSize: fSize0,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  AppLocalizations.of(context)!.erc155,
                                                  style: const TextStyle(
                                                    color: textColor,
                                                    fontSize: fSize0,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  AppLocalizations.of(context)!.polygon,
                                                  style: const TextStyle(
                                                    color: textColor,
                                                    fontSize: fSize0,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  item.data!.exclusivity!,
                                                  style: const TextStyle(
                                                    color: textColor,
                                                    fontSize: fSize0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                /*
                                MarketplaceItemsEmpfehlungen(
                                    id: item.data!.id!),

                                 */
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                            );
                          },
                          childCount: 1,
                        ),
                      ),
                    ],
                  ),
                ));
          } else {
            return const CustomProgressIndicator();
          }
        });
  }
}

/// Displays the play/pause button and volume/speed sliders.
class ControlButtons extends StatelessWidget {
  final AudioPlayer player;
  String previewUri;

  ControlButtons(this.player, this.previewUri, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return IconButton(
            icon: const Icon(Icons.pause_rounded),
            iconSize: 3 * iconSize,
            onPressed: () => {},
          );
        } else if (playing != true) {
          return IconButton(
            icon: const Icon(Icons.play_arrow_rounded),
            iconSize: 3 * iconSize,
            onPressed: () => {
              context.read<SongRepository>().pause(),
              previewplayer.setUrl(previewUri),
              player.play()
            },
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            icon: const Icon(Icons.pause_rounded),
            iconSize: 3 * iconSize,
            onPressed: () =>
                {context.read<SongRepository>().play(), player.pause()},
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.replay_rounded),
            iconSize: 3 * iconSize,
            onPressed: () => player.seek(Duration.zero),
          );
        }
      },
    );
  }
}

/// Example implementation of the
/// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
///
/// The payment queue delegate can be implementated to provide information
/// needed to complete transactions.
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
