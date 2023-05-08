import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

typedef TapSpecialStrCallback = void Function(String spStr, String type);

/// 富文本模型
class LinkRichModel {
  /// 要显示的文本
  final String text;

  /// 要显示文本的样式
  final TextStyle? style;

  /// 链接的样式
  final TextStyle? linkStyle;

  /// 特殊字符串模型
  List<SpecialStr>? specialStrs;

  /// 正则特殊字符串模型
  final List<RegExpStr>? regExpStrs;

  /// 点击特殊字符串回调
  TapSpecialStrCallback? onTapSpecialStr;

  /// 生成的TextSpan
  TextSpan get textSpan => _textSpan;
  late TextSpan _textSpan;

  /// 文案中是否有特殊字符串
  bool get hasSpecialStr => _hasSpecialStr ?? false;
  bool? _hasSpecialStr;

  /// 文案样式
  TextStyle get norStyle => style ?? _defStyle;

  final String _linkRegExpStr =
      "((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#\$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#\$%^&*+?:_/=<>]*)?)";
  final TextStyle _defStyle =
      const TextStyle(fontSize: 17, color: Colors.black);
  final TextStyle _defSpecialStyle =
      const TextStyle(fontSize: 17, color: Colors.blue);

  LinkRichModel(
    this.text, {
    this.style,
    this.linkStyle,
    this.specialStrs,
    this.regExpStrs,
    this.onTapSpecialStr,
  }) {
    if (specialStrs is! List) {
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
    for (RegExpStr regExpStr in regExpStrs!) {
      if (regExpStr.text.isEmpty) {
        continue;
      }
      _addSpecialStrByRegExpStr(regExpStr.text,
          type: regExpStr.type ?? '', style: regExpStr.style ?? linkStyle);
    }
  }

  _addSpecialStrByRegExpStr(String regExpStr,
      {String? type, TextStyle? style}) {
    RegExp linkExp = RegExp(regExpStr);
    Iterable<Match> matches = linkExp.allMatches(text);
    for (Match m in matches) {
      String? match = m.group(0);
      if (match == null) continue;
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
    }
  }

  TextSpan _initTextSpan() {
    var specialStrRanges = <_SpecialStrRange>[];
    // 算出特殊字符的范围
    for (SpecialStr specialStr in specialStrs!) {
      Iterable<Match> matches = specialStr.text.allMatches(text);
      var temSpecialStrRanges = List.from(specialStrRanges);
      for (Match m in matches) {
        String? match = m.group(0);
        if ((match ?? '').isNotEmpty) {
          // 范围去重（交叉：结束位置靠后者优先，包含：范围大者优先，相同：后者优先）
          bool isDiscard = false;
          for (_SpecialStrRange specialStrRange in temSpecialStrRanges) {
            if ((specialStrRange.range.start < m.end &&
                    specialStrRange.range.end > m.end) ||
                (specialStrRange.range.start < m.start &&
                    specialStrRange.range.end == m.end)) {
              isDiscard = true;
              break;
            }
            if (m.start < specialStrRange.range.end &&
                m.end >= specialStrRange.range.end) {
              specialStrRanges.remove(specialStrRange);
            }
          }
          if (isDiscard) continue;
          //
          _SpecialStrRange specialStrRange = _SpecialStrRange(
              range: TextRange(start: m.start, end: m.end),
              specialStr: specialStr);
          specialStrRanges.add(specialStrRange);
        }
      }
    }
    // 按位置从小到大排序
    specialStrRanges
        .sort((left, right) => left.range.start.compareTo(right.range.start));
    _hasSpecialStr = specialStrRanges.isNotEmpty;

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
      } catch (e) {
        if (kDebugMode) {
          print('$e');
        }
      }
      if (norText.isNotEmpty) {
        TextSpan norTxtSpan = TextSpan(
          text: norText,
          style: norStyle,
        );
        textSpans.add(norTxtSpan);
      }
      TextSpan speTxtSpan = TextSpan(
        text: specialStrRange.specialStr.text,
        style: specialStrRange.specialStr.style ?? _defSpecialStyle,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            if (onTapSpecialStr != null) {
              onTapSpecialStr!(specialStrRange.specialStr.text,
                  specialStrRange.specialStr.type ?? '');
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
        style: norStyle,
      );
      textSpans.add(norTxtSpan);
    }

    return TextSpan(text: '', children: textSpans);
  }
}

/// 特殊字符串模型
class SpecialStr {
  /// 字符串
  final String text;

  /// 样式
  final TextStyle? style;

  /// 类型
  final String? type;

  SpecialStr({required this.text, this.style, this.type});
}

/// 正则特殊字符串模型
class RegExpStr {
  /// 字符串
  final String text;

  /// 样式
  final TextStyle? style;

  /// 类型
  final String? type;

  RegExpStr({required this.text, this.style, this.type});
}

class _SpecialStrRange {
  final TextRange range;
  final SpecialStr specialStr;

  _SpecialStrRange({required this.range, required this.specialStr});
}
