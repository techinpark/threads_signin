import 'package:thread_signin/src/consts.dart';

class ThreadSignInParams {
  String clientId;
  String clientSecret;
  String redirectUrl;
  String scopes;

  ThreadSignInParams({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUrl,
    required this.scopes
  });

  String combinedUrl() {
    return '$authorizeUrl?client_id=$clientId&redirect_uri=$redirectUrl&scope=$scopes&response_type=code';
  }
}
