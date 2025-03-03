import 'dart:async';
import 'dart:developer';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/core/locator.dart';

class CleanTimer {
  CleanTimer._();
  static Future<Timer> init() async {
    EvaluationController evaluationController = Locator.get<EvaluationController>();
    return Timer.periodic(Duration(hours: 24), (_) async {
      try {
        log('Limpeza iniciada.');
        await evaluationController.clean();
        log('Limpeza finalizada.');
      } catch (e, s) {
        log('Erro ao limpar: $e', stackTrace: s);
      }
    });
  }
}
