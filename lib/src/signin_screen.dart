import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:thread_signin/src/consts.dart';
import 'package:thread_signin/src/signin_params.dart';
import 'package:thread_signin/src/signin_response.dart';
import 'package:http/http.dart' as http;

class ThreadSigninScreen extends StatefulWidget {

  final Color? headerColor;
  final Color? headerTextColor;
  final bool? safeAreaTop;
  final bool? safeAreaBottom;
  final String? title;
  final ThreadSignInParams params;

  const ThreadSigninScreen({
    super.key,
    required this.params,
    this.headerColor = Colors.black,
    this.headerTextColor = Colors.white,
    this.safeAreaTop = false,
    this.safeAreaBottom = false,
    this.title = 'Thread SignIn'
  });

  @override
  State<ThreadSigninScreen> createState() => _ThreadSigninScreenState();
}

class _ThreadSigninScreenState extends State<ThreadSigninScreen> {


  /// flag to display the progressbar
  bool shouldShowLoading = false;

  /// the controller of [InAppWebViewController]
  late InAppWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: widget.safeAreaTop ?? false,
      bottom: widget.safeAreaBottom ?? false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${widget.title}',
            style: TextStyle(
              color: widget.headerTextColor,
            ),
          ),
          backgroundColor: widget.headerColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: widget.headerTextColor),
            onPressed: () {
              ThreadSignInResponse res = ThreadSignInResponse(
                status: SignInStatus.failed,
                error: 'User cancelled',
              );
              Navigator.of(context).pop(res);
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  InAppWebView(
                    onWebViewCreated: (c) {
                      onWebViewCreated(c);
                    },
                    initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                          useShouldOverrideUrlLoading: true,
                          cacheEnabled: true,
                          clearCache: true,
                          transparentBackground: true),
                    ),
                    onProgressChanged: (_, p) {
                      onProgressChanged(p);
                    },
                    shouldOverrideUrlLoading: (x, navigationAction) async {
                      try {

                        bool startWithRedirectUrl = navigationAction.request.url
                            .toString()
                            .startsWith(widget.params.redirectUrl) ==
                            true;

                        bool hasCodeParam =
                            Uri.parse(navigationAction.request.url.toString())
                                .queryParameters['code'] !=
                                null;

                        if (hasCodeParam && startWithRedirectUrl) {
                          handleCodeResponse(navigationAction, context);
                          return NavigationActionPolicy.CANCEL;
                        } else {
                          return NavigationActionPolicy.ALLOW;
                        }
                      } catch (e) {
                        return NavigationActionPolicy.ALLOW;
                      }
                    },
                  ),
                  _buildProgressbar(),
                ],
              ),
            ),
            //endregion
          ],
        ),
      ),
    );
  }

  /// try to get token from thread then navigate to previous screen by [Navigator.of(context).pop(value)]
  void handleCodeResponse(
      NavigationAction navigationAction, BuildContext context) {
    var callBackCode = Uri.parse(navigationAction.request.url.toString()).queryParameters['code'];
    handleResponse(callBackCode).then((value) {
      Navigator.of(context).pop(value);
    }).catchError((onError) {
      ThreadSignInResponse res = ThreadSignInResponse(
        status: SignInStatus.failed,
        error: onError.toString(),
      );
      Navigator.of(context).pop(res);
    });
  }

  void onWebViewCreated(InAppWebViewController c) {
    webViewController = c;
    webViewController.loadUrl(
      urlRequest: URLRequest(
        url: Uri.parse(widget.params.combinedUrl())
      ),
    );
  }

  Widget _buildProgressbar() {
    if (shouldShowLoading) {
      return LinearProgressIndicator(
        color: widget.headerColor,
      );
    }
    return Container();
  }

  void onProgressChanged(int p) {
    setState(() {
      shouldShowLoading = p != 100;
    });
  }

  /// Call api and get the access token from thread
  Future<ThreadSignInResponse> handleResponse(String? code) async {
    try {
      //region interact with api
      var response = await http.post(
        Uri.parse(getAccessTokenUrl),
        headers: {"Accept": "application/x-www-form-urlencoded"},
        body: {
          "client_id": widget.params.clientId,
          "client_secret": widget.params.clientSecret,
          "code": code,
          "grant_type": 'authorization_code',
          'redirect_uri': widget.params.redirectUrl,
        },
      );
      var body = json.decode(utf8.decode(response.bodyBytes));
      bool hasError = body['error'] != null;

      //endregion
      //region handle error case
      if (hasError) {
        String errorDetail =
            body['error_description'] ?? 'Unknown Error: ${body.toString()}';
        ThreadSignInResponse res = ThreadSignInResponse(
          status: SignInStatus.failed,
          error: errorDetail,
        );
        return res;
      }
      //endregion
      //region handle success case
      return ThreadSignInResponse(
        status: SignInStatus.success,
        accessToken: '${body['access_token']}',
      );
      //endregion
    } catch (e) {
      return ThreadSignInResponse(
          status: SignInStatus.failed, error: 'Error: ${e.toString()}');
    }
  }

}
