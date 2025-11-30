import 'dart:async';
import 'dart:developer';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:manager_mobile/controllers/home_controller.dart';
import 'package:manager_mobile/core/locator.dart';


class SynchronizeTimer {
  static Timer? _timer;
  SynchronizeTimer._();
  static void start() {
    if (_timer != null && _timer!.isActive) {
      log("SynchronizeTimer já está ativo.");
      return;
    }

    final HomeController homeController = Locator.get<HomeController>();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) async {
      bool hasConnection = await InternetConnection().hasInternetAccess;
      if (hasConnection) {
        try {
          await homeController.synchronize(isAuto: true);
        } catch (e) {
          rethrow;
        }
      } else {
        log("Sem conexão para sincronização automática.");
      }
    });
    log("Timer de sincronização automática iniciado (1 min).");
  }

  // Método estático para parar (cancelar) o Timer.
  static void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
