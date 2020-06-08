import 'package:flutter/material.dart';
import 'package:link_rich_text/link_rich_text.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    RegExp exp = RegExp(
        "((?:(?:https?|ftp):\\/\\/)(?:\\S+(?::\\S*)?@)?(?:(?:(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|(?:(?:[a-zA-Z0-9\\u00a1-\\uffff]+-?)*[a-zA-Z0-9\\u00a1-\\uffff]+)(?:\\.(?:[a-zA-Z0-9\\u00a1-\\uffff]+-?)*[a-zA-Z0-9\\u00a1-\\uffff]+)*(?:\\.(?:[a-zA-Z\\u00a1-\\uffff]{2,})))|localhost)(?::\\d{2,5})?(?:\\/(?:(?!\\1|\\s)[\\S\\s])*)?[^\\s'\\\"]*)");
    String str = "百度 http://www.baidu.com 和新浪 http://www.sina.com abc";
    Iterable<Match> matches = exp.allMatches(str);

    for (Match m in matches) {
      String match = m.group(0);
      print('url = $match');
    }

    String text = 'a';
    'a123a456a789a9871a';
    List texts = text.split('a');

    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    List<SpecialText> specialTexts = List<SpecialText>();
    specialTexts.add(SpecialText(
        text: '@老陈',
        type: 'user',
        style: TextStyle(fontSize: 15, color: Colors.blue)));
    specialTexts.add(SpecialText(
        text: '@老邓',
        type: 'user',
        style: TextStyle(fontSize: 15, color: Colors.blue)));
    specialTexts.add(SpecialText(
        text: '@一只鱼',
        type: 'user',
        style: TextStyle(fontSize: 15, color: Colors.blue)));
    specialTexts.add(SpecialText(
        text: '@不老实的鸟',
        type: 'user',
        style: TextStyle(fontSize: 15, color: Colors.blue)));
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            LinkRichText(
              text:
                  '@一只鱼 http://www.baidu.com 打底裤积分 @老陈 快进快手动，肯德基疯狂的发，发拉拉速度快积分@哈哈卢萨卡的积分禄口街道和新浪：http://www.sina.com abc 你是谁 @不老实的鸟 ？是吗 @老邓',
              style: TextStyle(fontSize: 15, color: Colors.black),
              linkStyle: TextStyle(fontSize: 18, color: Colors.red),
              specialTexts: specialTexts,
              onTapSpecialText: (String text, String type) {
                print('type = $type, text = $text');
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
