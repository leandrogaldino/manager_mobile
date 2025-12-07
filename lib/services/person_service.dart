import 'dart:developer';

import 'package:manager_mobile/core/exceptions/service_exception.dart';
import 'package:manager_mobile/core/helper/datetime_helper.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/repositories/person_repository.dart';

class PersonService {
  final PersonRepository _personRepository;

  PersonService({required PersonRepository personRepository}) : _personRepository = personRepository;

  Future<List<PersonModel>> getTechnicians() async {
    final data = await _personRepository.getTechnicians();
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
    return await _personRepository.synchronize(lastSync);
  }
}
