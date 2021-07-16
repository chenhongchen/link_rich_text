export 'package:link_rich_text/link_rich_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_rich_text/link_rich_model.dart';

class LinkRichText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextStyle? linkStyle;
  final List<SpecialStr>? specialStrs;
  final List<RegExpStr>? regExpStrs;
  final TapSpecialStrCallback? onTapSpecialStr;

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
  final LinkRichModel _model;
  TextSpan get textSpan => _model.textSpan;

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
    this.key,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
  })  : text = model.text,
        style = model.style,
        linkStyle = model.linkStyle,
        specialStrs = model.specialStrs,
        regExpStrs = model.regExpStrs,
        onTapSpecialStr = model.onTapSpecialStr,
        _model = model,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
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
}
