import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

typedef TapSpecialStrCallback = void Function(String spStr, String type);

class LinkRichModel {
  final String text;
  final TextStyle style;
  final TextStyle linkStyle;
  List<SpecialStr> specialStrs;
  final List<RegExpStr> regExpStrs;
  final TapSpecialStrCallback onTapSpecialStr;

  final String _linkRegExpStr =
      "((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#\$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#\$%^&*+?:_/=<>]*)?)";
  final TextStyle _defStyle =
      const TextStyle(fontSize: 17, color: Colors.black);
  final TextStyle _defSpecialStyle =
      const TextStyle(fontSize: 17, color: Colors.blue);
  TextSpan get textSpan => _textSpan;
  TextSpan _textSpan;

  LinkRichModel(
    this.text, {
    this.style,
    this.linkStyle,
    this.specialStrs,
    this.regExpStrs,
    this.onTapSpecialStr,
  }) : assert(text != null) {
    if (!(specialStrs is List)) {
      specialStrs = <SpecialStr>[];
    }
    _initLinkSpecial();
    _initRegExpStrs();
    _textSpan = _initTextSpan();
  }

  _initLinkSpecial() {
    _addSpecialStrByRegExpStr(_linkRegExpStr, type: 'link', style: linkStyle);
  }

  _initRegExpStrs() {
    if (regExpStrs == null) {
      return;
    }
    for (RegExpStr regExpStr in regExpStrs) {
      if ((regExpStr.text ?? '').length <= 0) {
        continue;
      }
      _addSpecialStrByRegExpStr(regExpStr.text,
          type: regExpStr.type ?? '', style: regExpStr.style ?? linkStyle);
    }
  }

  _addSpecialStrByRegExpStr(String regExpStr, {String type, TextStyle style}) {
    RegExp linkExp = RegExp(regExpStr);
    Iterable<Match> matches = linkExp.allMatches(text);
    for (Match m in matches) {
      String match = m.group(0);
      bool hasThisSpecialStr = false;
      for (SpecialStr specialStr in specialStrs) {
        if (specialStr.text == match) {
          hasThisSpecialStr = true;
          break;
        }
      }
      if (hasThisSpecialStr == true) {
        continue;
      }
      SpecialStr specialStr = SpecialStr(text: match, type: type, style: style);
      specialStrs.add(specialStr);
    }
  }

  TextSpan _initTextSpan() {
    Map<int, _SpecialStrRange> temList = Map<int, _SpecialStrRange>();
    var specialStrRanges = <_SpecialStrRange>[];
    // 算出特殊字符的范围
    for (SpecialStr specialStr in specialStrs) {
      Iterable<Match> matches = specialStr.text.allMatches(text);
      for (Match m in matches) {
        String match = m.group(0);
        if ((match ?? '').length > 0) {
          // 去重
          _SpecialStrRange temSpecialStrRange = temList[m.start];
          if (temSpecialStrRange != null) {
            if (temSpecialStrRange.specialStr.text.contains(specialStr.text)) {
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
    specialStrRanges
        .sort((left, right) => left.range.start.compareTo(right.range.start));

    // 拼装富文本
    List<TextSpan> textSpans = <TextSpan>[];
    int start = 0;
    int end = 0;
    for (_SpecialStrRange specialStrRange in specialStrRanges) {
      start = end;
      end = specialStrRange.range.start;
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
        text: specialStrRange.specialStr.text,
        style: specialStrRange.specialStr.style ?? _defSpecialStyle,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            if (onTapSpecialStr != null) {
              onTapSpecialStr(specialStrRange.specialStr.text,
                  specialStrRange.specialStr.type);
            }
          },
      );
      textSpans.add(speTxtSpan);
      end = specialStrRange.range.end;
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

    return TextSpan(text: '', children: textSpans);
  }
}

class SpecialStr {
  final String text;
  final TextStyle style;
  final String type;
  SpecialStr({this.text, this.style, this.type});
}

class RegExpStr {
  final String text;
  final TextStyle style;
  final String type;
  RegExpStr({this.text, this.style, this.type});
}

class _SpecialStrRange {
  final TextRange range;
  final SpecialStr specialStr;
  _SpecialStrRange({this.range, this.specialStr});
}
