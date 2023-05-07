import 'dart:async';

import 'package:locale_emoji/locale_emoji.dart' as le;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:restart_app/restart_app.dart';
import 'package:speakeasy/main.dart';
import 'package:speakeasy/theme/theme.dart';
import 'package:speakeasy/utils/toast.dart';
import 'package:speakeasy/view/analytics_page.dart';
import 'package:speakeasy/view/rules_page.dart';
import 'package:speakeasy/view/widget/my_scaffold.dart';

import '../utils/utils.dart';

class InfoPage extends StatefulWidget {
  static const String emailLeo = "dev.rignaneseleo%2Btabu%40gmail.com";

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  StreamSubscription<List<PurchaseDetails>>? _paymentSubscription;

  @override
  void dispose() {
    _paymentSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        int sensitivity = 8;
        if (details.delta.dy < -sensitivity) {
          // Up Swipe
          Get.back();
        }
      },
      child: MyScaffold(
          topLeftWidget: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Theme.of(context).canvasColor,
              ),
              onPressed: () => Get.back()),
          widgets: [
            //Expanded(child: Container()),
            //SizedBox(height: 30),
            Expanded(
              child: ListView(
                shrinkWrap: false,
                physics: BouncingScrollPhysics(),
                children: [
                  Container(height: smallScreen ? 0 : 40),
                  buildLine(
                    context,
                    text: "Version".tr(),
                    value: packageInfo?.version.toString(),
                  ),
                  buildLine(
                    context,
                    text: "#Words".tr(),
                    value: words.length.toString(),
                  ),
                  Container(height: smallScreen ? 0 : 60),
                  buildLine(
                    context,
                    text: "📙  " + "Rules".tr(),
                    onTap: () => Get.to(() => RulesPage(),
                        transition: Transition.downToUp),
                  ),
                  buildLine(
                    context,
                    text: "☕️  " + "Support".tr(),
                    onTap: () => buildPaymentWidget(),
                  ),
                  buildLine(
                    context,
                    text: "📈  " + "Analytics".tr(),
                    onTap: () => Get.to(() => AnalyticsPage(),
                        transition: Transition.downToUp),
                  ),
                  buildLine(
                    context,
                    text: "🤯  " + "report_bug".tr(),
                    onTap: () => launchURL(
                        "mailto:${InfoPage.emailLeo}?subject=Bug%20tabu%20"),
                  ),
                  buildLine(
                    context,
                    text: "🌍  " + "language".tr(),
                    onTap: () => showLanguageDialog(context),
                  ),
                ],
              ),
            ),
            new AutoSizeText(
              "Made by",
              maxFontSize:
                  Theme.of(context).textTheme.headline2?.fontSize ?? 48,
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  ?.copyWith(color: materialPurple),
              maxLines: 1,
            ),
            GestureDetector(
              child: new AutoSizeText(
                "Leonardo Rignanese",
                style: Theme.of(context).textTheme.headline1,
                maxLines: 2,
              ),
              onTap: () async =>
                  await launchURL("https://www.twitter.com/rignaneseleo/"),
            ),
          ]),
    );
  }

  Future buildPaymentWidget() async {
    //get the product
    const Set<String> _kIds = <String>{'donation0'};
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(_kIds);
    if (response.notFoundIDs.isNotEmpty) {
      showToast("Product not found");
      showToast("error_trylater".tr());
      return;
    }

    //set the listener
    Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    _paymentSubscription ??=
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      // handle  purchaseDetailsList
      purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
        if (purchaseDetails.status == PurchaseStatus.pending) {
        } else {
          if (purchaseDetails.status == PurchaseStatus.error) {
            showToast("error_trylater".tr());
          } else if (purchaseDetails.status == PurchaseStatus.purchased ||
              purchaseDetails.status == PurchaseStatus.restored) {
            showToast("thankyou".tr() + " ❤️");
          }
          if (purchaseDetails.pendingCompletePurchase) {
            await InAppPurchase.instance.completePurchase(purchaseDetails);
          }
        }
      });
    }, onDone: () {
      showToast("thankyou".tr() + " 🍻");
      print("Close subscription");
    }, onError: (error) {
      print("Payment error: " + error.toString());
      showToast("error_trylater".tr());
    });

    //show the dialog
    List<ProductDetails> products = response.productDetails;
    var product = products.first;
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);

    return;

    /*
    bool available = await InAppPurchaseConnection.instance.isAvailable();
    if (!available) {
      showToast("error_trylater".tr());
      return;
    }

    //Get stuff available
    const Set<String> _kIds = <String>{'donation0'};
    final ProductDetailsResponse response =
        await InAppPurchaseConnection.instance.queryProductDetails(_kIds);
    if (response.notFoundIDs.isNotEmpty) {
      showToast("error_trylater".tr());
      return;
    }

    //Register for updates
    final Stream purchaseUpdated =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    purchaseUpdated.listen((purchaseDetailsList) {}, onDone: () {
      showToast("thankyou".tr() + " 🍻");
    }, onError: (error) {
      print("Payment error: " + error.toString());
      showToast("error_trylater".tr());
    });

    //Perform the payment
    List<ProductDetails> products = response.productDetails;
    final ProductDetails productDetails = products.elementAt(0);
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
    InAppPurchaseConnection.instance
        .buyConsumable(purchaseParam: purchaseParam);
*/
    // From here the purchase flow will be handled by the underlying store.
  }

  showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text("language".tr()),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: supportedLanguages.length,
              itemBuilder: (context, i) {
                var localeStr = supportedLanguages[i].toString();
                return ListTile(
                  leading: Text(le.getFlagEmoji(
                          languageCode: localeStr.substring(0, 2)) ??
                      ""),
                  title: Text(
                      LocaleNames.of(context)!.nameOf(localeStr) ?? localeStr),
                  onTap: () async {
                    await sp.setString("saved_locale", localeStr);
                    await context.setLocale(supportedLanguages[i]);
                    //need to reboot so it reads the correct csv
                    Restart.restartApp();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
