import 'package:intl/intl.dart';
import 'package:manager_mobile/core/helper/datetime_helper.dart';
import 'package:uuid/uuid.dart';

class StringHelper {
  StringHelper._();
  static String getUniqueString({String prefix = '', String suffix = ''}) => '$prefix${Uuid().v4()}_${DateFormat('ddMMyyyy_HHmmssSSS').format(DateTimeHelper.now())}$suffix';
}
