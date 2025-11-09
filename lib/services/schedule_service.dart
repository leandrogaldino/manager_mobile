import 'package:manager_mobile/models/visitschedule_model.dart';
import 'package:manager_mobile/repositories/schedule_repository.dart';

class ScheduleService {
  final ScheduleRepository _scheduleRepository;

  ScheduleService({
    required ScheduleRepository scheduleRepository,
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

  Future<void> synchronize(int lastSync) async {
    await _scheduleRepository.synchronize(lastSync);
  }
}
