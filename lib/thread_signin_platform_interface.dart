import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'thread_signin_method_channel.dart';

abstract class ThreadSigninPlatform extends PlatformInterface {
  /// Constructs a ThreadSigninPlatform.
  ThreadSigninPlatform() : super(token: _token);

  static final Object _token = Object();

  static ThreadSigninPlatform _instance = MethodChannelThreadSignin();

  /// The default instance of [ThreadSigninPlatform] to use.
  ///
  /// Defaults to [MethodChannelThreadSignin].
  static ThreadSigninPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ThreadSigninPlatform] when
  /// they register themselves.
  static set instance(ThreadSigninPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
