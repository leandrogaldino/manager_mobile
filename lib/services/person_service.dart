import 'package:manager_mobile/core/exceptions/service_exception.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/repositories/reviewed/person_repository.dart';

class PersonService {
  final PersonRepository _personRepository;

  PersonService({required PersonRepository personRepository}) : _personRepository = personRepository;

  Future<List<PersonModel>> getTechnicians() async {
    final data = await _personRepository.getTechnicians();
    return data.map((item) => PersonModel.fromMap(item)).toList();
  }

  Future<PersonModel> getById(dynamic id) async {
    final data = await _personRepository.getById(id);
    if (data.isNotEmpty) {
      return PersonModel.fromMap(data);
    } else {
      throw ServiceException('PER004', 'Pessoa com o id $id não encontrada.');
    }
  }

  Future<void> synchronize(int lastSync) async {
    await _personRepository.synchronize(lastSync);
  }
}
