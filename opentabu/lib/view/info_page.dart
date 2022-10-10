import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:opentabu/main.dart';
import 'package:opentabu/theme/theme.dart';
import 'package:opentabu/utils/toast.dart';
import 'package:opentabu/view/analytics_page.dart';
import 'package:opentabu/view/widget/my_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatelessWidget {
  //TODO email da codificare con https://www.w3schools.com/tags/ref_urlencode.asp
  static const String emailLeo = "dev.rignaneseleo%2Btabu%40gmail.com";

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
      child: MyScaffold(widgets: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Theme.of(context).canvasColor,
                ),
                onPressed: () => Get.back()),
          ),
        ),
        Expanded(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Container(height: smallScreen ? 0 : 40),
              buildLine(
                context,
                name: "Version".tr(),
                value: packageInfo?.version.toString(),
              ),
              buildLine(
                context,
                name: "#Tabu".tr(),
                value: words.length,
              ),
              Container(height: smallScreen ? 0 : 60),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => buildPaymentWidget(),
                  child: new Text(
                    "☕️  " + "Support".tr(),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => Get.to(() => AnalyticsPage(),
                      transition: Transition.upToDown),
                  child: new Text(
                    "📊  " + "Analytics".tr(),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () =>
                      _launchURL("mailto:$emailLeo?subject=Bug%20tabu%20"),
                  child: new Text(
                    "🤯  " + "report_bug".tr(),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
            ],
          ),
        ),
        new AutoSizeText(
          "Made by",
          maxFontSize: Theme.of(context).textTheme.headline2?.fontSize ?? 48,
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
              await _launchURL("https://www.linkedin.com/in/rignaneseleo/"),
        ),
      ]),
    );
  }

  Widget buildLine(context, {required String name, value}) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: new Text(
            name.tr(),
            style: Theme.of(context)
                .textTheme
                .headline4
                ?.copyWith(color: txtWhite),
          ),
        ),
        Text(value.toString(),
            style: Theme.of(context)
                .textTheme
                .headline4
                ?.copyWith(color: txtWhite)),
      ],
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future buildPaymentWidget() async {
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

    // From here the purchase flow will be handled by the underlying store.
  }
}
