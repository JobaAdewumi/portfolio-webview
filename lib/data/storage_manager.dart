import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static late SharedPreferences _sharedPreferences;

  static SharedPreferences get sharedPreferences => _sharedPreferences;

  static const String onboardingComplete = "_onboarding_complete";

  static init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setOnboardingComplete(bool value) async {
    return await _sharedPreferences.setBool(onboardingComplete, value);
  }

  static bool getOnboardingComplete() =>
      _sharedPreferences.getBool(onboardingComplete) ?? false;

  static String location() {
    if (kIsWeb) return 'LocalStorage';
    if (Platform.isIOS || Platform.isMacOS) return 'NSUserDefaults';
    if (Platform.isAndroid) return 'SharedPreferences';
    if (Platform.isLinux) return 'XDG_DATA_HOME directory';
    if (Platform.isWindows) return 'Roaming AppData directory';
    throw ArgumentError('unsupport');
  }
}
