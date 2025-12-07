import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class DateTimeHelper {
  static bool _initialized = false;
  static late tz.Location _sp;

  /// Inicializa timezone (chame no main)
  static Future<void> initialize() async {
    if (_initialized) return;
    tz.initializeTimeZones();
    _sp = tz.getLocation('America/Sao_Paulo');
    _initialized = true;
  }

  /// Retorna agora no fuso de São Paulo
  static DateTime now() {
    return tz.TZDateTime.now(_sp);
  }

  /// Converte um DateTime local ou UTC para São Paulo
  static DateTime toSP(DateTime date) {
    return tz.TZDateTime.from(date, _sp);
  }

  /// Cria um DateTime de São Paulo a partir de valores individuais
  static DateTime fromComponents({
    required int year,
    required int month,
    required int day,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
  }) {
    return tz.TZDateTime(
      _sp,
      year,
      month,
      day,
      hour,
      minute,
      millisecond,
    );
  }

  /// Formata no padrão HH:mm (24h)
  static String formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  /// Formata data DD/MM/YYYY
  static String formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
