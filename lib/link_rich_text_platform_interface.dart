import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'link_rich_text_method_channel.dart';

abstract class LinkRichTextPlatform extends PlatformInterface {
  /// Constructs a LinkRichTextPlatform.
  LinkRichTextPlatform() : super(token: _token);

  static final Object _token = Object();

  static LinkRichTextPlatform _instance = MethodChannelLinkRichText();

  /// The default instance of [LinkRichTextPlatform] to use.
  ///
  /// Defaults to [MethodChannelLinkRichText].
  static LinkRichTextPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LinkRichTextPlatform] when
  /// they register themselves.
  static set instance(LinkRichTextPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
