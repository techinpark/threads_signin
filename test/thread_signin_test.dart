import 'package:flutter_test/flutter_test.dart';
import 'package:thread_signin/thread_signin.dart';
import 'package:thread_signin/thread_signin_platform_interface.dart';
import 'package:thread_signin/thread_signin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockThreadSigninPlatform
    with MockPlatformInterfaceMixin
    implements ThreadSigninPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ThreadSigninPlatform initialPlatform = ThreadSigninPlatform.instance;

  test('$MethodChannelThreadSignin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelThreadSignin>());
  });

  test('getPlatformVersion', () async {
    ThreadSignin threadSigninPlugin = ThreadSignin();
    MockThreadSigninPlatform fakePlatform = MockThreadSigninPlatform();
    ThreadSigninPlatform.instance = fakePlatform;

    expect(await threadSigninPlugin.getPlatformVersion(), '42');
  });
}
