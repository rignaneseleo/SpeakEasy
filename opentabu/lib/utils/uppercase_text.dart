import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class UpperCaseText extends Text {
  UpperCaseText(
    String data, {
    Key? key,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    double? textScaleFactor,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
  }) : super(
          data.toUpperCase(),
          key: key,
          style: style,
          strutStyle: strutStyle,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          overflow: overflow,
          textScaleFactor: textScaleFactor,
          maxLines: maxLines,
          semanticsLabel: semanticsLabel,
          textWidthBasis: textWidthBasis,
        );
}

class UpperCaseAutoSizeText extends AutoSizeText {
  UpperCaseAutoSizeText(
    String data, {
    Key? key,
    Key? textKey,
    TextStyle? style,
    StrutStyle? strutStyle,
    double minFontSize = 12.0,
    double maxFontSize = double.infinity,
    List<double>? presetFontSizes,
    AutoSizeGroup? group,
    TextAlign? textAlign,
    double stepGranularity = 1,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    bool wrapWords = true,
    TextOverflow? overflow,
    Widget? overflowReplacement,
    double? textScaleFactor,
    int? maxLines,
    String? semanticsLabel,
    TextSpan? textSpan,
  }) : super(
          data.toUpperCase(),
          key: key,
          style: style,
          strutStyle: strutStyle,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          overflow: overflow,
          textScaleFactor: textScaleFactor,
          maxLines: maxLines,
          semanticsLabel: semanticsLabel,
          group: group,
          maxFontSize: maxFontSize,
          minFontSize: minFontSize,
          overflowReplacement: overflowReplacement,
          presetFontSizes: presetFontSizes,
          stepGranularity: stepGranularity,
          textKey: textKey,
          wrapWords: wrapWords,
        ) {
    // TODO: implement UpperCaseAutoSizeText
    throw UnimplementedError();
  }
}
