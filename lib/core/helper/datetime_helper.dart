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

  // ----------------------------
  // Mesmos métodos estáticos do DateTime
  // ----------------------------

  /// DateTime.now()
  static DateTime now() {
    return tz.TZDateTime.now(_sp);
  }

  /// DateTime.utc(...)
  static DateTime utc(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) {
    return tz.TZDateTime.utc(
      year,
      month,
      day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    ).toLocal();
  }

  /// DateTime.parse()
  static DateTime parse(String input) {
    final parsed = DateTime.parse(input);
    return tz.TZDateTime.from(parsed, _sp);
  }

  /// DateTime.tryParse()
  static DateTime? tryParse(String input) {
    final parsed = DateTime.tryParse(input);
    if (parsed == null) return null;
    return tz.TZDateTime.from(parsed, _sp);
  }

  /// DateTime.fromMillisecondsSinceEpoch()
  static DateTime fromMillisecondsSinceEpoch(
    int ms, {
    bool isUtc = false,
  }) {
    final dt = DateTime.fromMillisecondsSinceEpoch(ms, isUtc: isUtc);
    return tz.TZDateTime.from(dt, _sp);
  }

  /// DateTime.fromMicrosecondsSinceEpoch()
  static DateTime fromMicrosecondsSinceEpoch(
    int us, {
    bool isUtc = false,
  }) {
    final dt = DateTime.fromMicrosecondsSinceEpoch(us, isUtc: isUtc);
    return tz.TZDateTime.from(dt, _sp);
  }

  // ----------------------------
  // Construtor igual ao DateTime original
  // ----------------------------
  static DateTime create(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) {
    return tz.TZDateTime(
      _sp,
      year,
      month,
      day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }

  // ----------------------------
  // Conversão para SP
  // ----------------------------
  static DateTime toSP(DateTime date) {
    return tz.TZDateTime.from(date, _sp);
  }

  // ----------------------------
  // Helpers opcionais
  // ----------------------------
  static String formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  static String formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
