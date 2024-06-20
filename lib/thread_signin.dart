import 'thread_signin_platform_interface.dart';

class ThreadSignin {
  Future<String?> getPlatformVersion() {
    return ThreadSigninPlatform.instance.getPlatformVersion();
  }
}
