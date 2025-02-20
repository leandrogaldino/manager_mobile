import 'package:manager_mobile/core/exceptions/service_exception.dart';
import 'package:manager_mobile/interfaces/readable.dart';
import 'package:manager_mobile/interfaces/syncronizable.dart';
import 'package:manager_mobile/models/schedule_model.dart';
import 'package:manager_mobile/repositories/schedule_repository.dart';

class ScheduleService implements Readable<ScheduleModel>, Syncronizable {
  final ScheduleRepository _repository;

  ScheduleService({required ScheduleRepository repository}) : _repository = repository;

  Future<void> updateStatus(int scheduleId, int statusId) async {
    _repository.updateStatus(scheduleId, statusId);
  }

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

  Future<List<ScheduleModel>> getVisibles() async {
    final data = await _repository.getVisibles();
    return data.map((item) => ScheduleModel.fromMap(item)).toList();
  }

  @override
  Future<void> syncronize(int lastSync) async {
    await _repository.syncronize(lastSync);
  }
}
