import 'dart:developer';

import 'package:manager_mobile/core/exceptions/service_exception.dart';
import 'package:manager_mobile/core/helper/datetime_helper.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/repositories/person_repository.dart';
import 'package:manager_mobile/sync_event.dart';
import 'package:manager_mobile/sync_event_bus.dart';

class PersonService {
  final PersonRepository _personRepository;
  final SyncEventBus _eventBus;

  PersonService({required PersonRepository personRepository, required SyncEventBus eventBus})
      : _personRepository = personRepository,
        _eventBus = eventBus;

  Future<List<PersonModel>> searchVisibleTechnicians({
    required int offset,
    required int limit,
    String? search,
    List<int>? remove,
  }) async {
    final data = await _personRepository.searchVisibleTechnicians(offset: offset, limit: limit, search: search, remove: remove);
    return data.map((item) => PersonModel.fromMap(item)).toList();
  }

  Future<PersonModel> getById(int id) async {
    final data = await _personRepository.getById(id);
    if (data.isNotEmpty) {
      return PersonModel.fromMap(data);
    } else {
      String code = 'PER004';
      String message = 'Pessoa com o id $id não encontrada';
      log('[$code] $message', time: DateTimeHelper.now());
      throw ServiceException(code, message);
    }
  }

  Future<int> synchronize(int lastSync) async {
    return _personRepository.synchronize(
      lastSync,
      onItemSynced: (id) {
        _eventBus.emit(
          SyncEvent.person(id),
        );
      },
    );
  }
}
