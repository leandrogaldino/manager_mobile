import 'package:manager_mobile/models/syncronize_result_model.dart';

abstract class Syncronizable {
  Future<SyncronizeResultModel> syncronize(int lastSync);
}
