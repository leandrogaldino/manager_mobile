import 'package:manager_mobile/models/personcompressor_model.dart';
import 'package:manager_mobile/repositories/personcompressor_repository.dart';
import 'package:manager_mobile/sync_event.dart';
import 'package:manager_mobile/sync_event_bus.dart';

class PersonCompressorService {
  final PersonCompressorRepository _personCompressorRepository;
  final SyncEventBus _eventBus;

  PersonCompressorService({required PersonCompressorRepository personCompressorRepository, required SyncEventBus eventBus})
      : _personCompressorRepository = personCompressorRepository,
        _eventBus = eventBus;

  Future<List<PersonCompressorModel>> searchVisibles({
    required int offset,
    required int limit,
    String? search,
  }) async {
    final data = await _personCompressorRepository.searchVisibles(
      offset: offset,
      limit: limit,
      search: search,
    );
    return data.map((item) => PersonCompressorModel.fromMap(item)).toList();
  }

  Future<int> synchronize(int lastSync) async {
   return _personCompressorRepository.synchronize(
      lastSync,
      onItemSynced: (id) {
        _eventBus.emit(
          SyncEvent.personCompressor(id),
        );
      },
    );
  }
}
