import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/services/sync_service.dart';

class SynchronizeTimer {
  static Timer? _timer;
  SynchronizeTimer._();
  static void start() {
    if (_timer != null && _timer!.isActive) {
      print("SynchronizeTimer já está ativo.");
      return;
    }
    
    final SyncService syncService = Locator.get<SyncService>();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) async {

      bool hasConnection =  await InternetConnection().hasInternetAccess;
      if (hasConnection) {
        try {
          await syncService.runSync(isAuto: true);
        } catch (e) {
          rethrow;
        }
      } else {
        print("Sem conexão para sincronização automática.");
      }
    });
    print("Timer de sincronização automática iniciado (1 min).");
  }

  // Método estático para parar (cancelar) o Timer.
  static void stop() {
    _timer?.cancel();
    _timer = null;
  }

  // Opcional: Verifica o estado
  static bool get isActive => _timer != null && _timer!.isActive;
}
