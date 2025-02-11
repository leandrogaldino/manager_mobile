import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class StringHelper {
  StringHelper._();

  static String getRandomFileName(String extension) => '${Uuid().v4()}_${DateFormat('ddMMyyyy_HHmmssSSS').format(DateTime.now())}.$extension';
}
