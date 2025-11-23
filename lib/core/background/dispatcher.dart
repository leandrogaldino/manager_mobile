import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:manager_mobile/core/app_preferences.dart';
import 'package:manager_mobile/core/data/sqflite_database.dart';
import 'package:manager_mobile/firebase_options.dart';
import 'package:manager_mobile/services/sync_service_factory.dart';
import 'package:workmanager/workmanager.dart';

const String synchronizeTask = "synchronizeTask";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == synchronizeTask) {
      try {
        final localDb = SqfliteDatabase();
        await localDb.init();
        final appPreferences = AppPreferences(database: localDb);

        // Pega o token salvo
        final email = await appPreferences.loggedTechnicianEmail;
        final password = await appPreferences.loggedTechnicianPassword;

        

        if (email.isEmpty || password.isEmpty) {
          log("[Workmanager] Credenciais não encontradas, abortando sincronização", time: DateTime.now());
          return Future.value(false);
        }

        // Inicializa Firebase
        await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

        // Login usando o token

        
        final syncService = await SyncServiceFactory.create();

        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

        int count = await syncService.runSync(isAuto: true);

        appPreferences.setLastSyncCount(count);

        
      } catch (e, st) {
        log("[Workmanager] Erro ao executar $task: $e", error: e, stackTrace: st, time: DateTime.now());
      }
    }
    return Future.value(true);
  });
}
