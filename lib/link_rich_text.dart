import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SpecialText {
  final String text;
  final TextStyle style;
  final String type;
  SpecialText({this.text, this.style, this.type = 'link'});
}

class SpecialTextRange {
  final TextRange range;
  final SpecialText specialText;
  SpecialTextRange({this.range, this.specialText});
}

class LinkRichText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextStyle linkStyle;
  List<SpecialText> specialTexts;
  final Function(String spText, String type) onTapSpecialText;

  //
  final Key key;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int maxLines;
  final Locale locale;
  final StrutStyle strutStyle;
  final TextWidthBasis textWidthBasis;
  //

//  final String _linkRegExpStr =
//      "((?:(?:https?|ftp):\\/\\/)(?:\\S+(?::\\S*)?@)?(?:(?:(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|(?:(?:[a-zA-Z0-9\\u00a1-\\uffff]+-?)*[a-zA-Z0-9\\u00a1-\\uffff]+)(?:\\.(?:[a-zA-Z0-9\\u00a1-\\uffff]+-?)*[a-zA-Z0-9\\u00a1-\\uffff]+)*(?:\\.(?:[a-zA-Z\\u00a1-\\uffff]{2,})))|localhost)(?::\\d{2,5})?(?:\\/(?:(?!\\1|\\s)[\\S\\s])*)?[^\\s'\\\"]*)";

  final String _linkRegExpStr =
      "((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#\$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#\$%^&*+?:_/=<>]*)?)";
  RichText _richText;
  TextSpan get textSpan => _richText.text;
  TextStyle _defStyle;
  TextStyle _defSpecialStyle;

  LinkRichText(
    this.text, {
    this.key,
    this.style,
    this.linkStyle,
    this.specialTexts,
    this.onTapSpecialText,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
  })  : assert(text != null),
        assert(textAlign != null),
        assert(softWrap != null),
        assert(overflow != null),
        assert(textScaleFactor != null),
        assert(maxLines == null || maxLines > 0),
        assert(textWidthBasis != null),
        super(key: key) {
    _defStyle = TextStyle(fontSize: 17, color: Colors.black);
    _defSpecialStyle = TextStyle(fontSize: 17, color: Colors.blue);
    _initLinkSpecial();
    _initRichText();
  }

  _initLinkSpecial() {
    if (!(specialTexts is List)) {
      specialTexts = List<SpecialText>();
    }
    RegExp linkExp = RegExp(_linkRegExpStr);
    Iterable<Match> matches = linkExp.allMatches(text);
    for (Match m in matches) {
      String match = m.group(0);
      bool hasThisSpecialText = false;
      for (SpecialText specialText in specialTexts) {
        if (specialText.text == match) {
          hasThisSpecialText = true;
          break;
        }
      }
      if (hasThisSpecialText == true) {
        continue;
      }
      SpecialText specialText = SpecialText(text: match, style: linkStyle);
      specialTexts.add(specialText);
      print('url = $match');
    }
  }

  _initRichText() {
    var specialTextRanges = List<SpecialTextRange>();
    // 算出特殊字符的范围
    for (SpecialText specialText in specialTexts) {
      Iterable<Match> matches = specialText.text.allMatches(text);
      for (Match m in matches) {
        String match = m.group(0);
        if ((match ?? '').length > 0) {
          SpecialTextRange specialTextRange = SpecialTextRange(
              range: TextRange(start: m.start, end: m.end),
              specialText: specialText);
          specialTextRanges.add(specialTextRange);
        }
      }
    }
    // 按位置从小到大排序
    specialTextRanges
        .sort((left, right) => left.range.start.compareTo(right.range.start));

    // 拼装富文本
    List<TextSpan> textSpans = List<TextSpan>();
    int start = 0;
    int end = 0;
    for (SpecialTextRange specialTextRange in specialTextRanges) {
      start = end;
      end = specialTextRange.range.start;
      String norText = text.substring(start, end);
      if (norText.length > 0) {
        TextSpan norTxtSpan = TextSpan(
          text: norText,
          style: style ?? _defStyle,
        );
        textSpans.add(norTxtSpan);
      }
      TextSpan speTxtSpan = TextSpan(
        text: specialTextRange.specialText.text,
        style: specialTextRange.specialText.style ?? _defSpecialStyle,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            if (onTapSpecialText != null) {
              onTapSpecialText(specialTextRange.specialText.text,
                  specialTextRange.specialText.type);
            }
          },
      );
      textSpans.add(speTxtSpan);
      end = specialTextRange.range.end;
    }
    if (end < text.length) {
      start = end;
      end = text.length;
      String norText = text.substring(start, end);
      TextSpan norTxtSpan = TextSpan(
        text: norText,
        style: style ?? _defStyle,
      );
      textSpans.add(norTxtSpan);
    }

    TextSpan firstTextSpan = textSpans.first;
    textSpans.remove(firstTextSpan);
    _richText = RichText(
      key: key,
      text: TextSpan(
          text: firstTextSpan.text,
          style: firstTextSpan.style,
          recognizer: firstTextSpan.recognizer,
          children: textSpans),
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _richText;
  }
}
