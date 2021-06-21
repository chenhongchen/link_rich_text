import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SpecialStr {
  final String? text;
  final TextStyle? style;
  final String? type;
  SpecialStr({this.text, this.style, this.type});
}

class RegExpStr {
  final String? text;
  final TextStyle? style;
  final String? type;
  RegExpStr({this.text, this.style, this.type});
}

class _SpecialStrRange {
  final TextRange? range;
  final SpecialStr? specialStr;
  _SpecialStrRange({this.range, this.specialStr});
}

class LinkRichText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextStyle? linkStyle;
  List<SpecialStr>? specialStrs;
  final List<RegExpStr>? regExpStrs;
  final Function(String spStr, String type)? onTapSpecialStr;

  //
  final Key? key;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int? maxLines;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis textWidthBasis;
  //

//  final String _linkRegExpStr =
//      "((?:(?:https?|ftp):\\/\\/)(?:\\S+(?::\\S*)?@)?(?:(?:(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|(?:(?:[a-zA-Z0-9\\u00a1-\\uffff]+-?)*[a-zA-Z0-9\\u00a1-\\uffff]+)(?:\\.(?:[a-zA-Z0-9\\u00a1-\\uffff]+-?)*[a-zA-Z0-9\\u00a1-\\uffff]+)*(?:\\.(?:[a-zA-Z\\u00a1-\\uffff]{2,})))|localhost)(?::\\d{2,5})?(?:\\/(?:(?!\\1|\\s)[\\S\\s])*)?[^\\s'\\\"]*)";

  final String _linkRegExpStr =
      "((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#\$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#\$%^&*+?:_/=<>]*)?)";
  late RichText _richText;
  InlineSpan get textSpan => _richText.text;
  late TextStyle _defStyle;
  late TextStyle _defSpecialStyle;

  LinkRichText(
    this.text, {
    this.key,
    this.style,
    this.linkStyle,
    this.specialStrs,
    this.regExpStrs,
    this.onTapSpecialStr,
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
    _initRegExpStrs();
    _initRichText();
  }

  _initLinkSpecial() {
    _addSpecialStrByRegExpStr(_linkRegExpStr, type: 'link', style: linkStyle);
  }

  _initRegExpStrs() {
    if (regExpStrs == null) {
      return;
    }
    for (RegExpStr regExpStr in regExpStrs!) {
      if ((regExpStr.text ?? '').length <= 0) {
        continue;
      }
      _addSpecialStrByRegExpStr(regExpStr.text!,
          type: regExpStr.type ?? '', style: regExpStr.style ?? linkStyle);
    }
  }

  _addSpecialStrByRegExpStr(String regExpStr,
      {String? type, TextStyle? style}) {
    if (!(specialStrs is List)) {
      specialStrs = <SpecialStr>[];
    }
    RegExp linkExp = RegExp(regExpStr);
    Iterable<Match> matches = linkExp.allMatches(text);
    for (Match m in matches) {
      String? match = m.group(0);
      bool hasThisSpecialStr = false;
      for (SpecialStr specialStr in specialStrs!) {
        if (specialStr.text == match) {
          hasThisSpecialStr = true;
          break;
        }
      }
      if (hasThisSpecialStr == true) {
        continue;
      }
      SpecialStr specialStr = SpecialStr(text: match, type: type, style: style);
      specialStrs!.add(specialStr);
      print('url = $match');
    }
  }

  _initRichText() {
    if (!(specialStrs is List)) {
      specialStrs = <SpecialStr>[];
    }
    Map<int, _SpecialStrRange> temList = Map<int, _SpecialStrRange>();
    var specialStrRanges = <_SpecialStrRange>[];
    // 算出特殊字符的范围
    for (SpecialStr specialStr in specialStrs!) {
      Iterable<Match>? matches = specialStr.text?.allMatches(text);
      if (matches == null) {
        continue;
      }
      for (Match m in matches) {
        String? match = m.group(0);
        if ((match ?? '').length > 0) {
          // 去重
          _SpecialStrRange? temSpecialStrRange = temList[m.start];
          if (temSpecialStrRange != null) {
            if ((temSpecialStrRange.specialStr?.text ?? '')
                .contains(specialStr.text ?? '')) {
              continue;
            } else {
              specialStrRanges.remove(temSpecialStrRange);
            }
          }
          //
          _SpecialStrRange specialStrRange = _SpecialStrRange(
              range: TextRange(start: m.start, end: m.end),
              specialStr: specialStr);
          specialStrRanges.add(specialStrRange);
          temList[m.start] = specialStrRange;
        }
      }
    }
    // 按位置从小到大排序
    specialStrRanges.sort((left, right) =>
        (left.range?.start ?? 0).compareTo(right.range?.start ?? 0));

    // 拼装富文本
    List<TextSpan> textSpans = <TextSpan>[];
    int start = 0;
    int end = 0;
    for (_SpecialStrRange specialStrRange in specialStrRanges) {
      start = end;
      end = specialStrRange.range?.start ?? 0;
      String norText = '';
      try {
        norText = text.substring(start, end);
      } catch (e) {}
      if (norText.length > 0) {
        TextSpan norTxtSpan = TextSpan(
          text: norText,
          style: style ?? _defStyle,
        );
        textSpans.add(norTxtSpan);
      }
      TextSpan speTxtSpan = TextSpan(
        text: specialStrRange.specialStr?.text ?? '',
        style: specialStrRange.specialStr?.style ?? _defSpecialStyle,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            if (onTapSpecialStr != null) {
              if (specialStrRange.specialStr?.text == null ||
                  specialStrRange.specialStr?.type == null) {
                return;
              }
              onTapSpecialStr!(specialStrRange.specialStr!.text!,
                  specialStrRange.specialStr!.type!);
            }
          },
      );
      textSpans.add(speTxtSpan);
      end = specialStrRange.range?.end ?? 0;
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

    TextSpan textSpan = TextSpan(text: '', children: textSpans);
    _richText = RichText(
      key: key,
      text: textSpan,
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
