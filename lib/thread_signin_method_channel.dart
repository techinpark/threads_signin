import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'thread_signin_platform_interface.dart';

/// An implementation of [ThreadSigninPlatform] that uses method channels.
class MethodChannelThreadSignin extends ThreadSigninPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('thread_signin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
