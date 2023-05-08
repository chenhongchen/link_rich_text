export 'package:link_rich_text/link_rich_model.dart';
import 'package:flutter/material.dart';
import 'package:link_rich_text/link_rich_model.dart';

class LinkRichText extends StatelessWidget {
  /// 要显示的文本
  final String text;

  /// 要显示文本的样式
  final TextStyle? style;

  /// 链接的样式
  final TextStyle? linkStyle;

  /// 特殊字符串模型
  final List<SpecialStr>? specialStrs;

  /// 正则特殊字符串模型
  final List<RegExpStr>? regExpStrs;

  /// 点击特殊字符串回调
  final TapSpecialStrCallback? onTapSpecialStr;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// The directionality of the text.
  final TextDirection? textDirection;

  /// Whether the text should break at soft line breaks.
  final bool softWrap;

  /// How visual overflow should be handled.
  final TextOverflow overflow;

  /// The number of font pixels for each logical pixel.
  final double textScaleFactor;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  final int? maxLines;

  /// Used to select a font when the same Unicode character can
  final Locale? locale;

  /// {@macro flutter.painting.textPainter.strutStyle}
  final StrutStyle? strutStyle;

  /// {@macro flutter.painting.textPainter.textWidthBasis}
  final TextWidthBasis textWidthBasis;

  /// 生成的TextSpan
  TextSpan get textSpan => _model.textSpan;

  //
  final LinkRichModel _model;

  LinkRichText(
    this.text, {
    Key? key,
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
  })  : assert(maxLines == null || maxLines > 0),
        _model = LinkRichModel(
          text,
          style: style,
          linkStyle: linkStyle,
          specialStrs: specialStrs,
          regExpStrs: regExpStrs,
          onTapSpecialStr: onTapSpecialStr,
        ),
        super(key: key);

  LinkRichText.fromModel(
    LinkRichModel model, {
    Key? key,
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
  })  : assert(maxLines == null || maxLines > 0),
        text = model.text,
        style = model.style,
        linkStyle = model.linkStyle,
        specialStrs = model.specialStrs,
        regExpStrs = model.regExpStrs,
        _model = model,
        super(key: key) {
    if (onTapSpecialStr != null) {
      _model.onTapSpecialStr = onTapSpecialStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _model.hasSpecialStr
        ? RichText(
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
          )
        : Text(
            text,
            key: key,
            style: style,
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
}
