import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool hasInternetAccess = false;
  bool finishedInternetAccessCheck = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('jobaadewumi.vercel.app');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          hasInternetAccess = true;
          finishedInternetAccessCheck = true;
          isLoading = false;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        hasInternetAccess = false;
        finishedInternetAccessCheck = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: finishedInternetAccessCheck && hasInternetAccess
          ? InAppWebView(
              initialUrlRequest:
                  URLRequest(url: WebUri('https://jobaadewumi.vercel.app')),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                useShouldOverrideUrlLoading: true,
                userAgent: 'Owomi',
                allowsInlineMediaPlayback: true,
                allowsBackForwardNavigationGestures: true,
                automaticallyAdjustsScrollIndicatorInsets: true,
                contentInsetAdjustmentBehavior:
                    ScrollViewContentInsetAdjustmentBehavior.ALWAYS,
              ),
              onReceivedServerTrustAuthRequest: (controller, challenge) async {
                return ServerTrustAuthResponse(
                  action: ServerTrustAuthResponseAction.PROCEED,
                );
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'No Internet Connection',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 35),
                  ),
                  isLoading
                      ? const CircularProgressIndicator()
                      : TextButton(
                          child: Text(
                            'Click to retry',
                            style: TextStyle(
                              color: Colors.blueAccent[400],
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              hasInternetAccess = false;
                              finishedInternetAccessCheck = false;
                              isLoading = true;
                            });
                            checkInternetConnection();
                          },
                        ),
                ],
              ),
            ),
    );
  }
}
