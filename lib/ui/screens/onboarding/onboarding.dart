import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_webview/data/storage_manager.dart';
import 'package:portfolio_webview/provider/provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  Widget logoScreen() {
    return Image.asset(
      'assets/images/logo/logo-sky-blue.png',
      width: 200,
    );
  }

  bool hasInternetAccess = false;
  bool finishedInternetAccessCheck = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
    checkOnboardingStatus();
  }

  /// Check if user has already been onboarded to avoid showing this screen again
  checkOnboardingStatus() {
    if (ref.read(onboardingCompleteProvider) == true) {
      Future(() {
        context.go('/home');
      });
    }
  }

  /// Check internet connection
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: logoScreen(),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                finishedInternetAccessCheck && hasInternetAccess
                    ? Container()
                    : isLoading
                        ? const CircularProgressIndicator()
                        : TextButton(
                            child: Text(
                              'No internet access, click to retry',
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
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        finishedInternetAccessCheck && hasInternetAccess
                            ? WidgetStatePropertyAll(Colors.blueAccent[400])
                            : const WidgetStatePropertyAll(Colors.grey),
                  ),
                  child: const Text(
                    'Welcome to my Portfolio',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    if (finishedInternetAccessCheck && hasInternetAccess) {
                      StorageManager.setOnboardingComplete(true);
                      context.go('/home');
                    }
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
