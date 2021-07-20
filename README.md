# link_rich_text

Flutter plugin for hyperlinks and custom special characters rich text display.

## Demo

![Demo](https://github.com/chenhongchen/link_rich_text/raw/master/assets/demo.jpeg)

## Installation

In your `pubspec.yaml` file within your Flutter Project:

```yaml
dependencies:
  link_rich_text: 1.0.0
```

## Use it

```dart
import 'package:link_rich_text/link_rich_text.dart';
```

```dart
List<SpecialStr> specialStrs = <SpecialStr>[];
specialStrs.add(SpecialStr(
    text: '@老陈',
    type: 'user',
    style: TextStyle(fontSize: 15, color: Colors.blue)));
specialStrs.add(SpecialStr(
    text: '@老陈',
    type: 'user',
    style: TextStyle(fontSize: 15, color: Colors.blue)));
specialStrs.add(SpecialStr(
    text: '@老陈啊',
    type: 'user',
    style: TextStyle(fontSize: 15, color: Colors.blue)));
specialStrs.add(SpecialStr(
    text: '@老陈啊啊',
    type: 'user',
    style: TextStyle(fontSize: 15, color: Colors.blue)));
specialStrs.add(SpecialStr(
    text: '@老邓',
    type: 'user',
    style: TextStyle(fontSize: 15, color: Colors.blue)));
specialStrs.add(SpecialStr(
    text: '@老邓',
    type: 'user',
    style: TextStyle(fontSize: 15, color: Colors.blue)));
specialStrs.add(SpecialStr(
    text: '@一只鱼',
    type: 'user',
    style: TextStyle(fontSize: 15, color: Colors.blue)));
specialStrs.add(SpecialStr(
    text: '@不老实的鸟',
    type: 'user',
    style: TextStyle(fontSize: 15, color: Colors.blue)));

List<RegExpStr> regExpStrs = <RegExpStr>[];
regExpStrs.add(RegExpStr(
    text: '#\\S*? ',
    type: '#',
    style: TextStyle(fontSize: 15, color: Colors.lightBlueAccent)));

String text =
    '@一只鱼 https://www.baidu.comdfdfd打底可反#馈的 了@老陈啊都放到裤积分 @老陈 快进快手动，www.sohu.com肯德的框架反馈的减@老陈啊啊肥看的积分基疯狂的发，发拉拉速度快积分@哈哈卢萨卡的积分禄口街道和新浪：http://www.sina.com abc 你是谁 @不老实的鸟 ？是吗 @老邓';
```

```dart
LinkRichText(
  text,
  style: TextStyle(fontSize: 15, color: Colors.black),
  linkStyle: TextStyle(fontSize: 18, color: Colors.red),
  specialStrs: specialStrs,
  regExpStrs: regExpStrs,
  onTapSpecialStr: (String text, String type) {
    print('type = $type, text = $text');
  },
)
```
