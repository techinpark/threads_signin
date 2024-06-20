class ThreadSignInResponse {
  SignInStatus status;
  String? accessToken;
  String? error;

  ThreadSignInResponse({
    required this.status,
    this.accessToken,
    this.error
  });

  @override
  String toString() {
    return 'ThreadSignInResponse{status: $status, accessToken: $accessToken, error: $error}';
  }
}

enum SignInStatus { success, failed, canceled }
