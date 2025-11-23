import 'dart:async';
import 'package:manager_mobile/controllers/home_controller.dart';
import 'package:manager_mobile/core/app_preferences.dart';
import 'package:manager_mobile/core/locator.dart';

class RefreshSyncedTimer {
  RefreshSyncedTimer._();

  static Timer? _timer;

  static Future<void> init() async {
    if (_timer != null) return;
    final appPreferences = Locator.get<AppPreferences>();
    final homeController = Locator.get<HomeController>();
    _timer = Timer.periodic(Duration(minutes: 1), (_) async {
      final lastSyncCount = await appPreferences.lastSyncCount;
      if (lastSyncCount > 0) {
        await homeController.fetchAllIfNeeded(true);
        await appPreferences.setLastSyncCount(0);
      }
    });
  }

  static void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
