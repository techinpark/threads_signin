library thread_signin;

import 'thread_signin_platform_interface.dart';
export 'src/signin_params.dart';
export 'src/signin_response.dart';
export 'src/signin_screen.dart';

class ThreadSignin {
  Future<String?> getPlatformVersion() {
    return ThreadSigninPlatform.instance.getPlatformVersion();
  }
}
