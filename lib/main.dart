import 'dart:async';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:manager_mobile/controllers/app_controller.dart';
import 'package:manager_mobile/app.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/background/dispatcher.dart';
import 'package:manager_mobile/core/timers/refresh_sync_view_timer.dart';
import 'package:manager_mobile/firebase_options.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Locator.setup();
  await Locator.get<LocalDatabase>().init();
  await Locator.get<AppController>().clearOldTemporaryFiles();
  await GetIt.I<AppController>().loadTheme();
  await Locator.get<EvaluationController>().clean();
  await RefreshSyncedTimer.init();
  Workmanager().initialize(
    callbackDispatcher,
  );

  if (kDebugMode) {
    log('Registrando tarefa de sincronização imediata (debug)...', time: DateTime.now());
    Workmanager().registerOneOffTask(
      'immediateSync',
      synchronizeTask,
      initialDelay: Duration(seconds: 1),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  } else {
    log('Registrando tarefa de sincronização periódica (release)...', time: DateTime.now());
    Workmanager().registerPeriodicTask(
      synchronizeTask.toUpperCase(),
      synchronizeTask,
      frequency: Duration(minutes: 15),
      initialDelay: Duration(seconds: 30),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }
  if (kReleaseMode) {
    runZonedGuarded(
      () {
        runApp(const App());
      },
      (error, stack) {
        log('Erro não tratado', error: error, stackTrace: stack);
      },
    );
  } else {
    runApp(const App());
  }
}
