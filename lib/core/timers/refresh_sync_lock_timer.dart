import 'dart:async';
import 'package:manager_mobile/core/app_preferences.dart';
import 'package:manager_mobile/core/locator.dart';

class RefreshSyncLockTimer {
  RefreshSyncLockTimer._();

  static Timer? _timer;

  static Future<void> start() async {
    if (_timer != null) return;
    final appPreferences = Locator.get<AppPreferences>();
    _timer = Timer.periodic(Duration(seconds: 10), (_) => appPreferences.setSyncLockTime(DateTime.now()));
  }

  static Future<void> stop() async {
    _timer?.cancel();
  }

  static void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
