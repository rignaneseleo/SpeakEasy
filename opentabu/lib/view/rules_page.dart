import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:opentabu/theme/theme.dart';
import 'package:opentabu/utils/toast.dart';
import 'package:opentabu/view/widget/my_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

class RulesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var txtStyle = Theme.of(context)
        .textTheme
        .bodyText1
        ?.copyWith(color: txtWhite, height: 1.8, fontWeight: FontWeight.normal);

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
        new AutoSizeText(
          "Regole",
          style: Theme.of(context).textTheme.headline2,
          maxLines: 2,
        ),
        Expanded(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Text(
                "Scopo",
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                "Tabù è un gioco di squadra. Lo scopo è quello di fare più punti delle squadre avversarie. "
                "A turno un giocatore detto il 'Suggeritore' dovrà tenere in mano questo cellulare "
                    "e far indovinare ai componenti della propria "
                "squadra la parola segreta (parola in grigio sulla parte superiore dello schermo)"
                " senza pronunciare le parole tabù relative a quel termine (lista di parole in nero).",
                style: txtStyle,
              ),
              Container(height: 30),
              Text(
                "Preparazione",
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                "Forma da 2 a 5 squadre con un numero pari di giocatori (almeno due giocatori per squadra). "
                "Disponi i giocatori in cerchio, "
                "alternando i giocatori di ogni squadra. Una persona della prima squadra inizierà nel ruolo "
                "di 'Suggeritore', ovvero colui che deve far indovinare una parola ai membri della sua "
                "squadra senza pronunciare le parole tabù.",
                style: txtStyle,
              ),
              Container(height: 30),
              Text(
                "Il gioco",
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                "Ogni turno è a tempo. Durante ogni turno, il Suggeritore deve cercare di far indovinare "
                "più parole possibili ai suoi compagni di squadra,"
                "mentre i membri delle squadre avversarie hanno il ruolo di controllare che "
                "il Suggeritore non stia pronunciando parole incluse nella lista dei tabù. "
                    "\r\n\r\nIl Suggeritore dovrà tenere in mano questo cellulare. "
                    "Alla fine di ogni turno, il celluare passa al giocatore alla propria destra. "
                "\r\n\r\nUna parola è considerata indovinata solo se viene pronunciata esattamente nella forma scritta sullo schermo, altre forme verbali e i plurali/singolari non sono validi."
                "\r\n\r\nPer il Suggeritore, è vietato:"
                "\r\n - dire parti che compongono le parole tabù o la parola segreta (non si può dire “porco” o “spino” se la parola è “Porcospino”);"
                "\r\n - usare le forme plurali delle parole indicate, neppure nelle forme irregolari (per esempio, non si può dire “parchi” per far indovinare “parco” ai propri compagni di squadra);"
                "\r\n - fare gesti;"
                "\r\n - dire “fa rima con”, “suona come” o “assomiglia a”;"
                "\r\n - usare abbreviazioni (ad esempio, non di può dire “PC” per suggerire “computer”)."
                "\r\n\r\nSe uno dei giocatori che sta indovinando pronuncia uno dei tabù, quella parola diventa utilizzabile anche dal Suggeritore.",
                style: txtStyle,
              ),
              Container(height: 30),
              Text(
                "Punti",
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                "Per ogni parola indovinata, bisogna premere il pulsante verde e si guadagna un punto. "
                "\r\n\r\nPer ogni tabù pronunciato o infrazione delle regole, bisogna premere il pulsante rosso e si perde un punto.",
                style: txtStyle,
              ),
            ],
          ),
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
