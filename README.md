# link_rich_text

[![pub package](https://img.shields.io/pub/v/link_rich_text.svg)](https://pub.dartlang.org/packages/link_rich_text)
[![GitHub stars](https://img.shields.io/github/stars/chenhongchen/link_rich_text.svg?style=social&label=Stars)](https://github.com/chenhongchen/link_rich_text)

Flutter plugin for hyperlinks and custom special characters rich text display.

## Demo

<img src="https://github.com/chenhongchen/test_photos_lib/raw/master/pic/link_rich_text.PNG" width="270" height="480" alt="demo"/>

## Installation

In your `pubspec.yaml` file within your Flutter Project:

```yaml
dependencies:
  link_rich_text: 3.0.2
```

## Use it

```dart
import 'package:link_rich_text/link_rich_text.dart';
```

### Through LinkRichModel

Create model

```dart
_setLinkRichModel() async {
  // 对于性能要求高的场景，比如列表中，
  // 可在加载好数据的同时就设置好富文本模型（LinkRichModel）
  // 并将模型传入LinkRichText中，或将模型的textSpan属性传入RichText中显示

  // 添加特殊字符串
  List<SpecialStr> specialStrs = <SpecialStr>[];
  specialStrs.add(SpecialStr(
      text: '@我啊',
      type: 'user',
      style: const TextStyle(fontSize: 15, color: Colors.blue)));
  specialStrs.add(SpecialStr(
      text: '@我啊啊',
      type: 'user',
      style: const TextStyle(fontSize: 18, color: Colors.purple)));
  specialStrs.add(SpecialStr(
      text: '@一只鱼',
      type: 'user',
      style: const TextStyle(fontSize: 15, color: Colors.orange)));
  specialStrs.add(SpecialStr(
      text: '@不老实的鸟',
      type: 'user',
      style: const TextStyle(fontSize: 15, color: Colors.brown)));

  // 添加正则特殊字符串
  List<RegExpStr> regExpStrs = <RegExpStr>[];
  regExpStrs.add(RegExpStr(
      text: '#\\S*? ',
      type: '#',
      style: const TextStyle(fontSize: 18, color: Colors.lightBlueAccent)));

  String text = '@一只鱼 控件打底可反#馈的 了老@我啊都放到裤积分 '
      '快进快手动，肯德的框架反馈的减@我啊啊肥看的积分基疯狂的发，'
      '发拉拉速度快积分@哈哈卢萨卡的积分禄口街道和你是谁 @不老实的鸟 ？是吗';

  // 创建并缓存富文本模型
  _linkRichModel = LinkRichModel(
    text,
    style: const TextStyle(fontSize: 15, color: Colors.black),
    linkStyle: const TextStyle(fontSize: 18, color: Colors.red),
    specialStrs: specialStrs,
    regExpStrs: regExpStrs,
    onTapSpecialStr: (String text, String type) {
      if (kDebugMode) {
        print('type = $type, text = $text');
      }
    },
  );

  setState(() {});
}
```

Display rich text through the model

```dart
LinkRichText.fromModel(_linkRichModel!),
```

or

```dart
RichText(text: _linkRichModel!.textSpan),
```

### Through LinkRichText directly

```dart
LinkRichText(
  text,
  style: const TextStyle(fontSize: 15, color: Colors.black),
  linkStyle: const TextStyle(fontSize: 15, color: Colors.blue),
  specialStrs: specialStrs,
  regExpStrs: regExpStrs,
  onTapSpecialStr: (String text, String type) {
    if (kDebugMode) {
      print('type = $type, text = $text');
    }
    if (type == 'link') {
      launchUrlString(text);
    }
  },
)
```
