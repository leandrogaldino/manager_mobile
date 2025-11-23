import 'dart:async';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/util/network_connection.dart';
import 'package:manager_mobile/services/sync_service.dart';

class SynchronizeTimer {
  SynchronizeTimer._();
  static Future<Timer> init() async {
    NetworkConnection connection = NetworkConnection();
    SyncService syncService = Locator.get<SyncService>();
    return Timer.periodic(Duration(minutes: 1), (_) async {
      bool hasConnection = await connection.hasConnection();
      if (hasConnection) {
        await syncService.runSync(isAuto: true);
      }
    });
  }
}
