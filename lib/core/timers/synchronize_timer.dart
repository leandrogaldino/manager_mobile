import 'dart:async';
import 'dart:developer';
import 'package:manager_mobile/controllers/home_controller.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/core/util/network_connection.dart';

class SynchronizeTimer {
  SynchronizeTimer._();
  static Future<Timer> init() async {
    NetworkConnection connection = NetworkConnection();
    HomeController homeController = Locator.get<HomeController>();
    return Timer.periodic(Duration(minutes: 1), (_) async {
      try {
        log('Sincronização Automática iniciada.');
        bool hasConnection = await connection.hasConnection();
        if (hasConnection) {
          await homeController.synchronize(false);
          //await homeController.fetchData(customerOrCompressor: homeController.customerOrCompressor, dateRange: homeController.dateRange);
        }
        log('Sincronização Automática finalizada.');
      } catch (e, s) {
        log('Erro ao executar a sincronização automática: $e', stackTrace: s);
      }
    });
  }
}
