import 'dart:async';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:manager_mobile/controllers/app_controller.dart';
import 'package:manager_mobile/app.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/util/connection_notifier.dart';
import 'package:manager_mobile/firebase_options.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/core/locator.dart';

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
  final hasConnection = await InternetConnection().hasInternetAccess;



  if (kReleaseMode) {
    runZonedGuarded(
      () {
        runApp(ConnectionNotifier(
          notifier: ValueNotifier(hasConnection),
          child: const App(),
        ));
      },
      (error, stack) {
        log('Erro não tratado', error: error, stackTrace: stack, time: DateTime.now());
      },
    );
  } else {
    runApp(ConnectionNotifier(
      notifier: ValueNotifier(hasConnection),
      child: const App(),
    ));
  }
}
