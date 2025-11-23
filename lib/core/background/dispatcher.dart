import 'dart:developer';
import 'package:workmanager/workmanager.dart';
import 'package:manager_mobile/services/sync_service_factory.dart';

const String synchronizeTask = "synchronizeTask";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == synchronizeTask) {
      try {
        final syncService = await SyncServiceFactory.create();
        await syncService.runSync(isAuto: true);
        log("[Workmanager] Sincronização concluída com sucesso", time: DateTime.now());
      } catch (e, st) {
        log("[Workmanager] Erro ao executar $task: $e", error: e, stackTrace: st, time: DateTime.now());
      }
    } else {
      log("[Workmanager] Tarefa desconhecida recebida: $task", time: DateTime.now());
    }

    return Future.value(true);
  });
}
