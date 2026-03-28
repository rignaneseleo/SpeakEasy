import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:locale_emoji/locale_emoji.dart' as le;

import '../model/word.dart';
import '../provider/device_provider.dart';
import '../provider/locale_provider.dart';
import '../provider/shared_preferences_provider.dart';
import '../provider/unlocked_words_provider.dart';
import '../provider/words_provider.dart';
import '../theme/app_theme.dart';
import '../util/toast.dart';
import '../util/url_launcher.dart';
import 'widget/app_scaffold.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key, this.openPaymentDialog = false});

  static const String emailLeo = 'dev.rignaneseleo%2Btabu%40gmail.com';
  final bool openPaymentDialog;

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  StreamSubscription<List<PurchaseDetails>>? _paymentSubscription;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) _setupPaymentSubscription();
  }

  void _setupPaymentSubscription() {
    _paymentSubscription ??= InAppPurchase.instance.purchaseStream.listen(
      (purchases) {
        for (final details in purchases) {
          if (details.status == PurchaseStatus.error) {
            showToast('error_trylater'.tr());
          } else if (details.status == PurchaseStatus.purchased ||
              details.status == PurchaseStatus.restored) {
            if (details.productID.contains('words')) {
              final sp = ref.read(sharedPreferencesProvider);
              switch (details.productID) {
                case '100words':
                  sp.setBool('100words', true);
                case '500words':
                  sp.setBool('500words', true);
                case '1000words':
                  sp.setBool('1000words', true);
              }
              ref.invalidate(unlockedWordsCountProvider);
              setState(() {});
            }
            showToast('${'thankyou'.tr()} ❤️');
          }
          if (details.pendingCompletePurchase) {
            InAppPurchase.instance.completePurchase(details);
          }
        }
      },
      onDone: () => showToast('${'thankyou'.tr()} 🍻'),
      onError: (_) => showToast('error_trylater'.tr()),
    );

    if (widget.openPaymentDialog) {
      Future.delayed(
        const Duration(milliseconds: 500),
        () => _showPaymentDialog(),
      );
    }
  }

  @override
  void dispose() {
    _paymentSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final device = ref.watch(deviceInfoProvider);
    final sp = ref.read(sharedPreferencesProvider);
    final smallScreen = device.isSmallScreen;

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy < -8) context.pop();
      },
      child: AppScaffold(
        topLeftWidget: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Theme.of(context).canvasColor,
          ),
          onPressed: () => context.pop(),
        ),
        widgets: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SettingsLine(
                text: 'Version'.tr(),
                value: device.packageInfo?.version,
              ),
              FutureBuilder<List<Word>>(
                future: ref.watch(wordsControllerProvider.future),
                builder: (context, snapshot) {
                  return SettingsLine(
                    text: '#Words'.tr(),
                    value: (snapshot.data?.length ?? '...').toString(),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                if (!(sp.getBool('1000words') ?? false)) ...[
                  SettingsLine(
                    text: '🚀  ${'Buy more words'.tr()}',
                    onTap: _showPaymentDialog,
                  ),
                  SizedBox(height: smallScreen ? 0 : 20),
                ],
                SettingsLine(
                  text: '🌍  ${'language'.tr()}',
                  onTap: () => _showLanguageDialog(context),
                ),
                SettingsLine(
                  text: '📙  ${'Rules'.tr()}',
                  onTap: () => context.push('/rules'),
                ),
                SettingsLine(
                  text: '📈  ${'Analytics'.tr()}',
                  onTap: () => context.push('/analytics'),
                ),
                SettingsLine(
                  text: '👨🏽‍💻  ${'look_code'.tr()}',
                  onTap: () =>
                      launchURL('https://github.com/rignaneseleo/SpeakEasy'),
                ),
                SettingsLine(
                  text: '🤯  ${'report_bug'.tr()}',
                  onTap: () => launchURL(
                    'mailto:${SettingsPage.emailLeo}?subject=Bug%20tabu%20',
                  ),
                ),
                if (kDebugMode)
                  SettingsLine(
                    text: '--- reset sp',
                    onTap: () {
                      sp
                        ..remove('100words')
                        ..remove('500words')
                        ..remove('1000words');
                      ref.invalidate(unlockedWordsCountProvider);
                      showToast('done');
                    },
                  ),
              ],
            ),
          ),
          SizedBox(height: smallScreen ? 0 : 30),
          AutoSizeText(
            'Made by',
            maxFontSize:
                Theme.of(context).textTheme.displayMedium?.fontSize ?? 48,
            style: Theme.of(context)
                .textTheme
                .displayLarge
                ?.copyWith(color: AppColors.materialPurple),
            maxLines: 1,
          ),
          GestureDetector(
            onTap: () => launchURL('https://www.twitter.com/leorigna/'),
            child: AutoSizeText(
              'Leonardo Rignanese',
              style: Theme.of(context).textTheme.displayLarge,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showPaymentDialog() async {
    const ids = <String>{'100words', '1000words'};
    final response = await InAppPurchase.instance.queryProductDetails(ids);
    if (response.notFoundIDs.isNotEmpty) {
      showToast('error_trylater'.tr());
      return;
    }

    final products = response.productDetails;
    final w100 = products.where((p) => p.id == '100words').firstOrNull;
    final w1000 = products.where((p) => p.id == '1000words').firstOrNull;
    final sp = ref.read(sharedPreferencesProvider);

    if (!mounted) return;

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (w100 != null)
              ListTile(
                enabled: !(sp.getBool('100words') ?? false),
                trailing: const Icon(Icons.chat_bubble_outlined, size: 20),
                title: Text('Buy {} words'.tr(args: ['100'])),
                subtitle: Text(w100.price),
                onTap: () async {
                  final param = PurchaseParam(productDetails: w100);
                  final ok = await InAppPurchase.instance
                      .buyNonConsumable(purchaseParam: param);
                  if (ok && ctx.mounted) Navigator.of(ctx).pop();
                },
              ),
            if (w1000 != null)
              ListTile(
                enabled: !(sp.getBool('1000words') ?? false),
                trailing: const Icon(Icons.chat_bubble_outlined, size: 35),
                title: Text('Buy {} words'.tr(args: ['1000'])),
                subtitle: Text(w1000.price),
                onTap: () async {
                  final param = PurchaseParam(productDetails: w1000);
                  final ok = await InAppPurchase.instance
                      .buyNonConsumable(purchaseParam: param);
                  if (ok && ctx.mounted) Navigator.of(ctx).pop();
                },
              ),
            ListTile(
              title: Text('Restore'.tr()),
              subtitle: Text('Restore your purchases'.tr()),
              onTap: () async {
                await InAppPurchase.instance.restorePurchases();
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: supportedLocales.length,
            itemBuilder: (context, i) {
              final locale = supportedLocales[i];
              final localeStr = locale.toString();
              return ListTile(
                leading: Text(
                  le.getFlagEmoji(languageCode: localeStr.substring(0, 2)) ??
                      '',
                  style: const TextStyle(fontSize: 28),
                ),
                title: Text(
                  LocaleNames.of(context)!.nameOf(localeStr) ?? localeStr,
                ),
                trailing: locale == ref.watch(savedLocaleProvider)
                    ? const Icon(Icons.check)
                    : null,
                onTap: () async {
                  final sp = ref.read(sharedPreferencesProvider);
                  await sp.setString(
                    'saved_locale_langcode',
                    locale.languageCode,
                  );
                  ref.invalidate(savedLocaleProvider);
                  if (context.mounted) await context.setLocale(locale);
                  if (ctx.mounted) Navigator.of(ctx).pop();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
