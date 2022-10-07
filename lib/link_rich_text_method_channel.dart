import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'link_rich_text_platform_interface.dart';

/// An implementation of [LinkRichTextPlatform] that uses method channels.
class MethodChannelLinkRichText extends LinkRichTextPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('link_rich_text');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
