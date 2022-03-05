import 'package:flutter/material.dart';
import 'package:link_rich_text/link_rich_text.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'link_rich_text demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'link_rich_text demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LinkRichModel? _linkRichModel;

  @override
  void initState() {
    super.initState();
    _setLinkRichModel();
  }

  _setLinkRichModel() async {
    // 模拟加载数据的耗时
    await Future.delayed(Duration(milliseconds: 500));

    // 对于性能要求高的场景，比如列表中，
    // 可在加载好数据的同时就设置好富文本模型（LinkRichModel）
    // 并将模型传入LinkRichText中，或将模型的textSpan属性传入RichText中显示

    // 添加特殊字符串
    List<SpecialStr> specialStrs = <SpecialStr>[];
    specialStrs.add(SpecialStr(
        text: '@我啊',
        type: 'user',
        style: TextStyle(fontSize: 15, color: Colors.blue)));
    specialStrs.add(SpecialStr(
        text: '@我啊啊',
        type: 'user',
        style: TextStyle(fontSize: 18, color: Colors.purple)));
    specialStrs.add(SpecialStr(
        text: '@一只鱼',
        type: 'user',
        style: TextStyle(fontSize: 15, color: Colors.orange)));
    specialStrs.add(SpecialStr(
        text: '@不老实的鸟',
        type: 'user',
        style: TextStyle(fontSize: 15, color: Colors.brown)));

    // 添加正则特殊字符串
    List<RegExpStr> regExpStrs = <RegExpStr>[];
    regExpStrs.add(RegExpStr(
        text: '#\\S*? ',
        type: '#',
        style: TextStyle(fontSize: 18, color: Colors.lightBlueAccent)));

    String text = '@一只鱼 控件打底可反#馈的 了老@我啊都放到裤积分 '
        '快进快手动，肯德的框架反馈的减@我啊啊肥看的积分基疯狂的发，'
        '发拉拉速度快积分@哈哈卢萨卡的积分禄口街道和你是谁 @不老实的鸟 ？是吗';

    // 创建并缓存富文本模型
    _linkRichModel = LinkRichModel(
      text,
      style: TextStyle(fontSize: 15, color: Colors.black),
      linkStyle: TextStyle(fontSize: 18, color: Colors.red),
      specialStrs: specialStrs,
      regExpStrs: regExpStrs,
      onTapSpecialStr: (String text, String type) {
        print('type = $type, text = $text');
      },
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ''),
      ),
      body: Center(
        child: _linkRichModel == null
            ? Container()
            : Column(
                children: [
                  _buildLinkRichText(),
                  _buildSpan(),
                  LinkRichText.fromModel(_linkRichModel!),
                  _buildSpan(),
                  RichText(text: _linkRichModel!.textSpan),
                ],
              ),
      ),
    );
  }

  _buildLinkRichText() {
    // 添加特殊字符串
    List<SpecialStr> specialStrs = <SpecialStr>[];
    specialStrs.add(SpecialStr(
        text: '@老大',
        type: 'user',
        style: TextStyle(fontSize: 15, color: Colors.purple)));

    // 添加正则特殊字符串
    List<RegExpStr> regExpStrs = <RegExpStr>[];
    regExpStrs.add(RegExpStr(
        text: '#\\S*? ',
        type: '话题',
        style: TextStyle(fontSize: 15, color: Colors.blueAccent)));

    String text =
        '@老大看看这个：https://pub.dev/packages/photo_browser，一个不错的#flutter 图片浏览器';

    return LinkRichText(
      text,
      style: TextStyle(fontSize: 15, color: Colors.black),
      linkStyle: TextStyle(fontSize: 15, color: Colors.blue),
      specialStrs: specialStrs,
      regExpStrs: regExpStrs,
      onTapSpecialStr: (String text, String type) {
        print('type = $type, text = $text');
        if (type == 'link') {
          launch(text);
        }
      },
    );
  }

  _buildSpan() {
    return SizedBox(
      height: 20,
      child: Center(
        child: Container(
          width: double.infinity,
          height: 1,
          color: Colors.blueGrey,
        ),
      ),
    );
  }
}
