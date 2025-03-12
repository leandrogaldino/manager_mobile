import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class StringHelper {
  StringHelper._();
  static String getUniqueString({String prefix = '', String suffix = ''}) => '$prefix${Uuid().v4()}_${DateFormat('ddMMyyyy_HHmmssSSS').format(DateTime.now())}$suffix';
  static List<String> getMonthNames(List<int> monthNumbers) {
    List<String> monthNames = monthNumbers
        .map(
          (month) => DateFormat.MMMM('pt_BR').format(
            DateTime(0, month),
          ),
        )
        .toList();
    return monthNames;
  }
}
