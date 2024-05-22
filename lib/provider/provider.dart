import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_webview/data/storage_manager.dart';

final onboardingCompleteProvider = StateProvider<bool>((ref) {
  return StorageManager.getOnboardingComplete();
});
