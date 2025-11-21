import 'package:manager_mobile/models/visitschedule_model.dart';
import 'package:manager_mobile/repositories/visit_schedule_repository.dart';

class VisitScheduleService {
  final VisitScheduleRepository _scheduleRepository;

  VisitScheduleService({
    required VisitScheduleRepository scheduleRepository,
  }) : _scheduleRepository = scheduleRepository;

  Future<void> updateVisibility(int scheduleId, bool isVisible) async {
    _scheduleRepository.updateVisibility(scheduleId, isVisible);
  }

  Future<int> delete(int id) async {
    return await _scheduleRepository.delete(id);
  }

  Future<List<VisitScheduleModel>> getAll() async {
    final data = await _scheduleRepository.getAll();
    return data.map((item) => VisitScheduleModel.fromMap(item)).toList();
  }

  Future<List<VisitScheduleModel>> getVisibles() async {
    final data = await _scheduleRepository.getVisibles();
    return data.map((item) => VisitScheduleModel.fromMap(item)).toList();
  }

  Future<int> synchronize(int lastSync) async {
    return await _scheduleRepository.synchronize(lastSync);
  }
}
