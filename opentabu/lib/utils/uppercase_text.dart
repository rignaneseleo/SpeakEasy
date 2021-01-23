import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';

class UpperCaseText extends Text {
  UpperCaseText(
    String data, {
    Key key,
    TextStyle style,
    StrutStyle strutStyle,
    TextAlign textAlign,
    TextDirection textDirection,
    Locale locale,
    bool softWrap,
    TextOverflow overflow,
    double textScaleFactor,
    int maxLines,
    String semanticsLabel,
    TextWidthBasis textWidthBasis,
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
    data, {
    Key key,
    textKey,
    style,
    strutStyle,
    double minFontSize = 12.0,
    double maxFontSize = double.infinity,
    double stepGranularity = 1,
    presetFontSizes,
    group,
    textAlign,
    textDirection,
    locale,
    softWrap,
    bool wrapWords = true,
    overflow,
    overflowReplacement,
    textScaleFactor,
    maxLines,
    semanticsLabel,
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
        );
}
