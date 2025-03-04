import 'dart:async';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Import necessário para kReleaseMode
import 'package:manager_mobile/controllers/app_controller.dart';
import 'package:manager_mobile/app.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/firebase_options.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/core/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Locator.setup();
  await Locator.get<LocalDatabase>().init();
  await Locator.get<AppController>().clearOldTemporaryFiles();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetIt.I<AppController>().loadTheme();
  await Locator.get<EvaluationController>().clean();
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
