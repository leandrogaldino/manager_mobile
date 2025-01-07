import 'package:manager_mobile/core/exceptions/service_exception.dart';
import 'package:manager_mobile/interfaces/readable.dart';
import 'package:manager_mobile/interfaces/syncronizable.dart';
import 'package:manager_mobile/models/schedule_model.dart';
import 'package:manager_mobile/models/syncronize_result_model.dart';
import 'package:manager_mobile/repositories/schedule_repository.dart';

class ScheduleService implements Readable<ScheduleModel>, Syncronizable {
  final ScheduleRepository _repository;

  ScheduleService({required ScheduleRepository repository}) : _repository = repository;

  @override
  Future<List<ScheduleModel>> getAll() async {
    final data = await _repository.getAll();
    return data.map((item) => ScheduleModel.fromMap(item)).toList();
  }

  @override
  Future<ScheduleModel> getById(dynamic id) async {
    final data = await _repository.getById(id);
    if (data.isNotEmpty) {
      return ScheduleModel.fromMap(data);
    } else {
      throw ServiceException('Visita com o id $id não encontrada.');
    }
  }

  @override
  Future<List<ScheduleModel>> getByLastUpdate(DateTime lastUpdate) async {
    final data = await _repository.getByLastUpdate(lastUpdate);
    return data.map((item) => ScheduleModel.fromMap(item)).toList();
  }

  @override
  Future<SyncronizeResultModel> syncronize(int lastSync) async {
    return _repository.syncronize(lastSync);
  }
}
