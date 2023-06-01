import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Trans;
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

import '../persistence/csv_data_reader.dart';
import '../utils/utils.dart';

class SettingsPage extends StatefulWidget {
  static const String emailLeo = "dev.rignaneseleo%2Btabu%40gmail.com";
  bool openPaymentDialog = false;

  SettingsPage({Key? key, this.openPaymentDialog = false}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  StreamSubscription<List<PurchaseDetails>>? _paymentSubscription;

  @override
  void initState() {
    _setupPaymentSubscription();
    super.initState();
  }

  _setupPaymentSubscription() {
    //set the listener
    _paymentSubscription ??= InAppPurchase.instance.purchaseStream.listen(
        (List<PurchaseDetails> purchaseDetailsList) {
      // handle  purchaseDetailsList
      purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
        if (purchaseDetails.status == PurchaseStatus.pending) {
        } else {
          if (purchaseDetails.status == PurchaseStatus.error) {
            showToast("error_trylater".tr());
          } else if (purchaseDetails.status == PurchaseStatus.purchased ||
              purchaseDetails.status == PurchaseStatus.restored) {
            if (purchaseDetails.productID.contains("words")) {
              if (purchaseDetails.productID == "100words")
                await sp.setBool("100words", true);
              else if (purchaseDetails.productID == "1000words")
                await sp.setBool("1000words", true);
              else if (purchaseDetails.productID == "500words")
                await sp.setBool("500words", true);

              //load the new words
              words = await CSVDataReader.loadWords();
              setState(() {});
            }

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

    if (widget.openPaymentDialog)
      Future.delayed(Duration(milliseconds: 500), () => showPaymentDialog());
  }

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
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
              ],
            ),
            Expanded(
              child: ListView(
                shrinkWrap: false,
                physics: BouncingScrollPhysics(),
                children: [
                  if (!(sp.getBool("1000words") ?? false)) ...[
                    buildLine(
                      context,
                      text: "🚀  " + "Buy more words".tr(),
                      onTap: () => showPaymentDialog(),
                    ),
                    Container(height: smallScreen ? 0 : 20),
                  ],
                  buildLine(
                    context,
                    text: "🌍  " + "language".tr(),
                    onTap: () => showLanguageDialog(context),
                  ),
                  buildLine(
                    context,
                    text: "📙  " + "Rules".tr(),
                    onTap: () => Get.to(() => RulesPage(),
                        transition: Transition.downToUp),
                  ),
                  buildLine(
                    context,
                    text: "📈  " + "Analytics".tr(),
                    onTap: () => Get.to(() => AnalyticsPage(),
                        transition: Transition.downToUp),
                  ),
                  buildLine(
                    context,
                    text: "👨🏽‍💻  " + "look_code".tr(),
                    onTap: () =>
                        launchURL("https://github.com/rignaneseleo/SpeakEasy"),
                  ),
                  buildLine(
                    context,
                    text: "🤯  " + "report_bug".tr(),
                    onTap: () => launchURL(
                        "mailto:${SettingsPage.emailLeo}?subject=Bug%20tabu%20"),
                  ),
                  if (kDebugMode)
                    buildLine(context, text: "--- reset sp", onTap: () {
                      sp.remove("100words");
                      sp.remove("500words");
                      sp.remove("1000words");

                      showToast("done");
                    }),
                ],
              ),
            ),
            Container(height: smallScreen ? 0 : 30),
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
                  await launchURL("https://www.twitter.com/leorigna/"),
            ),
          ]),
    );
  }

  Future showPaymentDialog() async {
    const Set<String> _kIds = <String>{
      '100words',
      '500words',
      '1000words',
    };
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(_kIds);
    if (response.notFoundIDs.isNotEmpty) {
      print("Product not found");
      showToast("error_trylater".tr());
      return;
    }
    List<ProductDetails> products = response.productDetails;
    var _100words = products.firstWhereOrNull((p) => p.id == "100words");
    var _500words = products.firstWhereOrNull((p) => p.id == "500words");
    var _1000words = products.firstWhereOrNull((p) => p.id == "1000words");

    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      //title: Text("Buy more words",style: TextStyle(color: Colors.black),),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_100words != null)
            ListTile(
              enabled: !(sp.getBool("100words") ?? false),
              trailing: Icon(
                Icons.chat_bubble_outlined,
                size: 20,
              ),
              title: Text("Buy {} words".tr(args: ["100"])),
              subtitle: Text(_100words.price),
              onTap: () async {
                final PurchaseParam purchaseParam =
                    PurchaseParam(productDetails: _100words);
                var res = await InAppPurchase.instance
                    .buyNonConsumable(purchaseParam: purchaseParam);
                if (res) Get.back();
              },
            ),
          if (_500words != null)
            ListTile(
              enabled: !(sp.getBool("500words") ?? false),
              trailing: Icon(
                Icons.chat_bubble_outlined,
                size: 25,
              ),
              title: Text("Buy {} words".tr(args: ["500"])),
              subtitle: Text(_500words.price),
              onTap: () async {
                final PurchaseParam purchaseParam =
                    PurchaseParam(productDetails: _500words);
                var res = await InAppPurchase.instance
                    .buyNonConsumable(purchaseParam: purchaseParam);
                if (res) Get.back();
              },
            ),
          if (_1000words != null)
            ListTile(
              enabled: !(sp.getBool("1000words") ?? false),
              trailing: Icon(
                Icons.chat_bubble_outlined,
                size: 35,
              ),
              title: Text("Buy {} words".tr(args: ["1000"])),
              subtitle: Text(_1000words.price),
              onTap: () async {
                final PurchaseParam purchaseParam =
                    PurchaseParam(productDetails: _1000words);
                var res = await InAppPurchase.instance
                    .buyNonConsumable(purchaseParam: purchaseParam);
                if (res) Get.back();
              },
            ),
          //restore
          ListTile(
            title: Text("Restore".tr()),
            subtitle: Text("Restore your purchases".tr()),
            onTap: () async {
              await InAppPurchase.instance.restorePurchases();
              Get.back();
            },
          ),
          /*ListTile(
            title: Text("secret_code".tr()),
            subtitle: Text("unlock_cool_stuff".tr()),
            onTap: () async {


              await InAppPurchase.instance.restorePurchases();
              Get.back();
            },
          ),*/
        ],
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) => alert,
    );
    return;
  }

  showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          //title: Text("language".tr()),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: supportedLanguages.length,
              itemBuilder: (context, i) {
                var localeStr = supportedLanguages[i].toString();
                return ListTile(
                  leading: Text(
                      le.getFlagEmoji(
                              languageCode: localeStr.substring(0, 2)) ??
                          "",
                      style: TextStyle(fontSize: 28)),
                  title: Text(
                      LocaleNames.of(context)!.nameOf(localeStr) ?? localeStr),
                  onTap: () async {
                    await sp.setString("saved_locale", localeStr);
                    await context.setLocale(supportedLanguages[i]);
                    //need to reboot so it reads the correct csv
                    Restart.restartApp();
                  },
                  trailing: localeStr ==
                          getSelectedLocale(context: context)!.toString()
                      ? Icon(Icons.check)
                      : null,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
