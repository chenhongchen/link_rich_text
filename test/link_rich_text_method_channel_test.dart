import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:link_rich_text/link_rich_text_method_channel.dart';

void main() {
  MethodChannelLinkRichText platform = MethodChannelLinkRichText();
  const MethodChannel channel = MethodChannel('link_rich_text');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
